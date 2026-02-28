Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F2438D017
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302149; cv=none; b=DoRUu90IAWT0sp1AA+BCYVI3DAlMVeg+bNZwpnm77MvkW/Q9xX6GqnGvSlV70lzdZTYKnzeFHOna7YDA0tPWV2tIZua7nwNAH3TE5XyDiw3+WitoKDsnNSzoLPqn2EcGL8oAQ/0AcX9QcY0z7pUWAVAUHdLOe+d9AxLoGlI7FbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302149; c=relaxed/simple;
	bh=QUWhJWuASyQ3TGmR0hP/rOtSacngwO0yDirEAMfMkVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvE9l64fueSZCmIs599EHtKKtSN5c5ZfY3CXeS47IuW8+zVi6lUWlZPWa9FuZb85850VS7PWC8IrMj455hfN1aq81Zk4clDa811qYuICCNhVsjCz03Axtn0Jexapm1P6nu3VI+jDG/DRhzYMgkUw0265+WiDkOmMyJRugWCy+0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZiRof5RO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZiRof5RO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8A0C19423;
	Sat, 28 Feb 2026 18:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302149;
	bh=QUWhJWuASyQ3TGmR0hP/rOtSacngwO0yDirEAMfMkVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiRof5ROZfQV4pVCaZiJpYDkQaAex0ewno9AOaXt/l5M68mqD9QtY2cmLOSzQAw0I
	 ypsn+4EEJ21ig24QLH9tEyVWtRSlvxE4M43WYYg7oOkBhSsFfM8s7J2EtHgQH1TqCI
	 ZeNiQeWeZnvjjiOgWxmPdGWyb+C9JChl0qPH8dkW0A0MwqRXAL5ubgivvW+ous3sWo
	 VgjFRFXsfn8CuujRbU1/RJnvBu7bckSZrWdAIMHkQw/pYjllCKoX05Dqf2eBqZ+YP1
	 fEYBgq79bwnRLz58cdKeFX0RcUBPEp/Axbc3RWY7UgDiE1vwIzYERidKeSeP3c1/Ye
	 AXt5/MkMg+4Lg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/283] inet: RAW sockets using IPPROTO_RAW MUST drop incoming ICMP
Date: Sat, 28 Feb 2026 13:04:45 -0500
Message-ID: <20260228180709.1583486-143-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c89477ad79446867394360b29bb801010fc3ff22 ]

Yizhou Zhao reported that simply having one RAW socket on protocol
IPPROTO_RAW (255) was dangerous.

  socket(AF_INET, SOCK_RAW, 255);

A malicious incoming ICMP packet can set the protocol field to 255
and match this socket, leading to FNHE cache changes.

inner = IP(src="192.168.2.1", dst="8.8.8.8", proto=255)/Raw("TEST")
pkt = IP(src="192.168.1.1", dst="192.168.2.1")/ICMP(type=3, code=4, nexthopmtu=576)/inner

"man 7 raw" states:

  A protocol of IPPROTO_RAW implies enabled IP_HDRINCL and is able
  to send any IP protocol that is specified in the passed header.
  Receiving of all IP protocols via IPPROTO_RAW is not possible
  using raw sockets.

Make sure we drop these malicious packets.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Link: https://lore.kernel.org/netdev/20251109134600.292125-1-zhaoyz24@mails.tsinghua.edu.cn/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260203192509.682208-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 14 ++++++++++----
 net/ipv6/icmp.c |  6 ++++++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index b17549c4e5de8..f3cdfc09d7f06 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -840,16 +840,22 @@ static void icmp_socket_deliver(struct sk_buff *skb, u32 info)
 	/* Checkin full IP header plus 8 bytes of protocol to
 	 * avoid additional coding at protocol handlers.
 	 */
-	if (!pskb_may_pull(skb, iph->ihl * 4 + 8)) {
-		__ICMP_INC_STATS(dev_net_rcu(skb->dev), ICMP_MIB_INERRORS);
-		return;
-	}
+	if (!pskb_may_pull(skb, iph->ihl * 4 + 8))
+		goto out;
+
+	/* IPPROTO_RAW sockets are not supposed to receive anything. */
+	if (protocol == IPPROTO_RAW)
+		goto out;
 
 	raw_icmp_error(skb, protocol, info);
 
 	ipprot = rcu_dereference(inet_protos[protocol]);
 	if (ipprot && ipprot->err_handler)
 		ipprot->err_handler(skb, info);
+	return;
+
+out:
+	__ICMP_INC_STATS(dev_net_rcu(skb->dev), ICMP_MIB_INERRORS);
 }
 
 static bool icmp_tag_validation(int proto)
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index c7e815b7ca087..e9e457b7d4eac 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -869,6 +869,12 @@ enum skb_drop_reason icmpv6_notify(struct sk_buff *skb, u8 type,
 	if (reason != SKB_NOT_DROPPED_YET)
 		goto out;
 
+	if (nexthdr == IPPROTO_RAW) {
+		/* Add a more specific reason later ? */
+		reason = SKB_DROP_REASON_NOT_SPECIFIED;
+		goto out;
+	}
+
 	/* BUGGG_FUTURE: we should try to parse exthdrs in this packet.
 	   Without this we will not able f.e. to make source routed
 	   pmtu discovery.
-- 
2.51.0

