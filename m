Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD12E7C090;
	Mon, 15 Apr 2024 14:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191580; cv=none; b=tOnu6fbxkcxmvtiCVMYiaVXluEm1msS5uIrSvJmjl4Vru9TKJxqGILNgIX3OoKMYz7iRSki2Gj7ni6h+EJsQCsqhscvL8NJd7qwkaFEEum6mpgFUIWZNyVTXDXrCXWLuCAAvOyJcIonY4H1JYJdMy3xD6L1Ba1DYaW+2A2iPq+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191580; c=relaxed/simple;
	bh=Ofc+4T01ljAuWJJhPNtncMQokBRVkp4vABoAzS+H9hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3/a7jtjzjwhDw0vwJgw+LG2RAmXGPRUrvKVnTOCskWlY/e7qDnSrU9Eb8TCNAeQoND0iFdjSasCzwPoYBRw22FFDghcHgWO8UJ3blz91iLeApFSkbOwmQlWUHlgPuaiGDaObkomr1rBnadCmTxc7RYP3kV/x/kH4toLhOzHLxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zl3/VadR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zl3/VadR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC4BC113CC;
	Mon, 15 Apr 2024 14:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191580;
	bh=Ofc+4T01ljAuWJJhPNtncMQokBRVkp4vABoAzS+H9hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zl3/VadRbKiboPEZIDf2fnUk+uzrXvFCM1Bej/+8PakVJiiGAqOQwQi/rm5w2kk76
	 iLoLvFimYqXXm1ydQZyknr1RcrIBgiEojPsr9KLedkMjUe+7fF5WVEf9j0/ylIqmyh
	 FZjHu0+MzrzNPK7M3R5VMrLFTysq0JSvEe0Jgcvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/122] mmc: omap: fix deferred probe
Date: Mon, 15 Apr 2024 16:19:43 +0200
Message-ID: <20240415141953.921862439@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit f6862c7f156d04f81c38467e1c304b7e9517e810 ]

After a deferred probe, GPIO descriptor lookup will fail with EBUSY. Fix by
using managed descriptors.

Fixes: e519f0bb64ef ("ARM/mmc: Convert old mmci-omap to GPIO descriptors")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Message-ID: <20240223181439.1099750-5-aaro.koskinen@iki.fi>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/omap.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index aa40e1a9dc29e..50408771ae01c 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1259,18 +1259,18 @@ static int mmc_omap_new_slot(struct mmc_omap_host *host, int id)
 	slot->pdata = &host->pdata->slots[id];
 
 	/* Check for some optional GPIO controls */
-	slot->vsd = gpiod_get_index_optional(host->dev, "vsd",
-					     id, GPIOD_OUT_LOW);
+	slot->vsd = devm_gpiod_get_index_optional(host->dev, "vsd",
+						  id, GPIOD_OUT_LOW);
 	if (IS_ERR(slot->vsd))
 		return dev_err_probe(host->dev, PTR_ERR(slot->vsd),
 				     "error looking up VSD GPIO\n");
-	slot->vio = gpiod_get_index_optional(host->dev, "vio",
-					     id, GPIOD_OUT_LOW);
+	slot->vio = devm_gpiod_get_index_optional(host->dev, "vio",
+						  id, GPIOD_OUT_LOW);
 	if (IS_ERR(slot->vio))
 		return dev_err_probe(host->dev, PTR_ERR(slot->vio),
 				     "error looking up VIO GPIO\n");
-	slot->cover = gpiod_get_index_optional(host->dev, "cover",
-						id, GPIOD_IN);
+	slot->cover = devm_gpiod_get_index_optional(host->dev, "cover",
+						    id, GPIOD_IN);
 	if (IS_ERR(slot->cover))
 		return dev_err_probe(host->dev, PTR_ERR(slot->cover),
 				     "error looking up cover switch GPIO\n");
@@ -1402,8 +1402,8 @@ static int mmc_omap_probe(struct platform_device *pdev)
 	host->dev = &pdev->dev;
 	platform_set_drvdata(pdev, host);
 
-	host->slot_switch = gpiod_get_optional(host->dev, "switch",
-					       GPIOD_OUT_LOW);
+	host->slot_switch = devm_gpiod_get_optional(host->dev, "switch",
+						    GPIOD_OUT_LOW);
 	if (IS_ERR(host->slot_switch))
 		return dev_err_probe(host->dev, PTR_ERR(host->slot_switch),
 				     "error looking up slot switch GPIO\n");
-- 
2.43.0



