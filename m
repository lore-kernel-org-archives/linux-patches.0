Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEB21ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F62C433C7;
	Tue, 25 Jul 2023 11:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284173;
	bh=F7kQU87BJT+lluERYHbkfLuszCakmWSQTgwvcaP5Foo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTiyfczzDCVpmAyC8DM6nUscba7CoWpBqM/kofc9NEsnkfsfv5HQBGGvm/iDqrkh4
	 cwhZ0A/hphAomdmpLjfHvYfIdRpdXrGeNBVons60PXgwtbj7yQXB/578ry8LK0zzTK
	 JoTIIVB4FScLx5LP0D/3PAVzbI9j8E9Eu/rAjGVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Pawel Dembicki <paweldembicki@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/509] net: dsa: vsc73xx: fix MTU configuration
Date: Tue, 25 Jul 2023 12:43:21 +0200
Message-ID: <20230725104605.743537216@linuxfoundation.org>
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

From: Pawel Dembicki <paweldembicki@gmail.com>

[ Upstream commit 3cf62c8177adb0db9e15c8b898c44f997acf3ebf ]

Switch in MAXLEN register stores the maximum size of a data frame.
The MTU size is 18 bytes smaller than the frame size.

The current settings are causing problems with packet forwarding.
This patch fixes the MTU settings to proper values.

Fixes: fb77ffc6ec86 ("net: dsa: vsc73xx: make the MTU configurable")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20230628194327.1765644-1-paweldembicki@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 19ce4aa0973b4..80eadf509c0a9 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -1025,17 +1025,17 @@ static int vsc73xx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	struct vsc73xx *vsc = ds->priv;
 
 	return vsc73xx_write(vsc, VSC73XX_BLOCK_MAC, port,
-			     VSC73XX_MAXLEN, new_mtu);
+			     VSC73XX_MAXLEN, new_mtu + ETH_HLEN + ETH_FCS_LEN);
 }
 
 /* According to application not "VSC7398 Jumbo Frames" setting
- * up the MTU to 9.6 KB does not affect the performance on standard
+ * up the frame size to 9.6 KB does not affect the performance on standard
  * frames. It is clear from the application note that
  * "9.6 kilobytes" == 9600 bytes.
  */
 static int vsc73xx_get_max_mtu(struct dsa_switch *ds, int port)
 {
-	return 9600;
+	return 9600 - ETH_HLEN - ETH_FCS_LEN;
 }
 
 static const struct dsa_switch_ops vsc73xx_ds_ops = {
-- 
2.39.2



