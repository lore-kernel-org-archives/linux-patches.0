Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CFC51A720;
	Wed, 30 Sep 2026 17:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788372; cv=none; b=k75tBI5KBRlnprfpkPE93+1tDUyCDrSjpNZxJrl5+d8ato0GipAyN1pvkcVq8vzcKox17KijCiMmfsAKcrgXhuPeAQiWeKgp7gxSfLNlmXBlpchjJ0GE0qmm44XEacQm1VBeA9E7DMuZ0qQxJ9DvwAxIXQaQAZbU48B+e+TSc0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788372; c=relaxed/simple;
	bh=XINgnQesrEP4S3ritUtXmE6oS7bPAO6f+iqhFSpeztk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=or8OeGf/t87RppZBwPfbN4QVJDisED+t64bvrKh/c8q/2DKY4e7nYiC8gGEFdrF9Gksk0+Kr1Y4wXiL0uLf68CL2VLfvhZM5F5cfsG4vEKB0LgAiE4cKBSnn25rBD5XpotZHHJENCaXc6F6lpF8bZNzhcM1N4IhGShIuDX3ee5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jpyxepw2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jpyxepw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA3C1F00899;
	Wed, 30 Sep 2026 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788371;
	bh=pUOdk7z/7Cao1fuq0GGCT354BTFe7gbrITeTrBorR70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jpyxepw2rhyS+xYrqa+0BYV5JIfTwsUNJ6lfoh42MBybPNdJTi3+xpDSqvS2JKhJ5
	 cYgWJa2Z4/Ko+065iIN4clcL793ZJ9AoSl1YmT9qTeE+43xTTnEhdXXT6uRtRMI495
	 jgw5sLy/4J3/IUuIR6++b+cxpvpwkx5WdImiU4nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/877] neighbour: Skip default parms when resumed in neightbl_dump_info().
Date: Wed, 30 Sep 2026 17:16:51 +0200
Message-ID: <20260930152416.896195190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
 net/core/neighbour.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index c9d848085dad3..99822878262c7 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2507,9 +2507,10 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -2533,12 +2534,13 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
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
 
 		list_for_each_entry_rcu(p, &tbl->parms_list, list) {
 			if (!net_eq(neigh_parms_net(p), net))
@@ -2561,12 +2563,15 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 		}
 
 		neigh_skip = 0;
+		nidx = 0;
+		default_skip = 0;
 	}
 out:
 	rcu_read_unlock();
 
 	cb->args[0] = tidx;
 	cb->args[1] = nidx;
+	cb->args[2] = default_skip;
 
 	return skb->len;
 }
-- 
2.53.0



