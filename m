Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B314B165F16;
	Wed,  5 Feb 2025 15:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768328; cv=none; b=r7SY6MDY0zOuVtycXKXHioAtlqO1+zK54ZzGO9oezUN58a9b+rC2qrkwVmnhLa/dc1fCwWXMWlHzJFgjt1mvfotLvNdcEoIhgLGsTc7qHOR0uGB8ejEaR6yFMNAqUDnQ/GMi7WfK818tWOaaDEbdBG2IobdAmTxSirElTeKtFuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768328; c=relaxed/simple;
	bh=jfTFVhK6OsiuDfeFTrHnHx+zXWcKWMUsZ1rKGWZOQPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uqOW7zn659FOwhivz6y/76WSRV3h6uojKuM+GTKcvciyuLtRfFe5ZI9V3whYFywHs8MGvcdpjk2c4/pkkDGifhd1dNbJ94mte4ginhevEExaXqCF84qwSQiEU+V2B11SiBQvvy1VzDQ1MVvJop4gUMd+vmfnMhYF9pGCZRVnyyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10my7jU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10my7jU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E02C4CEDD;
	Wed,  5 Feb 2025 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768328;
	bh=jfTFVhK6OsiuDfeFTrHnHx+zXWcKWMUsZ1rKGWZOQPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10my7jU99XSkd6gjOYN8DFzZawaqUpM8S5QR5LYbdZaxiE4z/UlwGuj5f7RlDuVRP
	 042L68vy130ZwFMMC/eEPsuSIuA4JCu5PNQSHagwSoKp7ZaUFTu8l1XyOEcEaPqqvd
	 piAwCHny7PYw8U2FYO8U1RFVwXxYlr6GhwUwtB5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 531/623] net: davicom: fix UAF in dm9000_drv_remove
Date: Wed,  5 Feb 2025 14:44:33 +0100
Message-ID: <20250205134516.541631269@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 8735e333034cf..b87eaf0c250ce 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1777,10 +1777,11 @@ static void dm9000_drv_remove(struct platform_device *pdev)
 
 	unregister_netdev(ndev);
 	dm9000_release_board(pdev, dm);
-	free_netdev(ndev);		/* free device structure */
 	if (dm->power_supply)
 		regulator_disable(dm->power_supply);
 
+	free_netdev(ndev);		/* free device structure */
+
 	dev_dbg(&pdev->dev, "released and freed device\n");
 }
 
-- 
2.39.5



