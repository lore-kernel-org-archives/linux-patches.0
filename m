Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1695130AAC6;
	Mon, 13 Oct 2025 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369473; cv=none; b=CfyQOi89a4/ojd2B2P8/015+fk6ct2zIBo6+r90qB+hdvSFpYJi6sJpFIt8KqHx1MZvOrqel9mKyQ67NnaKfIfhnBRB6j7fV5oEkzvukcldyB3WH3BcEArEBRR4NYOpLRkphLp1pwd5FU3IuvMAlWXJiGJ+0FRTnx7GcQg2ZNn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369473; c=relaxed/simple;
	bh=tFISL2veRwHPa+nJ2rEtL7DnRTEGmWUIfMvOkzXDXiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g/psVVGEMKxyWcUXcARObdJA1XWIbIkBVI8bw+64pkhRZkQIubrqHrrYB6jUnZlC4DYDRu44OzVlrNiKGUUMvN3kveNmSj8Zz1DKcwNX2i2YjiAP43zut63x3g4yCPCqZaWiTJtPWOTj1NbZdpo+BDPipmN+v+8orwUL0tC2MCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOjBpfGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOjBpfGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39ECDC4CEE7;
	Mon, 13 Oct 2025 15:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369472;
	bh=tFISL2veRwHPa+nJ2rEtL7DnRTEGmWUIfMvOkzXDXiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOjBpfGoqkyok5TUqQ+Tbr2PXkP/UhYHBlp0qeCGYAPExstEik2WqXrLPhvmiqjTk
	 qc1xcIFc17e4MbknqKSUFREczSWK2kt3ZpNiVfUbGvKmDK1KMA9J7MdSTeSQLt11Go
	 3KnkiLqjNaZCzV0Gg5QBvafHQxXWt+7RSH99p2aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xaver Hugl <xaver.hugl@kde.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 258/563] drm: re-allow no-op changes on non-primary planes in async flips
Date: Mon, 13 Oct 2025 16:41:59 +0200
Message-ID: <20251013144420.625268933@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xaver Hugl <xaver.hugl@kde.org>

[ Upstream commit b065bd213caf6d35b57c5089d6507d7e8598a586 ]

Commit fd40a63c63a1 ("drm/atomic: Let drivers decide which planes to
async flip") unintentionally disallowed no-op changes on non-primary
planes that the driver doesn't allow async flips on. This broke async
flips for compositors that disable the cursor plane in every async
atomic commit. To fix that, change drm_atomic_set_property to again
only run atomic_async_check if the plane would actually be changed by
the atomic commit.

Fixes: fd40a63c63a1 ("drm/atomic: Let drivers decide which planes to async flip")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4263
Signed-off-by: Xaver Hugl <xaver.hugl@kde.org>
Reviewed-by: André Almeida <andrealmeid@igalia.com>
Link: https://lore.kernel.org/r/20250822152849.87843-1-xaver.hugl@kde.org
[andrealmeid: fix checkpatch warning]
Signed-off-by: André Almeida <andrealmeid@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_uapi.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_uapi.c b/drivers/gpu/drm/drm_atomic_uapi.c
index ecc73d52bfae4..85dbdaa4a2e25 100644
--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -1078,19 +1078,20 @@ int drm_atomic_set_property(struct drm_atomic_state *state,
 		}
 
 		if (async_flip) {
-			/* check if the prop does a nop change */
-			if ((prop != config->prop_fb_id &&
-			     prop != config->prop_in_fence_fd &&
-			     prop != config->prop_fb_damage_clips)) {
-				ret = drm_atomic_plane_get_property(plane, plane_state,
-								    prop, &old_val);
-				ret = drm_atomic_check_prop_changes(ret, old_val, prop_value, prop);
-			}
+			/* no-op changes are always allowed */
+			ret = drm_atomic_plane_get_property(plane, plane_state,
+							    prop, &old_val);
+			ret = drm_atomic_check_prop_changes(ret, old_val, prop_value, prop);
 
-			/* ask the driver if this non-primary plane is supported */
-			if (plane->type != DRM_PLANE_TYPE_PRIMARY) {
-				ret = -EINVAL;
+			/* fail everything that isn't no-op or a pure flip */
+			if (ret && prop != config->prop_fb_id &&
+			    prop != config->prop_in_fence_fd &&
+			    prop != config->prop_fb_damage_clips) {
+				break;
+			}
 
+			if (ret && plane->type != DRM_PLANE_TYPE_PRIMARY) {
+				/* ask the driver if this non-primary plane is supported */
 				if (plane_funcs && plane_funcs->atomic_async_check)
 					ret = plane_funcs->atomic_async_check(plane, state, true);
 
-- 
2.51.0



