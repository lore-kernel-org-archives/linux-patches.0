Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E3F4F7CC1;
	Tue, 13 Oct 2026 12:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892893; cv=none; b=REGE48GzwuHXD7nHQPg/b8MqG1CgpJqu460NVHzvf6OFeyxNeb+AmtG+xhXBtRxguF9s7A/sOlqcxbXPBAr4FiQ8QIoJjr6miIsGSluVK/Am84wGl7tJCsOmbFrloJ+aeN36efuEJd8NY00dZ7w8C5cI/iI2z3KojnHOjApX/2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892893; c=relaxed/simple;
	bh=FFCoDs4EX9WT6DgtVQ3Os8wrHLF77o6wEWskXVMCa4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIY7Cjys3t4SGn07kv5zSTz7WwLTzzSDbNTYfpOySxEf7dgemq65suIBTZgoq0HbAxyKMxQatQSrfLBTQdcVD+/RZo/KQ6dPXPz/dAtp9+mOlsulXfNXeGUP2qCGXTjQgkkUyaxGKpROOCPvjfBMIHJ4Ut3uQk2lTmQUWPRPpnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FN3Hub/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FN3Hub/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBF31F008BD;
	Tue, 13 Oct 2026 12:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892891;
	bh=ldQ1WYb9ObxlECk8AbrnApfkrzfJmeVnzcRYNk3Qsyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FN3Hub/SYcuVvJ3Lyo5jU1ZR7aAUHDBFxnR+1dWKHFZIinN+fohW8sXyM5pxa/qJ9
	 YQqgMFoXlnDafBMrNZrerjOJwzSmZGa7hOZdWu6Jo9vpIxIwKckRFd2BsKCTP2mbwR
	 drl884yUCBgFzAYi06skP/XycUmHpzgzzWWlk2B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulos Yibelo <habte.yibelo@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 016/621] ipv4: validate checksum_start before completing checksum
Date: Tue, 13 Oct 2026 13:30:11 +0200
Message-ID: <20261013112921.249170631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

commit 6785011f8b16abf40b1e9d8b2e332232b3e68822 upstream.

If a packet with bad checksum metadata gets into the ipv4 stack,
skb_checksum_help can corrupt the network header and cause a bunch of
mischief.

This was discovered and reported by Paulos, and has been reporoduced
by others independently since.

We really shouldn't allow such packets in, but as a defence
in depth measure, let's also check before we complete the checksum.

A more complete validation at input is forthcoming, but needs more work.

Cc: stable@vger.kernel.org
Fixes: f43798c27684 ("tun: Allow GSO using virtio_net_hdr")
Fixes: bfd5f4a3d605 ("packet: Add GSO/csum offload support.")
Reported-by: Paulos Yibelo <habte.yibelo@gmail.com>
Closes: https://lore.kernel.org/netdev/20260922030310.8684-2-habte.yibelo@gmail.com/
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/0a012b4923e189c4c593ef4f471e5ff0edbe9030.1791412497.git.mst@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip.h                           |    7 +++++++
 net/bridge/netfilter/nf_conntrack_bridge.c |   10 +++++++---
 net/ipv4/ip_output.c                       |   10 +++++++---
 net/netfilter/nfnetlink_queue.c            |    7 +++++++
 net/netfilter/xt_CHECKSUM.c                |    6 +++++-
 net/xfrm/xfrm_output.c                     |   16 +++++++++++-----
 6 files changed, 44 insertions(+), 12 deletions(-)

--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -74,6 +74,13 @@ static inline unsigned int ip_hdrlen(con
 	return ip_hdr(skb)->ihl * 4;
 }
 
+static inline int ip_check_csum_start(const struct sk_buff *skb)
+{
+	if (unlikely(skb->csum_start < skb->network_header + ip_hdrlen(skb)))
+		return -EINVAL;
+	return 0;
+}
+
 struct ipcm_cookie {
 	struct sockcm_cookie	sockc;
 	__be32			addr;
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -40,9 +40,13 @@ static int nf_br_ip_fragment(struct net
 	int err = 0;
 
 	/* for offloaded checksums cleanup checksum before fragmentation */
-	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (err = skb_checksum_help(skb)))
-		goto blackhole;
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		err = ip_check_csum_start(skb);
+		if (!err)
+			err = skb_checksum_help(skb);
+		if (err)
+			goto blackhole;
+	}
 
 	iph = ip_hdr(skb);
 
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -772,9 +772,13 @@ int ip_do_fragment(struct net *net, stru
 	int err = 0;
 
 	/* for offloaded checksums cleanup checksum before fragmentation */
-	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (err = skb_checksum_help(skb)))
-		goto fail;
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		err = ip_check_csum_start(skb);
+		if (!err)
+			err = skb_checksum_help(skb);
+		if (err)
+			goto fail;
+	}
 
 	/*
 	 *	Point into the IP datagram header.
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -33,6 +33,7 @@
 #include <linux/rhashtable.h>
 #include <linux/jhash.h>
 #include <net/gso.h>
+#include <net/ip.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/netfilter/nf_queue.h>
@@ -653,6 +654,12 @@ nla_put_failure:
 
 static int nf_queue_checksum_help(struct sk_buff *entskb)
 {
+	if (entskb->protocol == htons(ETH_P_IP)) {
+		if (!pskb_network_may_pull(entskb, sizeof(struct iphdr)) ||
+		    ip_check_csum_start(entskb))
+			return -EINVAL;
+	}
+
 	if (skb_csum_is_sctp(entskb))
 		return skb_crc32c_csum_help(entskb);
 
--- a/net/netfilter/xt_CHECKSUM.c
+++ b/net/netfilter/xt_CHECKSUM.c
@@ -15,6 +15,7 @@
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <net/ip.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael S. Tsirkin <mst@redhat.com>");
@@ -25,8 +26,11 @@ MODULE_ALIAS("ip6t_CHECKSUM");
 static unsigned int
 checksum_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	if (skb->ip_summed == CHECKSUM_PARTIAL && !skb_is_gso(skb))
+	if (skb->ip_summed == CHECKSUM_PARTIAL && !skb_is_gso(skb)) {
+		if (xt_family(par) == NFPROTO_IPV4 && ip_check_csum_start(skb))
+			return NF_DROP;
 		skb_checksum_help(skb);
+	}
 
 	return XT_CONTINUE;
 }
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -816,16 +816,22 @@ int xfrm_output(struct sock *sk, struct
 	}
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		err = skb_checksum_help(skb);
-		if (err) {
-			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
-			kfree_skb(skb);
-			return err;
+		if (skb->protocol == htons(ETH_P_IP)) {
+			err = ip_check_csum_start(skb);
+			if (err)
+				goto error;
 		}
+		err = skb_checksum_help(skb);
+		if (err)
+			goto error;
 	}
 
 out:
 	return xfrm_output2(net, sk, skb);
+error:
+	XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
+	kfree_skb(skb);
+	return err;
 }
 EXPORT_SYMBOL_GPL(xfrm_output);
 


