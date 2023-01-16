Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD93C6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35522C433EF;
	Mon, 16 Jan 2023 16:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887571;
	bh=uFzAFPObybysgSlov+ytUArXxBp6E7aFWUd/3gM81ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emefd3jblGXr8KiIO6hx570nUtmBwTDPaNlHUZpzsowA/UQnqq/8DKNg+9jfVoUg6
	 Z9vtHKw3lPDaxxjbj1pa+0XfcsIkW6iLVKsyXMWbJknNxA+yMh5aKnqe9Pj5madLIt
	 R9XVeG5W9WuFIr5f7XGliEpdW/gPIxYF48Ab8V8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Ray <jerry.ray@microchip.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 171/521] net: lan9303: Fix read error execution path
Date: Mon, 16 Jan 2023 16:47:13 +0100
Message-Id: <20230116154854.757507480@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jerry Ray <jerry.ray@microchip.com>

[ Upstream commit 8964916d206071b058c6351f88b1966bd58cbde0 ]

This patch fixes an issue where a read failure of a port statistic counter
will return unknown results.  While it is highly unlikely the read will
ever fail, it is much cleaner to return a zero for the stat count.

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221209153502.7429-1-jerry.ray@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lan9303-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 03dc075ff4e8..f976b3d64593 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1010,9 +1010,11 @@ static void lan9303_get_ethtool_stats(struct dsa_switch *ds, int port,
 		ret = lan9303_read_switch_port(
 			chip, port, lan9303_mib[u].offset, &reg);
 
-		if (ret)
+		if (ret) {
 			dev_warn(chip->dev, "Reading status port %d reg %u failed\n",
 				 port, lan9303_mib[u].offset);
+			reg = 0;
+		}
 		data[u] = reg;
 	}
 }
-- 
2.35.1



