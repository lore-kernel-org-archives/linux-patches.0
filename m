Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF24472F99;
	Fri,  7 Aug 2026 15:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115018; cv=none; b=iS/2wYY1+Q0/nlbwhyTvPNUjQ+nRV4sRchCIgDcxa9TkyqIDcsdnD5YHYyBoLI792IzwyiOvCB1ksaGqDkE3yQb+w+9Qaw4TUr7HRwbuV1oDhFoBHN/HejwjCJIMu6nt1L+x/1OohA9TUUJ3sjj2wZ4zFAzjdW06LIibXxlelhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115018; c=relaxed/simple;
	bh=Jy//1fOl3qOguuKlTE3NZ35mhrutBJFdrXXRDndIiaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzshEz1UZkU3BAlhrrupqR3Nb4wPK2NuRXbvq8dSjERwZsxgBeIdPT+5H/RS4pQxR6TaqvSnsBogslC3XeuKrhe75nP2DrrOzLFkpQrUfG/dQQLMR7JQV1+idtZ6/6tO1j92tJDpY+ycugKmsENkWGb99Q4NT0SPk3OcoC6VnlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxgKfoHW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxgKfoHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327941F000E9;
	Fri,  7 Aug 2026 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115016;
	bh=zW0iCQGCmZNhux1Al2nSa97vyzZ1zNu6MhpEZaJLLjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WxgKfoHWeTr1EcBhmg8xvxm0EjnrZt5+0RgrkK+LEAfa92TQUYv5esWO7q1FfWCUP
	 9iUcIqjOhwKRIm+g2IiIresGkj0H3JTSoWMF5kdZ6C+KYMPOvQXMOXgbsv2m1+x7s+
	 yb3rpYngTxlCeF5thITU9BzQRCId+p/cGxG7wkvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 127/396] net: phylink: put link_gpio if phylink_create fails
Date: Fri,  7 Aug 2026 16:34:47 +0200
Message-ID: <20260807143427.048243222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9182443082158..1b7fc17bf3919 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1861,8 +1861,8 @@ struct phylink *phylink_create(struct phylink_config *config,
 	} else if (config->type == PHYLINK_DEV) {
 		pl->dev = config->dev;
 	} else {
-		kfree(pl);
-		return ERR_PTR(-EINVAL);
+		ret = -EINVAL;
+		goto free_pl;
 	}
 
 	pl->mac_supports_eee_ops = phylink_mac_implements_lpi(mac_ops);
@@ -1895,28 +1895,29 @@ struct phylink *phylink_create(struct phylink_config *config,
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
 
 	pl->req_link_an_mode = pl->cfg_link_an_mode;
 
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



