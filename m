Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140BD3264F1;
	Mon, 20 Apr 2026 16:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701284; cv=none; b=o3ikZ1oDIhKDUHdBV5ar5B8lFMrY1o4AgGh2oV74M3eTq24XyfE62P7gqX14DtREnGOFLiM5SSsMUu/QwYO058JrMd81dI8Uy90sgW643rNtswjvk7mEZoEnN3GmRGXKldVVqdWk1/BDzavL02LPR7LWFLqOLDz25yXdNd5xUy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701284; c=relaxed/simple;
	bh=tjlqBejakTbcgR4B5gF5n6QX0KmlmaI1A+52sLQQYv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qzh7mpE8QA9CwM6rTagE/p2oGvxB1OeetWabKkO6z82xyuLSNMvfY02TmyC4GalRRUoPYoyTKxJg3A0e7uSzOy8Sydc8y0E78AcLOiutqa4xKnxP7VM9jfC154LiA64TCxyooyzKJHVyBWbt23pXCDxR5h984Bmni/mqHuYZlDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9UH4nX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9UH4nX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBC6C19425;
	Mon, 20 Apr 2026 16:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701284;
	bh=tjlqBejakTbcgR4B5gF5n6QX0KmlmaI1A+52sLQQYv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9UH4nX3d9AoZauy4MOHBjEFaes6ZMRUpJgmc5r/31lgX0aBNULhdszVlF9Okj6JT
	 xmzYgURcl5LQe4fI1Ql66oQ52RHREdjV/1Z6ZGCrXZl2/tGDf5KJ4FackQx2PC6Ct2
	 o+6RQ7uoFepaz/7ez66Nb2FM28qC3D4f+/VhjXr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/162] drm/vc4: Fix a memory leak in hang state error path
Date: Mon, 20 Apr 2026 17:41:18 +0200
Message-ID: <20260420153928.695375033@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 9525d169e5fd481538cf8c663cc5839e54f2e481 ]

When vc4_save_hang_state() encounters an early return condition, it
returns without freeing the previously allocated `kernel_state`,
leaking memory.

Add the missing kfree() calls by consolidating the early return paths
into a single place.

Fixes: 214613656b51 ("drm/vc4: Add an interface for capturing the GPU state after a hang.")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Link: https://patch.msgid.link/20260330-vc4-misc-fixes-v1-3-92defc940a29@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_gem.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_gem.c b/drivers/gpu/drm/vc4/vc4_gem.c
index 373d310c7b6a5..62d19601ef356 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -169,10 +169,8 @@ vc4_save_hang_state(struct drm_device *dev)
 	spin_lock_irqsave(&vc4->job_lock, irqflags);
 	exec[0] = vc4_first_bin_job(vc4);
 	exec[1] = vc4_first_render_job(vc4);
-	if (!exec[0] && !exec[1]) {
-		spin_unlock_irqrestore(&vc4->job_lock, irqflags);
-		return;
-	}
+	if (!exec[0] && !exec[1])
+		goto err_free_state;
 
 	/* Get the bos from both binner and renderer into hang state. */
 	state->bo_count = 0;
@@ -189,10 +187,8 @@ vc4_save_hang_state(struct drm_device *dev)
 	kernel_state->bo = kcalloc(state->bo_count,
 				   sizeof(*kernel_state->bo), GFP_ATOMIC);
 
-	if (!kernel_state->bo) {
-		spin_unlock_irqrestore(&vc4->job_lock, irqflags);
-		return;
-	}
+	if (!kernel_state->bo)
+		goto err_free_state;
 
 	k = 0;
 	for (i = 0; i < 2; i++) {
@@ -284,6 +280,12 @@ vc4_save_hang_state(struct drm_device *dev)
 		vc4->hang_state = kernel_state;
 		spin_unlock_irqrestore(&vc4->job_lock, irqflags);
 	}
+
+	return;
+
+err_free_state:
+	spin_unlock_irqrestore(&vc4->job_lock, irqflags);
+	kfree(kernel_state);
 }
 
 static void
-- 
2.53.0



