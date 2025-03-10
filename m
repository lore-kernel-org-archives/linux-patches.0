Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36DA17CA12;
	Mon, 10 Mar 2025 17:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629075; cv=none; b=aI+D3U9VjO3wG8I1PnPfVbKS11z0X6Dtdjniw/RZ1h9w1Qk3KzaBpvG51BXAiW1VHt2Oxv0zs6Cyh8b+AOThH6E8+cuEl2+wuB6xiThLClN9pbyAzP1ntIRGdFgCVO5jSekielNCKDKZZgVjCydVTOTBrCYnMvHRgWrN2l/pYvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629075; c=relaxed/simple;
	bh=yp1H4xE5wd9Q4nl0vasT7rlW+XN6Jg5nyInLcUcX7m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KWIpc0yyR0kTzMwC81dkvRpwqGAxbC4xC6G7PwsFPDLjKf4MtPnYks8M8XKZJbI68OeiWEMQdsXz1x9dVQvtUrpQvqW9pmHmr9ToabI7EBePMmcziGK+9sygobK5K0mE4/VelnzH9L9bfKU4/Jm6BprCIrcAMBQHja5kWqrJo8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t56sZfPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t56sZfPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76386C4CEE5;
	Mon, 10 Mar 2025 17:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629074;
	bh=yp1H4xE5wd9Q4nl0vasT7rlW+XN6Jg5nyInLcUcX7m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t56sZfPASiVKjMXOHdwuSG+tmF+/IZ47ZR7/OZ40Fb9jz6Fxe5lG8X7zmnYHpjLX+
	 eNiaQOdk/gQjuF3efwJ5LihyIJVU116krDSCxRPsYW10+zoHzEqdgBnmJukKyzRDFq
	 +08AgBqre7TQmuLMsWSTBLJqQYiUoFltel2tCjlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 168/620] net: davicom: fix UAF in dm9000_drv_remove
Date: Mon, 10 Mar 2025 18:00:14 +0100
Message-ID: <20250310170552.252938758@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 19e65c45a1507a1a2926649d2db3583ed9d55fd9 ]

dm is netdev private data and it cannot be
used after free_netdev() call. Using dm after free_netdev()
can cause UAF bug. Fix it by moving free_netdev() at the end of the
function.

This is similar to the issue fixed in commit
ad297cd2db89 ("net: qcom/emac: fix UAF in emac_remove").

This bug is detected by our static analysis tool.

Fixes: cf9e60aa69ae ("net: davicom: Fix regulator not turned off on driver removal")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
CC: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20250123214213.623518-1-chenyuan0y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/davicom/dm9000.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index e842de6f66356..afa92b44c8ebb 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1773,10 +1773,11 @@ dm9000_drv_remove(struct platform_device *pdev)
 
 	unregister_netdev(ndev);
 	dm9000_release_board(pdev, dm);
-	free_netdev(ndev);		/* free device structure */
 	if (dm->power_supply)
 		regulator_disable(dm->power_supply);
 
+	free_netdev(ndev);		/* free device structure */
+
 	dev_dbg(&pdev->dev, "released and freed device\n");
 	return 0;
 }
-- 
2.39.5



