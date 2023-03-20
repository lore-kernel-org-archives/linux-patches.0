Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19DA1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26642C433EF;
	Mon, 20 Mar 2023 15:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324711;
	bh=6cxS4m80Ezf2GPjn4+YCuF9rMU5fZ9CAwz9Ntc5fLro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlHFtwE7z6qNKmai/v5aalhvbxBN+w2gThQoV+HSD2xSv/KkgMRLhElZfG8+etvPj
	 mVS7idDKtf9dhTUWzGmkWA+Gw6FCh1xG2OM1s2h1dpjITLR1RRoWJpBD/cHbFQneeq
	 Qs5u8B5KJOSvJNrseLQliU1BJKf5gpZsLBb4gIkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/115] drm/i915/display: Workaround cursor left overs with PSR2 selective fetch enabled
Date: Mon, 20 Mar 2023 15:53:53 +0100
Message-Id: <20230320145450.300784720@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: José Roberto de Souza <jose.souza@intel.com>

[ Upstream commit 1f3a11c341ab211d6ba55ef3d58026b7b5319945 ]

Not sure why but when moving the cursor fast it causes some artifacts
of the cursor to be left in the cursor path, adding some pixels above
the cursor to the damaged area fixes the issue, so leaving this as a
workaround until proper fix is found.

This is reproducile on TGL and ADL-P.

Cc: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Reviewed-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210914212507.177511-3-jose.souza@intel.com
Stable-dep-of: 71c602103c74 ("drm/i915/psr: Use calculated io and fast wake lines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 25 ++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index a3d0c57ec0f0b..b4b193c2bc32e 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1601,6 +1601,28 @@ static void intel_psr2_sel_fetch_pipe_alignment(const struct intel_crtc_state *c
 		drm_warn(&dev_priv->drm, "Missing PSR2 sel fetch alignment with DSC\n");
 }
 
+/*
+ * FIXME: Not sure why but when moving the cursor fast it causes some artifacts
+ * of the cursor to be left in the cursor path, adding some pixels above the
+ * cursor to the damaged area fixes the issue.
+ */
+static void cursor_area_workaround(const struct intel_plane_state *new_plane_state,
+				   struct drm_rect *damaged_area,
+				   struct drm_rect *pipe_clip)
+{
+	const struct intel_plane *plane = to_intel_plane(new_plane_state->uapi.plane);
+	int height;
+
+	if (plane->id != PLANE_CURSOR)
+		return;
+
+	height = drm_rect_height(&new_plane_state->uapi.dst) / 2;
+	damaged_area->y1 -=  height;
+	damaged_area->y1 = max(damaged_area->y1, 0);
+
+	clip_area_update(pipe_clip, damaged_area);
+}
+
 int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 				struct intel_crtc *crtc)
 {
@@ -1669,6 +1691,9 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 				damaged_area.y2 = new_plane_state->uapi.dst.y2;
 				clip_area_update(&pipe_clip, &damaged_area);
 			}
+
+			cursor_area_workaround(new_plane_state, &damaged_area,
+					       &pipe_clip);
 			continue;
 		} else if (new_plane_state->uapi.alpha != old_plane_state->uapi.alpha ||
 			   (!num_clips &&
-- 
2.39.2



