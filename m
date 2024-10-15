Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A10F1AF0B3;
	Tue, 15 Oct 2024 12:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996923; cv=none; b=CA9zT852e4wVDePJf7z/oeVbl/CFTUqTgtKDev/p5qE222yU6NmyGPicxlF01nBn9TpPFmFnqAX4cBOGc7kmZgnXkBRwfM6BClVeeWLCWoltiZV7/QitMYnVySx9ETls9HD+vXQa71gN9v+m5X0obgw43CDR9d6PtagKSfxwc3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996923; c=relaxed/simple;
	bh=vMO8M480i4ihwYUorQP5LIQ/+JhBVLQkSQuqtLUI6no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUhtfIvzMWW7AhYPLw2lGgaQnyXYzyIcGoYkIYrQ2pL+qRdxZiyTvj7NZR4NsE4MhU8h7hTG4kYHv7GAuG5CEv32QFSU05BV6qWBZcoue6WubVBlbFTuAoCB75QT6WrX/pc3xZof1ERqjJq7lI9BLq169YFgr1glKwvsTq25MI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNh/SAP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNh/SAP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9B5C4CECE;
	Tue, 15 Oct 2024 12:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996923;
	bh=vMO8M480i4ihwYUorQP5LIQ/+JhBVLQkSQuqtLUI6no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNh/SAP7VSEM2VEtCRn6zCOHwdFgYe+AUqBO/U11VspHQRQW7nA75XY2AR2LPD+wG
	 eHjUCi5IBxFD9KIPc/deLorGH6h9N038V7dG2TH+O0o2GCaGftFImnf+QlLRB97Qrg
	 WQEWf72ip1nbqR7q3pDeeegI8f4EPb5g0IcCO0TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hongchi.peng" <hongchi.peng@siengine.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/518] drm: komeda: Fix an issue related to normalized zpos
Date: Tue, 15 Oct 2024 14:39:03 +0200
Message-ID: <20241015123918.513129415@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hongchi.peng <hongchi.peng@siengine.com>

[ Upstream commit 258905cb9a6414be5c9ca4aa20ef855f8dc894d4 ]

We use komeda_crtc_normalize_zpos to normalize zpos of affected planes
to their blending zorder in CU. If there's only one slave plane in
affected planes and its layer_split property is enabled, order++ for
its split layer, so that when calculating the normalized_zpos
of master planes, the split layer of the slave plane is included, but
the max_slave_zorder does not include the split layer and keep zero
because there's only one slave plane in affacted planes, although we
actually use two slave layers in this commit.

In most cases, this bug does not result in a commit failure, but assume
the following situation:
    slave_layer 0: zpos = 0, layer split enabled, normalized_zpos =
    0;(use slave_layer 2 as its split layer)
    master_layer 0: zpos = 2, layer_split enabled, normalized_zpos =
    2;(use master_layer 2 as its split layer)
    master_layer 1: zpos = 4, normalized_zpos = 4;
    master_layer 3: zpos = 5, normalized_zpos = 5;
    kcrtc_st->max_slave_zorder = 0;
When we use master_layer 3 as a input of CU in function
komeda_compiz_set_input and check it with function
komeda_component_check_input, the parameter idx is equal to
normailzed_zpos minus max_slave_zorder, the value of idx is 5
and is euqal to CU's max_active_inputs, so that
komeda_component_check_input returns a -EINVAL value.

To fix the bug described above, when calculating the max_slave_zorder
with the layer_split enabled, count the split layer in this calculation
directly.

Signed-off-by: hongchi.peng <hongchi.peng@siengine.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240826024517.3739-1-hongchi.peng@siengine.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_kms.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_kms.c b/drivers/gpu/drm/arm/display/komeda/komeda_kms.c
index 1f6682032ca49..ac8b7fb20d8fc 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_kms.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_kms.c
@@ -142,6 +142,7 @@ static int komeda_crtc_normalize_zpos(struct drm_crtc *crtc,
 	struct drm_plane *plane;
 	struct list_head zorder_list;
 	int order = 0, err;
+	u32 slave_zpos = 0;
 
 	DRM_DEBUG_ATOMIC("[CRTC:%d:%s] calculating normalized zpos values\n",
 			 crtc->base.id, crtc->name);
@@ -181,10 +182,13 @@ static int komeda_crtc_normalize_zpos(struct drm_crtc *crtc,
 				 plane_st->zpos, plane_st->normalized_zpos);
 
 		/* calculate max slave zorder */
-		if (has_bit(drm_plane_index(plane), kcrtc->slave_planes))
+		if (has_bit(drm_plane_index(plane), kcrtc->slave_planes)) {
+			slave_zpos = plane_st->normalized_zpos;
+			if (to_kplane_st(plane_st)->layer_split)
+				slave_zpos++;
 			kcrtc_st->max_slave_zorder =
-				max(plane_st->normalized_zpos,
-				    kcrtc_st->max_slave_zorder);
+				max(slave_zpos, kcrtc_st->max_slave_zorder);
+		}
 	}
 
 	crtc_st->zpos_changed = true;
-- 
2.43.0



