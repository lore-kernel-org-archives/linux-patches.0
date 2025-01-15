Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C840E1E98FA;
	Wed, 15 Jan 2025 10:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938579; cv=none; b=BQ/VuVow1NdE+KqmDRTSkio5vipSAqV42sDUYcNDv5Dqk4HKCHnOqofLBNTDQbO7OCHQOXVXYbWNttsBaqMfK2I/dGMRARV1JXvNkqGPk2KCOF15+3nrzgRTfi9JFxUFxn+VX8gTUOxGNsSy+XbTmUmkCWvwKAVM469RwveNKmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938579; c=relaxed/simple;
	bh=xVbcOGMYol1ImlLvQDrBaJBQoxtWtzTMwa9lnBRBy78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urrfZP8On23z/4uUbm+msq6z9xCrjWPeiXDOPkq1Ss68N0zc+EcwiB04ohnCXbrLHOtlj7oLT8M/g8e6JG1Os5JELjmX+alSZRusrOCYwwvfPN3MTo3XaVZMQ1X2U4jiewpylVKLsCOR+hi1/Y4TCWKQImK1F8nIddWjSnSYvL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIRfnIfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIRfnIfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BDCC4CEDF;
	Wed, 15 Jan 2025 10:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938579;
	bh=xVbcOGMYol1ImlLvQDrBaJBQoxtWtzTMwa9lnBRBy78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIRfnIfQWCd1nXTKDQx1dp/Qvdzkt1o1o8WvFpvvoUARXx+pDkjt4on4+rHny5erx
	 jIj/OLVGkUWfcqWBYujpGtGSh83oKAxk3Sd8c4s1h1AF2SFr8cw0AxFZ+jMEN5w5/i
	 0Yk+OZoWZRgzYir2CdaFVEXYqitt6wrfBFOsSWLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeroen de Borst <jeroendb@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/129] eth: gve: use appropriate helper to set xdp_features
Date: Wed, 15 Jan 2025 11:36:48 +0100
Message-ID: <20250115103555.697669533@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit db78475ba0d3c66d430f7ded2388cc041078a542 ]

Commit f85949f98206 ("xdp: add xdp_set_features_flag utility routine")
added routines to inform the core about XDP flag changes.
GVE support was added around the same time and missed using them.

GVE only changes the flags on error recover or resume.
Presumably the flags may change during resume if VM migrated.
User would not get the notification and upper devices would
not get a chance to recalculate their flags.

Fixes: 75eaae158b1b ("gve: Add XDP DROP and TX support for GQI-QPL format")
Reviewed-By: Jeroen de Borst <jeroendb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250106180210.1861784-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index d70305654e7d..90d433b36799 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2009,14 +2009,18 @@ static void gve_service_task(struct work_struct *work)
 
 static void gve_set_netdev_xdp_features(struct gve_priv *priv)
 {
+	xdp_features_t xdp_features;
+
 	if (priv->queue_format == GVE_GQI_QPL_FORMAT) {
-		priv->dev->xdp_features = NETDEV_XDP_ACT_BASIC;
-		priv->dev->xdp_features |= NETDEV_XDP_ACT_REDIRECT;
-		priv->dev->xdp_features |= NETDEV_XDP_ACT_NDO_XMIT;
-		priv->dev->xdp_features |= NETDEV_XDP_ACT_XSK_ZEROCOPY;
+		xdp_features = NETDEV_XDP_ACT_BASIC;
+		xdp_features |= NETDEV_XDP_ACT_REDIRECT;
+		xdp_features |= NETDEV_XDP_ACT_NDO_XMIT;
+		xdp_features |= NETDEV_XDP_ACT_XSK_ZEROCOPY;
 	} else {
-		priv->dev->xdp_features = 0;
+		xdp_features = 0;
 	}
+
+	xdp_set_features_flag(priv->dev, xdp_features);
 }
 
 static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
-- 
2.39.5



