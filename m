Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BEC3CB57E;
	Sat, 12 Sep 2026 07:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197355; cv=none; b=iAkQbSEllmW614JIzTcRqBdgLeDtClnEkqfjSmA2z2iSnIen6Xce09ac6vK4ix3Yl8Zvv4lRrqYzB6L986712S3edWKnbwITGxdQnyxkxFFCoXZIFzQ8/KyvVlzeTh4qN6DdeM/2cSCdlnk7uAAL1Bi/INBhWvqNwISF7Jze0MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197355; c=relaxed/simple;
	bh=TNbJwzPcnEuI/gpd0mtxhudLHwVG5qVIUrGNL2eiTbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDkwS8HB8/EdDlUc1tmEckDiaMkUKmywqlWdtYZIpoH8+aVpOhMOnbqal9SKtTSVFG2UoM8TfRQjWCLhEsUW0xNmPDK+J7n9sELmez357d87Q5TDH68NuXVndE1N763TaJNUZ6Vtr6WeAXIXbuaZUtEmaqV3PHUnD7hYLlONHNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+vU1eQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+vU1eQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395311F000FF;
	Sat, 12 Sep 2026 07:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197354;
	bh=uA+bcBaky/xuuo3iznfNPXq/PbDa3okqk8NfjhkS12o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v+vU1eQkp64y8rdumw1zk9agwdGjx1Rsm7Kwhs50vJ5A2Q2IAgTmj99bTgOvHZpVF
	 Pnc+MQMEz8u/LRhTHXHoJkMV3l+YwcI4paQNPzQmx2ZuEXyGX+PZekGxrWKlJzuBGd
	 GUIRj1NptHVzLsA0s625hGmPHsoRnmHEKSfeE0Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0157/1815] leds: lp5860-spi: Fix an error handling path
Date: Sat, 12 Sep 2026 08:31:47 +0200
Message-ID: <20260912065652.696836210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f647a2266289a35eaa4865f629f2ab7046900d9b ]

If lp5860_device_init() fails, a missing mutex_destroy() should be called.

Use devm_mutex_init() instead of mutex_init() to fix it.
This also simplifies the remove function.

Fixes: f0a66563aa2d ("leds: Add support for TI LP5860 LED driver chip")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/311792e767ab803d4744bc26155e6dac253d9b45.1781970783.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/rgb/leds-lp5860-spi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/rgb/leds-lp5860-spi.c b/drivers/leds/rgb/leds-lp5860-spi.c
index 5e0c44854a680..6bf6a625c28af 100644
--- a/drivers/leds/rgb/leds-lp5860-spi.c
+++ b/drivers/leds/rgb/leds-lp5860-spi.c
@@ -38,6 +38,7 @@ static int lp5860_probe(struct spi_device *spi)
 	struct device *dev = &spi->dev;
 	struct lp5860 *lp5860;
 	unsigned int multi_leds;
+	int ret;
 
 	multi_leds = device_get_child_node_count(dev);
 	if (!multi_leds) {
@@ -61,7 +62,10 @@ static int lp5860_probe(struct spi_device *spi)
 				     "Failed to initialise Regmap.\n");
 
 	lp5860->dev = dev;
-	mutex_init(&lp5860->lock);
+
+	ret = devm_mutex_init(dev, &lp5860->lock);
+	if (ret)
+		return ret;
 
 	spi_set_drvdata(spi, lp5860);
 
@@ -70,10 +74,6 @@ static int lp5860_probe(struct spi_device *spi)
 
 static void lp5860_remove(struct spi_device *spi)
 {
-	struct lp5860 *lp5860 = spi_get_drvdata(spi);
-
-	mutex_destroy(&lp5860->lock);
-
 	lp5860_device_remove(&spi->dev);
 }
 
-- 
2.53.0



