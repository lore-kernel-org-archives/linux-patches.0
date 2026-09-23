Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729FB535FAB;
	Wed, 23 Sep 2026 14:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174125; cv=none; b=M4FzCKLR2L+Dr/ZEQXS4zLy9UrzWid4FE3Z2kwMMTHezewAh3CF70jhEnXHH4vVTuFWj76v/LL22VyoXbbn7AVzPXFMMv8zzqnWPJXRlvpWPaRe8Xzx3oL8w+vBSDHxqOdPs5cfvcfSIZRvpII+QS8TS10L9ucodo9kI6Bo1Ct0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174125; c=relaxed/simple;
	bh=AQ+RxIoJSsWqMak05EKI4oAlilIiM8ovpayOTfoPv5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbN3+6Xlk/PWOIempUSzv6ogoaz9FblN8lVVnijaaFzlbcL4TJkgjW4BSyGGjW9CRU5np/HY5eKh4ICyr65zsE9Zksld+tAK+ThahoUslCkjfreWy7pc0mZ4+bJR4Xmzg0R6SLhn6sCHb1KAZl6uzueuWTBTvvMMGQfCb+c1qOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRqnq4vC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRqnq4vC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFDC1F000FF;
	Wed, 23 Sep 2026 14:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174124;
	bh=KCewmwSuURV0TaDuSwaEmDwz4jf8/6SbPcORD5VBXy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RRqnq4vC94m2psMSfWsiwKCYyf8m6SIsk2MZmSavYoPmVnNHVXwkGoZjC/RcKB3Q1
	 kHGVsmsUS0Y3Pbf7RhccZRr47zGlkpugxEA4urWLQMBQo6uIAdPxGTRb3KBkBpkErk
	 tDp04BI1ptrSE3sSbQu0XCXij591QgCcc9mozTw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sophie D <patches@scd31.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 7.2 401/438] drm/gud: Ignore damage clips in full update mode
Date: Wed, 23 Sep 2026 16:07:02 +0200
Message-ID: <20260923140655.288485543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/gud/gud_pipe.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -482,6 +482,9 @@ int gud_plane_atomic_check(struct drm_pl
 	if (!new_plane_state->visible)
 		return 0;
 
+	if (gdrm->flags & GUD_DISPLAY_FLAG_FULL_UPDATE)
+		new_plane_state->ignore_damage_clips = true;
+
 	if (old_plane_state->rotation != new_plane_state->rotation)
 		crtc_state->mode_changed = true;
 


