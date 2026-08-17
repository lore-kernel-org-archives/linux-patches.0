Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50B54457BB;
	Mon, 17 Aug 2026 14:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976027; cv=none; b=XobP6HF8ybpb8Lvza2jJGzX3EfbOip+VOgXnCS/6zLIemFKAgNxlVep0jQY2TYkcbPa5DNi0OsPr9OWKb0+qcoZT16eKWuEsXV4fJEUcqoT3NdLIS0mfnzaJSRwkfnZ4W3TfkwGKzxijoTeg5v+4XkpKOa5d3sCIuO2Vs9puDRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976027; c=relaxed/simple;
	bh=BBRM3LHGxHwm9rmc9w1B9NN5i4Oz+ubM/YqUt2vEdTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRcQpYZlxrRwpgs1BMF98fDLeFvpe45/h3FyZ1333sn5O5gGEVP1YNPGqQNk0UmRBDEhtccyIGgZlfAR9sdAzcml4xogD2WbwryTopBW7S8D3aChASSSBTEB+f8PefiBcfQo1UFyz5DmKP1EHJdrZSzlhIf0tG78J68GdLrCDgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4ryI405; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4ryI405"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE861F00A3A;
	Mon, 17 Aug 2026 14:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976025;
	bh=j92XjIF+VCDXyIhFb5NUAI6aG2DVJgxWA0gqlqlKhPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4ryI4059UGZTP2hw69mdf2lGmPHzJnXwXtn0zUXexgmgb14bMK9o01xu7f+M8UYO
	 ayC7ZUgHUz8e7tusJg3FWKp7h/KFi2NqAtP7rBMweUWh1+zmA1skAdfDevVZNch62D
	 vfG4KC00XXG+KrjjZLlrsbjMGfwKXs0ontdr6KiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/389] net: phylink: put link_gpio if phylink_create fails
Date: Mon, 17 Aug 2026 15:31:09 +0200
Message-ID: <20260817132548.202743240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
index cbdd01f311625..012c750d49874 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -842,8 +842,8 @@ struct phylink *phylink_create(struct phylink_config *config,
 	} else if (config->type == PHYLINK_DEV) {
 		pl->dev = config->dev;
 	} else {
-		kfree(pl);
-		return ERR_PTR(-EINVAL);
+		ret = -EINVAL;
+		goto free_pl;
 	}
 
 	pl->phy_state.interface = iface;
@@ -866,28 +866,29 @@ struct phylink *phylink_create(struct phylink_config *config,
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



