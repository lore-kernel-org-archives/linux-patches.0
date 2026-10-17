Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0968A3AF66D;
	Sat, 17 Oct 2026 16:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256120; cv=none; b=FLfdj5orfDVHWhXIcCKnKqvMAA45QmN8JHBd4AcxGKT8ojIDfVh85p5p0TfpkuHbi9XGZLY7nKorg/H1Ut1+/ExLj7I/VMZiW+z958l4z5PFFcylhwbNi5N1E8IDEKpVPtuYyvGA1uEz9ztc3tbweeL0kyAsv9k/9Vth5S5XK8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256120; c=relaxed/simple;
	bh=VMyaDlFxV+nJZr+yR9S5z8H7fv41aL9aCW+tfNOCiIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1QUBy2TkHqIQA8uxrP48Y7VS7jSRrOZ3G/NOjoe3J0cQIAV8m/Rdi3jxYBLaWESvwJBTpC6HfEsEnjYoiDFwj584axFVdNwQtmcCV/c5G15OY4eWYPR3kRxqH41tJxaEm51yDRADPPJyvafpcmz0LgUhBdItFCPHU2k3+8Tb6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUebet9R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUebet9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568D01F000C4;
	Sat, 17 Oct 2026 16:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256118;
	bh=xxw35ljpv5g/9dNdeNtqAIrsR/5L1D5VZmJN+o/d5iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUebet9R40dl5+fMeIXJkhyxJ025h2aP24tpvJIlwbeg+RDYClJtEEc73yoUdDle0
	 34LKdL61AdIg8Gk1x7NTI4B1gichOinKKSIkb+QCjibaEdHG7FSmpNbpI6tX/KIvLz
	 fUqMC1y081B5cjNunAntbORmBPQN8LskTHyY/JqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Mierczuk <axel.mierczuk@1password.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0132/1674] net: openvswitch: conntrack: fix helper UAF due to extensions realloc
Date: Sat, 17 Oct 2026 17:40:04 +0200
Message-ID: <20261017160434.551168254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 1a4151e6be57b098b7a5ebfbde58585e83200cdc ]

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

Fixes: cae3a2627520 ("openvswitch: Allow attaching helpers to ct action")
Cc: stable@vger.kernel.org
Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260921145655.3167436-4-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index acfef7f14bce2..cdbd6ad2b8d7c 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -818,11 +818,14 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 			}
 		}
 
-		/* Call the helper only if:
-		 * - nf_conntrack_in() was executed above ("!cached"), or
-		 * - When committing an unconfirmed connection.
+		/* Call the helper only if nf_conntrack_in() was executed
+		 * above ("!cached").
+		 *
+		 * For unconfirmed connections it will be called later during
+		 * commit as we need to have all the other extensions allocated
+		 * before the call.
 		 */
-		if ((nf_ct_is_confirmed(ct) ? !cached : info->commit)) {
+		if (nf_ct_is_confirmed(ct) && !cached) {
 			int err = nf_ct_helper(skb, ct, ctinfo, info->family);
 
 			err = verdict_to_errno(err);
@@ -1025,6 +1028,14 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
 			return err;
 
 		nf_conn_act_ct_ext_add(skb, ct, ctinfo);
+
+		/* Call the helpers now.  We couldn't do this before as
+		 * all the extensions must be allocated before the call.
+		 */
+		err = nf_ct_helper(skb, ct, ctinfo, info->family);
+		err = verdict_to_errno(err);
+		if (err)
+			return err;
 	} else if (IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS) &&
 		   labels_nonzero(&info->labels.mask)) {
 		err = ovs_ct_set_labels(ct, key, &info->labels.value,
-- 
2.53.0



