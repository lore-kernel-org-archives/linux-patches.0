Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348B12566;
	Tue, 15 Jul 2025 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586783; cv=none; b=Ex6oTzzlTDskDTgd3kwfQPuJ5iSUKH1vO3MyrTRVRXh9hAw/5vjjkPqbLhHJ5aZ42Y/4k3Fkyto0VwCYWkPqWoSYcf699iTc0/QoOCLKlJ/hp/5TMz/kCqbh3Ry+rVOQQ7L4k27BTGrRw65K9lduoK8i73wr7qkoT5Pgxj4g9Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586783; c=relaxed/simple;
	bh=gG7kjpLt5IJWireSw/Q6gLOvim+YotuN71v0KbcHRt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLE+FNirnWvqo55YSjyyYBIkpZAY4ttH4IBgNvOu934FMrO0RE52K7RO6H6Ta1bbhHlKa4mhKtdchPAnFu4W/iEf+9v+q8dRB0QOTxiO01H2j9vSbArJwowrS+PVxvvTanVwe/gd2uKdgFFmKpEuTdrsqi5e1fG8Pt2olvrKVwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wydrPPgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wydrPPgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E846C4CEE3;
	Tue, 15 Jul 2025 13:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586782;
	bh=gG7kjpLt5IJWireSw/Q6gLOvim+YotuN71v0KbcHRt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wydrPPgIPd1Mv37pRV9vxYDYJac++nmj5vye2z/eqXf+Qulwawt0bO8Svm7ZGCkUx
	 8Tj+YBgltl6Xlb0iFpEWpqcgo1j3v5UkvHS2C8hH6OD8Bufl2bMYPU3zbHqPEG0wDS
	 5Q2NkUtBdXoC1EYx7d5BPntDNaiSQZJ2unKRlA+o=
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
Subject: [PATCH 6.15 046/192] net/sched: Abort __tc_modify_qdisc if parent class does not exist
Date: Tue, 15 Jul 2025 15:12:21 +0200
Message-ID: <20250715130816.697052294@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index d58921ffcf35e..a96f9f74777bc 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -335,17 +335,22 @@ struct Qdisc *qdisc_lookup_rcu(struct net_device *dev, u32 handle)
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
 
@@ -1489,7 +1494,7 @@ static int __tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 					NL_SET_ERR_MSG(extack, "Failed to find qdisc with specified classid");
 					return -ENOENT;
 				}
-				q = qdisc_leaf(p, clid);
+				q = qdisc_leaf(p, clid, extack);
 			} else if (dev_ingress_queue(dev)) {
 				q = rtnl_dereference(dev_ingress_queue(dev)->qdisc_sleeping);
 			}
@@ -1500,6 +1505,8 @@ static int __tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 			NL_SET_ERR_MSG(extack, "Cannot find specified qdisc on specified device");
 			return -ENOENT;
 		}
+		if (IS_ERR(q))
+			return PTR_ERR(q);
 
 		if (tcm->tcm_handle && q->handle != tcm->tcm_handle) {
 			NL_SET_ERR_MSG(extack, "Invalid handle");
@@ -1601,7 +1608,9 @@ static int __tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 					NL_SET_ERR_MSG(extack, "Failed to find specified qdisc");
 					return -ENOENT;
 				}
-				q = qdisc_leaf(p, clid);
+				q = qdisc_leaf(p, clid, extack);
+				if (IS_ERR(q))
+					return PTR_ERR(q);
 			} else if (dev_ingress_queue_create(dev)) {
 				q = rtnl_dereference(dev_ingress_queue(dev)->qdisc_sleeping);
 			}
-- 
2.39.5



