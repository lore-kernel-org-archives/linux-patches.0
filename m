Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025D8FC03;
	Sat,  3 Feb 2024 04:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933461; cv=none; b=kaN7kIpZk0/2mlmEue9vDvyEJdHUaoIv2qruVQg/nh07lkBl0h9WMLCdSQYuPn2+F26hFUQreWGsXlT/vmJoNG4tPDDj1C8702gm61ykCzjbcnvey9PMErXSxtoH/Pwn4RVUNpSLHmkeSJhAiXntDNDLdhzPW8g/kv959lEWlVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933461; c=relaxed/simple;
	bh=/2/5gz0lF4FleU06Y1ov1jrUE2ZU0+V06pii0DQtLG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kce8M8Ir0U9EzEqX1k1H3Nkbi6EqE5LHYDljRUQcrcstnyf6Yo6Za8/UImAVjZR2UDmsZbMqkUN1npF5zd9kzBRJSBF6ixvjakRBWKISzts8iBogEgeSVELwwOyDXhS5yPeo+7QzzojWhZPC4p0c3eaCO/pK82szAan+1pcRECM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02MCd2al; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02MCd2al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B5DC433C7;
	Sat,  3 Feb 2024 04:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933460;
	bh=/2/5gz0lF4FleU06Y1ov1jrUE2ZU0+V06pii0DQtLG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02MCd2alF/SOpz8lR5pM4m+HzzEqS5X3Cvk/9xD8w79ZswlBxrlz5LnpFXSnCND+n
	 qRD2i3Q2BsziXPKHVfFH6/H9S3lHltHuUNMQgeu0PqlY/Bds4HVw7TSvRPN+Ae4FE6
	 WfHbObebKLcLvv3RxVe224C6/kv5/JLVWYot7WHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/219] net: dsa: qca8k: fix illegal usage of GPIO
Date: Fri,  2 Feb 2024 20:06:11 -0800
Message-ID: <20240203035345.011435424@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Vokáč <michal.vokac@ysoft.com>

[ Upstream commit c44fc98f0a8ffd94fa0bd291928e7e312ffc7ca4 ]

When working with GPIO, its direction must be set either when the GPIO is
requested by gpiod_get*() or later on by one of the gpiod_direction_*()
functions. Neither of this is done here which results in undefined
behavior on some systems.

As the reset GPIO is used right after it is requested here, it makes sense
to configure it as GPIOD_OUT_HIGH right away. With that, the following
gpiod_set_value_cansleep(1) becomes redundant and can be safely
removed.

Fixes: a653f2f538f9 ("net: dsa: qca8k: introduce reset via gpio feature")
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/1706266175-3408-1-git-send-email-michal.vokac@ysoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 7c3c90c9edbe..641692f716f8 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1935,12 +1935,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	priv->info = of_device_get_match_data(priv->dev);
 
 	priv->reset_gpio = devm_gpiod_get_optional(priv->dev, "reset",
-						   GPIOD_ASIS);
+						   GPIOD_OUT_HIGH);
 	if (IS_ERR(priv->reset_gpio))
 		return PTR_ERR(priv->reset_gpio);
 
 	if (priv->reset_gpio) {
-		gpiod_set_value_cansleep(priv->reset_gpio, 1);
 		/* The active low duration must be greater than 10 ms
 		 * and checkpatch.pl wants 20 ms.
 		 */
-- 
2.43.0



