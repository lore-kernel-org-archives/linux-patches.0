Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9254C6E;
	Mon, 23 Jun 2025 13:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686112; cv=none; b=BufpuGfHvRIH4fgOgOVdKdSzZicnlIO+Uo8Zmiym10NDP/rOl8R1vC6CgJplEN7clu63atMTtzfW9OpdcytHOHDrFWRdUeKV7vNUMcHKaB3xZvRZZIsdSkXzr4bz1WJ/LLZh/RD993lghQWHfkGfPfe4jl8wdtCrF+U0OKzZfLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686112; c=relaxed/simple;
	bh=+JktwlX+WWPV+S/ySg6HJ6cOljpJKFHMFdZ0nW00siE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbBbT8Cz+aTbEBBey/G9aBfZbCe2SjRvHHUFu+dABIOU/fT0iyEkfp7UQU67X3e5m3PORV7o3P/yG93V1Pfj39sBWi9ZqpKnosWZLIoPgQd4HOLG365EobvyHRRYh3BkVxc0JVJpRF84F32UyzThCyBo8Hysz4fEb7vl8C5cGfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNxy5HPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNxy5HPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DD3C4CEEA;
	Mon, 23 Jun 2025 13:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686112;
	bh=+JktwlX+WWPV+S/ySg6HJ6cOljpJKFHMFdZ0nW00siE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNxy5HPBmFqnRsIkUQDPM1T6nOV8QwYSUqIb829709hofIaO5pGhnYl51vDiZ1aPq
	 u/RIOpt60ZPMk1WDiUoSs+KI9Szd1rsv1N0y4mCZEy6Q9PIddJ5HbppF9cLGffh/X3
	 DVUPTkOf9/4SL6DEMGCzYQ9dUsN73gpurLFmJ6Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/508] drm: rcar-du: Fix memory leak in rcar_du_vsps_init()
Date: Mon, 23 Jun 2025 15:01:33 +0200
Message-ID: <20250623130646.429646020@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8c2719efda2a2..b64f62ad8dbd7 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -673,7 +673,7 @@ static int rcar_du_vsps_init(struct rcar_du_device *rcdu)
 		ret = of_parse_phandle_with_fixed_args(np, vsps_prop_name,
 						       cells, i, &args);
 		if (ret < 0)
-			goto error;
+			goto done;
 
 		/*
 		 * Add the VSP to the list or update the corresponding existing
@@ -711,13 +711,11 @@ static int rcar_du_vsps_init(struct rcar_du_device *rcdu)
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



