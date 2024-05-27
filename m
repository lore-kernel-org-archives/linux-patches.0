Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0FC17727;
	Mon, 27 May 2024 19:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838503; cv=none; b=f3SonAjXPbErVVVTb6lOZcJ4srPtap6vYdJNZ6Wm6F9ERyWDRSBPKGLOkA/365inmJgsGmUFeF/plmk3bb7BoN+W6CtKz+5Bmp7zdmQb6q2tmio9q7cKSqKBEoQhAIOY+7+O79GjAUJ4jCG0Wcfm/ELpFaECQZC+nSKziEb6NZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838503; c=relaxed/simple;
	bh=bY2F+Z83RmnGR/eEZihjho52PdS/DPCzObMKglFcqrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C2ch5Ri8SmR1L9sCuvnKID8qzEjkmShzsceqzV+oGA3IcsMVUKb4sj5uOQ9TLuGo16kPQpRnbH2/WThDN4313XV6tVTWHcbEP4exQ6uK850IHnIe+hMZDX/ryU0j5JWFFhDfXafPz3q/mDmz/pCp/QS0hwzjcciWvVOGUUydPLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9RovcqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9RovcqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFC5C2BBFC;
	Mon, 27 May 2024 19:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838503;
	bh=bY2F+Z83RmnGR/eEZihjho52PdS/DPCzObMKglFcqrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9RovcqHXGgLM80w48UE9Qqr5wTud/5b4OKS4MEFG4DXJl7m4dbj06/od/Yq14AKG
	 1U8PZk/QrnSpH/eZ44W9pP+kuPuSa+lnp8B4zbeXWOA3pc8Eq13a3vVdH9CAg1AoMK
	 wHidHfJnvEyXrZRWJkv1t+NTdK23QQGV345/hoNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 418/493] drm/edid: Parse topology block for all DispID structure v1.x
Date: Mon, 27 May 2024 20:57:00 +0200
Message-ID: <20240527185643.962264650@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit e0a200ab4b72afd581bd6f82fc1ef510a4fb5478 ]

DisplayID spec v1.3 revision history notes do claim that
the toplogy block was added in v1.3 so requiring structure
v1.2 would seem correct, but there is at least one EDID in
edid.tv with a topology block and structure v1.0. And
there are also EDIDs with DisplayID structure v1.3 which
seems to be totally incorrect as DisplayID spec v1.3 lists
structure v1.2 as the only legal value.

Unfortunately I couldn't find copies of DisplayID spec
v1.0-v1.2 anywhere (even on vesa.org), so I'll have to
go on empirical evidence alone.

We used to parse the topology block on all v1.x
structures until the check for structure v2.0 was added.
Let's go back to doing that as the evidence does suggest
that there are DisplayIDs in the wild that would miss
out on the topology stuff otherwise.

Also toss out DISPLAY_ID_STRUCTURE_VER_12 entirely as
it doesn't appear we can really use it for anything.

I *think* we could technically skip all the structure
version checks as the block tags shouldn't conflict
between v2.0 and v1.x. But no harm in having a bit of
extra sanity checks I guess.

So far I'm not aware of any user reported regressions
from overly strict check, but I do know that it broke
igt/kms_tiled_display's fake DisplayID as that one
gets generated with structure v1.0.

Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Fixes: c5a486af9df7 ("drm/edid: parse Tiled Display Topology Data Block for DisplayID 2.0")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240410180139.21352-1-ville.syrjala@linux.intel.com
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c  | 2 +-
 include/drm/drm_displayid.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 69c68804023ff..9ef9a70a836c7 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -7345,7 +7345,7 @@ static void drm_parse_tiled_block(struct drm_connector *connector,
 static bool displayid_is_tiled_block(const struct displayid_iter *iter,
 				     const struct displayid_block *block)
 {
-	return (displayid_version(iter) == DISPLAY_ID_STRUCTURE_VER_12 &&
+	return (displayid_version(iter) < DISPLAY_ID_STRUCTURE_VER_20 &&
 		block->tag == DATA_BLOCK_TILED_DISPLAY) ||
 		(displayid_version(iter) == DISPLAY_ID_STRUCTURE_VER_20 &&
 		 block->tag == DATA_BLOCK_2_TILED_DISPLAY_TOPOLOGY);
diff --git a/include/drm/drm_displayid.h b/include/drm/drm_displayid.h
index 566497eeb3b81..bc1f6b378195f 100644
--- a/include/drm/drm_displayid.h
+++ b/include/drm/drm_displayid.h
@@ -30,7 +30,6 @@ struct drm_edid;
 #define VESA_IEEE_OUI				0x3a0292
 
 /* DisplayID Structure versions */
-#define DISPLAY_ID_STRUCTURE_VER_12		0x12
 #define DISPLAY_ID_STRUCTURE_VER_20		0x20
 
 /* DisplayID Structure v1r2 Data Blocks */
-- 
2.43.0



