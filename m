Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361C634A783;
	Wed, 21 Jan 2026 18:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019961; cv=none; b=FhDefz4jvBetQWxmNPOlgXz/RiY/IGz6JUCKAb7hocXXTBhm0ehrDOjLLdlU+7cSQdvi1gW/sc35f1dvwwt85P1YOEfTutZ/YieugO5JirLE2AA6YaeAKlcNzXGiWHSosquZEMKFX3yeFlBbnoJF6UFYZsbCfKmyW/DjCDRfGmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019961; c=relaxed/simple;
	bh=HZe7uo34VVqp1p5S0ryb7w1Od/uoK9w8/nniKxHWtqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSsdKYThxuKujfZ0pNJy9e4jzRgom9Og8F7ENcFbwbqrqBW5+gJMPMDeifnMS7LPERzX4bVvfyGLqJ1X+KMT+aJrilXh9q1HmWPtaDN/MUCrdGz++GvTopNWvvRqugUKeuDTMYOLYxFGBTzMoPUEKeoR8JLwuNFnhCFaHfp+5PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTLrv+ja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTLrv+ja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB620C4CEF1;
	Wed, 21 Jan 2026 18:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019961;
	bh=HZe7uo34VVqp1p5S0ryb7w1Od/uoK9w8/nniKxHWtqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTLrv+jaRgkyiRIkqW8tIBxObgFrAr/Pi6OhBGJHBv7mPMi8IiXFjm/RsD8zxUwgb
	 UUwP6EK6n57USHZRa21y1WblNgCZU5WZYRN4HbMh9ce+6rBa9hhFC0Nt1BnTVOJ9sU
	 mEzsspPtfgq35hfIkJ5EO26GAbfeobljKUODJgvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/198] drm/vmwgfx: Fix KMS with 3D on HW version 10
Date: Wed, 21 Jan 2026 19:14:07 +0100
Message-ID: <20260121181419.244204750@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit d9186faeae6efb7d0841a5e8eb213ff4c7966614 ]

HW version 10 does not have GB Surfaces so there is no backing buffer for
surface backed FBs. This would result in a nullptr dereference and crash
the driver causing a black screen.

Fixes: 965544150d1c ("drm/vmwgfx: Refactor cursor handling")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patch.msgid.link/20251114203703.1946616-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 54ea1b513950a..535d844191e7a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -763,13 +763,15 @@ static struct drm_framebuffer *vmw_kms_fb_create(struct drm_device *dev,
 		return ERR_PTR(ret);
 	}
 
-	ttm_bo_reserve(&bo->tbo, false, false, NULL);
-	ret = vmw_bo_dirty_add(bo);
-	if (!ret && surface && surface->res.func->dirty_alloc) {
-		surface->res.coherent = true;
-		ret = surface->res.func->dirty_alloc(&surface->res);
+	if (bo) {
+		ttm_bo_reserve(&bo->tbo, false, false, NULL);
+		ret = vmw_bo_dirty_add(bo);
+		if (!ret && surface && surface->res.func->dirty_alloc) {
+			surface->res.coherent = true;
+			ret = surface->res.func->dirty_alloc(&surface->res);
+		}
+		ttm_bo_unreserve(&bo->tbo);
 	}
-	ttm_bo_unreserve(&bo->tbo);
 
 	return &vfb->base;
 }
-- 
2.51.0



