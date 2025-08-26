Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CD52135B8;
	Tue, 26 Aug 2025 11:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208079; cv=none; b=OgcxaSW9YT8JcmVjrgAOi8P2bVqaCWhrun4x2Hi1UTY9higjWgelzJSfVf7FMe1EFBnH+euFfkU+hwi7nBaJz80E8sbDlb3OTUDxbTHUQsASop34rAdpWSdf748Nqae7nmck5HynBSBW9zHEJ+ehVUZ7cyDJE5mrooMgTynOkZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208079; c=relaxed/simple;
	bh=nSfsrQ0GoofU90GV03H9uxwRdhRxvB0XyoC0Gwkdlvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Akx74MvTPXZXwnZzztChLkglDJD5BK1omLkdP55vMfInGk7Piqgt/q97cGhH/E5zD6+k3LLniyF63525zueYbUjb0OG43sexzANiQjBwwy0bJFJA1v70qu6FoLnutbvgAbVVs6q83Gk3BMpdpKwm5pqO1RVPxLmsWE7518QpayM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crUh2VJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crUh2VJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E9CC4CEF1;
	Tue, 26 Aug 2025 11:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208079;
	bh=nSfsrQ0GoofU90GV03H9uxwRdhRxvB0XyoC0Gwkdlvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crUh2VJKCNTefdZ3ITPKJPmERzjuPHMnSUf5z9Fx9KTTyJ1dRiJMGWuIFfiTGL2no
	 U9YRHa+Gr4vM3CiEafTPf8BtAL/jU4+K4RbV/TC6ZKG2IYydXj768qY1ZxpiuEJWLb
	 wJgKiTgKqKujbqcYMko/c2EkJOK3Bn2ZyvxO6Ts8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanteng Si <siyanteng@cqsoftware.com.cm>,
	Song Gao <gaosong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 430/457] LoongArch: KVM: Use kvm_get_vcpu_by_id() instead of kvm_get_vcpu()
Date: Tue, 26 Aug 2025 13:11:54 +0200
Message-ID: <20250826110947.915979060@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Gao <gaosong@loongson.cn>

[ Upstream commit 0dfd9ea7bf80fabe11f5b775d762a5cd168cdf41 ]

Since using kvm_get_vcpu() may fail to retrieve the vCPU context,
kvm_get_vcpu_by_id() should be used instead.

Fixes: 8e3054261bc3 ("LoongArch: KVM: Add IPI user mode read and write function")
Fixes: 3956a52bc05b ("LoongArch: KVM: Add EIOINTC read and write functions")
Reviewed-by: Yanteng Si <siyanteng@cqsoftware.com.cm>
Signed-off-by: Song Gao <gaosong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/intc/eiointc.c | 7 ++++++-
 arch/loongarch/kvm/intc/ipi.c     | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 3cf9894999da..0207cfe1dbd6 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -45,7 +45,12 @@ static void eiointc_update_irq(struct loongarch_eiointc *s, int irq, int level)
 	}
 
 	cpu = s->sw_coremap[irq];
-	vcpu = kvm_get_vcpu(s->kvm, cpu);
+	vcpu = kvm_get_vcpu_by_id(s->kvm, cpu);
+	if (unlikely(vcpu == NULL)) {
+		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
+		return;
+	}
+
 	if (level) {
 		/* if not enable return false */
 		if (!test_bit(irq, (unsigned long *)s->enable.reg_u32))
diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index 6a13d2f44575..4859e320e3a1 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -318,7 +318,7 @@ static int kvm_ipi_regs_access(struct kvm_device *dev,
 	cpu = (attr->attr >> 16) & 0x3ff;
 	addr = attr->attr & 0xff;
 
-	vcpu = kvm_get_vcpu(dev->kvm, cpu);
+	vcpu = kvm_get_vcpu_by_id(dev->kvm, cpu);
 	if (unlikely(vcpu == NULL)) {
 		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
 		return -EINVAL;
-- 
2.50.1



