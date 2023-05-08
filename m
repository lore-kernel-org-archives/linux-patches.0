Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06E1168C2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A84C433EF;
	Mon,  8 May 2023 10:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541686;
	bh=dmuIp60d0leTSZJ+I+m6nowOfBegPVAQdNkDSZzb2s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tm+4AyIX72TpixV5gsSNtBViqz0WFM40Gx9izZkHuPWCdjiiXFsDcvjRTzsJgQT95
	 shn+qJhEVT8uUXzjIYXE0Qtzxry2mL3Q0fI3AA6bPMWSxbaKsqVt0L00SVlfL4hyb3
	 DvilguETmVsO56qoFAa7vRND9byWKxGHuLD0YSaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 194/663] drm: rcar-du: Fix a NULL vs IS_ERR() bug
Date: Mon,  8 May 2023 11:40:20 +0200
Message-Id: <20230508094434.701944900@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 40f43730f43699ce8557e4fe59622d4f4b69f44a ]

The drmm_encoder_alloc() function returns error pointers.  It never
returns NULL.  Fix the check accordingly.

Fixes: 7a1adbd23990 ("drm: rcar-du: Use drmm_encoder_alloc() to manage encoder")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_encoder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_encoder.c b/drivers/gpu/drm/rcar-du/rcar_du_encoder.c
index b1787be31e92c..7ecec7b04a8d0 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_encoder.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_encoder.c
@@ -109,8 +109,8 @@ int rcar_du_encoder_init(struct rcar_du_device *rcdu,
 	renc = drmm_encoder_alloc(&rcdu->ddev, struct rcar_du_encoder, base,
 				  &rcar_du_encoder_funcs, DRM_MODE_ENCODER_NONE,
 				  NULL);
-	if (!renc)
-		return -ENOMEM;
+	if (IS_ERR(renc))
+		return PTR_ERR(renc);
 
 	renc->output = output;
 
-- 
2.39.2



