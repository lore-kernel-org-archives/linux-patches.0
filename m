Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C2A8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0F4C433C8;
	Sun, 16 Jul 2023 20:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540960;
	bh=GvasUrjslSpl/fZDe3gq8urQHDHxFEsHODlHWp9q8sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9WnTQhCyUfHTclkoeg0y6maz7mcOu78WjweeQCgRaE5yjw26MCuQ0/NXhMZWLsl8
	 121ry20nsv6LfhN+KcZ+VLKmTU2aM6DJM6Zv9Cdi4ajr7C2j+FmNZrFgd8W8jAzVoh
	 ZYHPTc/ZhssAeFZS2PEl7uelTT1DMd2GFUVS2ukM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 522/591] extcon: usbc-tusb320: Unregister typec port on driver removal
Date: Sun, 16 Jul 2023 21:51:01 +0200
Message-ID: <20230716194937.379063175@linuxfoundation.org>
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

From: Alvin Šipraga <alsi@bang-olufsen.dk>

[ Upstream commit 3adbaa30d973093a4f37927baf9596cca51b593d ]

The driver can register a typec port if suitable firmware properties are
present. But if the driver is removed through sysfs unbind, rmmod or
similar, then it does not clean up after itself and the typec port
device remains registered. This can be seen in sysfs, where stale typec
ports get left over in /sys/class/typec.

In order to fix this we have to add an i2c_driver remove function and
call typec_unregister_port(), which is a no-op in the case where no
typec port is created and the pointer remains NULL.

In the process we should also put the fwnode_handle when the typec port
isn't registered anymore, including if an error occurs during probe. The
typec subsystem does not increase or decrease the reference counter for
us, so we track it in the driver's private data.

Note that the conditional check on TYPEC_PWR_MODE_PD was removed in the
probe path because a call to tusb320_set_adv_pwr_mode() will perform an
even more robust validation immediately after, hence there is no
functional change here.

Fixes: bf7571c00dca ("extcon: usbc-tusb320: Add USB TYPE-C support")
Cc: stable@vger.kernel.org
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-usbc-tusb320.c | 42 ++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/extcon/extcon-usbc-tusb320.c b/drivers/extcon/extcon-usbc-tusb320.c
index b408ce989c223..10dff1c512c41 100644
--- a/drivers/extcon/extcon-usbc-tusb320.c
+++ b/drivers/extcon/extcon-usbc-tusb320.c
@@ -78,6 +78,7 @@ struct tusb320_priv {
 	struct typec_capability	cap;
 	enum typec_port_type port_type;
 	enum typec_pwr_opmode pwr_opmode;
+	struct fwnode_handle *connector_fwnode;
 };
 
 static const char * const tusb_attached_states[] = {
@@ -391,27 +392,25 @@ static int tusb320_typec_probe(struct i2c_client *client,
 	/* Type-C connector found. */
 	ret = typec_get_fw_cap(&priv->cap, connector);
 	if (ret)
-		return ret;
+		goto err_put;
 
 	priv->port_type = priv->cap.type;
 
 	/* This goes into register 0x8 field CURRENT_MODE_ADVERTISE */
 	ret = fwnode_property_read_string(connector, "typec-power-opmode", &cap_str);
 	if (ret)
-		return ret;
+		goto err_put;
 
 	ret = typec_find_pwr_opmode(cap_str);
 	if (ret < 0)
-		return ret;
-	if (ret == TYPEC_PWR_MODE_PD)
-		return -EINVAL;
+		goto err_put;
 
 	priv->pwr_opmode = ret;
 
 	/* Initialize the hardware with the devicetree settings. */
 	ret = tusb320_set_adv_pwr_mode(priv);
 	if (ret)
-		return ret;
+		goto err_put;
 
 	priv->cap.revision		= USB_TYPEC_REV_1_1;
 	priv->cap.accessory[0]		= TYPEC_ACCESSORY_AUDIO;
@@ -422,10 +421,25 @@ static int tusb320_typec_probe(struct i2c_client *client,
 	priv->cap.fwnode		= connector;
 
 	priv->port = typec_register_port(&client->dev, &priv->cap);
-	if (IS_ERR(priv->port))
-		return PTR_ERR(priv->port);
+	if (IS_ERR(priv->port)) {
+		ret = PTR_ERR(priv->port);
+		goto err_put;
+	}
+
+	priv->connector_fwnode = connector;
 
 	return 0;
+
+err_put:
+	fwnode_handle_put(connector);
+
+	return ret;
+}
+
+static void tusb320_typec_remove(struct tusb320_priv *priv)
+{
+	typec_unregister_port(priv->port);
+	fwnode_handle_put(priv->connector_fwnode);
 }
 
 static int tusb320_probe(struct i2c_client *client)
@@ -438,7 +452,9 @@ static int tusb320_probe(struct i2c_client *client)
 	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
+
 	priv->dev = &client->dev;
+	i2c_set_clientdata(client, priv);
 
 	priv->regmap = devm_regmap_init_i2c(client, &tusb320_regmap_config);
 	if (IS_ERR(priv->regmap))
@@ -489,10 +505,19 @@ static int tusb320_probe(struct i2c_client *client)
 					tusb320_irq_handler,
 					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 					client->name, priv);
+	if (ret)
+		tusb320_typec_remove(priv);
 
 	return ret;
 }
 
+static void tusb320_remove(struct i2c_client *client)
+{
+	struct tusb320_priv *priv = i2c_get_clientdata(client);
+
+	tusb320_typec_remove(priv);
+}
+
 static const struct of_device_id tusb320_extcon_dt_match[] = {
 	{ .compatible = "ti,tusb320", .data = &tusb320_ops, },
 	{ .compatible = "ti,tusb320l", .data = &tusb320l_ops, },
@@ -502,6 +527,7 @@ MODULE_DEVICE_TABLE(of, tusb320_extcon_dt_match);
 
 static struct i2c_driver tusb320_extcon_driver = {
 	.probe_new	= tusb320_probe,
+	.remove		= tusb320_remove,
 	.driver		= {
 		.name	= "extcon-tusb320",
 		.of_match_table = tusb320_extcon_dt_match,
-- 
2.39.2



