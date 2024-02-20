Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80D8446C9;
	Tue, 20 Feb 2024 21:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465044; cv=none; b=hnsmoPdLM+bgg8Km1ZolrXSeLybrJESNHmHRdiwTxVndj2jBiPyhnZkJST6Yviu8uX8dKdxNq+iMmSyLI7GYE8bB8cjp5HGolFiw1srlKgd2hVpRxfEKHNLMbyLfkUHnqH5RZICep0L97kEVTL6+/MY3IMXtE6B9gZHIUaYvGx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465044; c=relaxed/simple;
	bh=mUYCnNljdo9AYYXGiFZhiGacEtQgl51HVDGGu8Wc5r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXJS0zeL2mM2dpVfs+EloUSC+UIt0jac/G1plNM6tw31DgsO9zSBUCBgIpcKrqW1GpT55z3KwtaNyBPaqRD67bKo+ilrjwFFKhoxaWANRCb/tC5c5gVgiCq8O7TOpz63cWGJy6nq6hMtBBR6wuXktTLQK9/F2oMmAH4ag+OQt50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6ixGYzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6ixGYzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17408C433F1;
	Tue, 20 Feb 2024 21:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465044;
	bh=mUYCnNljdo9AYYXGiFZhiGacEtQgl51HVDGGu8Wc5r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6ixGYzEHVCqIewvCDwbe+XpYWGak0xEbJqmjGJa+L/K4hFIvmzIFGVkXO6b12fyu
	 qZKgJU3sbRlTo8U/mp3lAPtdo5AGVn9JkCaGKpL4g/1bYg5zvyXkZS1F2Xmai2UxSO
	 v9gk1aq+/gQjpBzmK5C8FpbQFZbMpWPE3xNCb0jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Zhou <hui.zhou@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 218/309] nfp: flower: add hardware offload check for post ct entry
Date: Tue, 20 Feb 2024 21:56:17 +0100
Message-ID: <20240220205639.985058094@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Zhou <hui.zhou@corigine.com>

commit cefa98e806fd4e2a5e2047457a11ae5f17b8f621 upstream.

The nfp offload flow pay will not allocate a mask id when the out port
is openvswitch internal port. This is because these flows are used to
configure the pre_tun table and are never actually send to the firmware
as an add-flow message. When a tc rule which action contains ct and
the post ct entry's out port is openvswitch internal port, the merge
offload flow pay with the wrong mask id of 0 will be send to the
firmware. Actually, the nfp can not support hardware offload for this
situation, so return EOPNOTSUPP.

Fixes: bd0fe7f96a3c ("nfp: flower-ct: add zone table entry when handling pre/post_ct flows")
CC: stable@vger.kernel.org # 5.14+
Signed-off-by: Hui Zhou <hui.zhou@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Link: https://lore.kernel.org/r/20240124151909.31603-2-louis.peens@corigine.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/flower/conntrack.c |   22 +++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -1864,10 +1864,30 @@ int nfp_fl_ct_handle_post_ct(struct nfp_
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	struct nfp_fl_ct_flow_entry *ct_entry;
+	struct flow_action_entry *ct_goto;
 	struct nfp_fl_ct_zone_entry *zt;
+	struct flow_action_entry *act;
 	bool wildcarded = false;
 	struct flow_match_ct ct;
-	struct flow_action_entry *ct_goto;
+	int i;
+
+	flow_action_for_each(i, act, &rule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_REDIRECT:
+		case FLOW_ACTION_REDIRECT_INGRESS:
+		case FLOW_ACTION_MIRRED:
+		case FLOW_ACTION_MIRRED_INGRESS:
+			if (act->dev->rtnl_link_ops &&
+			    !strcmp(act->dev->rtnl_link_ops->kind, "openvswitch")) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "unsupported offload: out port is openvswitch internal port");
+				return -EOPNOTSUPP;
+			}
+			break;
+		default:
+			break;
+		}
+	}
 
 	flow_rule_match_ct(rule, &ct);
 	if (!ct.mask->ct_zone) {


