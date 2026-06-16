Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E5615B998;
	Tue, 16 Jun 2026 15:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625227; cv=none; b=jYeimlns/5yXAyqi1cWFjlVzh6K3CT16cpd+Npz6B7UIBly5lq+PV65154tWXVzaEcPHxI2UyK9YlxRwtEZB49vGKs+ooTU+XFghs9+CTU/Rzlf5xGQFBbWh3mWfopnnE9lGfFP9K3SKaPrqxO7pwNZSnQd925uNG5oUHnsUd7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625227; c=relaxed/simple;
	bh=mmhSyT9B0K/4jesvNcwiU0AjFowx+jQsm5bIiJ72GjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHsZcLG4WloasOraOom5eDWvKQlf0DSOPLi3yi/6OrGeH9IZEpAq1Aik/vQru2TNof4KkgDT4qicoUp4z4WUt18X3HKcH8QPbur6ALwlgxcWORE3hs/pBk4QoHpKVSzynIbolXkXiNpBvYaW+aIITJ9gY97cJ4Aydqrv6k4zQ8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/NTg9ir; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/NTg9ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1D61F000E9;
	Tue, 16 Jun 2026 15:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625226;
	bh=+AkGkdYFZfZn4lu6Yg1GjENKnSbUzoUPqASd8ilc3cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/NTg9irS2DX5NoxLXGv6DwEn+6ztg3uq5U9gkmhfFgvepHUnT50GIfjaeRx4GOfE
	 gMtYgeSfnexIryNqAE6zKZrJ9wh18eMAYGrWV4z8aKsgwfVkj5Z0RR4LHWnhLFGJGK
	 CWGQPzCGP2SZmnDBNbT03g3au/4A+1ZtO2xuSzrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/325] netdev: fix double-free in netdev_nl_bind_rx_doit()
Date: Tue, 16 Jun 2026 20:28:17 +0530
Message-ID: <20260616145102.720293767@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c849de7d8757a7af801fc4a4058f71d481d367f2 ]

Sashiko flags that genlmsg_reply() always consumes the skb.
The error path calls nlmsg_free(rsp) so we can't jump directly
to it. Let's not unbind, just propagate the error to the user.
This is the typical way of handling genlmsg_reply() failures.
They shouldn't happen unless user does something silly like
calling the kernel with an already-full rcvbuf.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 170aafe35cb9 ("netdev: support binding dma-buf to netdevice")
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 470fabbeacd9bd..93ea09bd1e7bab 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -1019,8 +1019,6 @@ int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info)
 	genlmsg_end(rsp, hdr);
 
 	err = genlmsg_reply(rsp, info);
-	if (err)
-		goto err_unbind;
 
 	bitmap_free(rxq_bitmap);
 
@@ -1028,7 +1026,7 @@ int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info)
 
 	mutex_unlock(&priv->lock);
 
-	return 0;
+	return err < 0 ? err : 0;
 
 err_unbind:
 	net_devmem_unbind_dmabuf(binding);
-- 
2.53.0



