Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B7678B50;
	Wed, 21 Feb 2024 13:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522154; cv=none; b=Kqy1iYujp3ibJz0u6vYBooH8jJYf9q4mYyziY56AHyfBHyPZraLLgngQZFDRPkyTA0HP846kIj9y6cYFgCGS+gwo9BzXTw3aIWzbN9JCmSzlKSTh/iWROsgJAfyFHzwpo9caPELUOkB0G8RT2dy927SxKb1P8QbsNij5TVhtdoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522154; c=relaxed/simple;
	bh=iZDZSvwl6irlDjxvtMvw8TSy4b6N92rPTKTq78tdp+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGT0Xdv2YkvIZCP9VXxVOWJBnnpWCwL5vyOZdMGD1hISixb60PvE9h2gkjFXlM7q1JxtzdqWNKy/Yua6Cdp4hHR6t/eMKtHywXsKUiR6bS1brmRSsY/zGr9Hp32KeQeYptPMeodyst/yJwMbUlm2n7VLq+5Xih7GtXKXHLsi5s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/uotznL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/uotznL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBF1C433B1;
	Wed, 21 Feb 2024 13:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522154;
	bh=iZDZSvwl6irlDjxvtMvw8TSy4b6N92rPTKTq78tdp+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/uotznLA327b/AmlPN4dgWv4RJFbwTVI/dnA3eDDc4P3LbRikScw3dSOXYKAULaR
	 u/PAnTzqe29bjwSoZiS3dLTW+YOkU/7WD+B5WCM4Syn4CM+gJYQEPfPG1OJYv+9KKU
	 EUkejvD416SA+JJqaftJNImk9ZnR9SSmSnqOlFsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 5.15 093/476] drm/tidss: Fix atomic_flush check
Date: Wed, 21 Feb 2024 14:02:24 +0100
Message-ID: <20240221130011.439706687@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

commit 95d4b471953411854f9c80b568da7fcf753f3801 upstream.

tidss_crtc_atomic_flush() checks if the crtc is enabled, and if not,
returns immediately as there's no reason to do any register changes.

However, the code checks for 'crtc->state->enable', which does not
reflect the actual HW state. We should instead look at the
'crtc->state->active' flag.

This causes the tidss_crtc_atomic_flush() to proceed with the flush even
if the active state is false, which then causes us to hit the
WARN_ON(!crtc->state->event) check.

Fix this by checking the active flag, and while at it, fix the related
debug print which had "active" and "needs modeset" wrong way.

Cc:  <stable@vger.kernel.org>
Fixes: 32a1795f57ee ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Link: https://lore.kernel.org/r/20231109-tidss-probe-v2-10-ac91b5ea35c0@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tidss/tidss_crtc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/tidss/tidss_crtc.c
+++ b/drivers/gpu/drm/tidss/tidss_crtc.c
@@ -172,13 +172,13 @@ static void tidss_crtc_atomic_flush(stru
 	struct tidss_device *tidss = to_tidss(ddev);
 	unsigned long flags;
 
-	dev_dbg(ddev->dev,
-		"%s: %s enabled %d, needs modeset %d, event %p\n", __func__,
-		crtc->name, drm_atomic_crtc_needs_modeset(crtc->state),
-		crtc->state->enable, crtc->state->event);
+	dev_dbg(ddev->dev, "%s: %s is %sactive, %s modeset, event %p\n",
+		__func__, crtc->name, crtc->state->active ? "" : "not ",
+		drm_atomic_crtc_needs_modeset(crtc->state) ? "needs" : "doesn't need",
+		crtc->state->event);
 
 	/* There is nothing to do if CRTC is not going to be enabled. */
-	if (!crtc->state->enable)
+	if (!crtc->state->active)
 		return;
 
 	/*


