Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04588F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735AFC433C7;
	Sun, 16 Jul 2023 20:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539343;
	bh=QJo7hMnKjNvCErSeuQpWNr0b5EOJDH+mwZwQH30bBtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZvfF/glFTlN9K3yfcUNGoPHkrGAO8V/3aUlSP4QDlFv3M382i8evsxVlHPG99NCr
	 Kixn3x1yGKL8lK8cuwVuKp2UJxzgr9JRgtiDWNM8nQ3F1yz09sqzeXY7kQJV0ib+Ft
	 xfv05N8KSO3I249/+NSk2EgGgeinXOrj2W7cvsB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.4 774/800] Input: ads7846 - Fix usage of match data
Date: Sun, 16 Jul 2023 21:50:27 +0200
Message-ID: <20230716195007.126529199@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Walleij <linus.walleij@linaro.org>

commit 8f7913c04f6a7b90bcf998ece17395d7090f6d44 upstream.

device_get_match_data() returns the match data directly, fix
this up and fix the probe crash.

Fixes: 767d83361aaa ("Input: ads7846 - Convert to use software nodes")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lore.kernel.org/r/20230606191304.3804174-1-linus.walleij@linaro.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/ads7846.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -1117,20 +1117,13 @@ MODULE_DEVICE_TABLE(of, ads7846_dt_ids);
 static const struct ads7846_platform_data *ads7846_get_props(struct device *dev)
 {
 	struct ads7846_platform_data *pdata;
-	const struct platform_device_id *pdev_id;
 	u32 value;
 
-	pdev_id = device_get_match_data(dev);
-	if (!pdev_id) {
-		dev_err(dev, "Unknown device model\n");
-		return ERR_PTR(-EINVAL);
-	}
-
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return ERR_PTR(-ENOMEM);
 
-	pdata->model = (unsigned long)pdev_id->driver_data;
+	pdata->model = (u32)device_get_match_data(dev);
 
 	device_property_read_u16(dev, "ti,vref-delay-usecs",
 				 &pdata->vref_delay_usecs);


