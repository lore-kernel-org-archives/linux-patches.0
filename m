Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0645A4F392F;
	Thu, 17 Sep 2026 17:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666103; cv=none; b=PprDx0ERNBdsMw4QVIQnjNHGhJOzNMnTBO9OaTpK210vGJrfvGVD49t2imyhgt8NrYE4on3oy0MimlckUUI78/M4VAKnQ/6RhxjXevywkHbSbROGT9SyfEXvgIUAFIzEN+NQPBQVFE2JIBIh0w0C6euBsABq3UusykceCc5juHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666103; c=relaxed/simple;
	bh=9iH+kAjRRPOJ+Z4Yqwys+CO5/cXmNxEphH/ryJbyZm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbV5pWGXjt/YGrQgfEf/kJx5IYgOw0wMb9Zh3YwT4X2Jh8MZbRdlhETVUoAV2AY5H2GiM+VFSCa+Ajo6Kt4BhvcVjB2rZCMgB2Q/mkMlJAZQ97RnVD/23kZrA9a9QylDLTQjME0FRwTnvr0xL1yJYSkGO+wYrIuHsJZd7pDPun0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LziSIa/4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LziSIa/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4631F000FF;
	Thu, 17 Sep 2026 17:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666101;
	bh=0pQWTbqwqHutexSrG8Otdr20sn/XVnBbe2rN53pGHqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LziSIa/4FoN8Su6rdpOMeHU2aLK70tCbW463iUDrYn95q8lMKNiw2z7KmgHsjw5OX
	 SomhbOY8cBjtZwD9jTw5IZFwvMynT+BU9j11oN4XaBDxGZAtNlRcmWgfAte/Bw+c5d
	 vbvsuNPyjuVZtO/XIJP6gJWKay1doPEEhJyDGblg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0925/1250] net/sched: cls_route: Fix in-place replace
Date: Thu, 17 Sep 2026 16:12:00 +0100
Message-ID: <20260917151617.080084431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 41e85e54e5649a1617698438b0ce64c6f9d83d69 ]

Building on the previous patch, route4_set_parms rejects a duplicate by
scanning the destination chain for nhandle, but the scan doesn't exclude
the older version it is replacing, so an in-place replace will match
the older version's handle and fail.

Fix this by passing the older filter as a parameter to route4_set_parms
(replacing "new") and skipping it in the scan.

Excluding the older version is not enough on its own. nhandle is built
out of TCA_ROUTE4_TO, TCA_ROUTE4_FROM and TCA_ROUTE4_IIF alone, while the
0x7F00 bits, which only tell apart filters sharing one key, are folded in
on the create path. Letting the replace through would therefore rename
the filter it replaces: replacing handle 0x10101 stored it back as
0x10001, and a sibling at 0x10201 could then no longer be replaced at
all, since its own nhandle collided with the renamed filter.

	tc filter add ... handle 0x10101 route from 1 to 1 classid 1:1
	tc filter add ... handle 0x10201 route from 1 to 1 classid 1:2
	tc filter replace ... handle 0x10101 route from 1 to 1 classid 1:9
	... fh 0x00010001 flowid 1:9 to 1 from 1
	... fh 0x00010201 flowid 1:2 to 1 from 1
	tc filter replace ... handle 0x10201 route from 1 to 1 classid 1:8
	Error: Handle 10001 is already in use.

So carry those bits over when the key the request builds is the key the
older filter already has. An in-place replace then keeps the handle
userspace named the filter by, while a request that does change the key
still renames it, as it did before.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260829205422.854785-1-victor%40mojatatu.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260907192133.2639067-4-victor@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_route.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 1699ae262a615..5a0ddcf3e2b40 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -393,8 +393,9 @@ static const struct nla_policy route4_policy[TCA_ROUTE4_MAX + 1] = {
 static int route4_set_parms(struct net *net, struct tcf_proto *tp,
 			    unsigned long base, struct route4_filter *f,
 			    u32 handle, struct route4_head *head,
-			    struct nlattr **tb, struct nlattr *est, int new,
-			    u32 flags, struct netlink_ext_ack *extack)
+			    struct nlattr **tb, struct nlattr *est,
+			    struct route4_filter *fold, u32 flags,
+			    struct netlink_ext_ack *extack)
 {
 	u32 id = 0, to = 0, nhandle = 0x8000;
 	struct route4_filter *fp;
@@ -407,7 +408,7 @@ static int route4_set_parms(struct net *net, struct tcf_proto *tp,
 		return err;
 
 	if (tb[TCA_ROUTE4_TO]) {
-		if (new && handle & 0x8000) {
+		if (!fold && handle & 0x8000) {
 			NL_SET_ERR_MSG(extack, "Invalid handle");
 			return -EINVAL;
 		}
@@ -430,14 +431,14 @@ static int route4_set_parms(struct net *net, struct tcf_proto *tp,
 	} else
 		nhandle |= 0xFFFF << 16;
 
-	if (handle && new) {
+	if (handle && (!fold || nhandle == (handle & ~0x7F00)))
 		nhandle |= handle & 0x7F00;
-		if (nhandle != handle) {
-			NL_SET_ERR_MSG_FMT(extack,
-					   "Handle mismatch constructed: %x (expected: %x)",
-					   handle, nhandle);
-			return -EINVAL;
-		}
+
+	if (handle && !fold && nhandle != handle) {
+		NL_SET_ERR_MSG_FMT(extack,
+				   "Handle mismatch constructed: %x (expected: %x)",
+				   handle, nhandle);
+		return -EINVAL;
 	}
 
 	if (!nhandle) {
@@ -460,7 +461,7 @@ static int route4_set_parms(struct net *net, struct tcf_proto *tp,
 		for (fp = rtnl_dereference(b->ht[h2]);
 		     fp;
 		     fp = rtnl_dereference(fp->next))
-			if (fp->handle == nhandle) {
+			if (fp != fold && fp->handle == nhandle) {
 				NL_SET_ERR_MSG_FMT(extack,
 						   "Handle %x is already in use",
 						   nhandle);
@@ -502,7 +503,6 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 	struct nlattr *tb[TCA_ROUTE4_MAX + 1];
 	unsigned int h;
 	int err;
-	bool new = true;
 
 	if (!handle) {
 		NL_SET_ERR_MSG(extack, "Creating with handle of 0 is invalid");
@@ -539,11 +539,10 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 
 		f->tp = fold->tp;
 		f->bkt = fold->bkt;
-		new = false;
 	}
 
 	err = route4_set_parms(net, tp, base, f, handle, head, tb,
-			       tca[TCA_RATE], new, flags, extack);
+			       tca[TCA_RATE], fold, flags, extack);
 	if (err < 0)
 		goto errout;
 
-- 
2.53.0



