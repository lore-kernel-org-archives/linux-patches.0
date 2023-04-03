Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA66A6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7325DC433D2;
	Mon,  3 Apr 2023 14:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532148;
	bh=rRzLbpryEzP+7A7UMNef0x+tz6zPHOwmCX5mzJ1fB5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/xFyoprJn8L0AYOwDgJyQvG4iiurJvzn1ini6gMcBNG4fiRWFFYG90s4ROly/Zbo
	 ZZenL0pfGzhTKpfopRsXiDzkf3pegnDznOheCPE4HtD513HgDYhmHswe0liLGipj+K
	 DoGeWq/jU9CIDtftMpKJJFPoC7kxwNoZ1LakxEvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/173] pinctrl: ocelot: Fix alt mode for ocelot
Date: Mon,  3 Apr 2023 16:09:19 +0200
Message-Id: <20230403140419.115637632@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 657fd9da2d4b4aa0a384105b236baa22fa0233bf ]

In case the driver was trying to set an alternate mode for gpio
0 or 32 then the mode was not set correctly. The reason is that
there is computation error inside the function ocelot_pinmux_set_mux
because in this case it was trying to shift to left by -1.
Fix this by actually shifting the function bits and not the position.

Fixes: 4b36082e2e09 ("pinctrl: ocelot: fix pinmuxing for pins after 31")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20230206203720.1177718-1-horatiu.vultur@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index a4a1b00f7f0df..c42a5b0bc4f0c 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -575,7 +575,7 @@ static int ocelot_pinmux_set_mux(struct pinctrl_dev *pctldev,
 	regmap_update_bits(info->map, REG_ALT(0, info, pin->pin),
 			   BIT(p), f << p);
 	regmap_update_bits(info->map, REG_ALT(1, info, pin->pin),
-			   BIT(p), f << (p - 1));
+			   BIT(p), (f >> 1) << p);
 
 	return 0;
 }
-- 
2.39.2



