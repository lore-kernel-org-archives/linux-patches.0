Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69E4611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475C9C433C8;
	Mon, 28 Aug 2023 10:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219298;
	bh=ugo0Eohjxp1SdEc78I22vFwnsFYb7BMoPgLpHr8v4X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBj8xJOQY4fpJErIPglYT9ncepGTig/2fjRY7iFlkyaidHPvhC/Gl9G+4nDCLta+h
	 d5b46KWOy7EL8fi7aI2upbSNIrpTCZjT9GRcBJ6CmigmZW55tTtE8cr16/2zdDXxJj
	 eOzRpVKwWravGBTKTJZV9+dtNrUd65YFOkP9HKRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a3618a167af2021433cd@syzkaller.appspotmail.com,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/158] net/sched: fix a qdisc modification with ambiguous command request
Date: Mon, 28 Aug 2023 12:13:44 +0200
Message-ID: <20230828101201.689589821@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit da71714e359b64bd7aab3bd56ec53f307f058133 ]

When replacing an existing root qdisc, with one that is of the same kind, the
request boils down to essentially a parameterization change  i.e not one that
requires allocation and grafting of a new qdisc. syzbot was able to create a
scenario which resulted in a taprio qdisc replacing an existing taprio qdisc
with a combination of NLM_F_CREATE, NLM_F_REPLACE and NLM_F_EXCL leading to
create and graft scenario.
The fix ensures that only when the qdisc kinds are different that we should
allow a create and graft, otherwise it goes into the "change" codepath.

While at it, fix the code and comments to improve readability.

While syzbot was able to create the issue, it did not zone on the root cause.
Analysis from Vladimir Oltean <vladimir.oltean@nxp.com> helped narrow it down.

v1->V2 changes:
- remove "inline" function definition (Vladmir)
- remove extrenous braces in branches (Vladmir)
- change inline function names (Pedro)
- Run tdc tests (Victor)
v2->v3 changes:
- dont break else/if (Simon)

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+a3618a167af2021433cd@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/20230816225759.g25x76kmgzya2gei@skbuf/T/
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 53 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 6ca0cba8aad16..d07146a2d0bba 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1503,10 +1503,28 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 	return 0;
 }
 
+static bool req_create_or_replace(struct nlmsghdr *n)
+{
+	return (n->nlmsg_flags & NLM_F_CREATE &&
+		n->nlmsg_flags & NLM_F_REPLACE);
+}
+
+static bool req_create_exclusive(struct nlmsghdr *n)
+{
+	return (n->nlmsg_flags & NLM_F_CREATE &&
+		n->nlmsg_flags & NLM_F_EXCL);
+}
+
+static bool req_change(struct nlmsghdr *n)
+{
+	return (!(n->nlmsg_flags & NLM_F_CREATE) &&
+		!(n->nlmsg_flags & NLM_F_REPLACE) &&
+		!(n->nlmsg_flags & NLM_F_EXCL));
+}
+
 /*
  * Create/change qdisc.
  */
-
 static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 			   struct netlink_ext_ack *extack)
 {
@@ -1603,27 +1621,35 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 				 *
 				 *   We know, that some child q is already
 				 *   attached to this parent and have choice:
-				 *   either to change it or to create/graft new one.
+				 *   1) change it or 2) create/graft new one.
+				 *   If the requested qdisc kind is different
+				 *   than the existing one, then we choose graft.
+				 *   If they are the same then this is "change"
+				 *   operation - just let it fallthrough..
 				 *
 				 *   1. We are allowed to create/graft only
-				 *   if CREATE and REPLACE flags are set.
+				 *   if the request is explicitly stating
+				 *   "please create if it doesn't exist".
 				 *
-				 *   2. If EXCL is set, requestor wanted to say,
-				 *   that qdisc tcm_handle is not expected
+				 *   2. If the request is to exclusive create
+				 *   then the qdisc tcm_handle is not expected
 				 *   to exist, so that we choose create/graft too.
 				 *
 				 *   3. The last case is when no flags are set.
+				 *   This will happen when for example tc
+				 *   utility issues a "change" command.
 				 *   Alas, it is sort of hole in API, we
 				 *   cannot decide what to do unambiguously.
-				 *   For now we select create/graft, if
-				 *   user gave KIND, which does not match existing.
+				 *   For now we select create/graft.
 				 */
-				if ((n->nlmsg_flags & NLM_F_CREATE) &&
-				    (n->nlmsg_flags & NLM_F_REPLACE) &&
-				    ((n->nlmsg_flags & NLM_F_EXCL) ||
-				     (tca[TCA_KIND] &&
-				      nla_strcmp(tca[TCA_KIND], q->ops->id))))
-					goto create_n_graft;
+				if (tca[TCA_KIND] &&
+				    nla_strcmp(tca[TCA_KIND], q->ops->id)) {
+					if (req_create_or_replace(n) ||
+					    req_create_exclusive(n))
+						goto create_n_graft;
+					else if (req_change(n))
+						goto create_n_graft2;
+				}
 			}
 		}
 	} else {
@@ -1657,6 +1683,7 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 		NL_SET_ERR_MSG(extack, "Qdisc not found. To create specify NLM_F_CREATE flag");
 		return -ENOENT;
 	}
+create_n_graft2:
 	if (clid == TC_H_INGRESS) {
 		if (dev_ingress_queue(dev)) {
 			q = qdisc_create(dev, dev_ingress_queue(dev), p,
-- 
2.40.1



