Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FF378C67;
	Wed,  7 Aug 2024 15:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043397; cv=none; b=O1BCPDUjUcvzntxEvDyiDiqxWKZuVOXrK4dOZpGQhxAoXpXV+utEiBuvKGvCftncLxC/mBMH7rLFQV4hg3sQotlz/MNg3Wfga9IKw2i3HwnjMi152KfnwXb/PHg7y+oUnv8CoSQ8KL60zWIcjgbd62TDf2j7xAhHNmKPpl5PJ9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043397; c=relaxed/simple;
	bh=AdGQAX7s+s0RpEL5LYiU7EF+/lzLvG2x+UnKkJfTUPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5Ru76T55msCRPvN55AtWOeksCNP4mckrWfIsoCGLGuSjGJ3izIwCF/7JpBoK7QSTGkZGgCPSl78paWr+aiOq2nYjkay5b+YQgiqNHNcHT+7BddzNqrkpsrqDuyIRCWaWfWS5ut2hNftQnYinQpYgZNTpehpOXwrkrZ2Lk3TT9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gm7ZyTcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gm7ZyTcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855FEC32781;
	Wed,  7 Aug 2024 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043396;
	bh=AdGQAX7s+s0RpEL5LYiU7EF+/lzLvG2x+UnKkJfTUPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gm7ZyTcUTdiC1CB3gvOuuMoTKn61IhnT8dC1wvt6tD91NIQWvPhn0SJc21EeiRU8m
	 aQrVUbDZQaJ8m3y/I66ovuDomjJVyQiuGSsZdXzWbUFC2X98uDQfxLhTXzh2rsQurs
	 TH9MEueY6xMNVrhZYEgPMpUSfDRgQIT45X8fuUA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/121] net: mvpp2: Dont re-use loop iterator
Date: Wed,  7 Aug 2024 17:00:07 +0200
Message-ID: <20240807150021.864385815@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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
index 05f4aa11b95c3..34051c9abd97d 100644
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



