Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAEC281530;
	Wed,  4 Feb 2026 14:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216674; cv=none; b=KvuUpOx6FvY2TVtiAokq7FCAfJsiYVPA6WHEv8Y3p7A6JT8TKu6pRR8w99BnXtrsT5iy3dfNLqba73pDJnaheG+srj4kI5wzbJSUsyI/ZkHS85jgRJBs0da4DFPSTsmZHoIGI10T+x2weXFR3DKzLXApIuqlW0GHCi4qkm72AFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216674; c=relaxed/simple;
	bh=6s3qWw6ggmVpPmUALsc93RB8o1/iVJnkgIqbGxllii4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYLQQ4mJLzq3H/ZQIN8y29ZovaAg84YNbscf45nemYoGD4EHula6iezTGUT223bMRvkdBGygcPShtkfQqNqw6J0yVQWAwcfby3VJg94NclLT9P7cYNXOFIAnySeRIVfLczr5lViF+PraG5RyYnrhqqqikdTh8GeKxbzY4RkVX7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8rvhAcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8rvhAcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088EEC19423;
	Wed,  4 Feb 2026 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216674;
	bh=6s3qWw6ggmVpPmUALsc93RB8o1/iVJnkgIqbGxllii4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8rvhAcJbkx3s0fvxA7itI/qWyn6stHpxlBjM81lW2lJWjH85jiyzREyd8IJQMsrY
	 215DNWZc5JztFEmtVdYezzUFrJaegjDUtz01v/G4zubGzxVBrSCMsYbHzaTVH0tvUL
	 jGfTJmuDdc5Idc+q4AsiZgfVINy8DYLWYq5b0i/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/161] drm/imx: imx-tve: use local encoder and connector variables
Date: Wed,  4 Feb 2026 15:40:22 +0100
Message-ID: <20260204143857.469880991@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 396852df02b9ff49fe256ba459605fc680fe8d89 ]

Introduce local variables for encoder and connector.
This simplifies the following commits.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Stable-dep-of: e535c23513c6 ("drm/imx/tve: fix probe device leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imx/imx-tve.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -431,27 +431,28 @@ static int tve_clk_init(struct imx_tve *
 
 static int imx_tve_register(struct drm_device *drm, struct imx_tve *tve)
 {
+	struct drm_encoder *encoder = &tve->encoder;
+	struct drm_connector *connector = &tve->connector;
 	int encoder_type;
 	int ret;
 
 	encoder_type = tve->mode == TVE_MODE_VGA ?
 				DRM_MODE_ENCODER_DAC : DRM_MODE_ENCODER_TVDAC;
 
-	ret = imx_drm_encoder_parse_of(drm, &tve->encoder, tve->dev->of_node);
+	ret = imx_drm_encoder_parse_of(drm, encoder, tve->dev->of_node);
 	if (ret)
 		return ret;
 
-	drm_encoder_helper_add(&tve->encoder, &imx_tve_encoder_helper_funcs);
-	drm_simple_encoder_init(drm, &tve->encoder, encoder_type);
+	drm_encoder_helper_add(encoder, &imx_tve_encoder_helper_funcs);
+	drm_simple_encoder_init(drm, encoder, encoder_type);
 
-	drm_connector_helper_add(&tve->connector,
-			&imx_tve_connector_helper_funcs);
-	drm_connector_init_with_ddc(drm, &tve->connector,
+	drm_connector_helper_add(connector, &imx_tve_connector_helper_funcs);
+	drm_connector_init_with_ddc(drm, connector,
 				    &imx_tve_connector_funcs,
 				    DRM_MODE_CONNECTOR_VGA,
 				    tve->ddc);
 
-	drm_connector_attach_encoder(&tve->connector, &tve->encoder);
+	drm_connector_attach_encoder(connector, encoder);
 
 	return 0;
 }


