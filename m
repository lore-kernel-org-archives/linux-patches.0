Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21A429A30A;
	Tue, 11 Nov 2025 01:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823493; cv=none; b=rJEOH7pPf5/WyoAMeFVZkC0FRPnbSvoXVtME4mwj5p4uFRrl/TMNyQ1lvRDAiWu8jfZr8qXdTw4IQ6yQ0LpNpUyHCioozT6CPA1D28bcTSgHM5mTsCsYKEwbgJquSA4jyN8cdEKD5t5NwuBQFcTyJQEziF71vkoyifnUCSOhWMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823493; c=relaxed/simple;
	bh=cA/jFJxmMzGb+ALdDm7kiSd2hYuslmHOyrzfDp2swHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdNwOpMBQ+gweiBVIc0LdNLFqpA0mJPJu7T6BszmI7XJ2Hvw3T4h/ZswpkpXJQfXUX0PEQeyb/O/DWttUHFKION24sK45Tp/JNiLkxinVHKUFJiqQBxkKPTBVJfjAtKt1MhwKV3uCYsoD19P5iLwEbw56n04TQnXAdG+/xc44ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsJShA/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsJShA/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E885C4AF0B;
	Tue, 11 Nov 2025 01:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823493;
	bh=cA/jFJxmMzGb+ALdDm7kiSd2hYuslmHOyrzfDp2swHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsJShA/bsOIQ0Za6c0pEiQwAeToBOfP4BAmevXKLX3jxg7BC1YOGVa5H32VNVB3sq
	 jEqhSECkG3ft3Rw7lex77XVLpL8ge2tj7/lam3h0wk5AEMIZ4+ADLvuTGSJ8lq62Q0
	 afKS9mO07c6aTVJr9RlVKBctye8K+q/wpi+Z9aS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 257/565] drm/amdkfd: fix vram allocation failure for a special case
Date: Tue, 11 Nov 2025 09:41:53 +0900
Message-ID: <20251111004532.680592465@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit 93aa919ca05bec544b17ee9a1bfe394ce6c94bd8 ]

When it only allocates vram without va, which is 0, and a
SVM range allocated stays in this range, the vram allocation
returns failure. It should be skipped for this case from
SVM usage check.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index fc473e3ba2d00..7fbbc67adfd9e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1069,7 +1069,12 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 	svm_range_list_lock_and_flush_work(&p->svms, current->mm);
 	mutex_lock(&p->svms.lock);
 	mmap_write_unlock(current->mm);
-	if (interval_tree_iter_first(&p->svms.objects,
+
+	/* Skip a special case that allocates VRAM without VA,
+	 * VA will be invalid of 0.
+	 */
+	if (!(!args->va_addr && (flags & KFD_IOC_ALLOC_MEM_FLAGS_VRAM)) &&
+	    interval_tree_iter_first(&p->svms.objects,
 				     args->va_addr >> PAGE_SHIFT,
 				     (args->va_addr + args->size - 1) >> PAGE_SHIFT)) {
 		pr_err("Address: 0x%llx already allocated by SVM\n",
-- 
2.51.0



