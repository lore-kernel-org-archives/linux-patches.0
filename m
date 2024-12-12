Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9992210F8;
	Thu, 12 Dec 2024 16:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019270; cv=none; b=t03wKbFATrU5hVHPzuhU2Kqv/hwVP6au9jqGeBT9VmYvcxw9diX4+8DeicuWwATrecJenp3ehqI+ZeF8jsOX6Y8kljL8y7TB1azXAgmg+FgLdHVvrslBHuj7XneJmu/z1Q81E+qaRoTRHf7FDTFL+Jb97m8qld+nlnjsDtWfITI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019270; c=relaxed/simple;
	bh=DNq/xW3KoPX75yFlgh1gGrbXpZes7Wzt+y2bUWcJ7n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwbnYN8MCKAsKa5CDyY6K2CqI8G6ntlr/vBbhfi00BLdQOZ1eugNgBEcaT+irqvKbBI/JAifyadXxlp+vZ/OqVcg+EYw8eHrpFGI3krBJgtAuFWIy0USL1twy6eO0Ladc9XaYRzDOY4bCctcDsDJ661dUhT/IYX0leVZWdBs3qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8lNJD4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8lNJD4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09498C4CECE;
	Thu, 12 Dec 2024 16:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019269;
	bh=DNq/xW3KoPX75yFlgh1gGrbXpZes7Wzt+y2bUWcJ7n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8lNJD4HcjnQ7p+Ss/Ys0q1N7vNpB/TIq2usIjEKsWt/Dg5I5aSVlYsTTrPmZY/Il
	 Jq2N5LJ/16qC9Tj/1QupEL6VR/I6sVWsavZY+mnHOPvcNE1F30rp97yGZk+7q+zirZ
	 waI9pESWXKrgvmi6RgucrH+lpp9PFNYZyf1F2R5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/772] drm/omap: Fix locking in omap_gem_new_dmabuf()
Date: Thu, 12 Dec 2024 15:51:18 +0100
Message-ID: <20241212144355.431724368@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit e6a1c4037227539373c8cf484ace83833e2ad6a2 ]

omap_gem_new_dmabuf() creates the new gem object, and then takes and
holds the omap_obj->lock for the rest of the function. This has two
issues:

- omap_gem_free_object(), which is called in the error paths, also takes
  the same lock, leading to deadlock
- Even if the above wouldn't happen, in the error cases
  omap_gem_new_dmabuf() still unlocks omap_obj->lock, even after the
  omap_obj has already been freed.

Furthermore, I don't think there's any reason to take the lock at all,
as the object was just created and not yet shared with anyone else.

To fix all this, drop taking the lock.

Fixes: 3cbd0c587b12 ("drm/omap: gem: Replace struct_mutex usage with omap_obj private lock")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/511b99d7-aade-4f92-bd3e-63163a13d617@stanley.mountain/
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240806-omapdrm-misc-fixes-v1-3-15d31aea0831@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/omap_gem.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_gem.c b/drivers/gpu/drm/omapdrm/omap_gem.c
index cf571796fd26e..8fdb12ce2f884 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -1408,8 +1408,6 @@ struct drm_gem_object *omap_gem_new_dmabuf(struct drm_device *dev, size_t size,
 
 	omap_obj = to_omap_bo(obj);
 
-	mutex_lock(&omap_obj->lock);
-
 	omap_obj->sgt = sgt;
 
 	if (sgt->orig_nents == 1) {
@@ -1424,21 +1422,17 @@ struct drm_gem_object *omap_gem_new_dmabuf(struct drm_device *dev, size_t size,
 		pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
 		if (!pages) {
 			omap_gem_free_object(obj);
-			obj = ERR_PTR(-ENOMEM);
-			goto done;
+			return ERR_PTR(-ENOMEM);
 		}
 
 		omap_obj->pages = pages;
 		ret = drm_prime_sg_to_page_array(sgt, pages, npages);
 		if (ret) {
 			omap_gem_free_object(obj);
-			obj = ERR_PTR(-ENOMEM);
-			goto done;
+			return ERR_PTR(-ENOMEM);
 		}
 	}
 
-done:
-	mutex_unlock(&omap_obj->lock);
 	return obj;
 }
 
-- 
2.43.0



