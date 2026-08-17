Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AA6427FB2;
	Mon, 17 Aug 2026 14:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975915; cv=none; b=aEem4PPm5FQpCbnkLa0Rmnm5jlCuyju/Xy7JE1SAcDb6F5HJkAgtW6efs9ytGgieLuHGSTNxZ8zcJ16jzX4UC4T6bqjSqvy0XiDr2PPABQ7LjhxfMkRCpKgQR/pQj4DzrFy/FOp+KAW5Clp0c9bcwSwr2ZTW8Q2m/CTHBQUVLCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975915; c=relaxed/simple;
	bh=uFYuj9Ls/5pWDTZauoCZYfPJpZGb7R/5j3g4fMk4Ie8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8jaicZWHoAaToYCwK05I55hgP5Jgfg7XlxII+LsftSMaW3hhR2i2rk50d0mNVMDWMuZ3RFrs7oWidD7piVUDHAYdb+nZ8MWlKNYAzhU+Qqbg1ogJFR+W1e3iqLgEN3dFXoiq7ya/VSDd7APEi46bzNZtCA7KlyLz+c3C/mSVks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJhPxMOe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJhPxMOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C99C1F000E9;
	Mon, 17 Aug 2026 14:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975913;
	bh=CCYS+J/RBSaIYngPZtnTsyGIqR3PPFLS+EQHiMTD+Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vJhPxMOe3ntkF6ih91AVd5+jxGwNtLKijWj6PIhS274swuTd+idsvuiisNJqAT9hn
	 uTjvmZrqEtC0KkoM4E+MnGSzXXGH9zGSwYkzDdcbI5ajvj7tYiqRq2pG6I+ieMKZbz
	 wzAbrLpNRzSu9lxpnH6uVMO5llL8+pCRflsB2Mdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/389] openvswitch: fix GSO userspace truncation underflow
Date: Mon, 17 Aug 2026 15:30:29 +0200
Message-ID: <20260817132546.623474107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 4032f8ed10fcb84d41c508dfb04be96589f78dfe ]

OVS_ACTION_ATTR_TRUNC currently stores a delta from the original skb
length in OVS_CB(skb)->cutlen. When a later userspace action segments a
GSO skb, queue_gso_packets() reuses that delta for each smaller segment.
A segment can then reach queue_userspace_packet() with cutlen greater
than skb->len, underflowing the length passed to skb_zerocopy().

Store the maximum preserved length instead and bound each consumer
against the current skb length. Use U32_MAX as the no-truncation
sentinel so the value remains valid if skb geometry changes before a
consumer handles it.

Fixes: f2a4d086ed4c ("openvswitch: Add packet truncation support.")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260707221635.27489-1-kylebot@openai.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[5.10.y supports neither OVS_ACTION_ATTR_PSAMPLE nor OVS drop reasons]
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c  |   15 +++++----------
 net/openvswitch/datapath.c |   25 ++++++++++++++-----------
 net/openvswitch/datapath.h |    2 +-
 net/openvswitch/vport.c    |    2 +-
 4 files changed, 21 insertions(+), 23 deletions(-)

--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -855,12 +855,8 @@ static void do_output(struct datapath *d
 		u16 mru = OVS_CB(skb)->mru;
 		u32 cutlen = OVS_CB(skb)->cutlen;
 
-		if (unlikely(cutlen > 0)) {
-			if (skb->len - cutlen > ovs_mac_header_len(key))
-				pskb_trim(skb, skb->len - cutlen);
-			else
-				pskb_trim(skb, ovs_mac_header_len(key));
-		}
+		if (unlikely(cutlen < skb->len))
+			pskb_trim(skb, max(cutlen, ovs_mac_header_len(key)));
 
 		if (likely(!mru ||
 		           (skb->len <= mru + vport->dev->hard_header_len))) {
@@ -1232,22 +1228,21 @@ static int do_execute_actions(struct dat
 			clone = skb_clone(skb, GFP_ATOMIC);
 			if (clone)
 				do_output(dp, clone, port, key);
-			OVS_CB(skb)->cutlen = 0;
+			OVS_CB(skb)->cutlen = U32_MAX;
 			break;
 		}
 
 		case OVS_ACTION_ATTR_TRUNC: {
 			struct ovs_action_trunc *trunc = nla_data(a);
 
-			if (skb->len > trunc->max_len)
-				OVS_CB(skb)->cutlen = skb->len - trunc->max_len;
+			OVS_CB(skb)->cutlen = trunc->max_len;
 			break;
 		}
 
 		case OVS_ACTION_ATTR_USERSPACE:
 			output_userspace(dp, skb, key, a, attr,
 						     len, OVS_CB(skb)->cutlen);
-			OVS_CB(skb)->cutlen = 0;
+			OVS_CB(skb)->cutlen = U32_MAX;
 			break;
 
 		case OVS_ACTION_ATTR_HASH:
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -240,7 +240,7 @@ void ovs_dp_process_packet(struct sk_buf
 		upcall.cmd = OVS_PACKET_CMD_MISS;
 		upcall.portid = ovs_vport_find_upcall_portid(p, skb);
 		upcall.mru = OVS_CB(skb)->mru;
-		error = ovs_dp_upcall(dp, skb, key, &upcall, 0);
+		error = ovs_dp_upcall(dp, skb, key, &upcall, U32_MAX);
 		switch (error) {
 		case 0:
 		case -EAGAIN:
@@ -400,7 +400,8 @@ static int queue_userspace_packet(struct
 	struct sk_buff *nskb = NULL;
 	struct sk_buff *user_skb = NULL; /* to be queued to userspace */
 	struct nlattr *nla;
-	size_t len;
+	size_t msg_size;
+	size_t skb_len;
 	unsigned int hlen;
 	int err, dp_ifindex;
 	u64 hash;
@@ -421,7 +422,8 @@ static int queue_userspace_packet(struct
 		skb = nskb;
 	}
 
-	if (nla_attr_size(skb->len) > USHRT_MAX) {
+	skb_len = min(skb->len, cutlen);
+	if (nla_attr_size(skb_len) > USHRT_MAX) {
 		err = -EFBIG;
 		goto out;
 	}
@@ -436,13 +438,13 @@ static int queue_userspace_packet(struct
 	 * padding logic. Only perform zerocopy if padding is not required.
 	 */
 	if (dp->user_features & OVS_DP_F_UNALIGNED)
-		hlen = skb_zerocopy_headlen(skb);
+		hlen = min(skb_zerocopy_headlen(skb), cutlen);
 	else
-		hlen = skb->len;
+		hlen = skb_len;
 
-	len = upcall_msg_size(upcall_info, hlen - cutlen,
-			      OVS_CB(skb)->acts_origlen);
-	user_skb = genlmsg_new(len, GFP_ATOMIC);
+	msg_size = upcall_msg_size(upcall_info, hlen,
+				   OVS_CB(skb)->acts_origlen);
+	user_skb = genlmsg_new(msg_size, GFP_ATOMIC);
 	if (!user_skb) {
 		err = -ENOMEM;
 		goto out;
@@ -503,7 +505,7 @@ static int queue_userspace_packet(struct
 	}
 
 	/* Add OVS_PACKET_ATTR_LEN when packet is truncated */
-	if (cutlen > 0 &&
+	if (skb_len < skb->len &&
 	    nla_put_u32(user_skb, OVS_PACKET_ATTR_LEN, skb->len)) {
 		err = -ENOBUFS;
 		goto out;
@@ -528,9 +530,9 @@ static int queue_userspace_packet(struct
 		err = -ENOBUFS;
 		goto out;
 	}
-	nla->nla_len = nla_attr_size(skb->len - cutlen);
+	nla->nla_len = nla_attr_size(skb_len);
 
-	err = skb_zerocopy(user_skb, skb, skb->len - cutlen, hlen);
+	err = skb_zerocopy(user_skb, skb, skb_len, hlen);
 	if (err)
 		goto out;
 
@@ -587,6 +589,7 @@ static int ovs_packet_cmd_execute(struct
 		packet->ignore_df = 1;
 	}
 	OVS_CB(packet)->mru = mru;
+	OVS_CB(packet)->cutlen = U32_MAX;
 
 	if (a[OVS_PACKET_ATTR_HASH]) {
 		hash = nla_get_u64(a[OVS_PACKET_ATTR_HASH]);
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -96,7 +96,7 @@ struct datapath {
  * @mru: The maximum received fragement size; 0 if the packet is not
  * fragmented.
  * @acts_origlen: The netlink size of the flow actions applied to this skb.
- * @cutlen: The number of bytes from the packet end to be removed.
+ * @cutlen: The number of bytes in the packet to preserve on output.
  */
 struct ovs_skb_cb {
 	struct vport		*input_vport;
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -436,7 +436,7 @@ int ovs_vport_receive(struct vport *vpor
 
 	OVS_CB(skb)->input_vport = vport;
 	OVS_CB(skb)->mru = 0;
-	OVS_CB(skb)->cutlen = 0;
+	OVS_CB(skb)->cutlen = U32_MAX;
 	if (unlikely(dev_net(skb->dev) != ovs_dp_get_net(vport->dp))) {
 		u32 mark;
 


