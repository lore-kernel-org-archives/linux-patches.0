Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC3C612D7;
	Tue, 20 Feb 2024 21:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463989; cv=none; b=a/KEOJ0V6/h8nkSOVSZI6Ek8gYwzSiiRl6uggqbLuDH+zG7PwyUSIM82/Yi9285Z/ahrRX5PbPuEZtPTHrYx39iQ3V1xKmbk6zYkqdJi/nUwZrMsGy0KMUIZQk02krweLyV+hb7A+GI/3nXOirFq2ztY+IwAECU1r58mpUs0ONo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463989; c=relaxed/simple;
	bh=fPN3dCNE5XZa4p2nRb4FQ19eA5qAJviBbstl9/8yrdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozTu23sKlflxuxvkL51PbtKWzjM88i/W8vyQITestN+FU3++RtB7fK8X5bIseyecUfy06efLoRiJ/6+MS8KQK+0Pw5lP3SAb8tVrLP9/wH99F/JCeULhXqMffvSXMckg0RCwhyA/RHbeU90l5gK/wHdeDxVKGmMOOvjA4mvXNqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RaiLsLS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RaiLsLS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4914FC433C7;
	Tue, 20 Feb 2024 21:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463988;
	bh=fPN3dCNE5XZa4p2nRb4FQ19eA5qAJviBbstl9/8yrdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RaiLsLS4n2WC73IVGT0gOlpj9wmyisfbp2mw44y52/zaP1F4iPjWbcgz9T8K7WIDF
	 HGY0yQL1Lb4A1/J9ABjOqLDcnss2WIgxOx+U8EiuVo6+mzTxPE+YJvBar/gmiEaTs5
	 gz4/+oz8jli2YFNMKaQnODJmQ0+4YztYuEyMRsGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Zhou <hui.zhou@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 177/331] nfp: flower: add hardware offload check for post ct entry
Date: Tue, 20 Feb 2024 21:54:53 +0100
Message-ID: <20240220205643.076418376@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


