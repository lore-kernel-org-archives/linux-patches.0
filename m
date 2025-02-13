Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0495E26B091;
	Thu, 13 Feb 2025 15:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459811; cv=none; b=Cim8ZlZ/01XVan+uRT4bnP9gSgECly9Xg9pZGVYnqkiKh2kZ4PnR3wbZaihX0i2b2anxawg+1lD3p5Qo4dNy7B3F3bMWyw1lwP6TRAZJpA48R1rW8slNostwu3xAGInR+SJwQas9LFxPCKll5WSxg+NbCRJFtGbSQ7GNxQYV7PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459811; c=relaxed/simple;
	bh=rJCw/VxKl2jfWKHWDhnRXsZ8BA82YNpgPzNxpZHpPCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDv7STEMNfVyCKsMd+0A5zTKFjvOoNUkss3k2oexeRJmFCV2zz5a5hdW1tAfwRROYY8qwEW2ut69BwZsGyoVq9xOuTNOKsFI0Z+ucxavAPRM9vJQmw9MgRiADtAJjmfA7CeMOXu+EuhJvRTbEU9Ia10f0rJC58pYEEXB9/JSyCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmaTLDhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmaTLDhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDD2C4CEE7;
	Thu, 13 Feb 2025 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459810;
	bh=rJCw/VxKl2jfWKHWDhnRXsZ8BA82YNpgPzNxpZHpPCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmaTLDhNn4Eqw3lWu4JBsZ1psfaZixWS+lgEVepYSZvyvizUSXsAeOwaIkv4M9gcQ
	 k6d0Hyk6u8DIDBOSpDMqkU95n6+VyvlFyfCNdCkxiECY2Tqgu2ktn47LtJxYTIriKo
	 4qobcagLsiYhRmSGAJbkmr/fX0PFpwngPMy24jy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.13 370/443] media: i2c: ds90ub960: Fix logging SP & EQ status only for UB9702
Date: Thu, 13 Feb 2025 15:28:55 +0100
Message-ID: <20250213142454.887894558@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit 42d0ec194aa12e9b97f09a94fe565ba2e5f631a2 upstream.

UB9702 does not have SP and EQ registers, but the driver uses them in
log_status(). Fix this by separating the SP and EQ related log_status()
work into a separate function (for clarity) and calling that function
only for UB960.

Cc: stable@vger.kernel.org
Fixes: afe267f2d368 ("media: i2c: add DS90UB960 driver")
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ds90ub960.c |   90 +++++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 40 deletions(-)

--- a/drivers/media/i2c/ds90ub960.c
+++ b/drivers/media/i2c/ds90ub960.c
@@ -2949,6 +2949,54 @@ static const struct v4l2_subdev_pad_ops
 	.set_fmt = ub960_set_fmt,
 };
 
+static void ub960_log_status_ub960_sp_eq(struct ub960_data *priv,
+					 unsigned int nport)
+{
+	struct device *dev = &priv->client->dev;
+	u8 eq_level;
+	s8 strobe_pos;
+	u8 v = 0;
+
+	/* Strobe */
+
+	ub960_read(priv, UB960_XR_AEQ_CTL1, &v);
+
+	dev_info(dev, "\t%s strobe\n",
+		 (v & UB960_XR_AEQ_CTL1_AEQ_SFILTER_EN) ? "Adaptive" :
+							  "Manual");
+
+	if (v & UB960_XR_AEQ_CTL1_AEQ_SFILTER_EN) {
+		ub960_read(priv, UB960_XR_SFILTER_CFG, &v);
+
+		dev_info(dev, "\tStrobe range [%d, %d]\n",
+			 ((v >> UB960_XR_SFILTER_CFG_SFILTER_MIN_SHIFT) & 0xf) - 7,
+			 ((v >> UB960_XR_SFILTER_CFG_SFILTER_MAX_SHIFT) & 0xf) - 7);
+	}
+
+	ub960_rxport_get_strobe_pos(priv, nport, &strobe_pos);
+
+	dev_info(dev, "\tStrobe pos %d\n", strobe_pos);
+
+	/* EQ */
+
+	ub960_rxport_read(priv, nport, UB960_RR_AEQ_BYPASS, &v);
+
+	dev_info(dev, "\t%s EQ\n",
+		 (v & UB960_RR_AEQ_BYPASS_ENABLE) ? "Manual" :
+						    "Adaptive");
+
+	if (!(v & UB960_RR_AEQ_BYPASS_ENABLE)) {
+		ub960_rxport_read(priv, nport, UB960_RR_AEQ_MIN_MAX, &v);
+
+		dev_info(dev, "\tEQ range [%u, %u]\n",
+			 (v >> UB960_RR_AEQ_MIN_MAX_AEQ_FLOOR_SHIFT) & 0xf,
+			 (v >> UB960_RR_AEQ_MIN_MAX_AEQ_MAX_SHIFT) & 0xf);
+	}
+
+	if (ub960_rxport_get_eq_level(priv, nport, &eq_level) == 0)
+		dev_info(dev, "\tEQ level %u\n", eq_level);
+}
+
 static int ub960_log_status(struct v4l2_subdev *sd)
 {
 	struct ub960_data *priv = sd_to_ub960(sd);
@@ -2996,8 +3044,6 @@ static int ub960_log_status(struct v4l2_
 
 	for (nport = 0; nport < priv->hw_data->num_rxports; nport++) {
 		struct ub960_rxport *rxport = priv->rxports[nport];
-		u8 eq_level;
-		s8 strobe_pos;
 		unsigned int i;
 
 		dev_info(dev, "RX %u\n", nport);
@@ -3033,44 +3079,8 @@ static int ub960_log_status(struct v4l2_
 		ub960_rxport_read(priv, nport, UB960_RR_CSI_ERR_COUNTER, &v);
 		dev_info(dev, "\tcsi_err_counter %u\n", v);
 
-		/* Strobe */
-
-		ub960_read(priv, UB960_XR_AEQ_CTL1, &v);
-
-		dev_info(dev, "\t%s strobe\n",
-			 (v & UB960_XR_AEQ_CTL1_AEQ_SFILTER_EN) ? "Adaptive" :
-								  "Manual");
-
-		if (v & UB960_XR_AEQ_CTL1_AEQ_SFILTER_EN) {
-			ub960_read(priv, UB960_XR_SFILTER_CFG, &v);
-
-			dev_info(dev, "\tStrobe range [%d, %d]\n",
-				 ((v >> UB960_XR_SFILTER_CFG_SFILTER_MIN_SHIFT) & 0xf) - 7,
-				 ((v >> UB960_XR_SFILTER_CFG_SFILTER_MAX_SHIFT) & 0xf) - 7);
-		}
-
-		ub960_rxport_get_strobe_pos(priv, nport, &strobe_pos);
-
-		dev_info(dev, "\tStrobe pos %d\n", strobe_pos);
-
-		/* EQ */
-
-		ub960_rxport_read(priv, nport, UB960_RR_AEQ_BYPASS, &v);
-
-		dev_info(dev, "\t%s EQ\n",
-			 (v & UB960_RR_AEQ_BYPASS_ENABLE) ? "Manual" :
-							    "Adaptive");
-
-		if (!(v & UB960_RR_AEQ_BYPASS_ENABLE)) {
-			ub960_rxport_read(priv, nport, UB960_RR_AEQ_MIN_MAX, &v);
-
-			dev_info(dev, "\tEQ range [%u, %u]\n",
-				 (v >> UB960_RR_AEQ_MIN_MAX_AEQ_FLOOR_SHIFT) & 0xf,
-				 (v >> UB960_RR_AEQ_MIN_MAX_AEQ_MAX_SHIFT) & 0xf);
-		}
-
-		if (ub960_rxport_get_eq_level(priv, nport, &eq_level) == 0)
-			dev_info(dev, "\tEQ level %u\n", eq_level);
+		if (!priv->hw_data->is_ub9702)
+			ub960_log_status_ub960_sp_eq(priv, nport);
 
 		/* GPIOs */
 		for (i = 0; i < UB960_NUM_BC_GPIOS; i++) {


