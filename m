Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624147;
	b=eoVNq4DH6YqT5XL2K3jFbCHlFJAvgk0pBq9If8IvaIJ/L9pJp4LACUOC776Rz3DHTiHF
	 VOowZzQAfCDyZDRKL+uc9XKWNzR2ktgqGRLzMOK+odKZff0XTxe+Rf46FBTBXvi2/VtjA
	 NetRFeLxkAnemLZC98y5KidJwjiEjVd3XZVh7f6yMEJCjyF6OJGs9q7Z9UjuuObKMX6AO
	 Q7rs/HtBgXwAt/z+FDQplwnmnWwlLIDBrIK7CDowneKv1XF01eOeCVd9xWg2KdJl7hgLi
	 1MLd+Zpb+BLJ8BwXT/NxxNQ7MHXHMQdx/sTgr+I+DBOAuPbAZuJ17vNo+VFbNSyAEjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dLqFM0CVnsUtuYxmYn1dsSoxYV22jwxiKwmMAEA2L1U=;
	b=hQ6B5hDti9+k7/uOpEXAUhtO67UtkQnVqxmZzwRQamU69ZAN0dZQeGLOCQVcp7lwaxv3
	 o04HsCwG/W7XC88QI2RA85lrwZ+Ibb4TiXlYd1feT4AeGsswZyG6LoPpNbO0Qi5VDyDyZ
	 yyN9bnpZpDpzb8uQ8xjnabas9JyU5Oi4AKSEvVVJzJQZo/QHANdDssTsI77twPZaseEYc
	 txpUhJ/VMjGLn3yJifkACJgreCerrBCJozV59gVUOTyz87mqBxr+AMrCN2jn/JPElFRvw
	 819VYbBAyxQ6h6kCaTs2tgNFRz2vtw2exVX2Uqi2fjoSAr4LdJcOzTWyDQoym4JX+/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oPWbe25S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830A1606A326;
	Wed, 25 Nov 2026 16:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oPWbe25S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417481F000CA;
	Wed, 25 Nov 2026 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624146;
	bh=dLqFM0CVnsUtuYxmYn1dsSoxYV22jwxiKwmMAEA2L1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPWbe25SWY6gSn28HQa+ntZUItE1bd8zY6L9d3vVCZOVPty1JUQrNTszM8Ieug4WY
	 amfnMaSJbZPPqgmEg0P0T9h/1ohz2hCI/D+TLvH4egrYeMyyca9ZLWzoixoTwvC9Lp
	 3vDd/LlPnbEUCu77xK3StxiyOityp45PO+EJpgDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/816] bpf, cgroup: Keep the skb network offset signed
Date: Wed, 25 Nov 2026 15:27:28 +0100
Message-ID: <20261125143851.531893567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 3f9780d62dd1112ca15b5ae73568d29d42ccc950 ]

cgroup_skb progs see a packet from its network header. While they run,
__cgroup_bpf_run_filter_skb() moves skb->data there. It assumes that the
network header is not after skb->data. It negates skb_network_offset(skb)
and pushes skb->data by this offset. The offset is an unsigned int.

But ip6mr_cache_report() and bpf_lwt_xmit_reroute() can pass an skb that
has data before the network header. Then the offset wraps. On a 64-bit
kernel skb->data is then far below skb->head.

skb->len has 32 bits and wraps to the correct value, thus only skb->data is
wrong. A read of packet data faults or gets other memory.

Keep the offset in an int. Pull skb->data when the network header is after
it. Otherwise push it, as today.

Fixes: 3007098494be ("cgroup: add support for eBPF programs")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-15-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index f075f3a8cda30..03e31f1371715 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1577,7 +1577,7 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 				struct sk_buff *skb,
 				enum cgroup_bpf_attach_type atype)
 {
-	unsigned int offset = -skb_network_offset(skb);
+	int offset = skb_network_offset(skb);
 	struct sock *save_sk;
 	void *saved_data_end;
 	struct cgroup *cgrp;
@@ -1589,7 +1589,15 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
 	save_sk = skb->sk;
 	skb->sk = sk;
-	__skb_push(skb, offset);
+
+	/*
+	 * The program sees the packet from its network header on, on
+	 * whichever side of skb->data that header lies.
+	 */
+	if (offset > 0)
+		__skb_pull(skb, offset);
+	else
+		__skb_push(skb, -offset);
 
 	/* compute pointers for the bpf prog */
 	bpf_compute_and_save_data_end(skb, &saved_data_end);
@@ -1631,7 +1639,10 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 			ret = -EFAULT;
 	}
 	bpf_restore_data_end(skb, saved_data_end);
-	__skb_pull(skb, offset);
+	if (offset > 0)
+		__skb_push(skb, offset);
+	else
+		__skb_pull(skb, -offset);
 	skb->sk = save_sk;
 
 	return ret;
-- 
2.53.0



