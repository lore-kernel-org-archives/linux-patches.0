Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6183750CF;
	Wed, 30 Sep 2026 17:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787926; cv=none; b=cQT3TG9SvPudbZNVxr0qB63F72mfycQG4ofaR8GrcuwFg5X8fdaWe1/5z4qgXB2bTe4elyJueRmIyRU4G19dRtGtj3GsbDs1HGdAkXDkh8IYbUYUGu4efYQND1+nTD3hSALGwXfemNloOFY8etYDhB0GK26kXFlnhWF8Qa932hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787926; c=relaxed/simple;
	bh=ylvrlR1rfSKURMtCdULrC/STEpb6h/4hGxhyI6MkGRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qleYi/fQR9sG5SR7SxoB4z45rSZvciFL4fFZcP8jKOqTJYyo1B8QCwVEZ24sNljMi9c2vY6krN32l3gq4ISRTcAKIWLl4E7dmRzfBm+TMtfHa95/MKI1J7YuONZE51ch+Cd7MKw4oL5395tW44inHqaduUMdRHP2Ow/yaozmm4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BruogseG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BruogseG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3756E1F000FF;
	Wed, 30 Sep 2026 17:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787924;
	bh=3G3VP+ReR5lS66HZxfvCuJFT7ZVmWa0R+gdN7/a2IYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BruogseGKfrTW7gKFBFaS/4ZSeOQ2y6kTkFd8JhvsvgmPcN9XwEEi/aeQ1elna5wd
	 Sr8kTbF2Dn0sbN/Zs4n7QvPFzea5WYMcvUmaSjHca89/3sUxg4qGu622eMaFBOmbXg
	 Nv6rJkD+4bQkyoqBLt4CTonCBFSlBEQ0pgzBS67o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Bo <xb@ultrarisc.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 7.2 395/457] RISC-V: KVM: Propagate interrupted G-stage faults
Date: Wed, 30 Sep 2026 17:28:20 +0200
Message-ID: <20260930152354.521232853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -621,6 +621,8 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *v
 				vma_pageshift, current);
 		return 0;
 	}
+	if (is_sigpending_pfn(hfn))
+		return -EINTR;
 	if (is_error_noslot_pfn(hfn))
 		return -EFAULT;
 
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -267,7 +267,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu
 	}
 
 	/* Print details in-case of error */
-	if (ret < 0) {
+	if (ret < 0 && ret != -EINTR) {
 		kvm_err("VCPU exit error %d\n", ret);
 		kvm_err("SEPC=0x%lx SSTATUS=0x%lx HSTATUS=0x%lx\n",
 			vcpu->arch.guest_context.sepc,


