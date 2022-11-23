Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1A11C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36B8C433C1;
	Wed, 23 Nov 2022 09:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197045;
	bh=rbHOnH0bDQ0tV63PvzNhoB75RHapbYfhoW1bD24vfYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qR/nZfcN6SLaoLvUkWhtOg/MhNMizQ8mnMWYMLErLFA+4ejqvD5Fac3pa3UFw8F17
	 u/JNjCpQmHCVG5uYTRg6+RRAZjfNvGse93D2o1FD103Z9CZJTGPNX8VE6H31kCUYlb
	 whVD1OEepW0S1Kdqv1QNGKNycNywrJuQZRHhhcaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 183/314] net: ag71xx: call phylink_disconnect_phy if ag71xx_hw_enable() fail in ag71xx_open()
Date: Wed, 23 Nov 2022 09:50:28 +0100
Message-Id: <20221123084633.857629597@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit c9b895c6878bdb6789dc1d7af60fd10f4a9f1937 ]

If ag71xx_hw_enable() fails, call phylink_disconnect_phy() to clean up.
And if phylink_of_phy_connect() fails, nothing needs to be done.
Compile tested only.

Fixes: 892e09153fa3 ("net: ag71xx: port to phylink")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20221114095549.40342-1-liujian56@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/ag71xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index e461f4764066..e23d8734d4e4 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1427,7 +1427,7 @@ static int ag71xx_open(struct net_device *ndev)
 	if (ret) {
 		netif_err(ag, link, ndev, "phylink_of_phy_connect filed with err: %i\n",
 			  ret);
-		goto err;
+		return ret;
 	}
 
 	max_frame_len = ag71xx_max_frame_len(ndev->mtu);
@@ -1448,6 +1448,7 @@ static int ag71xx_open(struct net_device *ndev)
 
 err:
 	ag71xx_rings_cleanup(ag);
+	phylink_disconnect_phy(ag->phylink);
 	return ret;
 }
 
-- 
2.35.1



