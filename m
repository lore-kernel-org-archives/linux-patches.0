Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCE951AEC7;
	Wed, 30 Sep 2026 17:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788352; cv=none; b=Yf8iBukyYZV6BQNv7j0Mut4ZmGzqptkV8UODEVTZz8JyHY4i0BUOGQKBPN8ecnDKKkCUtR76NpX2B5XDJbq1IG3ngjSFCNH6PAWrlP/+FMvQHCnVb0qYO+qaGaGzlXGT39H1yZNNtpB30FTt2Rd38FGKy2ZhEQ5vkZKLcEFY7xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788352; c=relaxed/simple;
	bh=mNKOoWw/tdj4fz1ZZ5HI6F9mhujLj1JZT4AFvbtToAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkVYlrHFJdmaY/z2Tvcc4o5kvitbk41LPPnMhG0IzbyjP5RZCQ/apGzSr30t2jkYnBmuacbOuSUnhjjtx7xvYLxql0p2BDnQPKqhyizsIaa57hqaTzCTRvwTxWjmwt/rjJ0io2SpDiniefbvEZNGGgzmOANP2zWjEYtcWJeA5ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y67Tndnu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y67Tndnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C681F000FF;
	Wed, 30 Sep 2026 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788351;
	bh=D3MPa3Rq7vnvs5z1UUVGWkmeo58kOtOQcj14WPrUK1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y67TndnuqJ0LDHHHTp2ddU+RGUSrDMNIEU+rO3jlpmvdyGbsWpTRgKC+f7Budjp6p
	 N/cfgpyfOLG7pFnOY1Y736WiFbAxlmr+usHiZFVK642mBeu7Kur6HR4NtrpcpGzxmv
	 dZeoyt4YQdTA1r1FPWd9gTgvOGPlXGiKK4qVEQjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/877] neighbour: Make neigh_valid_get_req() return ndmsg.
Date: Wed, 30 Sep 2026 17:16:44 +0200
Message-ID: <20260930152416.743139363@linuxfoundation.org>
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

[ Upstream commit caf0a753a8eb7ca2b035e199b71a3dabb853a18a ]

neigh_get() passes 4 local variable pointers to neigh_valid_get_req().

If it returns a pointer of struct ndmsg, we do not need to pass two
of them.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250716221221.442239-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 1dd9f85b74997..fe921f8cc81c1 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2911,10 +2911,9 @@ static int neigh_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 	return err;
 }
 
-static int neigh_valid_get_req(const struct nlmsghdr *nlh,
-			       struct neigh_table **tbl,
-			       void **dst, int *dev_idx, u8 *ndm_flags,
-			       struct netlink_ext_ack *extack)
+static struct ndmsg *neigh_valid_get_req(const struct nlmsghdr *nlh,
+					 struct neigh_table **tbl, void **dst,
+					 struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[NDA_MAX + 1];
 	struct ndmsg *ndm;
@@ -2922,32 +2921,30 @@ static int neigh_valid_get_req(const struct nlmsghdr *nlh,
 
 	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*ndm))) {
 		NL_SET_ERR_MSG(extack, "Invalid header for neighbor get request");
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	ndm = nlmsg_data(nlh);
 	if (ndm->ndm_pad1  || ndm->ndm_pad2  || ndm->ndm_state ||
 	    ndm->ndm_type) {
 		NL_SET_ERR_MSG(extack, "Invalid values in header for neighbor get request");
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	if (ndm->ndm_flags & ~NTF_PROXY) {
 		NL_SET_ERR_MSG(extack, "Invalid flags in header for neighbor get request");
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	err = nlmsg_parse_deprecated_strict(nlh, sizeof(struct ndmsg), tb,
 					    NDA_MAX, nda_policy, extack);
 	if (err < 0)
-		return err;
+		return ERR_PTR(err);
 
-	*ndm_flags = ndm->ndm_flags;
-	*dev_idx = ndm->ndm_ifindex;
 	*tbl = neigh_find_table(ndm->ndm_family);
-	if (*tbl == NULL) {
+	if (!*tbl) {
 		NL_SET_ERR_MSG(extack, "Unsupported family in header for neighbor get request");
-		return -EAFNOSUPPORT;
+		return ERR_PTR(-EAFNOSUPPORT);
 	}
 
 	for (i = 0; i <= NDA_MAX; ++i) {
@@ -2958,17 +2955,17 @@ static int neigh_valid_get_req(const struct nlmsghdr *nlh,
 		case NDA_DST:
 			if (nla_len(tb[i]) != (int)(*tbl)->key_len) {
 				NL_SET_ERR_MSG(extack, "Invalid network address in neighbor get request");
-				return -EINVAL;
+				return ERR_PTR(-EINVAL);
 			}
 			*dst = nla_data(tb[i]);
 			break;
 		default:
 			NL_SET_ERR_MSG(extack, "Unsupported attribute in neighbor get request");
-			return -EINVAL;
+			return ERR_PTR(-EINVAL);
 		}
 	}
 
-	return 0;
+	return ndm;
 }
 
 static inline size_t neigh_nlmsg_size(void)
@@ -3039,18 +3036,16 @@ static int neigh_get(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 	struct net_device *dev = NULL;
 	struct neigh_table *tbl = NULL;
 	struct neighbour *neigh;
+	struct ndmsg *ndm;
 	void *dst = NULL;
-	u8 ndm_flags = 0;
-	int dev_idx = 0;
 	int err;
 
-	err = neigh_valid_get_req(nlh, &tbl, &dst, &dev_idx, &ndm_flags,
-				  extack);
-	if (err < 0)
-		return err;
+	ndm = neigh_valid_get_req(nlh, &tbl, &dst, extack);
+	if (IS_ERR(ndm))
+		return PTR_ERR(ndm);
 
-	if (dev_idx) {
-		dev = __dev_get_by_index(net, dev_idx);
+	if (ndm->ndm_ifindex) {
+		dev = __dev_get_by_index(net, ndm->ndm_ifindex);
 		if (!dev) {
 			NL_SET_ERR_MSG(extack, "Unknown device ifindex");
 			return -ENODEV;
@@ -3062,7 +3057,7 @@ static int neigh_get(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 	}
 
-	if (ndm_flags & NTF_PROXY) {
+	if (ndm->ndm_flags & NTF_PROXY) {
 		struct pneigh_entry *pn;
 
 		pn = pneigh_lookup(tbl, net, dst, dev, 0);
-- 
2.53.0



