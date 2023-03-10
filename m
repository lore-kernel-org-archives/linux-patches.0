Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359EF881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07D2C433EF;
	Fri, 10 Mar 2023 14:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459417;
	bh=AvZWhyc2chsXPo55AExN5en5/J0xkkBTakL4AM0pPHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJGWyqoiKQTyOw84VDLV/OCppO7/b2yVtLywHxlRokE5mM2xxI6yivjgRTmN1rSxE
	 gl/ipLeaDLjrANoOOjwywFZ+uuO+wi1Y1sF4UhGy4ofLYobIh6b4fP8sU1O3ZuG38z
	 CmLxZwItHp794M39TqXzE6zK5FxMxVXjwUujfp4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@siol.net>,
	Maxime Ripard <mripard@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 324/357] rtc: sun6i: Make external 32k oscillator optional
Date: Fri, 10 Mar 2023 14:40:13 +0100
Message-Id: <20230310133748.957723675@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit ec98a87509f40324807dc179a7e3163d40709eba ]

Some boards, like OrangePi PC2 (H5), OrangePi Plus 2E (H3) and Tanix TX6
(H6) don't have external 32kHz oscillator. Till H6, it didn't really
matter if external oscillator was enabled because HW detected error and
fall back to internal one. H6 has same functionality but it's the first
SoC which have "auto switch bypass" bit documented and always enabled in
driver. This prevents RTC to work correctly if external crystal is not
present on board. There are other side effects - all peripherals which
depends on this clock also don't work (HDMI CEC for example).

Make clocks property optional. If it is present, select external
oscillator. If not, stay on internal.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/20200308135849.106333-2-jernej.skrabec@siol.net
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 344f4030f6c5 ("rtc: sun6i: Always export the internal oscillator")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-sun6i.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index c41bc8084d7cc..b13af0368ef61 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -251,19 +251,17 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
 		writel(reg, rtc->base + SUN6I_LOSC_CTRL);
 	}
 
-	/* Switch to the external, more precise, oscillator */
-	reg |= SUN6I_LOSC_CTRL_EXT_OSC;
-	if (rtc->data->has_losc_en)
-		reg |= SUN6I_LOSC_CTRL_EXT_LOSC_EN;
+	/* Switch to the external, more precise, oscillator, if present */
+	if (of_get_property(node, "clocks", NULL)) {
+		reg |= SUN6I_LOSC_CTRL_EXT_OSC;
+		if (rtc->data->has_losc_en)
+			reg |= SUN6I_LOSC_CTRL_EXT_LOSC_EN;
+	}
 	writel(reg, rtc->base + SUN6I_LOSC_CTRL);
 
 	/* Yes, I know, this is ugly. */
 	sun6i_rtc = rtc;
 
-	/* Deal with old DTs */
-	if (!of_get_property(node, "clocks", NULL))
-		goto err;
-
 	/* Only read IOSC name from device tree if it is exported */
 	if (rtc->data->export_iosc)
 		of_property_read_string_index(node, "clock-output-names", 2,
@@ -280,11 +278,13 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
 	}
 
 	parents[0] = clk_hw_get_name(rtc->int_osc);
+	/* If there is no external oscillator, this will be NULL and ... */
 	parents[1] = of_clk_get_parent_name(node, 0);
 
 	rtc->hw.init = &init;
 
 	init.parent_names = parents;
+	/* ... number of clock parents will be 1. */
 	init.num_parents = of_clk_get_parent_count(node) + 1;
 	of_property_read_string_index(node, "clock-output-names", 0,
 				      &init.name);
-- 
2.39.2



