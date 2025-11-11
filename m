Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A64274FCB;
	Tue, 11 Nov 2025 01:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825501; cv=none; b=radoWJugmtDmRGwH8Zmi2rT+9G0VOnVNzsxDUm5vMSAZg0o7fLMKdLGpU4Zu8Jjk2lr7Rontg+Gx4Rz+Ts9MnuIl7aHiQimJvRvAmMT+BSjmC7Y2TISouLxP9td7PhqrKjSYWDWa9EwVf74poJzT6QrKvOKTB0B9GF6AmvMMT2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825501; c=relaxed/simple;
	bh=Ri6tvG/VZMAeofa+l4ZSjujsuY4so77EqLkzEiKJ4N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOxYZCn1GsRBP8Qy3itwWUaBUie8M6fbFatgzQHFsRCU6jetBtcZlaQ/HeX09f+nZbIgJgSF82LQBNq/iDwkDoTbQBgO43pmc8Pu6D9FhBDQQbnb7qYo6FhWnxmzooqahy+JAUTC9k+V5nPt2ruU0wyf5LG26x57tz7x8/u053M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpLtyPUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpLtyPUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0681CC116D0;
	Tue, 11 Nov 2025 01:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825501;
	bh=Ri6tvG/VZMAeofa+l4ZSjujsuY4so77EqLkzEiKJ4N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpLtyPUbuXH+IjsCt+BZHQPpBwVRY7eoCfRI14Dpwj8mFdaCKLye+CFGCdK+PzxFv
	 N7pu9dCkzQbK80nSVsBjdzGfbZpXhp7ihRuapOSTZfQwOPNTu+n6PS2Bgsk5h8N5vA
	 LPP8tkp+uh0GWlRZZVRvjoVDKaJaGrfGHggZmQlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 829/849] virtio_net: fix alignment for virtio_net_hdr_v1_hash
Date: Tue, 11 Nov 2025 09:46:39 +0900
Message-ID: <20251111004556.471388200@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

commit c3838262b824c71c145cd3668722e99a69bc9cd9 upstream.

Changing alignment of header would mean it's no longer safe to cast a
2 byte aligned pointer between formats. Use two 16 bit fields to make
it 2 byte aligned as previously.

This fixes the performance regression since
commit ("virtio_net: enable gso over UDP tunnel support.") as it uses
virtio_net_hdr_v1_hash_tunnel which embeds
virtio_net_hdr_v1_hash. Pktgen in guest + XDP_DROP on TAP + vhost_net
shows the TX PPS is recovered from 2.4Mpps to 4.45Mpps.

Fixes: 56a06bd40fab ("virtio_net: enable gso over UDP tunnel support.")
Cc: stable@vger.kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Link: https://patch.msgid.link/20251031060551.126-1-jasowang@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c        |   15 +++++++++++++--
 include/linux/virtio_net.h      |    3 ++-
 include/uapi/linux/virtio_net.h |    3 ++-
 3 files changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2539,6 +2539,13 @@ err_buf:
 	return NULL;
 }
 
+static inline u32
+virtio_net_hash_value(const struct virtio_net_hdr_v1_hash *hdr_hash)
+{
+	return __le16_to_cpu(hdr_hash->hash_value_lo) |
+		(__le16_to_cpu(hdr_hash->hash_value_hi) << 16);
+}
+
 static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
 				struct sk_buff *skb)
 {
@@ -2565,7 +2572,7 @@ static void virtio_skb_set_hash(const st
 	default:
 		rss_hash_type = PKT_HASH_TYPE_NONE;
 	}
-	skb_set_hash(skb, __le32_to_cpu(hdr_hash->hash_value), rss_hash_type);
+	skb_set_hash(skb, virtio_net_hash_value(hdr_hash), rss_hash_type);
 }
 
 static void virtnet_receive_done(struct virtnet_info *vi, struct receive_queue *rq,
@@ -3311,6 +3318,10 @@ static int xmit_skb(struct send_queue *s
 
 	pr_debug("%s: xmit %p %pM\n", vi->dev->name, skb, dest);
 
+	/* Make sure it's safe to cast between formats */
+	BUILD_BUG_ON(__alignof__(*hdr) != __alignof__(hdr->hash_hdr));
+	BUILD_BUG_ON(__alignof__(*hdr) != __alignof__(hdr->hash_hdr.hdr));
+
 	can_push = vi->any_header_sg &&
 		!((unsigned long)skb->data & (__alignof__(*hdr) - 1)) &&
 		!skb_header_cloned(skb) && skb_headroom(skb) >= hdr_len;
@@ -6759,7 +6770,7 @@ static int virtnet_xdp_rx_hash(const str
 		hash_report = VIRTIO_NET_HASH_REPORT_NONE;
 
 	*rss_type = virtnet_xdp_rss_type[hash_report];
-	*hash = __le32_to_cpu(hdr_hash->hash_value);
+	*hash = virtio_net_hash_value(hdr_hash);
 	return 0;
 }
 
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -401,7 +401,8 @@ virtio_net_hdr_tnl_from_skb(const struct
 	if (!tnl_hdr_negotiated)
 		return -EINVAL;
 
-        vhdr->hash_hdr.hash_value = 0;
+	vhdr->hash_hdr.hash_value_lo = 0;
+	vhdr->hash_hdr.hash_value_hi = 0;
         vhdr->hash_hdr.hash_report = 0;
         vhdr->hash_hdr.padding = 0;
 
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -193,7 +193,8 @@ struct virtio_net_hdr_v1 {
 
 struct virtio_net_hdr_v1_hash {
 	struct virtio_net_hdr_v1 hdr;
-	__le32 hash_value;
+	__le16 hash_value_lo;
+	__le16 hash_value_hi;
 #define VIRTIO_NET_HASH_REPORT_NONE            0
 #define VIRTIO_NET_HASH_REPORT_IPv4            1
 #define VIRTIO_NET_HASH_REPORT_TCPv4           2


