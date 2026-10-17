Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98703AFAE3;
	Sat, 17 Oct 2026 16:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256114; cv=none; b=fsCUNj6Jdx1bQC0kdBzzPAVZqL7+I5MhcHaZhzhxnPmzgbfeKVKdjAr2b7sgRffZJwTuNgj21cP9E09WRfeayp/3zGg138LUWU06LHPH4145oTf52Olp984cRQAprj1mL6uLy/RSC9bwUtuM9KGgiPkIm4CtwWaktJ8Ivm54xmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256114; c=relaxed/simple;
	bh=lcclyBpm4oXFaS86DHxio3qYgDhgCBR5X8BqTjxykhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pa1DY4eeoftJfRMGp1h80mrTZDz1MEORM5xVgy+4pSL9lj6abjgBFKj4FQAUn6ZMeRNqeTqvVEwP8kdRGLN+0DpECKyF6SksK61mec938qUGMgj6+KpE/Gqxtab3d+hiWrevnvWGEist/FFBUvoSUZ3z6ZdDwvNsuHNyq9PH+MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSagrMXU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSagrMXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D70E1F000C4;
	Sat, 17 Oct 2026 16:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256112;
	bh=5ViJoz73P2QetR62c0JRojBnvCB/b+JodqLIOEV4Lkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kSagrMXU09pu0WkjCqwfcROg/9RPkRQwknQ5MKPVnz5oNoIpXzgV4L3EpSiYO8SlN
	 p3apeTLtmbg2+ZvmUJZLvzrWjX4tAGO/3fCVLOlFWqZnG92dR1eQBYiijHpmPZ9VIb
	 6gsGOeBByvEAIVvIieJ6e1JC2yrJhEpVH6KRdAFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Aaron Conole <aconole@redhat.om>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0130/1674] openvswitch: prepare for stolen verdict coming from conntrack and nat engine
Date: Sat, 17 Oct 2026 17:40:02 +0200
Message-ID: <20261017160434.500473627@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c7f79f2620b7776586c626edf21eb6ed6ed3d1eb ]

At this time, conntrack either returns NF_ACCEPT or NF_DROP.
To improve debuging it would be nice to be able to replace NF_DROP
verdict with NF_DROP_REASON() helper,

This helper releases the skb instantly (so drop_monitor can pinpoint
precise location) and returns NF_STOLEN.

Prepare call sites to deal with this before introducing such changes
in conntrack and nat core.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Aaron Conole <aconole@redhat.om>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 1a4151e6be57 ("net: openvswitch: conntrack: fix helper UAF due to extensions realloc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 47 +++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 45a7ab66868f9..df48c4c90b8d9 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -679,6 +679,8 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 		action |= BIT(NF_NAT_MANIP_DST);
 
 	err = nf_ct_nat(skb, ct, ctinfo, &action, &info->range, info->commit);
+	if (err != NF_ACCEPT)
+		return err;
 
 	if (action & BIT(NF_NAT_MANIP_SRC))
 		ovs_nat_update_key(key, skb, NF_NAT_MANIP_SRC);
@@ -697,6 +699,22 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 }
 #endif
 
+static int verdict_to_errno(unsigned int verdict)
+{
+	switch (verdict & NF_VERDICT_MASK) {
+	case NF_ACCEPT:
+		return 0;
+	case NF_DROP:
+		return -EINVAL;
+	case NF_STOLEN:
+		return -EINPROGRESS;
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
 /* Pass 'skb' through conntrack in 'net', using zone configured in 'info', if
  * not done already.  Update key with new CT state after passing the packet
  * through conntrack.
@@ -747,7 +765,7 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 
 		err = nf_conntrack_in(skb, &state);
 		if (err != NF_ACCEPT)
-			return -ENOENT;
+			return verdict_to_errno(err);
 
 		/* Clear CT state NAT flags to mark that we have not yet done
 		 * NAT after the nf_conntrack_in() call.  We can actually clear
@@ -774,9 +792,12 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		 * the key->ct_state.
 		 */
 		if (info->nat && !(key->ct_state & OVS_CS_F_NAT_MASK) &&
-		    (nf_ct_is_confirmed(ct) || info->commit) &&
-		    ovs_ct_nat(net, key, info, skb, ct, ctinfo) != NF_ACCEPT) {
-			return -EINVAL;
+		    (nf_ct_is_confirmed(ct) || info->commit)) {
+			int err = ovs_ct_nat(net, key, info, skb, ct, ctinfo);
+
+			err = verdict_to_errno(err);
+			if (err)
+				return err;
 		}
 
 		/* Userspace may decide to perform a ct lookup without a helper
@@ -807,9 +828,12 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		 * - When committing an unconfirmed connection.
 		 */
 		if ((nf_ct_is_confirmed(ct) ? !cached || add_helper :
-					      info->commit) &&
-		    nf_ct_helper(skb, ct, ctinfo, info->family) != NF_ACCEPT) {
-			return -EINVAL;
+					      info->commit)) {
+			int err = nf_ct_helper(skb, ct, ctinfo, info->family);
+
+			err = verdict_to_errno(err);
+			if (err)
+				return err;
 		}
 
 		if (nf_ct_protonum(ct) == IPPROTO_TCP &&
@@ -1017,10 +1041,9 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
 	/* This will take care of sending queued events even if the connection
 	 * is already confirmed.
 	 */
-	if (nf_conntrack_confirm(skb) != NF_ACCEPT)
-		return -EINVAL;
+	err = nf_conntrack_confirm(skb);
 
-	return 0;
+	return verdict_to_errno(err);
 }
 
 /* Returns 0 on success, -EINPROGRESS if 'skb' is stolen, or other nonzero
@@ -1055,6 +1078,10 @@ int ovs_ct_execute(struct net *net, struct sk_buff *skb,
 	else
 		err = ovs_ct_lookup(net, key, info, skb);
 
+	/* conntrack core returned NF_STOLEN */
+	if (err == -EINPROGRESS)
+		return err;
+
 	skb_push_rcsum(skb, nh_ofs);
 	if (err)
 		ovs_kfree_skb_reason(skb, OVS_DROP_CONNTRACK);
-- 
2.53.0



