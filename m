Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836964C3A9;
	Mon,  8 Jan 2024 15:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wd2tTFIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62DFC433C9;
	Mon,  8 Jan 2024 15:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726867;
	bh=5a7hOfN0nSMFT2iQj3xBgUMFTSkVvHG2lRBdqdUjzZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wd2tTFIqvB7hDa6TztZBpuVhLuYiZGYVvRUpzZfI/PJmSDpMTNIXO4Ib426/i0Nb3
	 EGU+ogiIgntfgOYBwMkQ0Z5/Rrf9ndzGOr5FKWghoBlb9DXuLdYL2+nXDWdgxHW/En
	 74p5JVqpFUjPCnlwZXyXfgpSeoiMqp4iRemaKhXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Lin <roy.lin@sifive.com>,
	Wayling Chen <wayling.chen@sifive.com>,
	Vincent Chen <vincent.chen@sifive.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/124] RISCV: KVM: update external interrupt atomically for IMSIC swfile
Date: Mon,  8 Jan 2024 16:08:49 +0100
Message-ID: <20240108150607.693322594@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

[ Upstream commit 4ad9843e1ea088bd2529290234c6c4c6374836a7 ]

The emulated IMSIC update the external interrupt pending depending on
the value of eidelivery and topei. It might lose an interrupt when it
is interrupted before setting the new value to the pending status.

For example, when VCPU0 sends an IPI to VCPU1 via IMSIC:

VCPU0                           VCPU1

                                CSRSWAP topei = 0
                                The VCPU1 has claimed all the external
                                interrupt in its interrupt handler.

                                topei of VCPU1's IMSIC = 0

set pending in VCPU1's IMSIC

topei of VCPU1' IMSIC = 1

set the external interrupt
pending of VCPU1

                                clear the external interrupt pending
                                of VCPU1

When the VCPU1 switches back to VS mode, it exits the interrupt handler
because the result of CSRSWAP topei is 0. If there are no other external
interrupts injected into the VCPU1's IMSIC, VCPU1 will never know this
pending interrupt unless it initiative read the topei.

If the interruption occurs between updating interrupt pending in IMSIC
and updating external interrupt pending of VCPU, it will not cause a
problem. Suppose that the VCPU1 clears the IPI pending in IMSIC right
after VCPU0 sets the pending, the external interrupt pending of VCPU1
will not be set because the topei is 0. But when the VCPU1 goes back to
VS mode, the pending IPI will be reported by the CSRSWAP topei, it will
not lose this interrupt.

So we only need to make the external interrupt updating procedure as a
critical section to avoid the problem.

Fixes: db8b7e97d613 ("RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC")
Tested-by: Roy Lin <roy.lin@sifive.com>
Tested-by: Wayling Chen <wayling.chen@sifive.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/aia_imsic.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 6cf23b8adb712..e808723a85f1b 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -55,6 +55,7 @@ struct imsic {
 	/* IMSIC SW-file */
 	struct imsic_mrif *swfile;
 	phys_addr_t swfile_pa;
+	spinlock_t swfile_extirq_lock;
 };
 
 #define imsic_vs_csr_read(__c)			\
@@ -613,12 +614,23 @@ static void imsic_swfile_extirq_update(struct kvm_vcpu *vcpu)
 {
 	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
 	struct imsic_mrif *mrif = imsic->swfile;
+	unsigned long flags;
+
+	/*
+	 * The critical section is necessary during external interrupt
+	 * updates to avoid the risk of losing interrupts due to potential
+	 * interruptions between reading topei and updating pending status.
+	 */
+
+	spin_lock_irqsave(&imsic->swfile_extirq_lock, flags);
 
 	if (imsic_mrif_atomic_read(mrif, &mrif->eidelivery) &&
 	    imsic_mrif_topei(mrif, imsic->nr_eix, imsic->nr_msis))
 		kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_VS_EXT);
 	else
 		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_EXT);
+
+	spin_unlock_irqrestore(&imsic->swfile_extirq_lock, flags);
 }
 
 static void imsic_swfile_read(struct kvm_vcpu *vcpu, bool clear,
@@ -1039,6 +1051,7 @@ int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu)
 	}
 	imsic->swfile = page_to_virt(swfile_page);
 	imsic->swfile_pa = page_to_phys(swfile_page);
+	spin_lock_init(&imsic->swfile_extirq_lock);
 
 	/* Setup IO device */
 	kvm_iodevice_init(&imsic->iodev, &imsic_iodoev_ops);
-- 
2.43.0



