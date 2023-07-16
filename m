Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133A68F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEB4C433C7;
	Sun, 16 Jul 2023 20:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540716;
	bh=o4g3M1+T1+RobAwEH58yUdTFZodrhMEQJfF9/6uzET8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOh9F62AKp6waUpAwo/lTIJLlqHEAk1DdWIcmwkURD7f6s5P4EGS0BvBdURooS1Bl
	 Lem4PVHtfB1AcASjhi8xPi7Q00E8NGF0ALg0UniKm8oYuteKrOLg+bOTD7qxKVG7Ot
	 ji81C36PbZxyKtFafXkMqDDc9Ns7BXMSZ9utDQVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 436/591] mfd: wcd934x: Fix an error handling path in wcd934x_slim_probe()
Date: Sun, 16 Jul 2023 21:49:35 +0200
Message-ID: <20230716194935.192184228@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f190b4891a3f9fac123a7afd378d4143a2723313 ]

If devm_gpiod_get_optional() fails, some resources need to be released, as
already done in the .remove() function.

While at it, remove the unneeded error code from a dev_err_probe() call.
It is already added in a human readable way by dev_err_probe() itself.

Fixes: 6a0ee2a61a31 ("mfd: wcd934x: Replace legacy gpio interface for gpiod")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/02d8447f6d1df52cc8357aae698152e9a9be67c6.1684565021.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/wcd934x.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wcd934x.c b/drivers/mfd/wcd934x.c
index 68e2fa2fda99c..32ed2bd863758 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -253,8 +253,9 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 	usleep_range(600, 650);
 	reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(reset_gpio)) {
-		return dev_err_probe(dev, PTR_ERR(reset_gpio),
-				"Failed to get reset gpio: err = %ld\n", PTR_ERR(reset_gpio));
+		ret = dev_err_probe(dev, PTR_ERR(reset_gpio),
+				    "Failed to get reset gpio\n");
+		goto err_disable_regulators;
 	}
 	msleep(20);
 	gpiod_set_value(reset_gpio, 1);
@@ -264,6 +265,10 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 	dev_set_drvdata(dev, ddata);
 
 	return 0;
+
+err_disable_regulators:
+	regulator_bulk_disable(WCD934X_MAX_SUPPLY, ddata->supplies);
+	return ret;
 }
 
 static void wcd934x_slim_remove(struct slim_device *sdev)
-- 
2.39.2



