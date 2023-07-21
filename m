Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1841F94B
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C732BC433C8;
	Fri, 21 Jul 2023 18:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965990;
	bh=VFC5+BT+bSx60f2XJyjNYXM+AlDULRaTHB5AlBn5Zd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIe93zIaCozHGtQ4uUXNJlPbumu/CjjxVIFG+ghkbDUHjNKD0R/F5GKvvqM8qytKm
	 jL8jmYo1AIPNZCOokZF3doirpa7TLWoG/x7Gx0RtsUHPXT6o90ui7Nurcf0jybWk+X
	 CcFR9g29GWVvzIuVTNLMjbw16GRylwC69ktOGMt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/532] clk: si5341: check return value of {devm_}kasprintf()
Date: Fri, 21 Jul 2023 18:01:29 +0200
Message-ID: <20230721160624.414160368@linuxfoundation.org>
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

[ Upstream commit 36e4ef82016a2b785cf2317eade77e76699b7bff ]

{devm_}kasprintf() returns a pointer to dynamically allocated memory.
Pointer could be NULL in case allocation fails. Check pointer validity.
Identified with coccinelle (kmerr.cocci script).

Fixes: 3044a860fd09 ("clk: Add Si5341/Si5340 driver")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230530093913.1656095-5-claudiu.beznea@microchip.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si5341.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/clk-si5341.c b/drivers/clk/clk-si5341.c
index 883a49a0805c9..4bcfb38cfbebe 100644
--- a/drivers/clk/clk-si5341.c
+++ b/drivers/clk/clk-si5341.c
@@ -1698,6 +1698,10 @@ static int si5341_probe(struct i2c_client *client,
 	for (i = 0; i < data->num_synth; ++i) {
 		synth_clock_names[i] = devm_kasprintf(&client->dev, GFP_KERNEL,
 				"%s.N%u", client->dev.of_node->name, i);
+		if (!synth_clock_names[i]) {
+			err = -ENOMEM;
+			goto free_clk_names;
+		}
 		init.name = synth_clock_names[i];
 		data->synth[i].index = i;
 		data->synth[i].data = data;
@@ -1716,6 +1720,10 @@ static int si5341_probe(struct i2c_client *client,
 	for (i = 0; i < data->num_outputs; ++i) {
 		init.name = kasprintf(GFP_KERNEL, "%s.%d",
 			client->dev.of_node->name, i);
+		if (!init.name) {
+			err = -ENOMEM;
+			goto free_clk_names;
+		}
 		init.flags = config[i].synth_master ? CLK_SET_RATE_PARENT : 0;
 		data->clk[i].index = i;
 		data->clk[i].data = data;
-- 
2.39.2



