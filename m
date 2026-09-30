Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88ADE51C056;
	Wed, 30 Sep 2026 18:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793748; cv=none; b=E5/ZrZRYo/Ww2VimXL0uSwk5TSUV2eU8kz1OP0sXNF44TSYiGZc1ac1sV/1EfbbZ0JRkT/ge61A2U/zz+LpTfKV8rNZKqiAKY6m/II3cbblPO/Wn6cYfUGFylxJFElETQswNaBgXhjurxGoj8rWTBaB5Y3iOzGF2Pj94x1PWD2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793748; c=relaxed/simple;
	bh=6I0hzc0SZCF1JFUM8I2qvQmbC+KAThYGyePNv89SMJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xtb5fWZpI5xGQtb7Y8EA+cB9+M/3ocLp1Uevk7Vw2z6Jx53TryCbm+KqH2ObY7mkl6LF+GMTpP1sU7B4gegkSsHoudN6lQ8/dkHBD43xh4Ta2FWSG96t/sMgEgrz4Q2bUTolZvhWpgB4chGDg/onXLMvCQT1hf5urMRuo9VyQaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0KekKrV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0KekKrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28641F000FF;
	Wed, 30 Sep 2026 18:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793747;
	bh=evBUpeiNz2/c7Z8P3ia0uC9DdXHil+7gqz3CH0129Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0KekKrV0WUdskjKqMNp2C6xCHgDUBaML5Bsc/jvlYeUVq0VMG35Jj1IlTkXyuiIO
	 6MS3dvqxOeP6joSctkSEB8iKL6zS3Fil7TDQ9s4q91eHKlVuEmZGs+v1t+0YZuYQAR
	 0EdzU60+sErIQvOGNvlVwZy7P2PzeOJNWlJWK7Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Bo <xb@ultrarisc.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.18 319/395] RISC-V: KVM: Propagate interrupted G-stage faults
Date: Wed, 30 Sep 2026 17:29:41 +0200
Message-ID: <20260930152347.580597278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xie Bo <xb@ultrarisc.com>

commit f41fb17143df890855d3de980f8eb92dfd595817 upstream.

__kvm_faultin_pfn() reports an interrupted host page fault with
KVM_PFN_ERR_SIGPENDING. RISC-V currently handles it as a generic
error PFN and returns -EFAULT.

Return -EINTR for the signal-pending sentinel so callers can distinguish
an interrupted fault from an invalid userspace mapping. Do not log the
expected interruption as a vCPU exit error.

Fixes: 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page table programming")
Cc: stable@vger.kernel.org
Signed-off-by: Xie Bo <xb@ultrarisc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260810051544.3953925-3-xb@ultrarisc.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/mmu.c       |    2 ++
 arch/riscv/kvm/vcpu_exit.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -380,6 +380,8 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *v
 				vma_pageshift, current);
 		return 0;
 	}
+	if (is_sigpending_pfn(hfn))
+		return -EINTR;
 	if (is_error_noslot_pfn(hfn))
 		return -EFAULT;
 
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -248,7 +248,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu
 	}
 
 	/* Print details in-case of error */
-	if (ret < 0) {
+	if (ret < 0 && ret != -EINTR) {
 		kvm_err("VCPU exit error %d\n", ret);
 		kvm_err("SEPC=0x%lx SSTATUS=0x%lx HSTATUS=0x%lx\n",
 			vcpu->arch.guest_context.sepc,


