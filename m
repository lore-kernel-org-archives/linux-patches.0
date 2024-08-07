Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CF784E0D;
	Wed,  7 Aug 2024 15:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042994; cv=none; b=tEM7glHoQPZB/Z9MkzGBVsiyjQbiaosd12/TEXupPGm/8EuZgj3ZaaPqJpd61dK0JIlmMYZfwgrQWqJLtDDIl6n1AznBBr94BIe8bG78UE0pHY6aBdxJas6U0fjWBNXbDxI5dDYCCYpbFGd9J6wJedtz/99+DwrxwnPHr31qcLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042994; c=relaxed/simple;
	bh=POFyRQERIHvV7zn4OugzFyNpFASwn6Zr5cEF+Abt1nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3CEJaQRhw3c/DUobnZErSWi+ibNeaO1/1VMR5KNFR08qNpUf8Oi4AahagQPvc2oQDGSfKQtWcW1bGdNVTukpgR9hfirV3vchdk8Lo05b1OBAiGHD02DXzCMLZAKf9goRva6cfsLxnjZiw6xjHyfvN5y2tBS8W5OLRPnSwuJKnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rr6vH3BJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rr6vH3BJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12100C32781;
	Wed,  7 Aug 2024 15:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042994;
	bh=POFyRQERIHvV7zn4OugzFyNpFASwn6Zr5cEF+Abt1nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rr6vH3BJ+7+FToMQu8bmYHmMyM5ca0cUi4HetrpWvsa/DTHyoWN3XrpD8a1SQ1GcJ
	 QtbTeq6tkMaIsa/f8bPJaRQBaoYirPHtqzcLeZk2Z83F6BxCjqsb6l1L72hZH1mu0q
	 MdSFt9Qs3jPaM/m8H8znyDa5ot1CFw2weDD4GuSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 051/123] net: mvpp2: Dont re-use loop iterator
Date: Wed,  7 Aug 2024 16:59:30 +0200
Message-ID: <20240807150022.473125052@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 0aa3ca956c46d849775eae1816cef8fe4bc8b50e ]

This function has a nested loop.  The problem is that both the inside
and outside loop use the same variable as an iterator.  I found this
via static analysis so I'm not sure the impact.  It could be that it
loops forever or, more likely, the loop exits early.

Fixes: 3a616b92a9d1 ("net: mvpp2: Add TX flow control support for jumbo frames")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/eaa8f403-7779-4d81-973d-a9ecddc0bf6f@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9adf4301c9b1d..a40b631188866 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -953,13 +953,13 @@ static void mvpp2_bm_pool_update_fc(struct mvpp2_port *port,
 static void mvpp2_bm_pool_update_priv_fc(struct mvpp2 *priv, bool en)
 {
 	struct mvpp2_port *port;
-	int i;
+	int i, j;
 
 	for (i = 0; i < priv->port_count; i++) {
 		port = priv->port_list[i];
 		if (port->priv->percpu_pools) {
-			for (i = 0; i < port->nrxqs; i++)
-				mvpp2_bm_pool_update_fc(port, &port->priv->bm_pools[i],
+			for (j = 0; j < port->nrxqs; j++)
+				mvpp2_bm_pool_update_fc(port, &port->priv->bm_pools[j],
 							port->tx_fc & en);
 		} else {
 			mvpp2_bm_pool_update_fc(port, port->pool_long, port->tx_fc & en);
-- 
2.43.0



