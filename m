Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784B72E84A;
	Fri, 24 Nov 2023 19:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rq0quvz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C8CC433C7;
	Fri, 24 Nov 2023 19:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852541;
	bh=nB3gl9aHx/zf2afKRVbzCeVfcZWuYKSrhqNusnBn7bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rq0quvz4+CTlrpjmn0LegROyuN7TbJdSYM+ykcSr8w3OG/lO774aGdSQPp7VZIU/Z
	 9nxVhq9htVArkslUGbMA1ON1x62yrkSIpvVmoUVRK/5mXChjUYbBxPQB8/jmlTRGHQ
	 ZPWTSvJhkI6zSIbAoMYcZNNe2EhN82jZ2mw28u4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>,
	Frank Oltmanns <frank@oltmanns.dev>,
	Samuel Holland <samuel@sholland.org>,
	=?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/193] drm/panel: st7703: Pick different reset sequence
Date: Fri, 24 Nov 2023 17:52:31 +0000
Message-ID: <20231124171948.155593378@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Jirman <megi@xff.cz>

[ Upstream commit d12d635bb03c7cb4830acb641eb176ee9ff2aa89 ]

Switching to a different reset sequence, enabling IOVCC before enabling
VCC.

There also needs to be a delay after enabling the supplies and before
deasserting the reset. The datasheet specifies 1ms after the supplies
reach the required voltage. Use 10-20ms to also give the power supplies
some time to reach the required voltage, too.

This fixes intermittent panel initialization failures and screen
corruption during resume from sleep on panel xingbangda,xbd599 (e.g.
used in PinePhone).

Signed-off-by: Ondrej Jirman <megi@xff.cz>
Signed-off-by: Frank Oltmanns <frank@oltmanns.dev>
Reported-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Tested-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Guido Günther <agx@sigxcpu.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230211171748.36692-2-frank@oltmanns.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sitronix-st7703.c | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-sitronix-st7703.c b/drivers/gpu/drm/panel/panel-sitronix-st7703.c
index c22e7c49e0778..67e1da0a7db53 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7703.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7703.c
@@ -428,29 +428,30 @@ static int st7703_prepare(struct drm_panel *panel)
 		return 0;
 
 	dev_dbg(ctx->dev, "Resetting the panel\n");
-	ret = regulator_enable(ctx->vcc);
+	gpiod_set_value_cansleep(ctx->reset_gpio, 1);
+
+	ret = regulator_enable(ctx->iovcc);
 	if (ret < 0) {
-		dev_err(ctx->dev, "Failed to enable vcc supply: %d\n", ret);
+		dev_err(ctx->dev, "Failed to enable iovcc supply: %d\n", ret);
 		return ret;
 	}
-	ret = regulator_enable(ctx->iovcc);
+
+	ret = regulator_enable(ctx->vcc);
 	if (ret < 0) {
-		dev_err(ctx->dev, "Failed to enable iovcc supply: %d\n", ret);
-		goto disable_vcc;
+		dev_err(ctx->dev, "Failed to enable vcc supply: %d\n", ret);
+		regulator_disable(ctx->iovcc);
+		return ret;
 	}
 
-	gpiod_set_value_cansleep(ctx->reset_gpio, 1);
-	usleep_range(20, 40);
+	/* Give power supplies time to stabilize before deasserting reset. */
+	usleep_range(10000, 20000);
+
 	gpiod_set_value_cansleep(ctx->reset_gpio, 0);
-	msleep(20);
+	usleep_range(15000, 20000);
 
 	ctx->prepared = true;
 
 	return 0;
-
-disable_vcc:
-	regulator_disable(ctx->vcc);
-	return ret;
 }
 
 static int st7703_get_modes(struct drm_panel *panel,
-- 
2.42.0



