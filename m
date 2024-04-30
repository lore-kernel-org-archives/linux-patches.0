Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA1D17592;
	Tue, 30 Apr 2024 11:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476461; cv=none; b=Q1DQktP4kopZysPWr9Bv1VaTqzpbThJl9RxpPiCmy7YVQTaJEC6bbE+HGRrU0pNkRrtl4tC/n9qPfZNSy0Xld4R3f9/HmKAyEjY1E4IiR3Bji59IhQm2VvhtrS8jSxqEba7q6ImeH50ll+lUHbzEjP5ZIBzwdt2K7wFgdYaPNVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476461; c=relaxed/simple;
	bh=Yr9paaAySumC4hTejCvu+xO4Mq+qKDpPsIga0E87Vhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIBgTVga1+6OObmI+ApwA7IjQWPcMyZR61q6oHp0CpdQJ7TPgOHWyA3HZi3Ki4KnR+sql71Ofody546Rh30O9A+8I+MZUSw3GEIBw0/yiOhT2YhXSBgzRXs5IDUAHXrtDkh0GZwJehTF2sjLwjCZRLKS2je+IPUzOeWvZULXzKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvMpbV71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvMpbV71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FC2C2BBFC;
	Tue, 30 Apr 2024 11:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476461;
	bh=Yr9paaAySumC4hTejCvu+xO4Mq+qKDpPsIga0E87Vhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvMpbV71i5bNJR9bC5iaUM6qLNgZ88fT2J8jMcFjJHzTStkbW9OHLPLXCOsn6k/X/
	 9pmzsAMezJqoTbZ78lbPJlL3onLtG1GRI1NEsdn4V/jhOFFaYpsw9gEGNesxgyGfU0
	 0FTNZXUHPz092X03Vv5lnguryPOh2I9ALYWbCEFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/110] net: gtp: Fix Use-After-Free in gtp_dellink
Date: Tue, 30 Apr 2024 12:40:07 +0200
Message-ID: <20240430103048.692252642@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7086acfed5b90..05b5914d83582 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1110,11 +1110,12 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
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
 
 	list_del_rcu(&gtp->list);
-- 
2.43.0



