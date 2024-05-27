Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F077817E90E;
	Mon, 27 May 2024 19:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837195; cv=none; b=YNdZfxyxFAgFKYmV6TYU2tJWpuftJAYUZ/GVD8+Se990ci1Dd4rIAgNauUX6In7YTe6tDhf2o8HsPEDqiRpkZ6XeQSk/oGqzK07rbrETeMxP5/tp8GE1yLitRpV6lV2u/Y0rWdioWa8Y1ywPC/r1JlVMhcv8BAPSpfB/KNXRpZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837195; c=relaxed/simple;
	bh=eX7i1MUzJ0qV3sEbU0kOA6Ej8SgXD6nPB1lN9hBzxs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ayGPj1u34lAMnfxClX0FX38CHixpJFjUIfc3+t6zmy84fkbE+Svlf7EG0cAhvP58uRjj3gQpRDuwXaDt9LCZh6XocYZKwCSzC90rm9n3F1V33Qe7dGEwjBFXZVlntEJ3U2iUh4LMprMJ9oayMj0NFwRtGGABA/J4cUnCvSGLRrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuCj3ECY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuCj3ECY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D35C2BBFC;
	Mon, 27 May 2024 19:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837194;
	bh=eX7i1MUzJ0qV3sEbU0kOA6Ej8SgXD6nPB1lN9hBzxs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuCj3ECYgtr1b6Wb5q5bq41Dtm4Ewi6XbJBrK1sHk8UQq3nDLTgR7EIAhPxzHk8x5
	 AZxxXx4StLsjKTNsp15XTi0FGqIyG3jvszFhA/kjPNLdgElXGrqqNrB4YgOlypQLpc
	 YWbXtGHChtOZ88f/dvlu8zLWA2UldJC1O2MCgJH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 345/427] drm/edid: Parse topology block for all DispID structure v1.x
Date: Mon, 27 May 2024 20:56:32 +0200
Message-ID: <20240527185633.172355922@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 923c4423151c1..9064cdeb1319b 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -7324,7 +7324,7 @@ static void drm_parse_tiled_block(struct drm_connector *connector,
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



