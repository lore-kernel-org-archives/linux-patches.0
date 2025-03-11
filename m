Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B7C25DAFF;
	Tue, 11 Mar 2025 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705530; cv=none; b=hmk3/GPme3y20CSUTUcoT2ipD2hMJViOsh5WN6XGEHl3n7CjaY/jZ0AnETdeuNlRv1wii6r/g+/PBKlx4IKBAGeB51AI+ZmL34LSXB6eJNv8IaIldGi7Z88DkXWVMQgOaKUZH0gieKG3ztH+fBrqafJcoUtmkHqJTdw/upBwaPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705530; c=relaxed/simple;
	bh=G3O1D0gYw+TvdXJgZfDnHBDQaWGGHcYKITEq81szfmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DeXkquB9k5gqAwzyVAy7yhhybHjwjvG9AslPz97HjguV6j5No7kRpLxRCoWn9E/Vjpqp22oq9RsnECfpWdZ3PQ00Jh24FKcyE0k9ikSdxIjAilO9ji05+aqhZ/Jg15WlkcFw1gImlbTKjADMLhYo89534pp2by2WC5ku1Hmy8dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnWiMaHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnWiMaHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F7FC4CEE9;
	Tue, 11 Mar 2025 15:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705529;
	bh=G3O1D0gYw+TvdXJgZfDnHBDQaWGGHcYKITEq81szfmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnWiMaHSI5xU/xWuaMHvIVX/8JiCT3G3mHJ1tfUpvh5lRiXk6dT2NTKzqmAeQH4eu
	 f8/D0flzA8QDKXXwSvaOGQa25AxovgpodMANEcbfCfyzUWwf7gb1HS4FoOUTXQNjF+
	 qNwSZs258x9Mn9iuduSJHaGQfAqdFzaai/ceXp24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/328] net: davicom: fix UAF in dm9000_drv_remove
Date: Tue, 11 Mar 2025 15:57:17 +0100
Message-ID: <20250311145717.557599910@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1d5d8984b49a3..fdf69fe78fbb6 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1781,10 +1781,11 @@ dm9000_drv_remove(struct platform_device *pdev)
 
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



