Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8AF1774B;
	Thu, 18 Jan 2024 10:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575385; cv=none; b=MJ5SJfudNGInl3cJXv6Z0CVB7fQ9iCZYeVsNsQ3HK28hF2k+P6ZTCqSIV4vXWkFpMiQE6ELXg3n4CkCgSrXNrZCaRPW3+19OXCYfYXj//m8YY+N8zobP6eyKxGTXkW7QynO+o92KhPcSs8I4DRVJaU+5B2GHtPugTeZCZD1nzmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575385; c=relaxed/simple;
	bh=oy28UP+Q3PgOpVELYd61L030KmbDeyhK2QvqmvDj0fY=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=R3tSJl4e6DrYttj6tIKqyYZRqUy/x1fKoGoVkmVNsL247nZow6U0kjQSATFwL5THL5iSW/QoASmJpW9Dx7QtymrtC8kNZPeCzX1XfBYRYvzjrJW3g4Js0xfw8oQ1NbtQVSSSGeltWUZ9waM5/ZWePNT8kjGfU6C/l3DXNYpOxoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKRhBOZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKRhBOZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EACAC433F1;
	Thu, 18 Jan 2024 10:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575385;
	bh=oy28UP+Q3PgOpVELYd61L030KmbDeyhK2QvqmvDj0fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKRhBOZWOkXPIVrrbvgTqNd7+jb10eKBU+HSxb/l2/F9ST0U0vjJaGBVsElKAl3rq
	 dnXPHvgfTmiPC1SeUXC2nSrI7aLxxUNhb+IQ02zyKtLzU3sNyYndOkOCM9MrYjynJi
	 Ak5ibPuHqVKALqex8P2PSCzVw+j2FSFjwLyLacZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/150] drm/amdkfd: svm range always mapped flag not working on APU
Date: Thu, 18 Jan 2024 11:48:55 +0100
Message-ID: <20240118104325.281313270@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit ebab8c3eb6a6515dc14cd93fc29dd287709da6d3 ]

On gfx943 APU there is no VRAM and page migration, queue CWSR area, svm
range with always mapped flag, is not mapped to GPU correctly. This
works fine if retry fault on CWSR area can be recovered, but could cause
deadlock if there is another retry fault recover waiting for CWSR to
finish.

Fix this by mapping svm range with always mapped flag to GPU with ACCESS
attribute if XNACK ON.

There is side effect, because all GPUs have ACCESS attribute by default
on new svm range with XNACK on, the CWSR area will be mapped to all GPUs
after this change. This side effect will be fixed with Thunk change to
set CWSR svm range with ACCESS_IN_PLACE attribute on the GPU that user
queue is created.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 63ce30ea6891..8e368e4659fd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1632,18 +1632,24 @@ static int svm_range_validate_and_map(struct mm_struct *mm,
 			if (test_bit(gpuidx, prange->bitmap_access))
 				bitmap_set(ctx->bitmap, gpuidx, 1);
 		}
+
+		/*
+		 * If prange is already mapped or with always mapped flag,
+		 * update mapping on GPUs with ACCESS attribute
+		 */
+		if (bitmap_empty(ctx->bitmap, MAX_GPU_INSTANCE)) {
+			if (prange->mapped_to_gpu ||
+			    prange->flags & KFD_IOCTL_SVM_FLAG_GPU_ALWAYS_MAPPED)
+				bitmap_copy(ctx->bitmap, prange->bitmap_access, MAX_GPU_INSTANCE);
+		}
 	} else {
 		bitmap_or(ctx->bitmap, prange->bitmap_access,
 			  prange->bitmap_aip, MAX_GPU_INSTANCE);
 	}
 
 	if (bitmap_empty(ctx->bitmap, MAX_GPU_INSTANCE)) {
-		bitmap_copy(ctx->bitmap, prange->bitmap_access, MAX_GPU_INSTANCE);
-		if (!prange->mapped_to_gpu ||
-		    bitmap_empty(ctx->bitmap, MAX_GPU_INSTANCE)) {
-			r = 0;
-			goto free_ctx;
-		}
+		r = 0;
+		goto free_ctx;
 	}
 
 	if (prange->actual_loc && !prange->ttm_res) {
-- 
2.43.0



