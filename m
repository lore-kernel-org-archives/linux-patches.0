Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9BF27E07E;
	Mon, 17 Aug 2026 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974283; cv=none; b=YmN3pStkWaOmcwnl9YA0GWQs6Ooyg4HGi3wRuz4zuhWUV/wACMfeOb5JtlZapXb8j8xZ4M2XD4t+2SE1awEJMRvvNoOkWQEwL9+wIy4bD8I+Vh5fQ/r413zXzrxdWWcXb17eFecTAF1tKsRCotLyH4YrZ+g9DFWWODaTlS6whJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974283; c=relaxed/simple;
	bh=46HuDCbMxaRL0XW8l2gEhUBPbnTWQwl52gwRrdrRmKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLykzCgDX8dNP27nXJskVb7gOhPXb5vknursZs2ya6iMu511rGkjY+2G6y/tp6y2MbfXEIk1H7TVD9q8oSQpvj7GghsGh6Kgz35kqWs4iDWzOBlSETHhAlaWkDUCOt07MXFQ2E3yhMwM9BAXAmZXXC0To5+Wq/3lHOT+SNeqzoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxd4DYgd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxd4DYgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80691F00A3D;
	Mon, 17 Aug 2026 13:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974274;
	bh=BkUX3nWmO/S5mCXXFb4Hk9OchtLLQ04mhO7EFCunCnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxd4DYgdVSvMN6ZCCJqsIsOoupvhmbLeeJaj1NzVPvNAjis2/xyVPVvxqVkS+CBXL
	 /9cADWEXEFLHrYwr5GVWWma8skySCaoJf778kklJwI1TGT9Cp+3eCPik4LLQSOkEDA
	 01zRwnnEOSfLqTIG+irxQc17q9iuLdEqeVX7NTbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang Tang <q.h.hack.winter@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 149/271] packet: use consistent hard_header_len in non-ring send paths
Date: Mon, 17 Aug 2026 15:31:14 +0200
Message-ID: <20260817132543.011456870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang Tang <q.h.hack.winter@gmail.com>

commit 03390aa32e669cc4ecd7d34108e2e1afc13d689d upstream.

packet_snd() reads dev->hard_header_len multiple times while allocating
and constructing an skb. Device reconfiguration can change this value
concurrently, for example through bonding device type changes.

For SOCK_RAW, packet_snd() can save a larger value in reserve and later
allocate headroom using a smaller value. Moving skb->data back by reserve
then places it before skb->head, and the following copy from userspace can
attempt an out-of-bounds write.

packet_sendmsg_spkt() has the same issue because it calculates its
reservation and header offset from separate reads before dropping the RCU
read lock to allocate the skb.

Add LL_RESERVED_SPACE_EX() for callers that already saved a header length.
Read hard_header_len once in packet_snd() and use it for allocation and
construction. In packet_sendmsg_spkt(), preserve the allocation-time value
through the device lookup retry.

The separate SOCK_DGRAM consistency problem between hard_header_len and
header_ops->create is not addressed here.

Fixes: b84bbaf7a6c8 ("packet: in packet_snd start writing at link layer allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Qihang Tang <q.h.hack.winter@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260805125729.19220-3-q.h.hack.winter@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    6 ++++--
 net/packet/af_packet.c    |   26 ++++++++++++++++----------
 2 files changed, 20 insertions(+), 12 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -300,9 +300,11 @@ struct hh_cache {
  * We could use other alignment values, but we must maintain the
  * relationship HH alignment <= LL alignment.
  */
-#define LL_RESERVED_SPACE(dev) \
-	((((dev)->hard_header_len + READ_ONCE((dev)->needed_headroom)) \
+#define LL_RESERVED_SPACE_EX(dev, hlen) \
+	((((hlen) + READ_ONCE((dev)->needed_headroom)) \
 	  & ~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
+#define LL_RESERVED_SPACE(dev) \
+	LL_RESERVED_SPACE_EX(dev, (dev)->hard_header_len)
 #define LL_RESERVED_SPACE_EXTRA(dev,extra) \
 	((((dev)->hard_header_len + READ_ONCE((dev)->needed_headroom) + (extra)) \
 	  & ~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1953,8 +1953,9 @@ static int packet_sendmsg_spkt(struct so
 	struct net_device *dev;
 	struct sockcm_cookie sockc;
 	__be16 proto = 0;
-	int err;
+	int hard_header_len;
 	int extra_len = 0;
+	int err;
 
 	/*
 	 *	Get and verify the address.
@@ -1997,14 +1998,18 @@ retry:
 		extra_len = 4; /* We're doing our own CRC */
 	}
 
+	/* Keep the allocation-time header length across retry. */
+	if (!skb)
+		hard_header_len = READ_ONCE(dev->hard_header_len);
+
 	err = -EMSGSIZE;
-	if (len > dev->mtu + dev->hard_header_len + VLAN_HLEN + extra_len)
+	if (len > dev->mtu + hard_header_len + VLAN_HLEN + extra_len)
 		goto out_unlock;
 
 	if (!skb) {
-		size_t reserved = LL_RESERVED_SPACE(dev);
+		size_t reserved = LL_RESERVED_SPACE_EX(dev, hard_header_len);
 		int tlen = dev->needed_tailroom;
-		unsigned int hhlen = dev->header_ops ? dev->hard_header_len : 0;
+		unsigned int hhlen = dev->header_ops ? hard_header_len : 0;
 
 		rcu_read_unlock();
 		skb = sock_wmalloc(sk, len + reserved + tlen, 0, GFP_KERNEL);
@@ -2034,7 +2039,7 @@ retry:
 		err = -EINVAL;
 		goto out_unlock;
 	}
-	if (len > (dev->mtu + dev->hard_header_len + extra_len) &&
+	if (len > (dev->mtu + hard_header_len + extra_len) &&
 	    !packet_extra_vlan_len_allowed(dev, skb)) {
 		err = -EMSGSIZE;
 		goto out_unlock;
@@ -2956,7 +2961,7 @@ static int packet_snd(struct socket *soc
 	int offset = 0;
 	struct packet_sock *po = pkt_sk(sk);
 	int vnet_hdr_sz = READ_ONCE(po->vnet_hdr_sz);
-	int hlen, tlen, linear;
+	int hard_header_len, hlen, tlen, linear;
 	int extra_len = 0;
 
 	/*
@@ -2996,8 +3001,9 @@ static int packet_snd(struct socket *soc
 			goto out_unlock;
 	}
 
+	hard_header_len = READ_ONCE(dev->hard_header_len);
 	if (sock->type == SOCK_RAW)
-		reserve = dev->hard_header_len;
+		reserve = hard_header_len;
 	if (vnet_hdr_sz) {
 		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_sz);
 		if (err)
@@ -3018,10 +3024,10 @@ static int packet_snd(struct socket *soc
 		goto out_unlock;
 
 	err = -ENOBUFS;
-	hlen = LL_RESERVED_SPACE(dev);
+	hlen = LL_RESERVED_SPACE_EX(dev, hard_header_len);
 	tlen = dev->needed_tailroom;
 	linear = __virtio16_to_cpu(vio_le(), vnet_hdr.hdr_len);
-	linear = max(linear, min_t(int, len, dev->hard_header_len));
+	linear = max(linear, min_t(int, len, hard_header_len));
 	skb = packet_alloc_skb(sk, hlen + tlen, hlen, len, linear,
 			       msg->msg_flags & MSG_DONTWAIT, &err);
 	if (skb == NULL)
@@ -3037,7 +3043,7 @@ static int packet_snd(struct socket *soc
 	} else if (reserve) {
 		skb_reserve(skb, -reserve);
 		if (len < reserve + sizeof(struct ipv6hdr) &&
-		    dev->min_header_len != dev->hard_header_len)
+		    dev->min_header_len != hard_header_len)
 			skb_reset_network_header(skb);
 	}
 


