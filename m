Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CA58F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268D1C433C7;
	Sun, 16 Jul 2023 20:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540787;
	bh=0WuSaP4EjiSH6VHmUmG8yHgktuI1tL9+3zQXoJtMFBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1LNZH3yAR6BKHm1KMAbrRORD8OrPUPsNMUvj3KEjVcu4uIBiM4x/EBDQc1FNqqrT
	 bxqDZ3vdRSJGp74zlklB3U4kmgltoZwK0QPYd/pz6pQ8yFuRrhatnm3yNCflo4cnuG
	 hSG9CNUBvlSCr+s/U/lkYn/4Xnku4cNhvsPorsJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Pawel Dembicki <paweldembicki@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 487/591] net: dsa: vsc73xx: fix MTU configuration
Date: Sun, 16 Jul 2023 21:50:26 +0200
Message-ID: <20230716194936.494734575@linuxfoundation.org>
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
index ae55167ce0a6f..ef1a4a7c47b23 100644
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



