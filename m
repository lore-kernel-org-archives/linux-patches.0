Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC03A8801;
	Tue, 30 Apr 2024 11:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475976; cv=none; b=pAD/lXUKK7nFZHnzNwsZqFiY7RhsW0m6t6wIcJgVDOHL9j4cpFT2U4PczEtrV0u8S+8gqMRAno5kMl3iMhd0P3ReynnZYIcsh4AjKTXRhOnJLrsGU7T1Lv/uXiaQ/O41NYebHWuGM/7Shqf/TDWnfAQdQWYxS4ZWwh/JWowI/ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475976; c=relaxed/simple;
	bh=1xo8Q7ZVa1c/IZVP6TdILx6HiV90yNyi4/B2ZNRJBe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9xQ+CZvOH6sZGIQ4pqTVcW315fBrZK9FiqFvgO2KssoHrVCA0f75xzpnRdBxX4srRb/x667aYG2juwdc3bpduJKD+XbTeAYaZZx3eggxElLwSlARb30An+GTi0WARRcqah5ZZVBOos5RKo7bi1EKd4U5rDZqtky4M1I0I1W1cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKylsNjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKylsNjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416A6C2BBFC;
	Tue, 30 Apr 2024 11:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475976;
	bh=1xo8Q7ZVa1c/IZVP6TdILx6HiV90yNyi4/B2ZNRJBe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKylsNjCF59grvcF/j9fFqGaIg4nOQLDxJd0gULqAC8stj1KO/M4qX3NKRFz9DtMo
	 adCI7pwimBQzW9j4+kMVjVkrdWYlG8WiSa3Bk7SGCjFnZNMdcO6II1WYGuSewuT5Pz
	 CmTx5cguJ5S4pkouT150Ppu8B+p8aoq7H7JNAv8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/80] net: gtp: Fix Use-After-Free in gtp_dellink
Date: Tue, 30 Apr 2024 12:39:59 +0200
Message-ID: <20240430103044.217964054@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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
index ce93316f5f116..3271428e64b8c 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -713,11 +713,12 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
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



