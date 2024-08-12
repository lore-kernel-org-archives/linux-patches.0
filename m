Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF68716D9B8;
	Mon, 12 Aug 2024 16:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480326; cv=none; b=n17k/rrUWPRa7Oe8LlMNFdWZF1iUzV9nQkMayR42VjdxSCMnQKd1K3GimzEn2Ldy1q2u0w1ylYSZeT4QLiuQ5PTd2Gq7lxNDWxjbp+YFpMcs38xgTfFEWlGsV4aOSdDiElMFn1ljfS3r4zedSwQieebB0wd3wj0iKy25tUjzEr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480326; c=relaxed/simple;
	bh=ab/+02Ho2mHfH6TN8CT4Gu9w2F7P72NfNwunvzoJCwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHWVZz6CAnaBp703rXxFriQUX4oUU5nyuRY/ocqCKgO0TgxOo7ZY5ZsyIvBfhYGiMqJ5337GpMd+kyUMrJ10iCBTD9xU6W8gwzSaykSS0I/LWntlywxbOfAAnKU7Uvtz+LEHx32dIHZ1IGBYvub0eTrWX6UuupoYI7uxsiTR+fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhZlebeF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhZlebeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A96C32782;
	Mon, 12 Aug 2024 16:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480325;
	bh=ab/+02Ho2mHfH6TN8CT4Gu9w2F7P72NfNwunvzoJCwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhZlebeFnQIrP0jC4xpPttcR6Ce+H94z7vPNx/Ik5OcRLBu8eHuVXPUcAcqS40yRv
	 53sqo9Iy14i7Q99UU64nwnvbZ/CYlSFiGVV43yeiLsiYPTz1Me5400jdc8tN9gWF7f
	 wdcYwf/iJA9iYCXtB2qT/yiKrGgWEyJJUYX+JHcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Zanoni <paulo.r.zanoni@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 164/263] drm/xe: Use dma_fence_chain_free in chain fence unused as a sync
Date: Mon, 12 Aug 2024 18:02:45 +0200
Message-ID: <20240812160152.824745126@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 4f854a8b1b85d46abd5ce206936d23f87ac5e0c9 ]

A chain fence is uninitialized if not installed in a drm sync obj. Thus
if xe_sync_entry_cleanup is called and sync->chain_fence is non-NULL the
proper cleanup is dma_fence_chain_free rather than a dma-fence put.

Reported-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2411
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2261
Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240727012216.2118276-1-matthew.brost@intel.com
(cherry picked from commit 7f7a2da3bf8bc0e0f6c239af495b7050056e889c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_sync.c b/drivers/gpu/drm/xe/xe_sync.c
index 65f1f16282356..2bfff998458ba 100644
--- a/drivers/gpu/drm/xe/xe_sync.c
+++ b/drivers/gpu/drm/xe/xe_sync.c
@@ -263,7 +263,7 @@ void xe_sync_entry_cleanup(struct xe_sync_entry *sync)
 	if (sync->fence)
 		dma_fence_put(sync->fence);
 	if (sync->chain_fence)
-		dma_fence_put(&sync->chain_fence->base);
+		dma_fence_chain_free(sync->chain_fence);
 	if (sync->ufence)
 		user_fence_put(sync->ufence);
 }
-- 
2.43.0



