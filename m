Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96D9101D9
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+BL/J4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D88C433C8;
	Mon, 23 Oct 2023 11:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061648;
	bh=c3PoOwOah8w9xUG+I8EUGm2mr5M9Knr0rmo0p3i0hIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+BL/J4tPbBB87ZbZlDqdjkKIHJYWAz3MdwhSVsluV5D6+2aXZjukB4QdUX6t3GAm
	 febi9xIWd9RmQEunXkru6qiVgbteCEF/6/h4drGJRPTJzzEQUnh74Mpd7YwX6x6ljT
	 Z1+v+aEjCAS7saIrf89Z2hka+CjD9o4rD/S6f1lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Theune <ct@flyingcircus.io>,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 117/202] net/sched: sch_hfsc: upgrade rt to sc when it becomes a inner curve
Date: Mon, 23 Oct 2023 12:57:04 +0200
Message-ID: <20231023104829.953718949@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Tammela <pctammela@mojatatu.com>

commit a13b67c9a015c4e21601ef9aa4ec9c5d972df1b4 upstream.

Christian Theune says:
   I upgraded from 6.1.38 to 6.1.55 this morning and it broke my traffic shaping script,
   leaving me with a non-functional uplink on a remote router.

A 'rt' curve cannot be used as a inner curve (parent class), but we were
allowing such configurations since the qdisc was introduced. Such
configurations would trigger a UAF as Budimir explains:
   The parent will have vttree_insert() called on it in init_vf(),
   but will not have vttree_remove() called on it in update_vf()
   because it does not have the HFSC_FSC flag set.

The qdisc always assumes that inner classes have the HFSC_FSC flag set.
This is by design as it doesn't make sense 'qdisc wise' for an 'rt'
curve to be an inner curve.

Budimir's original patch disallows users to add classes with a 'rt'
parent, but this is too strict as it breaks users that have been using
'rt' as a inner class. Another approach, taken by this patch, is to
upgrade the inner 'rt' into a 'sc', warning the user in the process.
It avoids the UAF reported by Budimir while also being more permissive
to bad scripts/users/code using 'rt' as a inner class.

Users checking the `tc class ls [...]` or `tc class get [...]` dumps would
observe the curve change and are potentially breaking with this change.

v1->v2: https://lore.kernel.org/all/20231013151057.2611860-1-pctammela@mojatatu.com/
- Correct 'Fixes' tag and merge with revert (Jakub)

Cc: Christian Theune <ct@flyingcircus.io>
Cc: Budimir Markovic <markovicbudimir@gmail.com>
Fixes: b3d26c5702c7 ("net/sched: sch_hfsc: Ensure inner classes have fsc curve")
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20231017143602.3191556-1-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_hfsc.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -903,6 +903,14 @@ hfsc_change_usc(struct hfsc_class *cl, s
 	cl->cl_flags |= HFSC_USC;
 }
 
+static void
+hfsc_upgrade_rt(struct hfsc_class *cl)
+{
+	cl->cl_fsc = cl->cl_rsc;
+	rtsc_init(&cl->cl_virtual, &cl->cl_fsc, cl->cl_vt, cl->cl_total);
+	cl->cl_flags |= HFSC_FSC;
+}
+
 static const struct nla_policy hfsc_policy[TCA_HFSC_MAX + 1] = {
 	[TCA_HFSC_RSC]	= { .len = sizeof(struct tc_service_curve) },
 	[TCA_HFSC_FSC]	= { .len = sizeof(struct tc_service_curve) },
@@ -1012,10 +1020,6 @@ hfsc_change_class(struct Qdisc *sch, u32
 		if (parent == NULL)
 			return -ENOENT;
 	}
-	if (!(parent->cl_flags & HFSC_FSC) && parent != &q->root) {
-		NL_SET_ERR_MSG(extack, "Invalid parent - parent class must have FSC");
-		return -EINVAL;
-	}
 
 	if (classid == 0 || TC_H_MAJ(classid ^ sch->handle) != 0)
 		return -EINVAL;
@@ -1068,6 +1072,12 @@ hfsc_change_class(struct Qdisc *sch, u32
 	cl->cf_tree = RB_ROOT;
 
 	sch_tree_lock(sch);
+	/* Check if the inner class is a misconfigured 'rt' */
+	if (!(parent->cl_flags & HFSC_FSC) && parent != &q->root) {
+		NL_SET_ERR_MSG(extack,
+			       "Forced curve change on parent 'rt' to 'sc'");
+		hfsc_upgrade_rt(parent);
+	}
 	qdisc_class_hash_insert(&q->clhash, &cl->cl_common);
 	list_add_tail(&cl->siblings, &parent->children);
 	if (parent->level == 0)


