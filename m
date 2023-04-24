Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3E07C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBF6C433D2;
	Mon, 24 Apr 2023 13:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343064;
	bh=ecAMf6qGg+IApvGm14X8LPM1kVNrVNVx6A9l323fbKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mm29vvlJVPtE23vltfyRe2xyQ+3mIJQkhZytu2xz7SHPWOslGV+oZ9Ibp4AJRi2H6
	 uCNCvAVTaKwUam7OlMZ5sgqJeP2fbqiT1b0qU1fu9ZPQvNpkWJ0JWfWnDBCaxYXKuq
	 MiIYWFXgSidMiRtmj0wmQVz559IPtyzpdwsunyUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Simon Horman <simon.horman@corigine.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 034/110] net: dsa: microchip: ksz8795: Correctly handle huge frame configuration
Date: Mon, 24 Apr 2023 15:16:56 +0200
Message-Id: <20230424131137.427880445@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3d2f8f1f184c60508f7af3022536651d7ac2dd07 ]

Because of the logic in place, SW_HUGE_PACKET can never be set.
(If the first condition is true, then the 2nd one is also true, but is not
executed)

Change the logic and update each bit individually.

Fixes: 29d1e85f45e0 ("net: dsa: microchip: ksz8: add MTU configuration support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/43107d9e8b5b8b05f0cbd4e1f47a2bb88c8747b2.1681755535.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 3fffd5da8d3b0..ffcad057d0650 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -96,7 +96,7 @@ static int ksz8795_change_mtu(struct ksz_device *dev, int frame_size)
 
 	if (frame_size > KSZ8_LEGAL_PACKET_SIZE)
 		ctrl2 |= SW_LEGAL_PACKET_DISABLE;
-	else if (frame_size > KSZ8863_NORMAL_PACKET_SIZE)
+	if (frame_size > KSZ8863_NORMAL_PACKET_SIZE)
 		ctrl1 |= SW_HUGE_PACKET;
 
 	ret = ksz_rmw8(dev, REG_SW_CTRL_1, SW_HUGE_PACKET, ctrl1);
-- 
2.39.2



