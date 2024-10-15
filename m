Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61E92296C4;
	Tue, 15 Oct 2024 13:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998060; cv=none; b=NIbw1rXmsbQgH0eZlsjU9yhTw8hZz6DkuK3Z3Wr+qlLH5oOidzFj70I3O+cb2YLmZMeK/8peWz1JgD8YIzdyclJOgf0cDFN/FRSxCVNO2AHszZPfdaWLcAqfAOfO8HRdSWSNKAmJPdAekAR8CIDtZgxhLRNKfhVt87naQsEebTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998060; c=relaxed/simple;
	bh=pbPdtcEEb8oRMKu+BYspEqur8E4y6pX4UYyPTtMUZ+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hK1Jj5sJg9dNW72dIYCBvo0rHox1whs/dmnXLv50UvEAGwDwMwzNnFsF49e7gISpMOhMBFzRXCxy+GySNCJEYHDPhrzjoR0P3JxPwI0fbMEYHHlO41DKmX2ekw8V5byE3MxKFjVwgwE4+er/IHRqoiCN4KboZOq0nILfqe7FUUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTRMC9SF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTRMC9SF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA4BC4CEC6;
	Tue, 15 Oct 2024 13:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998060;
	bh=pbPdtcEEb8oRMKu+BYspEqur8E4y6pX4UYyPTtMUZ+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTRMC9SF2D8iP/2wFee9yNSLAv0Pj2i+7+WV/OHvBT6C/8UvNj+aMHwxtJrDX+OzF
	 v09/yzQjgQ7VPg2v1OAaRkjfHwbaNsZ7rz8DdYj9h9Paz6l3SkXqDc2XpEPc+M4tdL
	 tgMk+Dq+Hd1vRTmPEBCNBG+Hyz5BgLG0MrtBXYqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lukasz Spintzyk <lukasz.spintzyk@displaylink.com>,
	Deepak Rawat <drawat@vmware.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	dri-devel@lists.freedesktop.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 5.10 366/518] drm: Consistently use struct drm_mode_rect for FB_DAMAGE_CLIPS
Date: Tue, 15 Oct 2024 14:44:30 +0200
Message-ID: <20241015123931.099415996@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 8b0d2f61545545ab5eef923ed6e59fc3be2385e0 upstream.

FB_DAMAGE_CLIPS is a plane property for damage handling. Its UAPI
should only use UAPI types. Hence replace struct drm_rect with
struct drm_mode_rect in drm_atomic_plane_set_property(). Both types
are identical in practice, so there's no change in behavior.

Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Closes: https://lore.kernel.org/dri-devel/Zu1Ke1TuThbtz15E@intel.com/
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: d3b21767821e ("drm: Add a new plane property to send damage during plane update")
Cc: Lukasz Spintzyk <lukasz.spintzyk@displaylink.com>
Cc: Deepak Rawat <drawat@vmware.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.0+
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240923075841.16231-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic_uapi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -584,7 +584,7 @@ static int drm_atomic_plane_set_property
 					&state->fb_damage_clips,
 					val,
 					-1,
-					sizeof(struct drm_rect),
+					sizeof(struct drm_mode_rect),
 					&replaced);
 		return ret;
 	} else if (plane->funcs->atomic_set_property) {


