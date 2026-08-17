Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA833FA5CC;
	Mon, 17 Aug 2026 14:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977884; cv=none; b=DdsP0+HTX4jGxQ9D8Wv75WabSuPJ8PkDV7BMUTCvZMJuLAMxuI/8Bdu6w0R9eTA85yQrmyxy7QO66A4H546sAUYARVylf2wUzKlpJL507sJ3sck8aMjBLuKDWkxbxn23IjmgbFM+on7cQIAUHx/nTEddGXM9SBuHeL1Cak8M5go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977884; c=relaxed/simple;
	bh=uic5rH74jNHQZO6GzrJZq4H9OXc64s/P+1CGhNlDGvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSK/ekKT2HvoNNkQprnZySkS7cF/PRrJVYUeoiBv10lJtnt9UvDj0HYmBSCq5Pn4KjkW2bktxMQXO5BcuYAgGlPa+TRqLliQf+S9VkD3x2kdUf92isHwr7Ht1S0K+V49VXOyETNzQBlj33xoZzm5RUqWcur90U/TuCxB0eHMYPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysRQnJvH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysRQnJvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB66A1F000E9;
	Mon, 17 Aug 2026 14:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977882;
	bh=s4Rsz+ZyMdvBd2P2BkYsoqV/ACcp2/Q0hq35/iCsKg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysRQnJvHpIUViea/xZ4usBTflPdcS0ZjyX/I/Oos2Ero7MW5V4X007/AI2wxjYl2N
	 0oq8poKT8+XYGP/o/wU8fAS7lBfeyh2wG4jaQje+SaSifX5hBNLGmQCZfZR3C6nomf
	 lCMx4AD8QyacoxY5pO7CSsFqsztubleScWfCjYVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/181] net: hisilicon: hix5hd2_gmac: remove redundant NAPI delete
Date: Mon, 17 Aug 2026 15:32:00 +0200
Message-ID: <20260817132536.410594873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1a972b093a424..cc1d04d05e4b3 100644
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



