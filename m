Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5D7379981;
	Wed, 23 Sep 2026 14:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174487; cv=none; b=txpeRrsRjQExaxUBlWnA/V+DVC/e/TPieO9LSLeyiqR5WSimTxc2oHZurvB/QLSEUPRkysLSUFA1iWu69W533BHBkGxwW+1wksmmFrY/fgCHAdsJ/SFxlNpTM/zIM5VndjxEG57dU3KYza3yjnJKc2WTMszsijIghuF2PW0AA+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174487; c=relaxed/simple;
	bh=PBzVP/7BqVBcCtjP6KpJdetDKJPz4c4iU3sWU2ktZtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+jR0s6gnldbEuEyzkktXqZxVyu0wAI6eoaqK507tN0owpUU4fsj5Yu+XzczU7kc0jHmpDxGsglGgc+XM+xBEjNFU7akqvpNxqKdCgVVBCiAgBbT2CUYqFUsxG+05uHLlDHR3KUPWwkxSGFj51IX9+0iSjX4veBPNfec0Ipfl40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQqYJ7IX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQqYJ7IX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7B21F000FF;
	Wed, 23 Sep 2026 14:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174486;
	bh=gtWZojkBN0obPu9uVQTo2O2WT0vpMevS1txYC1E+zzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQqYJ7IXeUqOYHmdV2PSVzrheZ3buI3z2lH6Qkgj/mX9MyH9kkfubpUBVYfcT1u96
	 f6IQ1T5IWKpTxa6NdTuqnt4l5uQ3ix+Y8bh2mWOrzxWhbEVCcD0UhaobqmXEkWna8K
	 1KRovj8f6syp/FgK1px6h5XoGm/C3CLQKhse6BEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/398] neighbour: Skip default parms when resumed in neightbl_dump_info().
Date: Wed, 23 Sep 2026 16:02:57 +0200
Message-ID: <20260923140646.110220974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index d51899b011ddd..862867874e121 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2564,9 +2564,10 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -2590,12 +2591,13 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -2618,12 +2620,15 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
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



