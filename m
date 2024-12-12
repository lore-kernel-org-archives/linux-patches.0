Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0962223C5C;
	Thu, 12 Dec 2024 16:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022107; cv=none; b=MI5VfFWX5lmQPUX0fElGPoG+EOUg6loxrACUAwzQVUPkSGt9v/WE+7A2Obj4N3sAgD9yzUoQMV/2PdAQa/NO9O8hCYHaQWbrbJbZN1crBK6HTAmHtjPMQL9jtbpYnA3AhJk0e1dBdDWDNLAnIHd+RitQC2Y6z+dCUZCvEGy2dGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022107; c=relaxed/simple;
	bh=UDKMsbPpWQgA3S+BhiVFZ9ZbUKieecG/BHCcV6akSCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBobr5WDXqlhD05UjPGnV3P2brP6c0lvcONkhqSCzMFMm9jMaCvqKqbgYeZM5dNC7Fstyc+rOxSeDuuPN2m/z2MyEWCygWIqXr23iKV6bMYbWrl9XRZSgjS9ARErqKm+iDANeKhrtWWK5FTtf7U8i+CiHPmkXZRDhBiuODxtmS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R90kBZoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R90kBZoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B73C4CECE;
	Thu, 12 Dec 2024 16:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022106;
	bh=UDKMsbPpWQgA3S+BhiVFZ9ZbUKieecG/BHCcV6akSCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R90kBZoDtmOI2Cl0ZWYxIqJT7ghKn3R+vjXSCHbWXFA5FcrQlcx+AhzSR6NfQjzal
	 QFMwypUi+Mtz7XrPQXP1/jFyR7XEmYoFxC8wT44uCJwPXU5PNsEBUFYxoxaEApWD0u
	 AFFedE6a1HuNWp79NaPbLWtGSKSu1Ho7m28pZptQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/565] drm/omap: Fix locking in omap_gem_new_dmabuf()
Date: Thu, 12 Dec 2024 15:55:44 +0100
Message-ID: <20241212144317.375182551@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 38af6195d9593..ed206312ab426 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -1303,8 +1303,6 @@ struct drm_gem_object *omap_gem_new_dmabuf(struct drm_device *dev, size_t size,
 
 	omap_obj = to_omap_bo(obj);
 
-	mutex_lock(&omap_obj->lock);
-
 	omap_obj->sgt = sgt;
 
 	if (sgt->orig_nents == 1) {
@@ -1319,21 +1317,17 @@ struct drm_gem_object *omap_gem_new_dmabuf(struct drm_device *dev, size_t size,
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



