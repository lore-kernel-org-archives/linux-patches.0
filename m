Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3294231A2A;
	Mon, 10 Mar 2025 17:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626625; cv=none; b=uWv1wE60l4nroxIgrGziWZnYJ6qKOB/NkA8xJS5natzA7OR4s5DC7mXHF4ZPBiJzEq9NCNTrQz2VumfzjudJnt8odPrZ7OnWKUUqAtMjcKI9HEHUeoyJmsQ6reRlK3e7i6Ok4EqwmJvd5FfI8MGUG4W1YKpAypzjMC3n8a1i69o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626625; c=relaxed/simple;
	bh=DdRMA6bvAUl3+BltA5lcjc7IsNJijo7JvopzdvLhF4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IoF/Ijvlpcsg+2R5XP1o+5S8p52txeALYdGR2f2us4cL5UahDCMvQUhddahlb3Z3mfRKJnz8UmpiLG76tm1aLsulW1xcgVOFUgXSdaGd/2r1cFjtuHFGRJfawVMfIbmnWnAje0umLmP4jzs+jnJ3DZwBnBJ6zNTKkgHw+Wmbgkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBSU8WhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBSU8WhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE16C4CEE5;
	Mon, 10 Mar 2025 17:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626624;
	bh=DdRMA6bvAUl3+BltA5lcjc7IsNJijo7JvopzdvLhF4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBSU8WhZmG3RPINTZ9CqB7GAnp8k7Eya7/dvvpoDlk+tYvITV++IhklE1UTx1npPC
	 /KgrGKHO3SfB7BzFlMfIvT4WwsZLObPHCanYTw1rAHm3JOlJ9/7pABPFAYqH7Ctq6o
	 BHVWEJ7F79aydErFQ+n9HlrDlGE86Pvc5ISwIF6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.13 056/207] drm/xe/userptr: properly setup pfn_flags_mask
Date: Mon, 10 Mar 2025 18:04:09 +0100
Message-ID: <20250310170449.999160091@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit 475d06e00b7496c7915d87f7ae67af26738e4649 upstream.

Currently we just leave it uninitialised, which at first looks harmless,
however we also don't zero out the pfn array, and with pfn_flags_mask
the idea is to be able set individual flags for a given range of pfn or
completely ignore them, outside of default_flags. So here we end up with
pfn[i] & pfn_flags_mask, and if both are uninitialised we might get back
an unexpected flags value, like asking for read only with default_flags,
but getting back write on top, leading to potentially bogus behaviour.

To fix this ensure we zero the pfn_flags_mask, such that hmm only
considers the default_flags and not also the initial pfn[i] value.

v2 (Thomas):
 - Prefer proper initializer.

Fixes: 81e058a3e7fd ("drm/xe: Introduce helper to populate userptr")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@intel.com>
Cc: <stable@vger.kernel.org> # v6.10+
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250226174748.294285-2-matthew.auld@intel.com
(cherry picked from commit dd8c01e42f4c5c1eaf02f003d7d588ba6706aa71)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_hmm.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/xe/xe_hmm.c
+++ b/drivers/gpu/drm/xe/xe_hmm.c
@@ -203,13 +203,20 @@ int xe_hmm_userptr_populate_range(struct
 {
 	unsigned long timeout =
 		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
-	unsigned long *pfns, flags = HMM_PFN_REQ_FAULT;
+	unsigned long *pfns;
 	struct xe_userptr *userptr;
 	struct xe_vma *vma = &uvma->vma;
 	u64 userptr_start = xe_vma_userptr(vma);
 	u64 userptr_end = userptr_start + xe_vma_size(vma);
 	struct xe_vm *vm = xe_vma_vm(vma);
-	struct hmm_range hmm_range;
+	struct hmm_range hmm_range = {
+		.pfn_flags_mask = 0, /* ignore pfns */
+		.default_flags = HMM_PFN_REQ_FAULT,
+		.start = userptr_start,
+		.end = userptr_end,
+		.notifier = &uvma->userptr.notifier,
+		.dev_private_owner = vm->xe,
+	};
 	bool write = !xe_vma_read_only(vma);
 	unsigned long notifier_seq;
 	u64 npages;
@@ -236,19 +243,14 @@ int xe_hmm_userptr_populate_range(struct
 		return -ENOMEM;
 
 	if (write)
-		flags |= HMM_PFN_REQ_WRITE;
+		hmm_range.default_flags |= HMM_PFN_REQ_WRITE;
 
 	if (!mmget_not_zero(userptr->notifier.mm)) {
 		ret = -EFAULT;
 		goto free_pfns;
 	}
 
-	hmm_range.default_flags = flags;
 	hmm_range.hmm_pfns = pfns;
-	hmm_range.notifier = &userptr->notifier;
-	hmm_range.start = userptr_start;
-	hmm_range.end = userptr_end;
-	hmm_range.dev_private_owner = vm->xe;
 
 	while (true) {
 		hmm_range.notifier_seq = mmu_interval_read_begin(&userptr->notifier);


