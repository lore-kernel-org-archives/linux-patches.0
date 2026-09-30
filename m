Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFC2518149;
	Wed, 30 Sep 2026 17:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788087; cv=none; b=KE7RHVQwr+baWlNAZd58ORxSX/qlg/dgEIS2tol5vEyHKJg7WWKGP+xfQE4f7jHf/g6pOxEBWUXvkV2NxwAFBSBIbuFFUVRHW/eDC1DfTVnIs0G4P8h4Ix6plPc8FQrlXOeWzKGm9utlVqYx3W57VryP/rzeasxzspxZ3f3SSIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788087; c=relaxed/simple;
	bh=LGDtq0Xuf3BbBYVcKiz/IZ7lrTMnbELzPBwsZZ4+mLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pvyh625rU1ipeOidt43wVclzYlWEslyCtPVjOs/Or4PYNeIafV0mpJKSTwwK4pdFiMMiA/OwO3mpQKKDx78UsL/04kaTSspt72dz4pDZgRGFM4NITbUAS0UAuXJLwgjqJjIFEEhkXmAMyEUBs1CBekK7+r0x9j//1aGWmrSzksM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwcJd15j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwcJd15j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2AC1F000FF;
	Wed, 30 Sep 2026 17:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788086;
	bh=5Zbcxl5cvBBc5g7+yRmyQUw85JQYOt+aN/8jQGpImSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwcJd15joRjfCBo3+bLeV6Xr/bPEWsHzL6/mRp+ybqs7X3DmUfmvgs+SkIak6BZbz
	 DYxIVtT8YUlXfaHwWsL6nFjX//N65ggZzBqfAs6ve7a8Ikpd8Nn6IEOhd1VMQahpxY
	 j4WoiIRvsg1cIYflhZDNJA8yl+0s4vdQcOb4L1j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Mierczuk <axel.mierczuk@1password.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 446/457] net/sched: act_ct: fix helper UAF due to extensions realloc
Date: Wed, 30 Sep 2026 17:29:11 +0200
Message-ID: <20260930152355.628545776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit dad19b59da050cb60d3f7023dac2a042a84bf0bd ]

While calling the helpers, a raw pointer to the extensions area is
wired into expectations list:

  -> nf_ct_helper()
   -> helper->help()
    -> nf_ct_expect_related_report()
     -> nf_ct_expect_insert()
      -> hlist_add_head_rcu(&exp->lnode, &master_help->expectations)

In case the connection is not confirmed yet, more extensions can be
added afterwards with *_ext_add() calls reallocating the extension
space and leaving the now invalid pointer in the expectations list
that is later accessed while removing the expectation.

Make sure that helpers are called at the end after all the other
extensions are already added.

Note that the helper rejection now leaves the mark and labels set,
but that's not different from how the NAT was handled before or how
the mark and the labels were handled on confirmation failure.  And
there are no atomicity guarantees provided by the API anyway.

Fixes: a21b06e73191 ("net: sched: add helper support in act_ct")
Cc: stable@vger.kernel.org
Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260921145655.3167436-7-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Preserved the existing add_helper condition that upstream had removed. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1089,19 +1089,25 @@ do_nat:
 		}
 	}
 
-	if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
-		err = nf_ct_helper(skb, ct, ctinfo, family);
-		if (err != NF_ACCEPT)
-			goto nf_error;
-	}
-
 	if (commit) {
 		tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
 		tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
 
 		if (!nf_ct_is_confirmed(ct))
 			nf_conn_act_ct_ext_add(skb, ct, ctinfo);
+	}
 
+	/* Run helpers for the connection if nf_conntrack_in() was executed
+	 * or if we're about to commit.  This has to be done after all the
+	 * extensions are already added.
+	 */
+	if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
+		err = nf_ct_helper(skb, ct, ctinfo, family);
+		if (err != NF_ACCEPT)
+			goto nf_error;
+	}
+
+	if (commit) {
 		/* This will take care of sending queued events
 		 * even if the connection is already confirmed.
 		 */


