Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FFA51C358;
	Wed, 30 Sep 2026 18:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793340; cv=none; b=Am8RS2863ZDFwrWTDNwVXWiyQfYZBrCYPRxkmnUbW8tnoXAbmP2KwppC6CWd7ws5DIRbWI49tm2szmaZ/BrQGv3S1O+EbnDGXRWUZyT0JeqxveqA73U45K5/pkHcY7INH79kdYMVeVVo3eRwZgVqHSsLHr47dBy3d5JQ11zRrI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793340; c=relaxed/simple;
	bh=WPOgWUxspZBYdQvXk+n90AjO1UCKFqmQz7Q/0lpRl/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7PoHJPcLSsvJ16upQf5bUpPL+2YaIUFH/w8TR6NPophf4fvlHDJ5n1BE8aXsqe1COLohnP9ZxY5F1MNLGF4YFjqDDCEDSB73XQWtoGw5/ZmChnYqMXdKEzCwac9SgEfk38jTCveLzJQl+xfefjAD3AgjETtNiNyN7LkQMoMirI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvZSbtHP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvZSbtHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600A01F000FF;
	Wed, 30 Sep 2026 18:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793338;
	bh=bd6rEJ43TInRjSzqR+sCUeeXaTsbXKXrU5fBR/67v68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvZSbtHPPmRc5qcbSBx6YfnmAdzXU262K7KpvdgBaQ1epD+m8ZNhhqYPyvpNa2ZbR
	 WrBAXP7g8emTgnpolL7FvSbXh+bfObLQ6aUXov2a1Ne+zFc0cpaWqeDZkXsmJ2Vv08
	 euioFZCsLr0H8+E9lgKlKQcuFRD6Gk56Tq7NzxdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Sviridkin <f@lex.la>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 175/395] net: dsa: mt7530: fix NULL dereference on unbind of MT7531 and MT7621
Date: Wed, 30 Sep 2026 17:27:17 +0200
Message-ID: <20260930152344.446479823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Aleksei Sviridkin <f@lex.la>

[ Upstream commit c2cdef41e0b4d8ed23a5b41e6ad4e64594e055e4 ]

The core and io supplies are only requested for ID_MT7530: both the
devm_regulator_get() in probe and the regulator_enable() in
mt7530_setup() are guarded by the switch id, but mt7530_remove()
disables them unconditionally. On an MT7621 or an MT7531 both pointers
are still NULL from devm_kzalloc(), so rmmod or a sysfs unbind calls
regulator_disable() on NULL.

Fixes: ddda1ac116c8 ("net: dsa: mt7530: support the 7530 switch on the Mediatek MT7621 SoC")
Signed-off-by: Aleksei Sviridkin <f@lex.la>
Link: https://patch.msgid.link/20260918015020.2518315-2-f@lex.la
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530-mdio.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mt7530-mdio.c b/drivers/net/dsa/mt7530-mdio.c
index 6cc2c8975af66..119fdbea57160 100644
--- a/drivers/net/dsa/mt7530-mdio.c
+++ b/drivers/net/dsa/mt7530-mdio.c
@@ -227,15 +227,17 @@ mt7530_remove(struct mdio_device *mdiodev)
 	if (!priv)
 		return;
 
-	ret = regulator_disable(priv->core_pwr);
-	if (ret < 0)
-		dev_err(priv->dev,
-			"Failed to disable core power: %d\n", ret);
-
-	ret = regulator_disable(priv->io_pwr);
-	if (ret < 0)
-		dev_err(priv->dev, "Failed to disable io pwr: %d\n",
-			ret);
+	if (priv->id == ID_MT7530) {
+		ret = regulator_disable(priv->core_pwr);
+		if (ret < 0)
+			dev_err(priv->dev,
+				"Failed to disable core power: %d\n", ret);
+
+		ret = regulator_disable(priv->io_pwr);
+		if (ret < 0)
+			dev_err(priv->dev, "Failed to disable io pwr: %d\n",
+				ret);
+	}
 
 	mt7530_remove_common(priv);
 
-- 
2.53.0



