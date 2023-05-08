Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AD0171A1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001A0C4339B;
	Mon,  8 May 2023 11:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545677;
	bh=2md6CbZfoT57HjA+4hkA9zo9CEu6BXsHnCxIZXp8lgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayLoaDxpsMeipnQVlDI4Zda6I1XXc1uzhw81vW7v4CCQUDROlbMmje9mGve0l/+dW
	 DzN4LmGJBY/I1r2ZKgI0Ub4cswDkJ8iyiVY+mYsJ48b+hcv4GtRUDKq8lZgC1n3A5S
	 iI9g7O5rrbDqgZ4JLhGbJdp8FwQC9ZrHDsJTzkQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/371] drm: rcar-du: Fix a NULL vs IS_ERR() bug
Date: Mon,  8 May 2023 11:45:18 +0200
Message-Id: <20230508094816.656147710@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
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
index 4bf4e25d7f011..6bc0c4e6cd965 100644
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



