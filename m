Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A062AEE4;
	Mon, 23 Jun 2025 21:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715016; cv=none; b=ePlh/vCDffc8D/SCWt9U0dXuv913qX+4Xn9GCwmgK3Cwpe5q5+wjAHAZapNL/ZHguYM6Pt18q2hI4F9uFriO4ThsqRzisXwTsj9ASbEwfSoMuUBa0TnJUfTMtfkXIRkv3cJBN66yX2ayLBuKxvE5N3zouBtrcxJwYxZdHXXgjjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715016; c=relaxed/simple;
	bh=5qzvuXnVAbYm6JTegpdJu2DV7IJkleg0guKIptLOJXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFgJU4fct3Uu+2I/jAYJQfhG5omzsD9mTdPJLEofRldtmNcJY4mooH/nlx8zBM/APeJpoELCNRFmgYC6yUKZI3mzJKMygS060qFnQ7XQlCfQOXSdeDGDI1nj0zfhhyy8Tvdl9JrWNCrewfcubrikZe7Bh7e5tlnDVhbdamh3JWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9B8UAYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9B8UAYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFA8C4CEEA;
	Mon, 23 Jun 2025 21:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715016;
	bh=5qzvuXnVAbYm6JTegpdJu2DV7IJkleg0guKIptLOJXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9B8UAYLNvRu1sppLHh9cIo/fqQqa1ShgyFrHXgXl4J9T5MAg7t4y56G805tIC9sB
	 +Hc+gBSEXHob+SAVAkgmVzOvm/Wz3pmS9o53th/0zCx/cKX5tA7/Sf+FGA3zYeI++w
	 NTfoBs4AF6ov+IPqoI4qM+ZUTC+x4Y/tOE60dQ5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Werling <brett.werling@garmin.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 223/411] can: tcan4x5x: fix power regulator retrieval during probe
Date: Mon, 23 Jun 2025 15:06:07 +0200
Message-ID: <20250623130639.274526338@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Werling <brett.werling@garmin.com>

commit db22720545207f734aaa9d9f71637bfc8b0155e0 upstream.

Fixes the power regulator retrieval in tcan4x5x_can_probe() by ensuring
the regulator pointer is not set to NULL in the successful return from
devm_regulator_get_optional().

Fixes: 3814ca3a10be ("can: tcan4x5x: tcan4x5x_can_probe(): turn on the power before parsing the config")
Signed-off-by: Brett Werling <brett.werling@garmin.com>
Link: https://patch.msgid.link/20250612191825.3646364-1-brett.werling@garmin.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/tcan4x5x-core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -310,10 +310,11 @@ static int tcan4x5x_can_probe(struct spi
 	priv = cdev_to_priv(mcan_class);
 
 	priv->power = devm_regulator_get_optional(&spi->dev, "vsup");
-	if (PTR_ERR(priv->power) == -EPROBE_DEFER) {
-		ret = -EPROBE_DEFER;
-		goto out_m_can_class_free_dev;
-	} else {
+	if (IS_ERR(priv->power)) {
+		if (PTR_ERR(priv->power) == -EPROBE_DEFER) {
+			ret = -EPROBE_DEFER;
+			goto out_m_can_class_free_dev;
+		}
 		priv->power = NULL;
 	}
 


