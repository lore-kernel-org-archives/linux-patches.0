Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F68755FB;
	Mon, 29 Jan 2024 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548597; cv=none; b=LZLxFITmfeM/mfsZo1dvV5Z6hwJ/NzUv+QLxYPi/2iPjGSlDyzfu343tm7a9yAblmsuw4WeEQMgglGOGRS31NpjjrQT9wppdS4WMIc/LOOU6Sm8alwU3RGWa4IG0f6qT9xvACkhWacR7r95dVCL6sqtDpTHqnOQ/6G0QDEUewvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548597; c=relaxed/simple;
	bh=iV4VGCs3nDenNB51F+alsaJfB9G61M4YFmRKLubP2/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKUbDTEbgvB7mm5a16CLVOdtzOc7wKqblZ2p+sF4qUzs0sCuDdSdaCwdLfDaNroOsNnhllrvAgfcTct+xGHBo20PPYiCleDwWIeSmzTz1FS5ovJ5bW0tgfPEA5dhQllJLl1X+qixw2dBGN8KSK20jg49xzzvyzr9Ta+WI8znvp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQNHDLKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQNHDLKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB99C433F1;
	Mon, 29 Jan 2024 17:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548597;
	bh=iV4VGCs3nDenNB51F+alsaJfB9G61M4YFmRKLubP2/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQNHDLKOfaNXBLeeUPHXk6jEziM9SQxVuRLRKvmWbdd1/Krl+JS+PlmccpDK3tU6y
	 vagGtXUMt6LEX/DuTAGrT+ZgNntOKNmCHAHQnov2nCSuAbnSX8rWajO6szWzFqFY5e
	 yotP5Xv78JK1FWoEGEzy5hTW0mhfFLGqkAv8kWbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.6 258/331] drm/tidss: Fix atomic_flush check
Date: Mon, 29 Jan 2024 09:05:22 -0800
Message-ID: <20240129170022.434289682@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
@@ -169,13 +169,13 @@ static void tidss_crtc_atomic_flush(stru
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


