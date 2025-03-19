Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464F71D5CE7;
	Wed, 19 Mar 2025 14:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394860; cv=none; b=fWOc/ielcTzYYIAoVYEdMCfc8t6jA1UnX9wiI7tUWc9+USD0QDmDKpyu2Jm9bK2smbpJCQLsKnFKYpjHAZp/CgUhL7+58vl2ghmxF+2d9dXKsX35yvzxUDbz9UFBqjJss2HuBB3bWP+k45uxuZwTkHJzdwxEKrCDMwbY78buFzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394860; c=relaxed/simple;
	bh=lt01i60LJ+XF21OoySeYUt2oYmdFLQBpOFT5Y/dIhlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G6t9S2mG00n6sId9WEanTEmTPg//qXDEAMzG5IH+3o3TwKIrDfh1OMt+WY/V7kjySRBEgBeq3VwJdm012+SSZG8p+8BU4nfSqf3YCrogV7lKTfE0Zy3KQz3P/MaD70KYSFrb7J6AQLOTjxI26vuw+dPoJ+HEuDPMgYylzPGejV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQLRq0LN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQLRq0LN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C51C4CEE9;
	Wed, 19 Mar 2025 14:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394860;
	bh=lt01i60LJ+XF21OoySeYUt2oYmdFLQBpOFT5Y/dIhlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQLRq0LN0+UfmlxRuMYRR47wle9k7BHfda82SnonHo4yxtI+aO5BizV25nT7OY91E
	 2y9RSqKr9bRqGwF+hh6YzPM1PZJnNp6ZlNgstneEyaZCPtGV0ezHFeqHyDgxEI4EFb
	 vqV0SDFB4BR0tOha3y0fR2820BRBQ6qeBRQsP9/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Xin Long <lucien.xin@gmail.com>,
	Aaron Conole <aconole@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 050/241] Revert "openvswitch: switch to per-action label counting in conntrack"
Date: Wed, 19 Mar 2025 07:28:40 -0700
Message-ID: <20250319143028.965568105@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 1063ae07383c0ddc5bcce170260c143825846b03 ]

Currently, ovs_ct_set_labels() is only called for confirmed conntrack
entries (ct) within ovs_ct_commit(). However, if the conntrack entry
does not have the labels_ext extension, attempting to allocate it in
ovs_ct_get_conn_labels() for a confirmed entry triggers a warning in
nf_ct_ext_add():

  WARN_ON(nf_ct_is_confirmed(ct));

This happens when the conntrack entry is created externally before OVS
increments net->ct.labels_used. The issue has become more likely since
commit fcb1aa5163b1 ("openvswitch: switch to per-action label counting
in conntrack"), which changed to use per-action label counting and
increment net->ct.labels_used when a flow with ct action is added.

Since there’s no straightforward way to fully resolve this issue at the
moment, this reverts the commit to avoid breaking existing use cases.

Fixes: fcb1aa5163b1 ("openvswitch: switch to per-action label counting in conntrack")
Reported-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/1bdeb2f3a812bca016a225d3de714427b2cd4772.1741457143.git.lucien.xin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 30 ++++++++++++++++++------------
 net/openvswitch/datapath.h  |  3 +++
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 3bb4810234aac..e573e92213029 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1368,8 +1368,11 @@ bool ovs_ct_verify(struct net *net, enum ovs_key_attr attr)
 	    attr == OVS_KEY_ATTR_CT_MARK)
 		return true;
 	if (IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS) &&
-	    attr == OVS_KEY_ATTR_CT_LABELS)
-		return true;
+	    attr == OVS_KEY_ATTR_CT_LABELS) {
+		struct ovs_net *ovs_net = net_generic(net, ovs_net_id);
+
+		return ovs_net->xt_label;
+	}
 
 	return false;
 }
@@ -1378,7 +1381,6 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 		       const struct sw_flow_key *key,
 		       struct sw_flow_actions **sfa,  bool log)
 {
-	unsigned int n_bits = sizeof(struct ovs_key_ct_labels) * BITS_PER_BYTE;
 	struct ovs_conntrack_info ct_info;
 	const char *helper = NULL;
 	u16 family;
@@ -1407,12 +1409,6 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 		return -ENOMEM;
 	}
 
-	if (nf_connlabels_get(net, n_bits - 1)) {
-		nf_ct_tmpl_free(ct_info.ct);
-		OVS_NLERR(log, "Failed to set connlabel length");
-		return -EOPNOTSUPP;
-	}
-
 	if (ct_info.timeout[0]) {
 		if (nf_ct_set_timeout(net, ct_info.ct, family, key->ip.proto,
 				      ct_info.timeout))
@@ -1581,7 +1577,6 @@ static void __ovs_ct_free_action(struct ovs_conntrack_info *ct_info)
 	if (ct_info->ct) {
 		if (ct_info->timeout[0])
 			nf_ct_destroy_timeout(ct_info->ct);
-		nf_connlabels_put(nf_ct_net(ct_info->ct));
 		nf_ct_tmpl_free(ct_info->ct);
 	}
 }
@@ -2006,9 +2001,17 @@ struct genl_family dp_ct_limit_genl_family __ro_after_init = {
 
 int ovs_ct_init(struct net *net)
 {
-#if	IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT)
+	unsigned int n_bits = sizeof(struct ovs_key_ct_labels) * BITS_PER_BYTE;
 	struct ovs_net *ovs_net = net_generic(net, ovs_net_id);
 
+	if (nf_connlabels_get(net, n_bits - 1)) {
+		ovs_net->xt_label = false;
+		OVS_NLERR(true, "Failed to set connlabel length");
+	} else {
+		ovs_net->xt_label = true;
+	}
+
+#if	IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT)
 	return ovs_ct_limit_init(net, ovs_net);
 #else
 	return 0;
@@ -2017,9 +2020,12 @@ int ovs_ct_init(struct net *net)
 
 void ovs_ct_exit(struct net *net)
 {
-#if	IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT)
 	struct ovs_net *ovs_net = net_generic(net, ovs_net_id);
 
+#if	IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT)
 	ovs_ct_limit_exit(net, ovs_net);
 #endif
+
+	if (ovs_net->xt_label)
+		nf_connlabels_put(net);
 }
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 365b9bb7f546e..9ca6231ea6470 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -160,6 +160,9 @@ struct ovs_net {
 #if	IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT)
 	struct ovs_ct_limit_info *ct_limit_info;
 #endif
+
+	/* Module reference for configuring conntrack. */
+	bool xt_label;
 };
 
 /**
-- 
2.39.5



