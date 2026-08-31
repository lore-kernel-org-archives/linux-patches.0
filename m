Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D7043DA53;
	Mon, 31 Aug 2026 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184732; cv=none; b=bCizzgoKYmaBoUQBDFFlKJ01IncwDFZxE5Zxznxxr+4gkACy6S4mYFCjNUSug8Lw7otdiTHHTahCv+7PGN1UPrlcmNLEibtkv+OihGho2SAY7k/v1Eo8C7x10rq0jJQEHKfrLVYtVM/BbVuA5IpLruzAUtoR67ifoXF+iKFWm8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184732; c=relaxed/simple;
	bh=SZnJl8kQ1X7kaYJVjokEbbubH56PiX76fRzwndEF3Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f81iSQcjm6qAvSXUYSMM0lw3uzOZQ1xXDXQLYs20apPzjhd19nFaPyyAXl9zUlKgxpuPaakdL5TJYM9RKiiP4QMw2FjiaGNT6APujdlE8oWCGMWRmMa/YeEMXwtE2pte/2llNajEr0ur+T3R95LnVeipxhfZ+gYyEFQRVKyzm1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XB3Ocu8K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XB3Ocu8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940681F00A3D;
	Mon, 31 Aug 2026 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184731;
	bh=EJd5H+b14PRsc/GLBpumrOp0pGl3kT2ZnofqEboxKOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XB3Ocu8KeGQuNp1Fq4hQi9FV6qN48/IolKPmOASQwvPIB0JcTYM1PeD/oLnT7zhEQ
	 Xwh+ePYkmQ1YxuiFllPqd8viRX62+me24WR0o44hd3dgW3inIC51uDT4wQJZQ6tQyA
	 UsrzZVbFF8vYgLE2edDPBemWaH6bktDlW+tznv5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Juhandr=C3=A9=20Knoetze?= <juhandre.knoetze@windriver.com>,
	Dmitriy Korovkin <dmitriy.korovkin@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 02/92] inet: RAW sockets using IPPROTO_RAW MUST drop incoming ICMP
Date: Mon, 31 Aug 2026 15:34:00 +0200
Message-ID: <20260831133359.600784266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
[ in 6.1.y kernel icmpv6_notify returns void, not skb_drop_reason ]
Signed-off-by: Juhandré Knoetze <juhandre.knoetze@windriver.com>
Signed-off-by: Dmitriy Korovkin <dmitriy.korovkin@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 14 ++++++++++----
 net/ipv6/icmp.c |  3 +++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index e8c59c2051c2d..7c4c7b7fe3846 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -868,16 +868,22 @@ static void icmp_socket_deliver(struct sk_buff *skb, u32 info)
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
index f8f7c1246f43b..e984f03b0b418 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -861,6 +861,9 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 	if (!pskb_may_pull(skb, inner_offset+8))
 		goto out;
 
+	if (nexthdr == IPPROTO_RAW)
+		goto out;
+
 	/* BUGGG_FUTURE: we should try to parse exthdrs in this packet.
 	   Without this we will not able f.e. to make source routed
 	   pmtu discovery.
-- 
2.53.0



