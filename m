Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F299B8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74234C433C7;
	Sun, 16 Jul 2023 20:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540197;
	bh=3snP4T0v2pRmorPOa1JRHEQl2CKk0lThyGvASpsau4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6xJGJmw8aZgve6HIbavydWBqsTHs5D2tXfL4dqPMg7uVx+eYNxxOpOIAZ5SDpq8H
	 Xz2KYKqkQPUPwK/+1rI3TjjPaaXsMKMgW3CgU/twFAbKzNJ4M0afIRiaaaQqoZBYQT
	 NLy9CvZcJ9fA6cUgLYcTqH4ALwivQnHeyfwarLuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Tony Lindgren <tony@atomide.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 277/591] clk: ti: clkctrl: check return value of kasprintf()
Date: Sun, 16 Jul 2023 21:46:56 +0200
Message-ID: <20230716194931.061669866@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit bd46cd0b802d9c9576ca78007aa084ae3e74907b ]

kasprintf() returns a pointer to dynamically allocated memory.
Pointer could be NULL in case allocation fails. Check pointer validity.
Identified with coccinelle (kmerr.cocci script).

Fixes: 852049594b9a ("clk: ti: clkctrl: convert subclocks to use proper names also")
Fixes: 6c3090520554 ("clk: ti: clkctrl: Fix hidden dependency to node name")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230530093913.1656095-8-claudiu.beznea@microchip.com
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clkctrl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/clk/ti/clkctrl.c b/drivers/clk/ti/clkctrl.c
index ae58628794176..57611bfb299c1 100644
--- a/drivers/clk/ti/clkctrl.c
+++ b/drivers/clk/ti/clkctrl.c
@@ -258,6 +258,9 @@ static const char * __init clkctrl_get_clock_name(struct device_node *np,
 	if (clkctrl_name && !legacy_naming) {
 		clock_name = kasprintf(GFP_KERNEL, "%s-clkctrl:%04x:%d",
 				       clkctrl_name, offset, index);
+		if (!clock_name)
+			return NULL;
+
 		strreplace(clock_name, '_', '-');
 
 		return clock_name;
@@ -586,6 +589,10 @@ static void __init _ti_omap4_clkctrl_setup(struct device_node *node)
 	if (clkctrl_name) {
 		provider->clkdm_name = kasprintf(GFP_KERNEL,
 						 "%s_clkdm", clkctrl_name);
+		if (!provider->clkdm_name) {
+			kfree(provider);
+			return;
+		}
 		goto clkdm_found;
 	}
 
-- 
2.39.2



