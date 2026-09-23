Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E07D535FA9;
	Wed, 23 Sep 2026 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175165; cv=none; b=sviV+ubDT6kdii2z9BZwxzWh9QbmzvfJoavU14Zpo9DXcfmup6Zj2C5aFP96lT1IRs2RsN/+6lydB+1NZAdie9gdKgmvD3oKH0P0v0J3leGbKHvNOxW9mn+ObQxwHSmAmX14+MFnkWE4eTpMNAwaO60yHOaMygOuqE8byi0gH7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175165; c=relaxed/simple;
	bh=E6f7m8EMIfuLJ3czsBG/gh0Ml2bS1MOQf3M1IlPQ/V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPbT2PFoNkuO2KTTvwVgx2Xb4OTdpcyhxmuqzOXjt4pkQxT+DVqAu13gm97eJCm1hjEn49zdSl1uV1JoSBwPoNJg514zYKT7uDMA1xee0JtdcswcuKfM28sPX49eBENkNyn46xez+vsEI3i9MBzAm57YTZclX8zFYc0/xe797Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ooG2Y3Rg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ooG2Y3Rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89F41F00893;
	Wed, 23 Sep 2026 14:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175160;
	bh=zUiCCtkgC7IDaKTz2e1qUBzeOza1kMzHSDmaQBaN28k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooG2Y3RgDk1H3rB+yFnlfB8ZXiz22lX6ut6YOAqkbZeakuSV5AC+PUUJja3WYLEH2
	 bZPuiOA0MkrNucmjiQSyz4eBi2pbW6QKK0iXTIyraSJr8tTDLyz47EzNhHMjikXtgd
	 gbfoevqwFoIpQM4PJj1LJVTvuIV5jKbyZgudj3Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sophie D <patches@scd31.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 6.18 339/398] drm/gud: Ignore damage clips in full update mode
Date: Wed, 23 Sep 2026 16:06:53 +0200
Message-ID: <20260923140652.212773245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Sophie D <patches@scd31.com>

commit effce1cb87ee0d8b3a8cbe7722968f4ea7efd360 upstream.

When running in full update mode, previously small updates (such as
moving the mouse across the screen) would cause many full frames to be
generated. This would bog down the bus and lower the effective framerate
significantly - I was seeing a drop from 60 FPS to 2 FPS.

Set ignore_damage_clips in full update mode so the damage iterator
yields a single full-plane rectangle instead of one per clip.

Fixes: 73cfd166e045 ("drm/gud: Replace simple display pipe with DRM atomic helpers")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Sophie D <patches@scd31.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Ruben Wauters <rubenru09@aol.com>
Signed-off-by: Ruben Wauters <rubenru09@aol.com>
Link: https://patch.msgid.link/20260910014910.8564-1-patches@scd31.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gud/gud_pipe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/gud/gud_pipe.c b/drivers/gpu/drm/gud/gud_pipe.c
index 5ef887d8485a..3388fdc8ea7b 100644
--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -482,6 +482,9 @@ int gud_plane_atomic_check(struct drm_plane *plane,
 	if (!new_plane_state->visible)
 		return 0;
 
+	if (gdrm->flags & GUD_DISPLAY_FLAG_FULL_UPDATE)
+		new_plane_state->ignore_damage_clips = true;
+
 	if (old_plane_state->rotation != new_plane_state->rotation)
 		crtc_state->mode_changed = true;
 
-- 
2.55.0



