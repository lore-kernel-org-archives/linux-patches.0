Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41F5187A
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D04C433F0;
	Wed, 28 Dec 2022 16:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244263;
	bh=F/0i3aK9Xtz5gEUzmTfMTfJBA5+YH/epPJZIIbstWpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmiBxrnx5zdOYyt3Aa7xqhJMCZkKgbS20Ximt8B4t5k6GN1KRSPnGIA0ZED28KY89
	 W5YWS+R/HuaCMpdRMX70jjfOQLvqINlKx/jKiFIbqX9VSIj6hgGH22hULZUAoMMNKx
	 2nSnAZMWwDcAQuNlEbEoqCqvR3IUg64O5yUkdKBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@svenpeter.dev>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0678/1073] usb: typec: tipd: Fix typec_unregister_port error paths
Date: Wed, 28 Dec 2022 15:37:46 +0100
Message-Id: <20221228144346.453693684@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit 4c8f27ba9ede0118cac9d775204f9b0ecdb877b0 ]

typec_unregister_port is only called for some error paths after
typec_register_port was successful. Ensure it's called in all
cases.

Fixes: 92440202a880 ("usb: typec: tipd: Only update power status on IRQ")
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221114174449.34634-3-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tipd/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index a5fbbae52525..513ac7e141a4 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -826,7 +826,7 @@ static int tps6598x_probe(struct i2c_client *client)
 		ret = tps6598x_read16(tps, TPS_REG_POWER_STATUS, &tps->pwr_status);
 		if (ret < 0) {
 			dev_err(tps->dev, "failed to read power status: %d\n", ret);
-			goto err_role_put;
+			goto err_unregister_port;
 		}
 		ret = tps6598x_connect(tps, status);
 		if (ret)
@@ -839,8 +839,7 @@ static int tps6598x_probe(struct i2c_client *client)
 					dev_name(&client->dev), tps);
 	if (ret) {
 		tps6598x_disconnect(tps, 0);
-		typec_unregister_port(tps->port);
-		goto err_role_put;
+		goto err_unregister_port;
 	}
 
 	i2c_set_clientdata(client, tps);
@@ -848,6 +847,8 @@ static int tps6598x_probe(struct i2c_client *client)
 
 	return 0;
 
+err_unregister_port:
+	typec_unregister_port(tps->port);
 err_role_put:
 	usb_role_switch_put(tps->role_sw);
 err_fwnode_put:
-- 
2.35.1



