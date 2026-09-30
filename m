Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6A25187CA;
	Wed, 30 Sep 2026 17:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788059; cv=none; b=D5fIyYJkgue8wz3qk5LZd5n6gwed7JV+Jnaim7SzbQHykRNQ7bLcJaKYZr8S7sLH2FLjUA1wmhROiQA8GhyzOaaFC6MujXVnAx1L1W0dbSLSV+q2O9uVjpOLDB2YCyBi0Mh0o04i21WaW274oVpamXUzvclAJQugG/SDM5BCBz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788059; c=relaxed/simple;
	bh=ILcJR5B3G5cpoHSpsqlOxkC44WMmT9Orj91rB8FENic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2LsyElFYTgmkYh1rInS8drpquQFB/TlgNmwhSwOS/f2SvPLy1+HsIQ+TLXPFRNnfxJX3bPBmBTWxUhPG32Ty+W3bAa88ZxYDQo4Qh9CfVHtWqxEfaCfHvUSPqG6LVfJOTwkvsf0OqgCZJCCIUXH9I0XUL7YFGFrV2jiEvC6hCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abiMqTfh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abiMqTfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1021F000FF;
	Wed, 30 Sep 2026 17:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788058;
	bh=gkLO7zo8dr/Sb/1XTMOw+Vxz6S58GUKd4lFgfEM/pb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abiMqTfhnWzW9nztmnTUMEQM0yPfj6O/GcONBolIuGFacedw1t6YFk1HbkvjFWRRb
	 t/ZGlKvL8wjClbxkldub8ut36tV1QtyUzWx/TdobT8+37vF9bLXkQRRuGhItoDAPUr
	 OSl28v5ieuiB9dKmQT0T7fJosZ7SCmoocgdCXE2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Bo <xb@ultrarisc.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 7.2 394/457] RISC-V: KVM: Release unused page after MMU invalidation
Date: Wed, 30 Sep 2026 17:28:19 +0200
Message-ID: <20260930152354.500146082@linuxfoundation.org>
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

commit ed54fdb460a6e81d5f8f38388d1f10b385dd4a58 upstream.

If an MMU invalidation races with a G-stage fault, the fault handler skips
installing the page but leaves ret set to zero. As a result,
kvm_release_faultin_page() treats the page as used and can unnecessarily
mark it dirty.

Track the invalidation retry separately and release the page as unused,
while preserving the existing return value so that the vCPU retries the
fault.

Fixes: 2ed90cb0938a ("KVM: RISC-V: Retry fault if vma_lookup() results become invalid")
Cc: stable@vger.kernel.org
Signed-off-by: Xie Bo <xb@ultrarisc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260810051544.3953925-2-xb@ultrarisc.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/mmu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -540,6 +540,7 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *v
 	int ret;
 	kvm_pfn_t hfn;
 	bool is_hugetlb;
+	bool unused = false;
 	bool writable;
 	short vma_pageshift;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
@@ -632,8 +633,10 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *v
 
 	write_lock(&kvm->mmu_lock);
 
-	if (mmu_invalidate_retry(kvm, mmu_seq))
+	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+		unused = true;
 		goto out_unlock;
+	}
 
 	/*
 	 * Check if we are backed by a THP and thus use block mapping if
@@ -656,7 +659,8 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *v
 		kvm_err("Failed to map in G-stage\n");
 
 out_unlock:
-	kvm_release_faultin_page(kvm, page, ret && ret != -EEXIST, writable);
+	kvm_release_faultin_page(kvm, page,
+				 unused || (ret && ret != -EEXIST), writable);
 	write_unlock(&kvm->mmu_lock);
 	return ret;
 }


