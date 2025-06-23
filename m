Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17926248176;
	Mon, 23 Jun 2025 13:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685150; cv=none; b=b/XP3HexNGd2gXXjUZwnE+q9lBC+Jh070ZCdXhO7b6SgmK6ETbHGwo8RaT/iFIiSdxC7ShyCkf+0WTHHPAXRLXo035fUFZ8Yj1UnFGVrIwBcBQEzMtJPCDeIhxxw3cNdhG6NFQlmXkuw1Ag00dhK1bDKZLEkPQjLucLMd4GjXgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685150; c=relaxed/simple;
	bh=e0I2vE1KiqK3z92GL6hPuZozyKw4NC6f0KbmI8HwyrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYXsbLG6qes5swa3S34g4A+b0NZNilhBEe4ROngZTuXx45mOrlMRvczAbRrR1mmuyVQQi80KbjKqNPiDlJL2GpbUW7OKLwhGIvVB5FwJrIYqJ5DoclI1KI+fTftVnUnUi/efeCFEMViMH5XSZHsu02xZyUWhJFK4+8KL2fV5m5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkCS2DsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkCS2DsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBFCC4CEEA;
	Mon, 23 Jun 2025 13:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685150;
	bh=e0I2vE1KiqK3z92GL6hPuZozyKw4NC6f0KbmI8HwyrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkCS2DsSOSM35mPcXcryvFesrTLjl280BiZMCD3EmPkL1OYdw6MjzLxYagLjynuA4
	 zq223oun1bPLuJVNd8qC7eVlwt6GXNB/6sssjpMCuB8HXH3h1D3984ao/RXaexvvbD
	 C/7N1QSpfFJw99iRCmoj7g6IOO5MnwwZyQkqVi1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/355] drm: rcar-du: Fix memory leak in rcar_du_vsps_init()
Date: Mon, 23 Jun 2025 15:03:51 +0200
Message-ID: <20250623130627.716697729@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 91e3bf09a90bb4340c0c3c51396e7531555efda4 ]

The rcar_du_vsps_init() doesn't free the np allocated by
of_parse_phandle_with_fixed_args() for the non-error case.

Fix memory leak for the non-error case.

While at it, replace the label 'error'->'done' as it applies to non-error
case as well and update the error check condition for rcar_du_vsp_init()
to avoid breakage in future, if it returns positive value.

Fixes: 3e81374e2014 ("drm: rcar-du: Support multiple sources from the same VSP")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Link: https://lore.kernel.org/r/20231116122424.80136-1-biju.das.jz@bp.renesas.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_kms.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index 7015e22872bbe..41b4a6715dad5 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -626,7 +626,7 @@ static int rcar_du_vsps_init(struct rcar_du_device *rcdu)
 		ret = of_parse_phandle_with_fixed_args(np, vsps_prop_name,
 						       cells, i, &args);
 		if (ret < 0)
-			goto error;
+			goto done;
 
 		/*
 		 * Add the VSP to the list or update the corresponding existing
@@ -664,13 +664,11 @@ static int rcar_du_vsps_init(struct rcar_du_device *rcdu)
 		vsp->dev = rcdu;
 
 		ret = rcar_du_vsp_init(vsp, vsps[i].np, vsps[i].crtcs_mask);
-		if (ret < 0)
-			goto error;
+		if (ret)
+			goto done;
 	}
 
-	return 0;
-
-error:
+done:
 	for (i = 0; i < ARRAY_SIZE(vsps); ++i)
 		of_node_put(vsps[i].np);
 
-- 
2.39.5



