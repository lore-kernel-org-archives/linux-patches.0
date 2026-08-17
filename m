Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDF42F0C48;
	Mon, 17 Aug 2026 14:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977572; cv=none; b=Ml3otXaD1O+zbCVQbAKO9CJanKsR4zLxUnAgNbv5qMAhmzQbKChXlOVlAAKQJhygoumgDwXjsC8icK9b/uVhqD65ypMbgzFJAWPojZ7txmYNyijXpNkYn0+VVMVjKJ+O9Uz3ELLb6Q/JMBnQ8OIYbdTxUG6cr33/YvBSuAYzXuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977572; c=relaxed/simple;
	bh=bd+zAwpf7eeL3zax5mCuCsOO7FqWJhsrgD4KmZAIL7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmEuCRnvV7phGhBzhDXVJYuUjVVnL9akv1H5L1/mLgQjbgfwTiONdo9viZp/EhGS7N5YwHhaQ088sgaYPAp+2kqr6Tjnv745KeRRu4+Giy0H3pdjW4NrG1tpVpAe5c07RdBkbcH4hVS+vcmvJPrgK5brUe4h9U6HJsIwf6YDnmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0DsZjOPJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0DsZjOPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EDD1F00A3F;
	Mon, 17 Aug 2026 14:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977570;
	bh=GIZrQ4+tiaKkkRvJjnCcXWYE40bUQEryxo1KmqeGhD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0DsZjOPJC4czBeOSMUUBUir/1z2QiFCGkOCobtpLXLYFUwWN7FqTVlwj1GAl3mXj9
	 7J7vTR0mIWbGBOsuccvtTu6a+v7o9+pYfhFxwj+aA0P1KxkXcASDAi1Ai8VSLTQHn9
	 TExLL7BPLZcjwaV51449KQIZ/0xgDr/IYn8Fxbww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 375/456] net: hisilicon: hix5hd2_gmac: remove redundant NAPI delete
Date: Mon, 17 Aug 2026 15:32:45 +0200
Message-ID: <20260817132554.147875549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b981b6cbe6fff..7ecc3333c8df2 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1288,7 +1288,6 @@ static int hix5hd2_dev_remove(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct hix5hd2_priv *priv = netdev_priv(ndev);
 
-	netif_napi_del(&priv->napi);
 	unregister_netdev(ndev);
 	mdiobus_unregister(priv->bus);
 	mdiobus_free(priv->bus);
-- 
2.53.0



