Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A8F6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CD7C433EF;
	Mon, 16 Jan 2023 17:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888770;
	bh=PPB+FOaMAgsOvNPU6f/jap/4gGs6mKG6z1G7dWcdXRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VO8yqaaUwiWEUuLfNnTZE+fkPwq7h0Y8KOdTRVOwLAdXlktjqmdezdoKkU+cmwQXg
	 QONqeX+S0ITFC7h0faX167Ic8So/Zcl2KNixjyu6vrrAALF97MEIyoZaoHkEq8kVEP
	 +WRMo4oOXOHSPrjtT4WH1j6JMoVNp2PkEd6Bkqeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Ray <jerry.ray@microchip.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 132/338] net: lan9303: Fix read error execution path
Date: Mon, 16 Jan 2023 16:50:05 +0100
Message-Id: <20230116154826.589293251@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index 10d1c08ffeea..989a0cd39f7a 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -721,9 +721,11 @@ static void lan9303_get_ethtool_stats(struct dsa_switch *ds, int port,
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



