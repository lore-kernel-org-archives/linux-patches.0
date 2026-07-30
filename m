Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F1D40FD86;
	Thu, 30 Jul 2026 14:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423081; cv=none; b=m3/9nOAxT/QGbbtoQceSJA5sFv2lvRnpd6ocBXcy4fsbQJ+Lq8IgPHDnMZ62vWzlnJyd1RGSTgVcrW+1Pa2IXbUpr1xgWnzuSM8dHZsofHlZfx17nVfUPlDFR3HW4vEYNFsML8Jy6+a5ap9GWHfhwNMFkC4x99N4bEgoioEMPNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423081; c=relaxed/simple;
	bh=1yEkRjeS6Yz2r0NbllhPaxj8LjIdEwlMQS1JzqJoqIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULAXItTW6IAcXr5pjC22D2I40QYtQenkf0U5CaEmOz1hC5cpYpnOTYKfsI1zvYCX7t9Yso7p+sOkzI43qwGb7NJHTnXWLhmCAvlmGFulOUNoVCV4PacJcWdZ6r/P/PXGpyTN7uC38g9qmFh5GCkbPsAqu6zFx5BrpFRGPvrx2/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rk2+xTzt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rk2+xTzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C901F000E9;
	Thu, 30 Jul 2026 14:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423079;
	bh=aTyDdnkGxY51+1HymD3bBhJe0vA0tTp0FQChPpWW2bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rk2+xTztxD9DKOxXc29YditSVwwzwqpXJhtgRyjrRo/Y5+HPzdhRK0H//Qrsu3c6v
	 YHH29yZejOH5nQQOKY8jBAj4n8QFuwGH2q3Dzo1N3HwJVcBAbgEs9wr7UDIolgn4Pb
	 a+QoyqLveIKD/bVtGArePEDj6vysWRt9F7SK7VSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 660/744] net/sched: serialize qdisc_rtab_list against concurrent get/put
Date: Thu, 30 Jul 2026 16:15:33 +0200
Message-ID: <20260730141458.294497788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit f43ee0c0730d6191629b5ee1ceae27b1ebfdc047 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_api.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -415,12 +415,13 @@ static __u8 __detect_linklayer(struct tc
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
@@ -429,15 +430,20 @@ struct qdisc_rate_table *qdisc_get_rtab(
 		return NULL;
 	}
 
+	new_rtab = kmalloc_obj(*new_rtab);
+
+	spin_lock(&qdisc_rtab_lock);
 	for (rtab = qdisc_rtab_list; rtab; rtab = rtab->next) {
 		if (!memcmp(&rtab->rate, r, sizeof(struct tc_ratespec)) &&
 		    !memcmp(&rtab->data, nla_data(tab), TC_RTAB_SIZE)) {
 			rtab->refcnt++;
+			spin_unlock(&qdisc_rtab_lock);
+			kfree(new_rtab);
 			return rtab;
 		}
 	}
 
-	rtab = kmalloc_obj(*rtab);
+	rtab = new_rtab;
 	if (rtab) {
 		rtab->rate = *r;
 		rtab->refcnt = 1;
@@ -449,6 +455,7 @@ struct qdisc_rate_table *qdisc_get_rtab(
 	} else {
 		NL_SET_ERR_MSG(extack, "Failed to allocate new qdisc rate table");
 	}
+	spin_unlock(&qdisc_rtab_lock);
 	return rtab;
 }
 EXPORT_SYMBOL(qdisc_get_rtab);
@@ -457,18 +464,25 @@ void qdisc_put_rtab(struct qdisc_rate_ta
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
 


