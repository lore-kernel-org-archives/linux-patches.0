Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4614312D1FA;
	Tue, 30 Apr 2024 10:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473821; cv=none; b=GijeOAjHk7JEyOyT/FwbZLbyT1QYmR9wCHBsgE2jxlBwk71pYRw7wXOA45Yt4YvrEfDoVrdEGH3O4Ckw/B47hLD3615MPIJFiOjHuzjeEa0DheBWHDWT3C3Fy6MzsOxTqervh9kqw+l7Y+OE0CjGec6Y6HpuZc9lkP0gwh/ZY+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473821; c=relaxed/simple;
	bh=JJ2vZVqSsrt7qBTrfObPyOyugrLLK4xKJTcKds0i1vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eyk+2BqSbiXul4DjlLiiff5TjVm3BtcLUF5rsajJLna4Xpz6FNoVZZXQnRK/mGPHGbN3TM6SWgVG/tOWsgLR/uQy8txm1HRsUQ1MjPoAjYlt6sbCGCL4d3g/N6ZLeyuboFJ9Op9Y0caneGDX8SVMczR/aKxGNIUWyiK033tQKxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FwDW1Vh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FwDW1Vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DADC4AF19;
	Tue, 30 Apr 2024 10:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473820;
	bh=JJ2vZVqSsrt7qBTrfObPyOyugrLLK4xKJTcKds0i1vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FwDW1VhQ13d2d5mii0uPxnmhCcK8roDRMKi05bcd/sHjmxMCcmXmfqnBSi/aLpxF
	 RvyPrOcq4xA/6ooUa9I7Nmhnq6Z0C7uD5WCTXqW5KVTXvFznZJOkxOCcqwugoEGS/E
	 BwWshGKbDWF8ph3CkeE6+NObir5+ntb5YMCYBs7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/77] net: gtp: Fix Use-After-Free in gtp_dellink
Date: Tue, 30 Apr 2024 12:39:27 +0200
Message-ID: <20240430103042.554025478@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <v4bel@theori.io>

[ Upstream commit f2a904107ee2b647bb7794a1a82b67740d7c8a64 ]

Since call_rcu, which is called in the hlist_for_each_entry_rcu traversal
of gtp_dellink, is not part of the RCU read critical section, it
is possible that the RCU grace period will pass during the traversal and
the key will be free.

To prevent this, it should be changed to hlist_for_each_entry_safe.

Fixes: 94dc550a5062 ("gtp: fix an use-after-free in ipv4_pdp_find()")
Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 3f4e20a9ce9a1..db97f2fa203cf 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -710,11 +710,12 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 static void gtp_dellink(struct net_device *dev, struct list_head *head)
 {
 	struct gtp_dev *gtp = netdev_priv(dev);
+	struct hlist_node *next;
 	struct pdp_ctx *pctx;
 	int i;
 
 	for (i = 0; i < gtp->hash_size; i++)
-		hlist_for_each_entry_rcu(pctx, &gtp->tid_hash[i], hlist_tid)
+		hlist_for_each_entry_safe(pctx, next, &gtp->tid_hash[i], hlist_tid)
 			pdp_context_delete(pctx);
 
 	gtp_encap_disable(gtp);
-- 
2.43.0



