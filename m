Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E532501285;
	Wed, 30 Sep 2026 17:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789330; cv=none; b=KLw8T2pn3AEJKFDLdBwDQbPBFmigOguD8Zr3AYersgQduoWBp9r6dwCkpU0v9bSydSHzwEG3L9c73qqpNmaHAXve41Yu+rhbbupahn8L94/99Od5l8aLtXiYfT5NjKQ1tOaFknwraFE4HlUHUHuufl8JXz/OiwL+tp+xus7gJWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789330; c=relaxed/simple;
	bh=NnLlS5h3k9K4hsgQg+kVHzXW04LOIGQkq+w6q8RDLE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZ11CIyfvDWHyj/0OsMR/N5mI6CYrNt1Sr9ficJZPOt79MrpU/l/rqcXWKW3UxpwHVAlRYpCZ++xAEwgn2bdq2jmOTvwCpKf6GbI3rtZT3kDEcA2LF91tUjaLSkXTcqA6rvBCsB0bXtCuc8j7T5eddM8PQeBBxJU1QmCVjRuubU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDvARej9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDvARej9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA781F000FF;
	Wed, 30 Sep 2026 17:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789329;
	bh=lLr2O9YdtLo5ihudIPhk2YfiODu70K7RmjMz8GtBfAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDvARej9XctXyLGh/C+KNHgp+omwTnqEErOuFEgukDk2wNLbCC+6TMgOeY7YgdVkr
	 cc7v8N1iMey/40lhMkTamCcrzzM4HcPBIKu7VVDfZmp5LKasVOzdKM4NK/q71B6Lit
	 IqLDnMULBA4dzLhBGwKscGeQTb3hGnVTODL/BEig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Sviridkin <f@lex.la>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 438/877] net: dsa: mt7530: fix NULL dereference on unbind of MT7531 and MT7621
Date: Wed, 30 Sep 2026 17:22:29 +0200
Message-ID: <20260930152424.135106412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e19b46449ffe6..9bc142e55df23 100644
--- a/drivers/net/dsa/mt7530-mdio.c
+++ b/drivers/net/dsa/mt7530-mdio.c
@@ -230,15 +230,17 @@ mt7530_remove(struct mdio_device *mdiodev)
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



