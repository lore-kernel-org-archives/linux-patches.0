Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C7B153800;
	Fri, 15 Nov 2024 06:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653315; cv=none; b=kozjZz0AJkBq1BxjgkVHLRDM5Trh7wLMg2/FAki4zk/+7xETbS9aq/5QB2lq9qdYiqtqsv9zlK0ozQPmdk/nFIgyRAajbndCrV0y+Kh4SxEmSsurP3tyY/+0htBfWdE5iMQ70hOsImya8IZwcwzeC/kVkR+25JLIW8sbrzuxV5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653315; c=relaxed/simple;
	bh=P+gYs0SVcDlR5PBAW7tXIDXCsH4Okj95AuqJuKBlbwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMGiTLfQbn0LgqMLV3fereJjSdDFBSdpjYiKLVxQ1OUtvjx4axCkaw+xIMbB4ytX9/YtjIGMk525Mg341RVZFgoy7piccV/9UjKQ4N0DVhZ1ptWXd4HQ+1Wp7R+z5TcppVMRVWhpf7pYvPk41azFhnMrlwUbnW03FUcEmW6jJew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JB2Ca4q5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JB2Ca4q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE02C4CECF;
	Fri, 15 Nov 2024 06:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653315;
	bh=P+gYs0SVcDlR5PBAW7tXIDXCsH4Okj95AuqJuKBlbwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JB2Ca4q5nnFf+ExCBNePfrjlDMulVCh+Ri0wkD4hoxsVqaJncYAtPDg8nb8Ts9XOP
	 jDacUaNDj0dxPSwFZtvSErxwQosG/qvTUodXbm3nsKyjscDciJB5Yh7w8mZu+yV7lO
	 M531NhMtW5a3vlZcYHmHq61gGQDqWcu6wcAZsoGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyan Yang <cyan.yang@sifive.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 50/63] RISCV: KVM: use raw_spinlock for critical section in imsic
Date: Fri, 15 Nov 2024 07:38:13 +0100
Message-ID: <20241115063727.717640319@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyan Yang <cyan.yang@sifive.com>

[ Upstream commit 3ec4350d4efb5ccb6bd0e11d9cf7f2be4f47297d ]

For the external interrupt updating procedure in imsic, there was a
spinlock to protect it already. But since it should not be preempted in
any cases, we should turn to use raw_spinlock to prevent any preemption
in case PREEMPT_RT was enabled.

Signed-off-by: Cyan Yang <cyan.yang@sifive.com>
Reviewed-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Message-ID: <20240919160126.44487-1-cyan.yang@sifive.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/aia_imsic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 0a1e859323b45..a8085cd8215e3 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -55,7 +55,7 @@ struct imsic {
 	/* IMSIC SW-file */
 	struct imsic_mrif *swfile;
 	phys_addr_t swfile_pa;
-	spinlock_t swfile_extirq_lock;
+	raw_spinlock_t swfile_extirq_lock;
 };
 
 #define imsic_vs_csr_read(__c)			\
@@ -622,7 +622,7 @@ static void imsic_swfile_extirq_update(struct kvm_vcpu *vcpu)
 	 * interruptions between reading topei and updating pending status.
 	 */
 
-	spin_lock_irqsave(&imsic->swfile_extirq_lock, flags);
+	raw_spin_lock_irqsave(&imsic->swfile_extirq_lock, flags);
 
 	if (imsic_mrif_atomic_read(mrif, &mrif->eidelivery) &&
 	    imsic_mrif_topei(mrif, imsic->nr_eix, imsic->nr_msis))
@@ -630,7 +630,7 @@ static void imsic_swfile_extirq_update(struct kvm_vcpu *vcpu)
 	else
 		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_EXT);
 
-	spin_unlock_irqrestore(&imsic->swfile_extirq_lock, flags);
+	raw_spin_unlock_irqrestore(&imsic->swfile_extirq_lock, flags);
 }
 
 static void imsic_swfile_read(struct kvm_vcpu *vcpu, bool clear,
@@ -1051,7 +1051,7 @@ int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu)
 	}
 	imsic->swfile = page_to_virt(swfile_page);
 	imsic->swfile_pa = page_to_phys(swfile_page);
-	spin_lock_init(&imsic->swfile_extirq_lock);
+	raw_spin_lock_init(&imsic->swfile_extirq_lock);
 
 	/* Setup IO device */
 	kvm_iodevice_init(&imsic->iodev, &imsic_iodoev_ops);
-- 
2.43.0



