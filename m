Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BAA35B631;
	Fri,  7 Aug 2026 15:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116110; cv=none; b=J2Fhke1gqzWq/S587o9dtcXMw2aGALTqgZHvb5zcuIsS70YhIouQW3/qgSdHsMxtukBhYjqcxmIPsRuYcnoplf+0thHNYab5gO547PCn9ob2VwUVWh0AD/6riVRGWzflXwvxYeF82J+gjH5hKTSY0kCmRk4/rWR2CmA4cya4tj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116110; c=relaxed/simple;
	bh=Vwc0XadB7gE2ioQqVez/+VrI99hm622X1PFQV57A9cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oF34lTHsI/dSlIdrNjRbS3j8anUW2cxqNDwbjggkGHSxOvt3XZGDBYmuFPapyPdWzqNrAHGGq4lrGaPyqHdp8G49EFmgO2qpSoOlAFha2lZ3O9z5XioeescCTga0vpAMh2JcUJEwxznfBfHzQvGDQ7hm1QRrGnNkKUgmzynHRmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtMUpEKE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtMUpEKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD8B1F000E9;
	Fri,  7 Aug 2026 15:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116107;
	bh=AzM4WkHEPdFsJQffi3cNNwzIrOUtkMx/zBUyPLDK1Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtMUpEKEAPU9iL6TRF+riWXDoPOiOfUc9g+qR2+vbg4kpURDZg/QXb7sgGCz/otf+
	 ImdDqdl3xqU4B4zxIxE0joqhNWYN264defY/oVIGMIZiKfST0lED6tM6oJ2s6NRdXU
	 QHVtFO963XcSros+aJbkHWL6uw5I3ZygqvbO572U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/261] net: phylink: put link_gpio if phylink_create fails
Date: Fri,  7 Aug 2026 16:37:08 +0200
Message-ID: <20260807143416.916324963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 800e8b9eb4532..6d8ff73a7ebae 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1635,8 +1635,8 @@ struct phylink *phylink_create(struct phylink_config *config,
 	} else if (config->type == PHYLINK_DEV) {
 		pl->dev = config->dev;
 	} else {
-		kfree(pl);
-		return ERR_PTR(-EINVAL);
+		ret = -EINVAL;
+		goto free_pl;
 	}
 
 	pl->using_mac_select_pcs = using_mac_select_pcs;
@@ -1660,28 +1660,29 @@ struct phylink *phylink_create(struct phylink_config *config,
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



