Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24015293443;
	Tue, 17 Jun 2025 15:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174440; cv=none; b=oxBBlhfN94GLo55RYt80yJnO+EWAX/7XhwFmVr8EL8CbyzHNIB+x83SUazU8B18Jn5N45PRpys6GBkVBrMBPyErGHeaTSEe16NKd58G1QIcx63tVKoYm8y2kuSr6WirGwbDm1sV0nYa1aU/EBZ5wJuusV5n8FprXMsRKyaBAh4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174440; c=relaxed/simple;
	bh=w9egBynCop/A+TfGGgZHL8IY/kN3hqJQuhqQU4JPD3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3WFdFMXQeIscn3cKPtaeVBS3Tzk/Y4/FyBT7Ry34F8tKQZgJlsO1S2Y29urrdQsNBszbqj5baFWuLK4cLGPZcqvjfNm4pcyekxqqFMAtU+s0yf9UzjXVHgtbgMlSYFelRMEjizXZxz8MGdf27k61rdUzzYpkC2uFNi4Ins3cjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEcOdF+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEcOdF+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871C9C4CEE3;
	Tue, 17 Jun 2025 15:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174440;
	bh=w9egBynCop/A+TfGGgZHL8IY/kN3hqJQuhqQU4JPD3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEcOdF+ubju8nGCnTFllu7mToNTyD/UPCvcj4TCBDMkePduLCBhnZEMsiC4gIy/7s
	 96Ct5Ha9TOT/9ztGQahl4hG5sVZKOQ280a7AKAHCYA1RjrClGGBSzMAHoCuhILBFS/
	 5WzuI8duY5qTOOLbggvM2O4Q1r6Rh4/Th5tXuc9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/356] drm: rcar-du: Fix memory leak in rcar_du_vsps_init()
Date: Tue, 17 Jun 2025 17:23:04 +0200
Message-ID: <20250617152341.004088514@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/renesas/rcar-du/rcar_du_kms.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/renesas/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/renesas/rcar-du/rcar_du_kms.c
index 70d8ad065bfa1..4c8fe83dd6101 100644
--- a/drivers/gpu/drm/renesas/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/renesas/rcar-du/rcar_du_kms.c
@@ -705,7 +705,7 @@ static int rcar_du_vsps_init(struct rcar_du_device *rcdu)
 		ret = of_parse_phandle_with_fixed_args(np, vsps_prop_name,
 						       cells, i, &args);
 		if (ret < 0)
-			goto error;
+			goto done;
 
 		/*
 		 * Add the VSP to the list or update the corresponding existing
@@ -743,13 +743,11 @@ static int rcar_du_vsps_init(struct rcar_du_device *rcdu)
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



