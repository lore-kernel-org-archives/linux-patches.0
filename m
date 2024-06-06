Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD861A186C;
	Thu,  6 Jun 2024 14:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683709; cv=none; b=TR4+R6krMts0jt/E+g8+fiHV4XhLrfv1mdVcZjXzMfmp3p+4cCQ/6DbTHNhdT+wzhDDCeAMRKpA14rWh5RV+HfkTY5WCkAIShxdwIJU4yOIeCPEAQtvncmVh8UKwDptaEEPdvGSYtNLx3YXS1hDnnbntlGZkKc997pRMs6mwv2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683709; c=relaxed/simple;
	bh=qqSw+wEHom9nm0wdBH15YMtVMAu71sYiF2IarTv0/Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plX5HTSqNehizEGpj9jw988kSWaCPSLHaRLJzD4mEJdyQagV7dQgyCY/uXxgs6khRCny2F+q35TpNIYhAOfcA51LaL86lEDyQL2dpHmP/XwK5Jrj40foFpahY4cDZ+3t2r+f3VYQtDd9nl0de9SuSWqyFFWJ8H9VAEGzqLdN4f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImLvG/pg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImLvG/pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B07C32781;
	Thu,  6 Jun 2024 14:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683709;
	bh=qqSw+wEHom9nm0wdBH15YMtVMAu71sYiF2IarTv0/Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImLvG/pgOMk7JSCEBLFvgnczsTKDR1adH9YJnVH6p7tDbmh9yKwMFvQrOstCYFWX4
	 AVc6V4XmNQe/u/l24MFHTycQtRFARqjTn6Z+KMOOlDJR9+I6X9IVkuOB1fWS7p8Xvd
	 I5qBqJ3yfDsHSrxfry6vgY8EJ+TvxQ3oNO4ecEfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Robert Foss <rfoss@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 611/744] Revert "drm/bridge: ti-sn65dsi83: Fix enable error path"
Date: Thu,  6 Jun 2024 16:04:43 +0200
Message-ID: <20240606131752.086952453@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit ad81feb5b6f1f5461641706376dcf7a9914ed2e7 ]

This reverts commit 8a91b29f1f50ce7742cdbe5cf11d17f128511f3f.

The regulator_disable() added by the original commit solves one kind of
regulator imbalance but adds another one as it allows the regulator to be
disabled one more time than it is enabled in the following scenario:

 1. Start video pipeline -> sn65dsi83_atomic_pre_enable -> regulator_enable
 2. PLL lock fails -> regulator_disable
 3. Stop video pipeline -> sn65dsi83_atomic_disable -> regulator_disable

The reason is clear from the code flow, which looks like this (after
removing unrelated code):

  static void sn65dsi83_atomic_pre_enable()
  {
      regulator_enable(ctx->vcc);

      if (PLL failed locking) {
          regulator_disable(ctx->vcc);  <---- added by patch being reverted
          return;
      }
  }

  static void sn65dsi83_atomic_disable()
  {
      regulator_disable(ctx->vcc);
  }

The use case for introducing the additional regulator_disable() was
removing the module for debugging (see link below for the discussion). If
the module is removed after a .atomic_pre_enable, i.e. with an active
pipeline from the DRM point of view, .atomic_disable is not called and thus
the regulator would not be disabled.

According to the discussion however there is no actual use case for
removing the module with an active pipeline, except for
debugging/development.

On the other hand, the occurrence of a PLL lock failure is possible due to
any physical reason (e.g. a temporary hardware failure for electrical
reasons) so handling it gracefully should be supported. As there is no way
for .atomic[_pre]_enable to report an error to the core, the only clean way
to support it is calling regulator_disabled() only in .atomic_disable,
unconditionally, as it was before.

Link: https://lore.kernel.org/all/15244220.uLZWGnKmhe@steina-w/
Fixes: 8a91b29f1f50 ("drm/bridge: ti-sn65dsi83: Fix enable error path")
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240426122259.46808-1-luca.ceresoli@bootlin.com
(cherry picked from commit 2940ee03b23281071620dda1d790cd644dabd394)
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi83.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi83.c b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
index 061e8bd5915de..8a23116346a8a 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -478,7 +478,6 @@ static void sn65dsi83_atomic_pre_enable(struct drm_bridge *bridge,
 		dev_err(ctx->dev, "failed to lock PLL, ret=%i\n", ret);
 		/* On failure, disable PLL again and exit. */
 		regmap_write(ctx->regmap, REG_RC_PLL_EN, 0x00);
-		regulator_disable(ctx->vcc);
 		return;
 	}
 
-- 
2.43.0



