Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F27314D34;
	Mon, 17 Aug 2026 14:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975341; cv=none; b=nimVKSJ65VSFTw0kws7Y2N5+sLQB+mBg3ClFIs+QgxYybmUZ5ckU80erHCNzIahg9l5vasJwL0omLRppm9dcOgaqnK2ttBP6pGwcQkEoLEBm1GxleP6XUJhdwWggbRezftAIKMZciIVaSXtE93SV31EaQTFqdgSj/lAkTK1bJ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975341; c=relaxed/simple;
	bh=hkngG3DTEqmdEuu0yVpItnfl3TuXFKPIMpiyI+qCJe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmwUo1N7258HssPBkswz+yNubQjehvXuOhN7rzOTJfqE+4a7WseAjHyt19dCxRSxvWtwiCaoW+7dF5Wwl0tJ7lSG5U/EvProV9Buw3ijL9E4EpuVH8kUuhAWetZODmOd6fCoyurhj4xV9jSuEImgrd+V7Azn9HmY3WJZioNFFmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQ3eKJ4W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQ3eKJ4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4AA1F000E9;
	Mon, 17 Aug 2026 14:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975340;
	bh=fnAjxHc6Bt/Nwnnpu82yotiStAwHmU8QHaq5Sf7iQuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQ3eKJ4WJWhF6B2iMFWhTQ5fs2pxm6z1RMqSbtOKJpYcV9ZCIobFaun7GlmsxMG0a
	 ObT6khakI0KKvWivYLO8hSF8tZ/boVsw+/VhYDalJV1TEKj8jdvV40ldI61tlDHm/B
	 vE0sGkOqSIxs8dPKOvoZfjejN8avdkIh7K/0hjHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunjung Ko <hj351016@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 206/250] net/sched: act_gact, act_police: range check the fallback control action
Date: Mon, 17 Aug 2026 15:32:47 +0200
Message-ID: <20260817132544.953916818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Hyunjung Ko <hj351016@gmail.com>

commit 883b56ae58fe657d8497806c7059646e9ba6dbd0 upstream.

tcf_action_check_ctrlact() range checks the primary control action:

	if (!opcode)
		ret = action > TC_ACT_VALUE_MAX ? -EINVAL : 0;

TC_ACT_VALUE_MAX is TC_ACT_TRAP, so kernel-internal verdicts above it
cannot be set that way. But act_gact and act_police each carry a second,
independent control action supplied by user space that never reaches that
helper - TCA_GACT_PROB.paction and TCA_POLICE_RESULT. Both only reject
TC_ACT_GOTO_CHAIN, so any other value is stored verbatim and returned
verbatim from the action.

In particular user space can store TC_ACT_CONSUMED, which is
TC_ACT_VALUE_MAX + 1 and is deliberately not part of the UAPI value
range. That verdict tells every caller the action took ownership of the
skb, so nobody frees it: sch_handle_ingress(), sch_handle_egress() and
tcf_qevent_handle() all deliberately skip the free for it. The result is
one leaked sk_buff plus its data buffer per packet traversing the filter,
unbounded, for all traffic on the chain including kernel-generated
packets.

Both are trivially deterministic. act_gact clamps tcfg_pval to >= 1, so
with pval = 1 gact_determ() returns the fallback for every packet.
act_police has no mandatory rate, so rate = 0 leaves tcfp_mtu = ~0 and
tcf_police_mtu_check() always passes.

TC_ACT_CONSUMED was added by commit 720f22fed81b ("net: sched: refactor
reinsert action"), after both goto-chain guards were written:
commit 9469f375ab09 ("net/sched: act_gact: disallow 'goto chain' on
fallback control action") and
commit c08f5ed5d625 ("net/sched: act_police: disallow 'goto chain' on
fallback control action"). Neither guard was widened when the new
verdict appeared.

Factor the existing range test out of tcf_action_check_ctrlact() as
tcf_action_valid() and apply it to both fallbacks. The helper cannot call
tcf_action_check_ctrlact() directly because that also allocates a
goto_chain, which is exactly what these two sites must not do.

Reproduced on v7.2-rc6: kmemleak reports one leaked 232-byte
skbuff_head_cache object plus its 704-byte data buffer per packet. With
this patch both configurations are rejected with -EINVAL and kmemleak
reports none.

Fixes: 720f22fed81b ("net: sched: refactor reinsert action")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Hyunjung Ko <hj351016@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260806101252.809593-1-hj351016@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/act_api.h  |   19 +++++++++++++++++++
 net/sched/act_gact.c   |    5 +++++
 net/sched/act_police.c |    6 ++++++
 3 files changed, 30 insertions(+)

--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -270,6 +270,25 @@ int tcf_action_check_ctrlact(int action,
 struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
 					 struct tcf_chain *newchain);
 
+/* Range check for a control action supplied by user space.
+ *
+ * This is the same test tcf_action_check_ctrlact() applies to the primary
+ * control action, factored out for the *fallback* control actions
+ * (act_gact's TCA_GACT_PROB.paction and act_police's TCA_POLICE_RESULT),
+ * which must not reach tcf_action_check_ctrlact() because they have no
+ * goto_chain to allocate.  Without it, user space can store kernel-internal
+ * verdicts such as TC_ACT_CONSUMED, which is TC_ACT_VALUE_MAX + 1 and is
+ * deliberately not part of the UAPI value range.
+ */
+static inline bool tcf_action_valid(int action)
+{
+	int opcode = TC_ACT_EXT_OPCODE(action);
+
+	if (!opcode)
+		return action <= TC_ACT_VALUE_MAX;
+	return opcode <= TC_ACT_EXT_OPCODE_MAX || action == TC_ACT_UNSPEC;
+}
+
 #ifdef CONFIG_INET
 DECLARE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
 #endif
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -89,6 +89,11 @@ static int tcf_gact_init(struct net *net
 		p_parm = nla_data(tb[TCA_GACT_PROB]);
 		if (p_parm->ptype >= MAX_RAND)
 			return -EINVAL;
+		if (!tcf_action_valid(p_parm->paction)) {
+			NL_SET_ERR_MSG(extack,
+				       "invalid fallback control action");
+			return -EINVAL;
+		}
 		if (TC_ACT_EXT_CMP(p_parm->paction, TC_ACT_GOTO_CHAIN)) {
 			NL_SET_ERR_MSG(extack,
 				       "goto chain not allowed on fallback");
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -128,6 +128,12 @@ static int tcf_police_init(struct net *n
 
 	if (tb[TCA_POLICE_RESULT]) {
 		tcfp_result = nla_get_u32(tb[TCA_POLICE_RESULT]);
+		if (!tcf_action_valid(tcfp_result)) {
+			NL_SET_ERR_MSG(extack,
+				       "invalid fallback control action");
+			err = -EINVAL;
+			goto failure;
+		}
 		if (TC_ACT_EXT_CMP(tcfp_result, TC_ACT_GOTO_CHAIN)) {
 			NL_SET_ERR_MSG(extack,
 				       "goto chain not allowed on fallback");


