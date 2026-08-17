Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5713D43C7DF;
	Mon, 17 Aug 2026 14:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976285; cv=none; b=gnTxXXU2m0aCcZi64SFUWx+qcO9YwdncqQsSWj/Fm9VElA/3ILM0HacTjAW36Ss0iWRb41vAdL3vyOkdXuUdFkIQxSQkiqmcXd+EoMXbwdkTzDfONrZCZ8+MnnvtfjgR4oADupldJW/NmAIQPBPra/RSSxg0n2XXGW8G6QKrYfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976285; c=relaxed/simple;
	bh=qpjJqmuHGPmWaMqqsDDjHAWK5cI5yPcdh/UlGpTqEG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0Yvya2KSUGFRSMN/ainkPF3Tt4f6Hp/KPf9w62zjTCaJD8kznrXoiXnjzQkVonvSKYVwPhzG2QpeMmyEdfuz3OEn06ykRMpnBqtt96ccRxiBX2iPPYHCdvFADCmar2+kmfpTaiMxFYW6mmwQn+zxJZ6sdU2Cs2ciws87Tb1bzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s64RjnlJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s64RjnlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7FD1F000E9;
	Mon, 17 Aug 2026 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976284;
	bh=JEpJY6Mc6VO2AGrgyfhEclbex3oucXzO3DujbgF+zfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s64RjnlJpcVfPhmheLnPlM9vhBkFX49oHhX3YI828Oi+P3MGSso0hJPQKy7yQPC4V
	 d4BKvrztHx/o8iSBEoz8o+PZrgppAOTav8ZDucyeOnJqL4SynJTEg6j/BxjEh4+fqu
	 QMx2INRdsjKC/DYkiEbltbLjZ78AFsfFZjiwpX/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 318/389] net: hisilicon: hix5hd2_gmac: remove redundant NAPI delete
Date: Mon, 17 Aug 2026 15:32:37 +0200
Message-ID: <20260817132551.363651152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 43f3146caf07e..18495d80e2e74 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1291,7 +1291,6 @@ static int hix5hd2_dev_remove(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct hix5hd2_priv *priv = netdev_priv(ndev);
 
-	netif_napi_del(&priv->napi);
 	unregister_netdev(ndev);
 	mdiobus_unregister(priv->bus);
 	mdiobus_free(priv->bus);
-- 
2.53.0



