Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E998837A498;
	Thu, 20 Aug 2026 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247028; cv=none; b=Xz6FJozCqcrPkjNaM+oEUDbYzkKxgpa/I8Hw1RdKBG1wle/1TUbc3Ipmlz0WYgGiI+OQrz+wkDJl7XU/YnAXQHn7pBT8AUGA/nmWxHJ7l7fwvjPue6y4BwSMmDf1Rq+fWhGFeJsZqkxfTuUzaCO+uPMU1xBzMWXoiH0QZftmzd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247028; c=relaxed/simple;
	bh=WJdfzl9EXXmWktHoHIeXTxalZZZ+rgG0XPRrGkVHSQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agiMK6Q2Bu/vfc/qZKWNpzYkfy/7cLQ3Ox99hijs0Sxv9vrfcwNx+d7lM9SPleG1x0MO+LkDrd0M4/XVzWiDfFTpCRUGDSodBZN7aWkiqB7+ExzMaUesONZOJOWTN6d8XVWouoeQVTQC9JHJCO4Wl65q8sUimGwyU/VJi9FtBFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHpZ/4DB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHpZ/4DB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B02D1F000E9;
	Thu, 20 Aug 2026 17:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247026;
	bh=pX/fmR/iJLCTn8Xu2cr/CKtqaum5VqDDVwb9W9j04QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHpZ/4DBfQG82fEAQnSM8It9Kv/0cWIMZ/zrKOJ0KiJvhaw9l6G8Fzk/OACxFwp+p
	 vU4sAeP/WFkIGFgykQZ+MOGEjukawXAWkjewjIiCoMARp4fDi2Ck3pQSMf6qCEB2uY
	 WH0bs2jVqUng2yM6FjmQkztYlAo5yfTIX4KTYx98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/220] net/sched: serialize qdisc_rtab_list against concurrent get/put
Date: Thu, 20 Aug 2026 16:55:13 +0200
Message-ID: <20260820145227.171410571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit f43ee0c0730d6191629b5ee1ceae27b1ebfdc047 ]

qdisc_get_rtab() and qdisc_put_rtab() mutate the process-global singly
linked list qdisc_rtab_list and a plain non-atomic 'int refcnt' with no
lock. This was only safe because every caller historically held the RTNL
mutex, which serialized all rate-table lookups, inserts and frees.

That invariant no longer holds. cls_flower sets
TCF_PROTO_OPS_DOIT_UNLOCKED, so tc_new_tfilter() keeps rtnl_held == false
for it and sets TCA_ACT_FLAGS_NO_RTNL. That flag propagates through
tcf_exts_validate_ex() -> tcf_action_init() -> tcf_action_init_1() ->
tcf_police_init(), which calls qdisc_get_rtab()/qdisc_put_rtab() with the
RTNL mutex NOT held. Two RTM_NEWTFILTER requests on different CPUs, each
adding a flower filter with a police action carrying the same rate, then
race on qdisc_rtab_list and on the non-atomic refcnt, leading to a
use-after-free / double-free of the kmalloc-2k struct qdisc_rate_table.
qdisc_rtab_list is a single global (not per-netns), so the corrupted
object is shared system-wide.

  BUG: KASAN: slab-use-after-free in qdisc_put_rtab+0x12f/0x160
   qdisc_put_rtab+0x12f/0x160
   tcf_police_init+0xda9/0x1590
   tcf_action_init_1+0x460/0x6b0
   tcf_action_init+0x439/0xa40
   tcf_exts_validate_ex+0x42d/0x550
   fl_change+0xddd/0x7da0
   tc_new_tfilter+0xaa7/0x2420
   rtnetlink_rcv_msg+0x95e/0xe90
  which belongs to the cache kmalloc-2k of size 2048

Protect qdisc_rtab_list and the refcount with a dedicated spinlock. The
(sleeping, GFP_KERNEL) allocation in qdisc_get_rtab() is performed before
taking the lock; if a concurrent inserter added an identical table in the
meantime the freshly allocated one is freed under the lock, so no
duplicate is leaked. qdisc_put_rtab() now decrements the refcount and
unlinks under the same lock.

Fixes: 470502de5bdb ("net: sched: unlock rules update API")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Cc: stable@vger.kernel.org
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260715114114.446841-1-qwe.aldo@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_api.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -413,12 +413,13 @@ static __u8 __detect_linklayer(struct tc
 }
 
 static struct qdisc_rate_table *qdisc_rtab_list;
+static DEFINE_SPINLOCK(qdisc_rtab_lock);
 
 struct qdisc_rate_table *qdisc_get_rtab(struct tc_ratespec *r,
 					struct nlattr *tab,
 					struct netlink_ext_ack *extack)
 {
-	struct qdisc_rate_table *rtab;
+	struct qdisc_rate_table *rtab, *new_rtab;
 
 	if (tab == NULL || r->rate == 0 ||
 	    r->cell_log == 0 || r->cell_log >= 32 ||
@@ -427,15 +428,20 @@ struct qdisc_rate_table *qdisc_get_rtab(
 		return NULL;
 	}
 
+	new_rtab = kmalloc_obj(*new_rtab);
+
+	spin_lock(&qdisc_rtab_lock);
 	for (rtab = qdisc_rtab_list; rtab; rtab = rtab->next) {
 		if (!memcmp(&rtab->rate, r, sizeof(struct tc_ratespec)) &&
 		    !memcmp(&rtab->data, nla_data(tab), 1024)) {
 			rtab->refcnt++;
+			spin_unlock(&qdisc_rtab_lock);
+			kfree(new_rtab);
 			return rtab;
 		}
 	}
 
-	rtab = kmalloc(sizeof(*rtab), GFP_KERNEL);
+	rtab = new_rtab;
 	if (rtab) {
 		rtab->rate = *r;
 		rtab->refcnt = 1;
@@ -447,6 +453,7 @@ struct qdisc_rate_table *qdisc_get_rtab(
 	} else {
 		NL_SET_ERR_MSG(extack, "Failed to allocate new qdisc rate table");
 	}
+	spin_unlock(&qdisc_rtab_lock);
 	return rtab;
 }
 EXPORT_SYMBOL(qdisc_get_rtab);
@@ -455,18 +462,25 @@ void qdisc_put_rtab(struct qdisc_rate_ta
 {
 	struct qdisc_rate_table *rtab, **rtabp;
 
-	if (!tab || --tab->refcnt)
+	if (!tab)
+		return;
+
+	spin_lock(&qdisc_rtab_lock);
+	if (--tab->refcnt) {
+		spin_unlock(&qdisc_rtab_lock);
 		return;
+	}
 
 	for (rtabp = &qdisc_rtab_list;
 	     (rtab = *rtabp) != NULL;
 	     rtabp = &rtab->next) {
 		if (rtab == tab) {
 			*rtabp = rtab->next;
-			kfree(rtab);
-			return;
+			break;
 		}
 	}
+	spin_unlock(&qdisc_rtab_lock);
+	kfree(tab);
 }
 EXPORT_SYMBOL(qdisc_put_rtab);
 


