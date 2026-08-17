Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D06F2E762C;
	Mon, 17 Aug 2026 15:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979846; cv=none; b=cNNR0GnqkngVZwqgnykre7WyjcghAX0PU0RCEpaEVZKaxGXhXlMQ5Kgoa4vY5t62vj5wTWXrHkJKxQqmtK8ce3F4ImkCqf2m96AdVPAyhYDQGdlsJu2Y7ROou4Db5JnjrqyNrRNHg8Yk3CUEMCB/GCgUGbsMva56NjILPShWV5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979846; c=relaxed/simple;
	bh=Prrh//2VwkafoonI0dKr/6Heznrnv5tBFxw93Re35ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWfUYr1zh03OMdB0bT5joPqe6ownrcqAuoXX0ySN/EtvsMNNAEt76yPtYPpGDbH7TT429I50au7yDm6jSGUdYQQOGQzeBtGKRl9VNKcZ1o71d0BgrJTLg0YgTrErfvFhQrxNEKY9cy/pxM2MaK/WcVSmcjd5kwDK1zfhzAqzye4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5CGJR1b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5CGJR1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8EA1F00A3A;
	Mon, 17 Aug 2026 15:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979844;
	bh=mL6BbMJNGFfMqMh2153yG6WmDQV6gzX0HS2fSaqHSEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5CGJR1brPjLrvGGjLKVVKcd10RmHfM0AZfa2vm0lkEj1e6YnknN0xW9w6Y6Kggtd
	 R84dfyoZmR8hvMbW05m1LlzB2yq5rIzB8FrnXS1ttVVdRRAPGNJKsjv3brPdtaVqeX
	 zPAsAV60tMRo4RbsbUXQEZw4/oBChqH7gmXUaItY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 368/609] net: phylink: put link_gpio if phylink_create fails
Date: Mon, 17 Aug 2026 15:31:04 +0200
Message-ID: <20260817132556.599834230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 0fe1e3e8f3380d7862296a73b528d164e96c76b8 ]

In phylink_create() if phylink_register_sfp() returns an error, link_gpio
obtained by phylink_parse_fixedlink() is never released. While this is a
very unlikely scenario, it's worth to fix/handle this.

This was present from the very first implementation of phylink but got
relevant only with the introduction of ce0aa27ff3f6 ("sfp: add sfp-bus to
bridge between network devices and sfp cages") where additional function
were added after phylink_parse_fixedlink() making the release of link_gpio
needed if such additional function errored out.

While at it, restructure the exit condition of phylink_create() with the
goto pattern to reduce code duplication on handling error conditions.

Fixes: ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices and sfp cages")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260726150806.2437-1-ansuelsmth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 3069a7df25d3f..8109a049a74e4 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1483,8 +1483,8 @@ struct phylink *phylink_create(struct phylink_config *config,
 	} else if (config->type == PHYLINK_DEV) {
 		pl->dev = config->dev;
 	} else {
-		kfree(pl);
-		return ERR_PTR(-EINVAL);
+		ret = -EINVAL;
+		goto free_pl;
 	}
 
 	pl->using_mac_select_pcs = using_mac_select_pcs;
@@ -1508,28 +1508,29 @@ struct phylink *phylink_create(struct phylink_config *config,
 	phylink_validate(pl, pl->supported, &pl->link_config);
 
 	ret = phylink_parse_mode(pl, fwnode);
-	if (ret < 0) {
-		kfree(pl);
-		return ERR_PTR(ret);
-	}
+	if (ret < 0)
+		goto free_pl;
 
 	if (pl->cfg_link_an_mode == MLO_AN_FIXED) {
 		ret = phylink_parse_fixedlink(pl, fwnode);
-		if (ret < 0) {
-			kfree(pl);
-			return ERR_PTR(ret);
-		}
+		if (ret < 0)
+			goto release_link_gpio;
 	}
 
 	pl->cur_link_an_mode = pl->cfg_link_an_mode;
 
 	ret = phylink_register_sfp(pl, fwnode);
-	if (ret < 0) {
-		kfree(pl);
-		return ERR_PTR(ret);
-	}
+	if (ret < 0)
+		goto release_link_gpio;
 
 	return pl;
+
+release_link_gpio:
+	if (pl->link_gpio)
+		gpiod_put(pl->link_gpio);
+free_pl:
+	kfree(pl);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(phylink_create);
 
-- 
2.53.0



