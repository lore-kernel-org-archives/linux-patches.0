Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5423AFAE3;
	Sat, 17 Oct 2026 16:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256111; cv=none; b=loyoeZvq487hDjag+Hp0zm2i5KB3WbLYdOeYs2/vYstV7VCfhb5m82aBsK9K9g3W/btqIyETJXppo9Y1FdlK4N0unX867ywLm1CPI6sADEtGtKivIU4Z1/Rh6srKpSmoJfa0168rZaKJpb+RXep4z5N0/SFcLqE43JfOF7Pk+ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256111; c=relaxed/simple;
	bh=DGzA6moXaW3F1eXP7BQlFtDnu5enScpdUd5/KkTm+LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dj65JK4OfrbKJzMl9boZ8JqcysobBfEoYSLzu6vK1+3QguRzDzExnqgVo2F3dO9XQ1myniN5zkueSsNusw//koRNOE7CvftFZzuIbKks/XhZaPabhkkiZMQvl3Xh7NJP3UqZEy3jl9y3IP145l30rv/LO/0/2sARtiOH1kzz7eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqsP0cSF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqsP0cSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566D81F000C4;
	Sat, 17 Oct 2026 16:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256109;
	bh=NkcxwgCLvGYjxq+u6nCEpQexI272IvFO9abyxKPgmIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EqsP0cSFtmiDl4kksswYAHG/MWw7ZeYXDwJ4LxoNCBNKbFvKoa98JlAJaKHrWyrmL
	 KDoyQ/wzhvULoezgvts+jhbrKPhteWRy5MKtUW6mXJm2c4vLVOF7saQhrC+8NAdqcC
	 8JCZH1HC06F2mZ8nVNaJZOPSoMCzN3fY0vWKgDpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Mierczuk <axel.mierczuk@1password.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0129/1674] net/sched: act_ct: avoid modifying shared unconfirmed ct entry
Date: Sat, 17 Oct 2026 17:40:01 +0200
Message-ID: <20261017160434.473546100@linuxfoundation.org>
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

[ Upstream commit f85009dfcd65e5969526b0db7a49b5413746e630 ]

In a case where skb with an unconfirmed ct entry gets cloned, we may
end up processing both again but with different sets of extensions.

The series of events:

 1. The first clone wants to commit and runs the helpers wiring up
    the extension pointer into the expectation list.
 2. Then it looses the confirmation keeping the entry unconfirmed.
 3. Second clone now wants to commit labels or run NAT and adds the
    new extension for that breaking the pointer in the expectation
    list causing UAF on the destruction path later.

While this is possible to trigger, there should be no practical
network pipeline where we need to process both clones without
modifications in the same zone.  So, let's just reset the entry in
case for some reason we got an skb with a shared one.  This doesn't
affect any known use cases, but avoids any potential problems with
sharing and modification of the unconfirmed ct entry.

Unlike openvswitch module, act_ct allows for NAT without commit.
Changing that would be a uAPI break.  So, act_ct needs to reset on NAT
regardless of the commit flag to avoid reallocation of the extension
space.  This, however, doesn't really change the picture for sensible
networking cases as there should be no need to run the same packet
twice (before and after the clone) through conntrack without packet
header or zone changes and without commit.

The fixes tag points to the introduction of helpers, since that's the
main UAF trigger for the sharing.

Fixes: a21b06e73191 ("net: sched: add helper support in act_ct")
Cc: stable@vger.kernel.org
Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260921145655.3167436-5-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 55e5c24cb4835..3393c8b174c0f 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -973,11 +973,11 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 				 struct tcf_result *res)
 {
 	struct net *net = dev_net(skb->dev);
+	bool cached, commit, clear, nat;
 	enum ip_conntrack_info ctinfo;
 	struct tcf_ct *c = to_ct(a);
 	struct nf_conn *tmpl = NULL;
 	struct nf_hook_state state;
-	bool cached, commit, clear;
 	int nh_ofs, err, retval;
 	struct tcf_ct_params *p;
 	bool add_helper = false;
@@ -992,6 +992,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	retval = READ_ONCE(c->tcf_action);
 	commit = p->ct_action & TCA_CT_ACT_COMMIT;
 	clear = p->ct_action & TCA_CT_ACT_CLEAR;
+	nat = p->ct_action & TCA_CT_ACT_NAT;
 	tmpl = p->tmpl;
 
 	tcf_lastuse_update(&c->tcf_tm);
@@ -1040,6 +1041,19 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	 * different zone.
 	 */
 	cached = tcf_ct_skb_nfct_cached(net, skb, p);
+
+	/* If the ct entry is not confirmed and shared with some other skb,
+	 * e.g., a cloned one, we can't just modify it with a commit or nat
+	 * as we must not modify the extension set.  Reset.
+	 */
+	if (cached && (commit || nat)) {
+		ct = nf_ct_get(skb, &ctinfo);
+		if (ct && !nf_ct_is_confirmed(ct) && nf_ct_shared(ct)) {
+			nf_reset_ct(skb);
+			cached = false;
+		}
+	}
+
 	if (!cached) {
 		if (tcf_ct_flow_table_lookup(p, skb, family)) {
 			skip_add = true;
@@ -1077,7 +1091,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		if (err)
 			goto drop;
 		add_helper = true;
-		if (p->ct_action & TCA_CT_ACT_NAT && !nfct_seqadj(ct)) {
+		if (nat && !nfct_seqadj(ct)) {
 			if (!nfct_seqadj_ext_add(ct))
 				goto drop;
 		}
-- 
2.53.0



