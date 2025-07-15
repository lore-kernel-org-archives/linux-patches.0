Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DD02397BF;
	Tue, 15 Jul 2025 13:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587812; cv=none; b=kY8q5AP+r2pl6QPQ98ntW6vfv9cU07DoYo9SrR5tm1sQGCUKlHlGtzeFme7lk57CB9Po2H8e6IF16+2R/b0pNPcWfAj6eTSHi0V0RcWZ1wY2Gds6bhtOmbUcO4uPm/v82lrKfny0tl95kCpP2wTaTop4ArBf8lU4AuNrj2dvE18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587812; c=relaxed/simple;
	bh=DJILK9pERcKw0xVD2xGZsKSIYl2pp3pZ8K8OYNrABm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQ8mNABZCZJtG+PrPAjlUx2XpBuoWC/FhfNqIoUrnYDxOnjFZUWYhpH2ItXMv5i2kxKfCZHW1KyxbdSf1sMzvJ+phI7H1xISkU4jgySw1YBWZLRwcRcj6/isIyLZAlM8K1nRA/J6LcBVjcnX9BYJyGyO7cthpchBqEIBibMohZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2lypPO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2lypPO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1C0C4CEE3;
	Tue, 15 Jul 2025 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587812;
	bh=DJILK9pERcKw0xVD2xGZsKSIYl2pp3pZ8K8OYNrABm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2lypPO/3q3slx4YvtK10Y9Rc9Q96+HQD6u63fcZaJkNAFWQ0SaY2BJo7Ee3ojNJK
	 +nPX1l99eAIEnvEDSyhWaC7cOR+4bXG5qOhOmLKxfSuAQlxWWoix3LDjgOoo7rUexq
	 0TsjRIrnamgnG6vzovtE3Hm1Iisk+vKu6NejdS+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d8b58d7b0ad89a678a16@syzkaller.appspotmail.com,
	syzbot+5eccb463fa89309d8bdc@syzkaller.appspotmail.com,
	syzbot+1261670bbdefc5485a06@syzkaller.appspotmail.com,
	syzbot+15b96fc3aac35468fe77@syzkaller.appspotmail.com,
	syzbot+4dadc5aecf80324d5a51@syzkaller.appspotmail.com,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/208] net/sched: Abort __tc_modify_qdisc if parent class does not exist
Date: Tue, 15 Jul 2025 15:14:21 +0200
Message-ID: <20250715130817.001074504@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit ffdde7bf5a439aaa1955ebd581f5c64ab1533963 ]

Lion's patch [1] revealed an ancient bug in the qdisc API.
Whenever a user creates/modifies a qdisc specifying as a parent another
qdisc, the qdisc API will, during grafting, detect that the user is
not trying to attach to a class and reject. However grafting is
performed after qdisc_create (and thus the qdiscs' init callback) is
executed. In qdiscs that eventually call qdisc_tree_reduce_backlog
during init or change (such as fq, hhf, choke, etc), an issue
arises. For example, executing the following commands:

sudo tc qdisc add dev lo root handle a: htb default 2
sudo tc qdisc add dev lo parent a: handle beef fq

Qdiscs such as fq, hhf, choke, etc unconditionally invoke
qdisc_tree_reduce_backlog() in their control path init() or change() which
then causes a failure to find the child class; however, that does not stop
the unconditional invocation of the assumed child qdisc's qlen_notify with
a null class. All these qdiscs make the assumption that class is non-null.

The solution is ensure that qdisc_leaf() which looks up the parent
class, and is invoked prior to qdisc_create(), should return failure on
not finding the class.
In this patch, we leverage qdisc_leaf to return ERR_PTRs whenever the
parentid doesn't correspond to a class, so that we can detect it
earlier on and abort before qdisc_create is called.

[1] https://lore.kernel.org/netdev/d912cbd7-193b-4269-9857-525bee8bbb6a@gmail.com/

Fixes: 5e50da01d0ce ("[NET_SCHED]: Fix endless loops (part 2): "simple" qdiscs")
Reported-by: syzbot+d8b58d7b0ad89a678a16@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/68663c93.a70a0220.5d25f.0857.GAE@google.com/
Reported-by: syzbot+5eccb463fa89309d8bdc@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/68663c94.a70a0220.5d25f.0858.GAE@google.com/
Reported-by: syzbot+1261670bbdefc5485a06@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/686764a5.a00a0220.c7b3.0013.GAE@google.com/
Reported-by: syzbot+15b96fc3aac35468fe77@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/686764a5.a00a0220.c7b3.0014.GAE@google.com/
Reported-by: syzbot+4dadc5aecf80324d5a51@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/68679e81.a70a0220.29cf51.0016.GAE@google.com/
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20250707210801.372995-1-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 7fd4c94d6f464..a325036f3ae02 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -331,17 +331,22 @@ struct Qdisc *qdisc_lookup_rcu(struct net_device *dev, u32 handle)
 	return q;
 }
 
-static struct Qdisc *qdisc_leaf(struct Qdisc *p, u32 classid)
+static struct Qdisc *qdisc_leaf(struct Qdisc *p, u32 classid,
+				struct netlink_ext_ack *extack)
 {
 	unsigned long cl;
 	const struct Qdisc_class_ops *cops = p->ops->cl_ops;
 
-	if (cops == NULL)
-		return NULL;
+	if (cops == NULL) {
+		NL_SET_ERR_MSG(extack, "Parent qdisc is not classful");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
 	cl = cops->find(p, classid);
 
-	if (cl == 0)
-		return NULL;
+	if (cl == 0) {
+		NL_SET_ERR_MSG(extack, "Specified class not found");
+		return ERR_PTR(-ENOENT);
+	}
 	return cops->leaf(p, cl);
 }
 
@@ -1462,7 +1467,7 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 					NL_SET_ERR_MSG(extack, "Failed to find qdisc with specified classid");
 					return -ENOENT;
 				}
-				q = qdisc_leaf(p, clid);
+				q = qdisc_leaf(p, clid, extack);
 			} else if (dev_ingress_queue(dev)) {
 				q = dev_ingress_queue(dev)->qdisc_sleeping;
 			}
@@ -1473,6 +1478,8 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 			NL_SET_ERR_MSG(extack, "Cannot find specified qdisc on specified device");
 			return -ENOENT;
 		}
+		if (IS_ERR(q))
+			return PTR_ERR(q);
 
 		if (tcm->tcm_handle && q->handle != tcm->tcm_handle) {
 			NL_SET_ERR_MSG(extack, "Invalid handle");
@@ -1569,7 +1576,9 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 					NL_SET_ERR_MSG(extack, "Failed to find specified qdisc");
 					return -ENOENT;
 				}
-				q = qdisc_leaf(p, clid);
+				q = qdisc_leaf(p, clid, extack);
+				if (IS_ERR(q))
+					return PTR_ERR(q);
 			} else if (dev_ingress_queue_create(dev)) {
 				q = dev_ingress_queue(dev)->qdisc_sleeping;
 			}
-- 
2.39.5



