Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21897DA7D;
	Thu, 15 Aug 2024 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730300; cv=none; b=N5Ii0EAKT9i5dHp9zHrC3ABGzlO8k/Nj47+smEp/rqgBGGPCrh0oOxw2F0DbFRB7t+ZKmcmuVqdR4Ld3XseN6/On9lPeDpFHz19FxiJw25C5DFwl7s94/pbVTds+fQsNe2sPjhniqkTz9rUBuazbeAyKF4IcITZxfnr+UAZPy+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730300; c=relaxed/simple;
	bh=IEbPbYbr+00EaTj+UIVOgrHuuUmpTrkapmZZ9qiLHEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6bOMOvTyQ7hR8am5qKiBJbJUhc+H3fx935Ds7yz5aU+A0jSNUKL5u33zonSdZxbGVtXJXIuDHQ75nE65epPhfWRbXeYVdv1GX7EKuShJWy+xz3YzYOVxbeor2GQDhNq1rFiuY+tIZy3Z/Yp6EY5tmhwvBluKipF/xwBW+5n5jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8Dk+E0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8Dk+E0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AD3C4AF0A;
	Thu, 15 Aug 2024 13:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730300;
	bh=IEbPbYbr+00EaTj+UIVOgrHuuUmpTrkapmZZ9qiLHEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8Dk+E0Sq1l66dgxq96cOJqLrNQPTR7KNhsPEB3fURsbVLOOOeTZ5WC45IRKRU+pI
	 +UywUgQIRibqfYO6IMFlYO01eCGxNnxQVbWgk/jpTQnDirtyXtmtf3tJ8ZmUgC/n4Y
	 CnQwXuzbJZ9XlLWNJVPwRwGJBKYqh+Pjg0PEJ6WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 335/484] net: mvpp2: Dont re-use loop iterator
Date: Thu, 15 Aug 2024 15:23:13 +0200
Message-ID: <20240815131954.351099259@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ba44d1d9cfcd4..2a60f949d9532 100644
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



