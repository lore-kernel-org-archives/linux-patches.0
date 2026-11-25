Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623833;
	b=Xpfw6a1DodaOkvIb8Lt8doOX9u4PPthFN5HFTz/nu41LAGfBzYvLBzYjbIhPi8jliLTq
	 5SEOoXDOFCRhlbzEahJBF+SLVLdKIUWK4M0yeoxEtXtfAWMk4WU/q55LvlylczWPSmOBM
	 JxVMIBrl1V60y2IEoC2Nr2NwY8E9mZ4LUb+kskpAVS5zHeZNq+bV5i0fKQ8VjyL3GFPQh
	 kE4qWhIrgUJBED7QhX3nshVuVu4T9c/PYVc32FguH7C/zGb73QV+qs1YMn7AhLrUi1tLd
	 GineZ+69TwUERjqmwD7HK9KPoBxfzmL7y8SDzLUickUbzu6Vxn+UFS+y80q4qPND36w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xcQbhktTT9Yy/dGea+gDIX27Cns3o+wcAAxGHIUGlPc=;
	b=DGdDnxvrCs5Xg9KH5NrRmcswKaPB/jSmzwEUJDLzN8XVpMHTCDC6ciswI1U2RPSZVSpt
	 EUvuWGtKUpgaNYGYHZ65kfJ+rM3UcOHVcYYyXDdTzRg+ptCWt+AVqjSynqsXHiakBxnXX
	 fjB9V0H20MitVObtdc1Qmlgerp8wa1yO14bM7mfn9Q5zdKdZoC4xe7pzb/3ly0XOXVq1K
	 SSa9VlJ0nwpbWLiZN8Hpg2y6Xm3sHr77uthX/vRZrmGZM4OK972f0rxEkX2PuuY1P12WM
	 uBSBAg5n3J2O6bHkeKEBPLhMFRHfvN9dMWkofow3gtgs+QjcuYTzE/60WJ5vPAfviIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v6RTGLvm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9AB606A31E;
	Wed, 25 Nov 2026 16:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v6RTGLvm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0431F000C4;
	Wed, 25 Nov 2026 16:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623833;
	bh=xcQbhktTT9Yy/dGea+gDIX27Cns3o+wcAAxGHIUGlPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v6RTGLvmxJ480owFQmmhvU6Pk6DwNJVmAnxh56WW0FzyMXtvyBelCQkqEV8GFuLC0
	 eKcpFouRHciB1nve7w+Rm+4n9j9/RonOd6U5q9c3CLEAk/5JomLd/Wcq8sG9/068lr
	 YgR6n6NrDLIyD9shO0AT+M8Axx04blJDiK8wqVbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 987/990] seg6: ensure packet data is writable before modifying SRH and IPv6 DA
Date: Wed, 25 Nov 2026 15:39:14 +0100
Message-ID: <20261125143845.096696115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Mayer <andrea.mayer@uniroma2.it>

commit 8ae3f4067ba4ae3a15581392f6dac422e3d3def0 upstream.

advance_nextseg() modifies the SRH Segments Left field and the IPv6
destination address without ensuring the packet data is writable.
seg6_next_csid_advance_arg() has the same problem when it advances the
NEXT-C-SID argument in the destination address.

The skb may be cloned, for example by an AF_PACKET socket receiving on
the ingress device. advance_nextseg() and seg6_next_csid_advance_arg()
then write into the packet data shared with the clone. A read from that
socket can return the modified packet instead of the received one. The
simplified path below shows this for advance_nextseg():

__netif_receive_skb_one_core
  __netif_receive_skb_core
    deliver_skb               [orig: users=2, cloned=0]
      packet_rcv
        skb_clone             clone queued to the AF_PACKET socket
        consume_skb(orig)     [orig: users=1, cloned=1]
  ipv6_rcv
    ip6_rcv_core              skb_share_check: no-op [orig: users=1]
    [...]
      input_action_end_core
        advance_nextseg       writes into the data shared with the clone

Call skb_ensure_writable() in advance_nextseg() and in
seg6_next_csid_advance_arg() before they modify the packet data.
skb_ensure_writable() may reallocate skb->head, which invalidates the
pointers into the packet data taken before the call.
advance_nextseg() now returns a valid SRH pointer, or NULL if
skb_ensure_writable() fails.
seg6_next_csid_advance_arg() takes the pointer to the destination
address from the skb after skb_ensure_writable().
On failure, the callers drop the packet with SKB_DROP_REASON_NOMEM.

Fixes: 140f04c33bbc ("ipv6: sr: implement several seg6local actions")
Fixes: 848f3c0d4769 ("seg6: add NEXT-C-SID support for SRv6 End behavior")
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20260925133807.32-1-andrea.mayer@uniroma2.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6_local.c |  140 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 117 insertions(+), 23 deletions(-)

--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -292,13 +292,43 @@ static bool decap_and_validate(struct sk
 	return true;
 }
 
-static void advance_nextseg(struct ipv6_sr_hdr *srh, struct in6_addr *daddr)
+/* advance the SRH to the next segment and set the IPv6 DA accordingly.
+ * skb pointers may change: after this call, the caller must evaluate again
+ * any pointer into the packet data.
+ *
+ * This function returns:
+ *  - the SRH on success;
+ *  - NULL when the skb cannot be made writable. In this case, the function
+ *    sets the drop reason to SKB_DROP_REASON_NOMEM.
+ */
+static struct ipv6_sr_hdr *advance_nextseg(struct sk_buff *skb,
+					   struct ipv6_sr_hdr *srh,
+					   enum skb_drop_reason *reason)
 {
 	struct in6_addr *addr;
+	int srhoff;
+	int wlen;
+
+	srhoff = (unsigned char *)srh - skb->data;
+	/* we write only the Segment Left field and the IPv6 DA. The segment
+	 * list is only read, and seg6_get_srh() already pulled it into the
+	 * linear area.
+	 */
+	wlen = srhoff + sizeof(*srh);
+
+	if (unlikely(skb_ensure_writable(skb, wlen))) {
+		*reason = SKB_DROP_REASON_NOMEM;
+		return NULL;
+	}
+
+	/* skb_ensure_writable() may change skb pointers; evaluate srh again */
+	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
 
 	srh->segments_left--;
 	addr = srh->segments + srh->segments_left;
-	*daddr = *addr;
+	ipv6_hdr(skb)->daddr = *addr;
+
+	return srh;
 }
 
 static int
@@ -396,12 +426,26 @@ static bool seg6_next_csid_is_arg_zero(c
 	return true;
 }
 
-/* assume that DA.Argument length > 0 */
-static void seg6_next_csid_advance_arg(struct in6_addr *addr,
-				       const struct seg6_flavors_info *finfo)
+/* assume that DA.Argument length > 0.
+ * skb pointers may change: after this call, the caller must evaluate again
+ * any pointer into the packet data.
+ *
+ * This function returns:
+ *  - SKB_NOT_DROPPED_YET on success;
+ *  - SKB_DROP_REASON_NOMEM when the skb cannot be made writable.
+ */
+static enum skb_drop_reason
+seg6_next_csid_advance_arg(struct sk_buff *skb,
+			   const struct seg6_flavors_info *finfo)
 {
 	__u8 fnc_octects = seg6_flv_lcnode_func_octects(finfo);
 	__u8 blk_octects = seg6_flv_lcblock_octects(finfo);
+	struct in6_addr *addr;
+
+	if (unlikely(skb_ensure_writable(skb, sizeof(struct ipv6hdr))))
+		return SKB_DROP_REASON_NOMEM;
+
+	addr = &ipv6_hdr(skb)->daddr;
 
 	/* advance DA.Argument */
 	memmove(&addr->s6_addr[blk_octects],
@@ -409,6 +453,8 @@ static void seg6_next_csid_advance_arg(s
 		16 - blk_octects - fnc_octects);
 
 	memset(&addr->s6_addr[16 - fnc_octects], 0x00, fnc_octects);
+
+	return SKB_NOT_DROPPED_YET;
 }
 
 static int input_action_end_finish(struct sk_buff *skb,
@@ -422,31 +468,42 @@ static int input_action_end_finish(struc
 static int input_action_end_core(struct sk_buff *skb,
 				 struct seg6_local_lwt *slwt)
 {
+	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct ipv6_sr_hdr *srh;
+	int err = -EINVAL;
 
 	srh = get_and_validate_srh(skb);
 	if (!srh)
 		goto drop;
 
-	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	srh = advance_nextseg(skb, srh, &reason);
+	if (!srh) {
+		err = -ENOMEM;
+		goto drop;
+	}
 
 	return input_action_end_finish(skb, slwt);
 
 drop:
-	kfree_skb(skb);
-	return -EINVAL;
+	kfree_skb_reason(skb, reason);
+	return err;
 }
 
 static int end_next_csid_core(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 {
 	const struct seg6_flavors_info *finfo = &slwt->flv_info;
 	struct in6_addr *daddr = &ipv6_hdr(skb)->daddr;
+	enum skb_drop_reason reason;
 
 	if (seg6_next_csid_is_arg_zero(daddr, finfo))
 		return input_action_end_core(skb, slwt);
 
 	/* update DA */
-	seg6_next_csid_advance_arg(daddr, finfo);
+	reason = seg6_next_csid_advance_arg(skb, finfo);
+	if (reason) {
+		kfree_skb_reason(skb, reason);
+		return -ENOMEM;
+	}
 
 	return input_action_end_finish(skb, slwt);
 }
@@ -462,19 +519,25 @@ static int input_action_end_x_finish(str
 static int input_action_end_x_core(struct sk_buff *skb,
 				   struct seg6_local_lwt *slwt)
 {
+	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct ipv6_sr_hdr *srh;
+	int err = -EINVAL;
 
 	srh = get_and_validate_srh(skb);
 	if (!srh)
 		goto drop;
 
-	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	srh = advance_nextseg(skb, srh, &reason);
+	if (!srh) {
+		err = -ENOMEM;
+		goto drop;
+	}
 
 	return input_action_end_x_finish(skb, slwt);
 
 drop:
-	kfree_skb(skb);
-	return -EINVAL;
+	kfree_skb_reason(skb, reason);
+	return err;
 }
 
 static int end_x_next_csid_core(struct sk_buff *skb,
@@ -482,12 +545,17 @@ static int end_x_next_csid_core(struct s
 {
 	const struct seg6_flavors_info *finfo = &slwt->flv_info;
 	struct in6_addr *daddr = &ipv6_hdr(skb)->daddr;
+	enum skb_drop_reason reason;
 
 	if (seg6_next_csid_is_arg_zero(daddr, finfo))
 		return input_action_end_x_core(skb, slwt);
 
 	/* update DA */
-	seg6_next_csid_advance_arg(daddr, finfo);
+	reason = seg6_next_csid_advance_arg(skb, finfo);
+	if (reason) {
+		kfree_skb_reason(skb, reason);
+		return -ENOMEM;
+	}
 
 	return input_action_end_x_finish(skb, slwt);
 }
@@ -774,10 +842,12 @@ pull:
  */
 static int end_flv8986_core(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 {
+	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	const struct seg6_flavors_info *finfo = &slwt->flv_info;
 	enum seg6_local_flv_action action;
 	enum seg6_local_pktinfo pinfo;
 	struct ipv6_sr_hdr *srh;
+	int err = -EINVAL;
 	__u32 flvmask;
 	int srhoff;
 
@@ -801,10 +871,18 @@ static int end_flv8986_core(struct sk_bu
 	switch (action) {
 	case SEG6_LOCAL_FLV_ACT_END:
 		/* process the packet as the "standard" End behavior */
-		advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+		srh = advance_nextseg(skb, srh, &reason);
+		if (!srh) {
+			err = -ENOMEM;
+			goto drop;
+		}
 		break;
 	case SEG6_LOCAL_FLV_ACT_PSP:
-		advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+		srh = advance_nextseg(skb, srh, &reason);
+		if (!srh) {
+			err = -ENOMEM;
+			goto drop;
+		}
 
 		if (unlikely(!seg6_pop_srh(skb, srhoff)))
 			goto drop;
@@ -821,8 +899,8 @@ static int end_flv8986_core(struct sk_bu
 	return input_action_end_finish(skb, slwt);
 
 drop:
-	kfree_skb(skb);
-	return -EINVAL;
+	kfree_skb_reason(skb, reason);
+	return err;
 }
 
 /* regular endpoint function */
@@ -861,21 +939,27 @@ static int input_action_end_x(struct sk_
 
 static int input_action_end_t(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 {
+	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct ipv6_sr_hdr *srh;
+	int err = -EINVAL;
 
 	srh = get_and_validate_srh(skb);
 	if (!srh)
 		goto drop;
 
-	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	srh = advance_nextseg(skb, srh, &reason);
+	if (!srh) {
+		err = -ENOMEM;
+		goto drop;
+	}
 
 	seg6_lookup_nexthop(skb, NULL, slwt->table);
 
 	return dst_input(skb);
 
 drop:
-	kfree_skb(skb);
-	return -EINVAL;
+	kfree_skb_reason(skb, reason);
+	return err;
 }
 
 /* decapsulate and forward inner L2 frame on specified interface */
@@ -1450,6 +1534,7 @@ drop:
 static int input_action_end_b6_encap(struct sk_buff *skb,
 				     struct seg6_local_lwt *slwt)
 {
+	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct ipv6_sr_hdr *srh;
 	int err = -EINVAL;
 
@@ -1457,7 +1542,11 @@ static int input_action_end_b6_encap(str
 	if (!srh)
 		goto drop;
 
-	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	srh = advance_nextseg(skb, srh, &reason);
+	if (!srh) {
+		err = -ENOMEM;
+		goto drop;
+	}
 
 	skb_reset_inner_headers(skb);
 	skb->encapsulation = 1;
@@ -1473,7 +1562,7 @@ static int input_action_end_b6_encap(str
 	return dst_input(skb);
 
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return err;
 }
 
@@ -1509,6 +1598,7 @@ static int input_action_end_bpf(struct s
 				struct seg6_local_lwt *slwt)
 {
 	struct seg6_bpf_srh_state *srh_state;
+	enum skb_drop_reason reason;
 	struct ipv6_sr_hdr *srh;
 	int ret;
 
@@ -1517,7 +1607,11 @@ static int input_action_end_bpf(struct s
 		kfree_skb(skb);
 		return -EINVAL;
 	}
-	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	srh = advance_nextseg(skb, srh, &reason);
+	if (!srh) {
+		kfree_skb_reason(skb, reason);
+		return -ENOMEM;
+	}
 
 	/* The access to the per-CPU buffer srh_state is protected by running
 	 * always in softirq context (with disabled BH). On PREEMPT_RT the


