Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA791ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAD3C433C8;
	Tue, 25 Jul 2023 11:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283902;
	bh=MTCTiG4zcHbQkUQgYCOuZFdyp263Clraks052Ayih3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pR9ygRTY1HQbA74cnzE1AduJgWTAPwbVTe2f99x8p8ttiXNkXt9P/QMWgDHfiqY+3
	 f0TlFCbE+rCEdDvKvuk+Qyi+2EQhH9/Sod/nLRkhrZWuyW6oTp98YEIDIiNqNcFmWg
	 C431gCXVILKYeg11u24wdZUU7T+Ne9DlacAzhkmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/509] clk: cdce925: check return value of kasprintf()
Date: Tue, 25 Jul 2023 12:41:43 +0200
Message-ID: <20230725104601.232779981@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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

[ Upstream commit bb7d09ddbf361d51eae46f38e7c8a2b85914ea2a ]

kasprintf() returns a pointer to dynamically allocated memory.
Pointer could be NULL in case allocation fails. Check pointer validity.
Identified with coccinelle (kmerr.cocci script).

Fixes: 19fbbbbcd3a3 ("Add TI CDCE925 I2C controlled clock synthesizer driver")
Depends-on: e665f029a283 ("clk: Convert to using %pOFn instead of device_node.name")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230530093913.1656095-3-claudiu.beznea@microchip.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-cdce925.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/clk/clk-cdce925.c b/drivers/clk/clk-cdce925.c
index 308b353815e17..470d91d7314db 100644
--- a/drivers/clk/clk-cdce925.c
+++ b/drivers/clk/clk-cdce925.c
@@ -705,6 +705,10 @@ static int cdce925_probe(struct i2c_client *client,
 	for (i = 0; i < data->chip_info->num_plls; ++i) {
 		pll_clk_name[i] = kasprintf(GFP_KERNEL, "%pOFn.pll%d",
 			client->dev.of_node, i);
+		if (!pll_clk_name[i]) {
+			err = -ENOMEM;
+			goto error;
+		}
 		init.name = pll_clk_name[i];
 		data->pll[i].chip = data;
 		data->pll[i].hw.init = &init;
@@ -746,6 +750,10 @@ static int cdce925_probe(struct i2c_client *client,
 	init.num_parents = 1;
 	init.parent_names = &parent_name; /* Mux Y1 to input */
 	init.name = kasprintf(GFP_KERNEL, "%pOFn.Y1", client->dev.of_node);
+	if (!init.name) {
+		err = -ENOMEM;
+		goto error;
+	}
 	data->clk[0].chip = data;
 	data->clk[0].hw.init = &init;
 	data->clk[0].index = 0;
@@ -764,6 +772,10 @@ static int cdce925_probe(struct i2c_client *client,
 	for (i = 1; i < data->chip_info->num_outputs; ++i) {
 		init.name = kasprintf(GFP_KERNEL, "%pOFn.Y%d",
 			client->dev.of_node, i+1);
+		if (!init.name) {
+			err = -ENOMEM;
+			goto error;
+		}
 		data->clk[i].chip = data;
 		data->clk[i].hw.init = &init;
 		data->clk[i].index = i;
-- 
2.39.2



