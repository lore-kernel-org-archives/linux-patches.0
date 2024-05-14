Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3B66E60F;
	Tue, 14 May 2024 11:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687181; cv=none; b=L2qcMO+jRyoCYsIPqV7fF4SlVI3yKe5EhgaSuFpicgHgCd+RjCzdGVzVxfchH0UIO3Xo6Y1XuwQ1XmB9rexUYIaPAP8trvdV9esJUi0T9PY/L95Fsp8I1ykwZI77MJryUKvVvy24EWR5AEBwN80pgHttKad5h9crwR7f/pENULk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687181; c=relaxed/simple;
	bh=4vPsQY/jHL0rigD46wBsRgmrMkYIaJobo/d/8q4Qs+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T17g50YA27TzDo0TjUXbY46LmiP/oe2gu7aUz/x/HQXxVewvggIg02HXEzfrmS/q4b11OtJ+Z6UmPuI5KJynuVw9vFDG6oZsmz0V4nYpF2ldD+nc19JYD0AE6MpPBkJk0bNw8JONVF3kJxDOW2+wLehtikI22mGdurPG8LIbpvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15KmNf6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15KmNf6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE5FC2BD10;
	Tue, 14 May 2024 11:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687181;
	bh=4vPsQY/jHL0rigD46wBsRgmrMkYIaJobo/d/8q4Qs+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15KmNf6fHffvTYi5x0ejQNYZrqV3EjhKJPDCv6xbQshNubBDtNDjgPoqHkPrvjDnX
	 JHoshmQXdXF+ppmILaFRsfmgYcBBsr9R1baBpYuCcUzKF2YSi6RW/5hLOXJT06JcT0
	 IOwkQ3qxuopL4r2oWFIQoQDPhkmLgeov5TN0ckNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Davey <paul.davey@alliedtelesis.co.nz>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 62/84] xfrm: Preserve vlan tags for transport mode software GRO
Date: Tue, 14 May 2024 12:20:13 +0200
Message-ID: <20240514100954.018240454@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Davey <paul.davey@alliedtelesis.co.nz>

[ Upstream commit 58fbfecab965014b6e3cc956a76b4a96265a1add ]

The software GRO path for esp transport mode uses skb_mac_header_rebuild
prior to re-injecting the packet via the xfrm_napi_dev.  This only
copies skb->mac_len bytes of header which may not be sufficient if the
packet contains 802.1Q tags or other VLAN tags.  Worse copying only the
initial header will leave a packet marked as being VLAN tagged but
without the corresponding tag leading to mangling when it is later
untagged.

The VLAN tags are important when receiving the decrypted esp transport
mode packet after GRO processing to ensure it is received on the correct
interface.

Therefore record the full mac header length in xfrm*_transport_input for
later use in corresponding xfrm*_transport_finish to copy the entire mac
header when rebuilding the mac header for GRO.  The skb->data pointer is
left pointing skb->mac_header bytes after the start of the mac header as
is expected by the network stack and network and transport header
offsets reset to this location.

Fixes: 7785bba299a8 ("esp: Add a software GRO codepath")
Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 15 +++++++++++++++
 include/net/xfrm.h     |  3 +++
 net/ipv4/xfrm4_input.c |  6 +++++-
 net/ipv6/xfrm6_input.c |  6 +++++-
 net/xfrm/xfrm_input.c  |  8 ++++++++
 5 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 302a2ad679809..29ccc33a1c627 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2576,6 +2576,21 @@ static inline void skb_mac_header_rebuild(struct sk_buff *skb)
 	}
 }
 
+/* Move the full mac header up to current network_header.
+ * Leaves skb->data pointing at offset skb->mac_len into the mac_header.
+ * Must be provided the complete mac header length.
+ */
+static inline void skb_mac_header_rebuild_full(struct sk_buff *skb, u32 full_mac_len)
+{
+	if (skb_mac_header_was_set(skb)) {
+		const unsigned char *old_mac = skb_mac_header(skb);
+
+		skb_set_mac_header(skb, -full_mac_len);
+		memmove(skb_mac_header(skb), old_mac, full_mac_len);
+		__skb_push(skb, full_mac_len - skb->mac_len);
+	}
+}
+
 static inline int skb_checksum_start_offset(const struct sk_buff *skb)
 {
 	return skb->csum_start - skb_headroom(skb);
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 96faf09186945..4368dcb709f4e 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1024,6 +1024,9 @@ struct xfrm_offload {
 #define CRYPTO_INVALID_PACKET_SYNTAX		64
 #define CRYPTO_INVALID_PROTOCOL			128
 
+	/* Used to keep whole l2 header for transport mode GRO */
+	__u32			orig_mac_len;
+
 	__u8			proto;
 };
 
diff --git a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
index f8de2482a5292..9b062f2e45695 100644
--- a/net/ipv4/xfrm4_input.c
+++ b/net/ipv4/xfrm4_input.c
@@ -66,7 +66,11 @@ int xfrm4_transport_finish(struct sk_buff *skb, int async)
 	ip_send_check(iph);
 
 	if (xo && (xo->flags & XFRM_GRO)) {
-		skb_mac_header_rebuild(skb);
+		/* The full l2 header needs to be preserved so that re-injecting the packet at l2
+		 * works correctly in the presence of vlan tags.
+		 */
+		skb_mac_header_rebuild_full(skb, xo->orig_mac_len);
+		skb_reset_network_header(skb);
 		skb_reset_transport_header(skb);
 		return 0;
 	}
diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index a52cb3fc6df5a..c12d51f5b5893 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -58,7 +58,11 @@ int xfrm6_transport_finish(struct sk_buff *skb, int async)
 	skb_postpush_rcsum(skb, skb_network_header(skb), nhlen);
 
 	if (xo && (xo->flags & XFRM_GRO)) {
-		skb_mac_header_rebuild(skb);
+		/* The full l2 header needs to be preserved so that re-injecting the packet at l2
+		 * works correctly in the presence of vlan tags.
+		 */
+		skb_mac_header_rebuild_full(skb, xo->orig_mac_len);
+		skb_reset_network_header(skb);
 		skb_reset_transport_header(skb);
 		return -1;
 	}
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 4d8d7cf3d1994..2e7fd0aa5f373 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -394,11 +394,15 @@ static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
  */
 static int xfrm4_transport_input(struct xfrm_state *x, struct sk_buff *skb)
 {
+	struct xfrm_offload *xo = xfrm_offload(skb);
 	int ihl = skb->data - skb_transport_header(skb);
 
 	if (skb->transport_header != skb->network_header) {
 		memmove(skb_transport_header(skb),
 			skb_network_header(skb), ihl);
+		if (xo)
+			xo->orig_mac_len =
+				skb_mac_header_was_set(skb) ? skb_mac_header_len(skb) : 0;
 		skb->network_header = skb->transport_header;
 	}
 	ip_hdr(skb)->tot_len = htons(skb->len + ihl);
@@ -409,11 +413,15 @@ static int xfrm4_transport_input(struct xfrm_state *x, struct sk_buff *skb)
 static int xfrm6_transport_input(struct xfrm_state *x, struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_IPV6)
+	struct xfrm_offload *xo = xfrm_offload(skb);
 	int ihl = skb->data - skb_transport_header(skb);
 
 	if (skb->transport_header != skb->network_header) {
 		memmove(skb_transport_header(skb),
 			skb_network_header(skb), ihl);
+		if (xo)
+			xo->orig_mac_len =
+				skb_mac_header_was_set(skb) ? skb_mac_header_len(skb) : 0;
 		skb->network_header = skb->transport_header;
 	}
 	ipv6_hdr(skb)->payload_len = htons(skb->len + ihl -
-- 
2.43.0



