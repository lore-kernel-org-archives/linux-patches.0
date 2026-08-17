Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48EF32ED40;
	Mon, 17 Aug 2026 13:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974006; cv=none; b=BnIWlmKIbN222uj98sH9RF7W5ScgPiaGTy3ZCKAOFjzrN87qhqt2Mp3tj7TtYjFhkxLAqc26LPLrXwB2t5If+8Y6TlvHp5TiS4SNOsK19r1xYw5HGpfpXhuAKUBuhy8gIzWyfuibGd+rCAsvLKYwzK2HmcoARoIWMZYHM2Xf0bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974006; c=relaxed/simple;
	bh=/VKhxdFiKCu0CLfAzShog78OQZxqHgplU5JoXdp0c+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ibvw7FJd7ILctddRw+vxbqUmKjB7usLqBIbl3Wv84KVWZZRNIPo3kNrISST+0N0syZTKLSUK1CXmV0TKr6OtiHypjt1qnJEyC5xGJtRqs5YbYNHvMJjHHIwnvzwhnzHxVjC74/ZXB01XTGv8upxnKLwmI0r8XY2F74ap9R1IDrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ccp6mrT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ccp6mrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A7C1F00A3D;
	Mon, 17 Aug 2026 13:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974005;
	bh=uxD3ozvygw/BTJJmm55of6huzbheZodY8ixyLydBYv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ccp6mrTakB6KAN7vXG++8HMhkuoD4UCoWr/MTkDDrLVykl/byLQZbevt03a+1fQO
	 g1mTeylXv89oKb4PaTf257rLUE2kaFatp1aCrg9B/SjT3IXZhBnPC7jgFiHqUiPnRz
	 dyIk/FHkTVCfanLEIKMAn0586D4sM5EfiGkiKm04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 056/271] net: hisilicon: hix5hd2_gmac: remove redundant NAPI delete
Date: Mon, 17 Aug 2026 15:29:41 +0200
Message-ID: <20260817132539.052979162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit f307a7dc32097c11413178fca437a10d20890bc2 ]

hix5hd2_dev_remove() calls netif_napi_del() before unregister_netdev().
This is not needed because free_netdev() deletes all NAPI instances
attached to the net_device.

Remove the redundant call and let the networking core tear down the NAPI
instance during unregister_netdev(). The probe error path still keeps its
explicit netif_napi_del(), because the device has not been registered
there.

Fixes: 57c5bc9ad7d7 ("net: hisilicon: add hix5hd2 mac driver")
Signed-off-by: Jiawen Liu <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_5FFD37A252B4FEA6A80AD25B17C8E904F005@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index e3e7f2270560c..02282dc86faf4 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1282,7 +1282,6 @@ static void hix5hd2_dev_remove(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct hix5hd2_priv *priv = netdev_priv(ndev);
 
-	netif_napi_del(&priv->napi);
 	unregister_netdev(ndev);
 	mdiobus_unregister(priv->bus);
 	mdiobus_free(priv->bus);
-- 
2.53.0



