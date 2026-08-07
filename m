Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF8F3557F3;
	Fri,  7 Aug 2026 15:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116592; cv=none; b=kCu5AuNFvPCb52p9yUD7OVczU/uD7oOlDF71bFu1bkeU2Mo6CUJGCysag7UppTykMpJcs4ApTYCGNn/2D3sqmqFv9XKFuA26YojmoTvDOTbWDPJu5yo57/urap4NOBEl4kcpbd+MNDKk4SggdT7BKt/LFO45+Eibhulv4X+0e40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116592; c=relaxed/simple;
	bh=BlkWQXxqL0U3LnGjItHE/RYCsLKaFL3BJCP01S1Syiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fde2WJhFfIUOClLISlVIeD9n8cS8kRHbMZnU86PMl11YSVhKRjIZqBN5muiH4jEyV01TkMbbhk20JrsJx36FdK1mAF84m78tBfLHmsfbxQClX/h7XhoTniykWF6T+outgwZx+FfPPZsL/DDmg5mbnHNkH7l00P0byj7yZrZhWXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13Riekh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13Riekh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99101F000E9;
	Fri,  7 Aug 2026 15:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116591;
	bh=KlQHZDTHP4LMRZg/z5scUXV5UxAGc/HC+5mwmWReY94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13Riekh/YHrhC4qQgyhYNW4drP5e6GFhBun/E0QuiQXqRntKrQSyjXPxGPyDqnr03
	 SHdRYKmheAqSlt64381BPQLxTEQV647aidIbRKZ8BV0X1AGpbTRJOUCqkABpDdZ3bk
	 IVgXroG4RSBgUR5t4G1/edjUrEL0ti17XgXdlz5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.1 007/438] KVM: arm64: vgic: Avoid double-deactivate of IRQs in the nested context
Date: Fri,  7 Aug 2026 16:33:23 +0200
Message-ID: <20260807143428.169108992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: D Scott Phillips <scott@os.amperecomputing.com>

commit 8a570b19b4b16a8a3b5ffa2b332bd5613110b2d8 upstream.

In the nested state, the physical interrupt has already been
deactivated through the HW bit in the LR. The extra deactivation
would be harmless but can hit an errata case on AmpereOne, so
avoid it here.

On AmpereOne, deactivating a physical interrupt through
ICC_DIR_EL1 or ICC_EOIR1_EL1 (depending on EOImode) which is not
active, but is the highest priority pending interrupt causes the
cpu to lose the interrupt pending state and also prevents the
delivery of future interrupts.

Fixes: 6dd333c8942b2 ("KVM: arm64: GICv3: nv: Plug L1 LR sync into deactivation primitive")
Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-arm-kernel/20260710222128.416581-1-scott@os.amperecomputing.com/
Link: https://patch.msgid.link/20260714231158.496808-1-scott@os.amperecomputing.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/silicon-errata.rst |    4 ++++
 arch/arm64/kvm/vgic/vgic-v3.c               |    8 +++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -55,10 +55,14 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Ampere         | AmpereOne       | AC03_CPU_38     | AMPERE_ERRATUM_AC03_CPU_38  |
 +----------------+-----------------+-----------------+-----------------------------+
+| Ampere         | AmpereOne       | AC03_CPU_57     | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
 | Ampere         | AmpereOne AC04  | AC04_CPU_10     | AMPERE_ERRATUM_AC03_CPU_38  |
 +----------------+-----------------+-----------------+-----------------------------+
 | Ampere         | AmpereOne AC04  | AC04_CPU_23     | AMPERE_ERRATUM_AC04_CPU_23  |
 +----------------+-----------------+-----------------+-----------------------------+
+| Ampere         | AmpereOne AC04  | AC04_CPU_29     | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
 +----------------+-----------------+-----------------+-----------------------------+
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -275,7 +275,13 @@ void vgic_v3_deactivate(struct kvm_vcpu
 		lr = vgic_v3_compute_lr(vcpu, irq) & ~ICH_LR_ACTIVE_BIT;
 	}
 
-	if (lr & ICH_LR_HW)
+	/*
+	 * In the nested state, the irq has already been deactivated via the HW
+	 * bit in the LR. Deactivating again would be harmless except AmpereOne
+	 * errata AC03_CPU_57, AC04_CPU_29 could cause irq delivery to break if
+	 * the deactivation hits the highest priority pending irq.
+	 */
+	if ((lr & ICH_LR_HW) && !vgic_state_is_nested(vcpu))
 		vgic_v3_deactivate_phys(FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
 
 	vgic_v3_fold_lr(vcpu, lr);


