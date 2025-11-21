Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B200351FCF;
	Fri, 21 Nov 2025 13:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732590; cv=none; b=SMJkzikAUozEtxYBXuHYp++AeWncduPoJKVivslkGPFlY4HXSfJLfG+0HyyIVjoXX1VYqzcSzr8R/IEdaexaB+faV/N7bPAi6dByCDcrzgpX2xoZ7mvig8kZHuVKOKgqNy5Emx7c9cCTILUtHi8eFYFe6ELsP5rmTjpEWG/rU3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732590; c=relaxed/simple;
	bh=yTEOROQthZyKIw0e3VQ7+WqghfqcBJikus6hc8/eInA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WI+EHqeQe3jw7qjLiXEnD+pHJw7pTKzkpenfuKHG4qZst6QPfS7ELX/g7cpfAzjfWxDN3yCh2CZ1DEBYOlkOYsfXY1jNSMxGr8nPVyHmS07CNbIur5JlDutvi+cPQESxMQxMQqm2pDvoKOr5V7TOG5WoKrawO8/Y1qJtmEc8eNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cf62wrVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cf62wrVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B740EC4CEF1;
	Fri, 21 Nov 2025 13:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732590;
	bh=yTEOROQthZyKIw0e3VQ7+WqghfqcBJikus6hc8/eInA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cf62wrVo/61SrwXurfpXxiJSx6F5Lkp5v34QAA0u3iwlW7Oc1hJZzC1wsNuPGDbQY
	 yyi1FcOebRk0w7tT3GuRHQSo/HGoq7Tl8IncUymA52C+eqtxpeU8iJNopgFiWOuhD1
	 Ud6JkHVuafD9M5ihfaZ8uMZEVL3I5TDMlIpTOhf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/529] drm/amdkfd: fix vram allocation failure for a special case
Date: Fri, 21 Nov 2025 14:07:46 +0100
Message-ID: <20251121130236.961329799@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f77324a5e9584..76196ab75475e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1085,7 +1085,12 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
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



