Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4841F94B
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA2BC433C8;
	Fri, 21 Jul 2023 18:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965981;
	bh=i/REAkM4E+9dkt28BeXvOyHa8TqZ8RzaJuX/6uuDxjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ib4TBq7yxo7VFrsNBD93I5DAQarVjMdWuqzN591p/aMzTXCGxjJ/qJ1qwbqOkJyeC
	 WmORqO19bt2BLDv6+zIBcLz8spqyw06b2m8wHi8FGi+3JvKvsc9gTJLM6W0FT5JBke
	 rv8l8crRvx9H3gJcqhHMnWbYyhWxl/ApG2fWbQmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/532] clk: vc5: check memory returned by kasprintf()
Date: Fri, 21 Jul 2023 18:01:26 +0200
Message-ID: <20230721160624.246146727@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 144601f6228de5598f03e693822b60a95c367a17 ]

kasprintf() returns a pointer to dynamically allocated memory.
Pointer could be NULL in case allocation fails. Check pointer validity.
Identified with coccinelle (kmerr.cocci script).

Fixes: f491276a5168 ("clk: vc5: Allow Versaclock driver to support multiple instances")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230530093913.1656095-2-claudiu.beznea@microchip.com
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-versaclock5.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/clk/clk-versaclock5.c b/drivers/clk/clk-versaclock5.c
index 5f8bd49b0810c..c52f02471bb4f 100644
--- a/drivers/clk/clk-versaclock5.c
+++ b/drivers/clk/clk-versaclock5.c
@@ -992,6 +992,11 @@ static int vc5_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	init.name = kasprintf(GFP_KERNEL, "%pOFn.mux", client->dev.of_node);
+	if (!init.name) {
+		ret = -ENOMEM;
+		goto err_clk;
+	}
+
 	init.ops = &vc5_mux_ops;
 	init.flags = 0;
 	init.parent_names = parent_names;
@@ -1006,6 +1011,10 @@ static int vc5_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		memset(&init, 0, sizeof(init));
 		init.name = kasprintf(GFP_KERNEL, "%pOFn.dbl",
 				      client->dev.of_node);
+		if (!init.name) {
+			ret = -ENOMEM;
+			goto err_clk;
+		}
 		init.ops = &vc5_dbl_ops;
 		init.flags = CLK_SET_RATE_PARENT;
 		init.parent_names = parent_names;
@@ -1021,6 +1030,10 @@ static int vc5_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	/* Register PFD */
 	memset(&init, 0, sizeof(init));
 	init.name = kasprintf(GFP_KERNEL, "%pOFn.pfd", client->dev.of_node);
+	if (!init.name) {
+		ret = -ENOMEM;
+		goto err_clk;
+	}
 	init.ops = &vc5_pfd_ops;
 	init.flags = CLK_SET_RATE_PARENT;
 	init.parent_names = parent_names;
@@ -1038,6 +1051,10 @@ static int vc5_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	/* Register PLL */
 	memset(&init, 0, sizeof(init));
 	init.name = kasprintf(GFP_KERNEL, "%pOFn.pll", client->dev.of_node);
+	if (!init.name) {
+		ret = -ENOMEM;
+		goto err_clk;
+	}
 	init.ops = &vc5_pll_ops;
 	init.flags = CLK_SET_RATE_PARENT;
 	init.parent_names = parent_names;
@@ -1057,6 +1074,10 @@ static int vc5_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		memset(&init, 0, sizeof(init));
 		init.name = kasprintf(GFP_KERNEL, "%pOFn.fod%d",
 				      client->dev.of_node, idx);
+		if (!init.name) {
+			ret = -ENOMEM;
+			goto err_clk;
+		}
 		init.ops = &vc5_fod_ops;
 		init.flags = CLK_SET_RATE_PARENT;
 		init.parent_names = parent_names;
@@ -1075,6 +1096,10 @@ static int vc5_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	memset(&init, 0, sizeof(init));
 	init.name = kasprintf(GFP_KERNEL, "%pOFn.out0_sel_i2cb",
 			      client->dev.of_node);
+	if (!init.name) {
+		ret = -ENOMEM;
+		goto err_clk;
+	}
 	init.ops = &vc5_clk_out_ops;
 	init.flags = CLK_SET_RATE_PARENT;
 	init.parent_names = parent_names;
@@ -1101,6 +1126,10 @@ static int vc5_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		memset(&init, 0, sizeof(init));
 		init.name = kasprintf(GFP_KERNEL, "%pOFn.out%d",
 				      client->dev.of_node, idx + 1);
+		if (!init.name) {
+			ret = -ENOMEM;
+			goto err_clk;
+		}
 		init.ops = &vc5_clk_out_ops;
 		init.flags = CLK_SET_RATE_PARENT;
 		init.parent_names = parent_names;
-- 
2.39.2



