Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82680472F73;
	Tue, 13 Oct 2026 12:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894684; cv=none; b=AuWlh22O9St/jTRxMEYXWPVz1W55N8gxJEsRG0D3/jh8lTF2/2FfDzVOa0pFxKErNfKTuDQSZZm4Nq/rtF7zXyfGKCYx0sQHKYRQw1nEfIjJadpf9p6lrCYyRyvu25y7UqvMEHaIj0AAQaiYjO+BftfTqMDgnw9GUUXy1mIE7mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894684; c=relaxed/simple;
	bh=c+lCn5IIcboraERBkeGBNuPx6IY11AFCq15rM3qb82o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNMxUmN9LRVAa0slI+JIGRHHT+5kGXVYDrAPhNxNMBQ/AKAHtfIs2xaoR1hdahEvOJ8aJOSg65E5GqcjYemRCRfS6XSrYGxk2C1eA1nTn1KXyedVqiTqylSFQqH5bNho+E/5CBt22GLWsM4Jnu35BiwKOs+ezYE0iEZz8QHMPKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cubTYWFW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cubTYWFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895A31F000FF;
	Tue, 13 Oct 2026 12:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894683;
	bh=IhaaLNNfcF84ZA+xas0deQsge5JMxBm2VH9HE/b2C2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cubTYWFWu+Jxn0QNWnQ8c/2dxQ1x+3wWpAkxv/SzHdB9p3ywXPaK9BCtX9oVMjWad
	 ZEs+cAcPOkhb0Uwr5TZ600bdJTnGYTnmpxP2pttiCS3Bm2PlLxSVzxJTW3fDi9HNXw
	 B6iWHm6PV4yqLqc4CwdW/nqsqr6s8R0lCLczeWtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/497] neighbour: Skip default parms when resumed in neightbl_dump_info().
Date: Tue, 13 Oct 2026 13:33:08 +0200
Message-ID: <20261013112908.386703471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 979aabdad8dd03394467ee484a1a70f3d40b19ba ]

neightbl_dump_info() calls neightbl_fill_info() in each loop
to render the default parms.

If there are many devices and neightbl_fill_param_info() failed,
neightbl_fill_info() is called again when the dump resumes:

  # ynl --family rt-neigh --dump getneightbl --output-json |
    jq '.[] | {name: .name, ifindex: .parms.ifindex}'
  ...
  {
    "name": "ndisc_cache",
    "ifindex": null
  }
  ...
  {
    "name": "ndisc_cache",
    "ifindex": 6
  }
  {
    "name": "ndisc_cache",
    "ifindex": null
  }
  {
    "name": "ndisc_cache",
    "ifindex": 5
  }

Let's skip neightbl_fill_info() if it is already called in
neightbl_dump_info().

Note that we cannot use !neigh_skip instead of !default_skip
because default_skip == 1 && neigh_skip == 0 could be true
if the first neightbl_fill_param_info() fails.

Also, nidx must be cleared at the end of each table loop;
otherwise, if neightbl_fill_info() for a subsequent table
fails, the leftover nidx from the previous table would be
saved in cb->args[1], resulting in erroneously skipping parms
of the subsequent table in the next dump.

Fixes: c7fb64db001f ("[NETLINK]: Neighbour table configuration and statistics via rtnetlink")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260909233143.2401847-5-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index bf07438d6dfa5..172974574f18f 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2517,9 +2517,10 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nlmsghdr *nlh = cb->nlh;
 	struct net *net = sock_net(skb->sk);
+	int default_skip = cb->args[2];
+	int neigh_skip = cb->args[1];
 	int family, tidx, nidx = 0;
 	int tbl_skip = cb->args[0];
-	int neigh_skip = cb->args[1];
 	struct neigh_table *tbl;
 
 	if (cb->strict_check) {
@@ -2541,12 +2542,14 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 		if (tidx < tbl_skip || (family && tbl->family != family))
 			continue;
 
-		if (neightbl_fill_info(skb, tbl, NETLINK_CB(cb->skb).portid,
+		if (!default_skip &&
+		    neightbl_fill_info(skb, tbl, NETLINK_CB(cb->skb).portid,
 				       nlh->nlmsg_seq, RTM_NEWNEIGHTBL,
 				       NLM_F_MULTI) < 0)
 			break;
 
-		nidx = 0;
+		default_skip = 1;
+
 		p = list_next_entry(&tbl->parms, list);
 		list_for_each_entry_from(p, &tbl->parms_list, list) {
 			if (!net_eq(neigh_parms_net(p), net))
@@ -2566,10 +2569,13 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 		}
 
 		neigh_skip = 0;
+		nidx = 0;
+		default_skip = 0;
 	}
 out:
 	cb->args[0] = tidx;
 	cb->args[1] = nidx;
+	cb->args[2] = default_skip;
 
 	return skb->len;
 }
-- 
2.53.0



