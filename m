Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26428F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779CCC433C8;
	Sun, 16 Jul 2023 20:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540248;
	bh=wv2qpIUqEGmnI0oXo87CMWN+BkRFhzAcVdsLkyc1Cco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kz0yzOu6J9nQvQ/ZaDdjKaoRgAJv1HswgG24r4w9PgS3mW2QxzWmQ2+LkjbBWCIqD
	 CHQVJ4IMfiR6oFqGnzQ9RlJrKsjEZX7txjDO9uSOQxld+uf1IYBejnBGq6DeokafiF
	 3R8meuGGKp1wI4OIyps/cBLrmdBwF2e9DVIetfGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wells Lu <wellslutw@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 296/591] pinctrl: sunplus: Add check for kmalloc
Date: Sun, 16 Jul 2023 21:47:15 +0200
Message-ID: <20230716194931.554589444@linuxfoundation.org>
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

From: Wells Lu <wellslutw@gmail.com>

[ Upstream commit a5961bed5429cf1134d7f539b4ed60317012f84d ]

Fix Smatch static checker warning:
potential null dereference 'configs'. (kmalloc returns null)

Fixes: aa74c44be19c ("pinctrl: Add driver for Sunplus SP7021")
Signed-off-by: Wells Lu <wellslutw@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/1685277277-12209-1-git-send-email-wellslutw@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunplus/sppctl.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/sunplus/sppctl.c b/drivers/pinctrl/sunplus/sppctl.c
index 2b3335ab56c66..0449595b943cf 100644
--- a/drivers/pinctrl/sunplus/sppctl.c
+++ b/drivers/pinctrl/sunplus/sppctl.c
@@ -838,11 +838,6 @@ static int sppctl_dt_node_to_map(struct pinctrl_dev *pctldev, struct device_node
 	int i, size = 0;
 
 	list = of_get_property(np_config, "sunplus,pins", &size);
-
-	if (nmG <= 0)
-		nmG = 0;
-
-	parent = of_get_parent(np_config);
 	*num_maps = size / sizeof(*list);
 
 	/*
@@ -870,10 +865,14 @@ static int sppctl_dt_node_to_map(struct pinctrl_dev *pctldev, struct device_node
 		}
 	}
 
+	if (nmG <= 0)
+		nmG = 0;
+
 	*map = kcalloc(*num_maps + nmG, sizeof(**map), GFP_KERNEL);
-	if (*map == NULL)
+	if (!(*map))
 		return -ENOMEM;
 
+	parent = of_get_parent(np_config);
 	for (i = 0; i < (*num_maps); i++) {
 		dt_pin = be32_to_cpu(list[i]);
 		pin_num = FIELD_GET(GENMASK(31, 24), dt_pin);
@@ -887,6 +886,8 @@ static int sppctl_dt_node_to_map(struct pinctrl_dev *pctldev, struct device_node
 			(*map)[i].data.configs.num_configs = 1;
 			(*map)[i].data.configs.group_or_pin = pin_get_name(pctldev, pin_num);
 			configs = kmalloc(sizeof(*configs), GFP_KERNEL);
+			if (!configs)
+				goto sppctl_map_err;
 			*configs = FIELD_GET(GENMASK(7, 0), dt_pin);
 			(*map)[i].data.configs.configs = configs;
 
@@ -900,6 +901,8 @@ static int sppctl_dt_node_to_map(struct pinctrl_dev *pctldev, struct device_node
 			(*map)[i].data.configs.num_configs = 1;
 			(*map)[i].data.configs.group_or_pin = pin_get_name(pctldev, pin_num);
 			configs = kmalloc(sizeof(*configs), GFP_KERNEL);
+			if (!configs)
+				goto sppctl_map_err;
 			*configs = SPPCTL_IOP_CONFIGS;
 			(*map)[i].data.configs.configs = configs;
 
@@ -969,6 +972,15 @@ static int sppctl_dt_node_to_map(struct pinctrl_dev *pctldev, struct device_node
 	of_node_put(parent);
 	dev_dbg(pctldev->dev, "%d pins mapped\n", *num_maps);
 	return 0;
+
+sppctl_map_err:
+	for (i = 0; i < (*num_maps); i++)
+		if (((*map)[i].type == PIN_MAP_TYPE_CONFIGS_PIN) &&
+		    (*map)[i].data.configs.configs)
+			kfree((*map)[i].data.configs.configs);
+	kfree(*map);
+	of_node_put(parent);
+	return -ENOMEM;
 }
 
 static const struct pinctrl_ops sppctl_pctl_ops = {
-- 
2.39.2



