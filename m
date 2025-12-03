Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EA335FF77;
	Wed,  3 Dec 2025 16:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779297; cv=none; b=GOaqfNJT5jpVe3KT6qUdkOSnZn1if5XqODaXBwgmnIIATXvv10ei7p7ZLZvrVBzJ0//XHEyNv6YOkdkjx0dKXe01n4PaOVltHWpHhQ+3GqWIKDOLBuoNtVYkv+3JakW5VKLiMaHeQp6itvzqMCYeqZ++NlR2f3TyBcHW0ygBPVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779297; c=relaxed/simple;
	bh=VNUKTO3Um/pMyvqGrhZeif4DzRbFjZUe7/C97Nyumz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZbtgQtTIZkuN5WXDo1ulqrWNF+b31iiBjLZOvQN//ZnB1/qcBFy4idms3+BsFOgq/p6qvbM9gJHIPc+CEod9Uwud0IvGTn4GEyK0qaxOrI8ep0pV4XTm5LnkYwtncens49IcBqVKa1l1OfAKDHMADWSh6S5tZVErER0/Yijo4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2rK5cp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2rK5cp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAD0C4CEF5;
	Wed,  3 Dec 2025 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779296;
	bh=VNUKTO3Um/pMyvqGrhZeif4DzRbFjZUe7/C97Nyumz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2rK5cp+j0Z43lhADVJDTUOxRyhYhdJMutX6VcCs7nlzRBZzbw2zlp6tUIEvuHkyF
	 uFfJyBEU6inM2Xw+KMkfgfhEjtmo0sShTSuyaVqW04LWnvSJ9QjRSWnePNdWjN8nGw
	 y5RS5Y10YhyM9v9RguR44zekBGpUAanpBXf9qZmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/568] drm/amdkfd: fix vram allocation failure for a special case
Date: Wed,  3 Dec 2025 16:22:54 +0100
Message-ID: <20251203152447.032603267@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c1cb91a79b796..890c2befe7dce 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1067,7 +1067,12 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
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



