Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA223C661A;
	Mon, 17 Aug 2026 14:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976335; cv=none; b=b96O593CQRvCvnFC9CUeJ8MFK7T9zORaVp/cMj/HACDHHnuGUxq1iVk4JPciJ1OxA8TpGIE8qDSp28Tk1oUXA7kZZrtQt7QhTev/x9JG8IXmaxJ9HB7dpwTMJXqfQKBbhrJ0EX+5U0Oy7pHvgOM5C/jXisl1qaA/RCbZ9oV6geE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976335; c=relaxed/simple;
	bh=517fLg3qXUEd1kr6Hn99vJvwKJQ3KYta0WhNTQaFqus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAz1ThsIzla5lgmc3+tSyRNmhCtml+i7Un+W+mp6rOJjAqq1Rv79AFA8ET53mQHsE8rWPpiceKaEohsxyoFX76Zswd+5UZSwMZREDyc2EC5dsRx1uR+O/OS3SBT24aQIjBDkwgaINszZRg/N5RILYVRjI974jaWZXnKwgCYs79g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WK3gN70Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WK3gN70Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330451F000E9;
	Mon, 17 Aug 2026 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976333;
	bh=fpwxZH0+EiXaBH1CADzzgmyT7BqSgrAjp0Dat6DWZG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WK3gN70Q5Na5Bk7ZRMgK+VqJKLCQFoUSGNyoxF3e5e3oG73aUTLQmso3z/UGQHZ1b
	 MfwaN4XYKSGoyVqvjhYDU9smOi1FgJO/CwQEuCmr2lUwfSVzxIDQY8WGj1XLyz5MEH
	 +eGFG+4Y3k9TnWrcqEk6CRCWygcqZbSmyktJ5IOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 338/389] sctp: extract sctp_v6_err_handle function from sctp_v6_err
Date: Mon, 17 Aug 2026 15:32:57 +0200
Message-ID: <20260817132552.031191034@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit f6549bd37b927655c6fecad88428a731cd8a4a34 ]

This patch is to extract sctp_v6_err_handle() from sctp_v6_err() to
only handle the icmp err after the sock lookup, and it also makes
the code clearer.

sctp_v6_err_handle() will be used in sctp over udp's err handling
in the following patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: af0e5cdd031f ("tls: don't abort the connection on signal-interrupted sends")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/ipv6.c | 76 ++++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 36 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 984ec00ad6384..48bd3b52d56d0 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -121,50 +121,28 @@ static struct notifier_block sctp_inet6addr_notifier = {
 	.notifier_call = sctp_inet6addr_event,
 };
 
-/* ICMP error handler. */
-static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
-			u8 type, u8 code, int offset, __be32 info)
+static void sctp_v6_err_handle(struct sctp_transport *t, struct sk_buff *skb,
+			       __u8 type, __u8 code, __u32 info)
 {
-	struct sock *sk;
-	struct sctp_association *asoc;
-	struct sctp_transport *transport;
+	struct sctp_association *asoc = t->asoc;
+	struct sock *sk = asoc->base.sk;
 	struct ipv6_pinfo *np;
-	__u16 saveip, savesctp;
-	int err, ret = 0;
-	struct net *net = dev_net(skb->dev);
-
-	/* Fix up skb to look at the embedded net header. */
-	saveip	 = skb->network_header;
-	savesctp = skb->transport_header;
-	skb_reset_network_header(skb);
-	skb_set_transport_header(skb, offset);
-	sk = sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, &transport);
-	/* Put back, the original pointers. */
-	skb->network_header   = saveip;
-	skb->transport_header = savesctp;
-	if (!sk) {
-		__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
-		return -ENOENT;
-	}
-
-	/* Warning:  The sock lock is held.  Remember to call
-	 * sctp_err_finish!
-	 */
+	int err = 0;
 
 	switch (type) {
 	case ICMPV6_PKT_TOOBIG:
 		if (ip6_sk_accept_pmtu(sk))
-			sctp_icmp_frag_needed(sk, asoc, transport, ntohl(info));
-		goto out_unlock;
+			sctp_icmp_frag_needed(sk, asoc, t, info);
+		return;
 	case ICMPV6_PARAMPROB:
 		if (ICMPV6_UNK_NEXTHDR == code) {
-			sctp_icmp_proto_unreachable(sk, asoc, transport);
-			goto out_unlock;
+			sctp_icmp_proto_unreachable(sk, asoc, t);
+			return;
 		}
 		break;
 	case NDISC_REDIRECT:
-		sctp_icmp_redirect(sk, transport, skb);
-		goto out_unlock;
+		sctp_icmp_redirect(sk, t, skb);
+		return;
 	default:
 		break;
 	}
@@ -174,13 +152,39 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	if (!sock_owned_by_user(sk) && np->recverr) {
 		sk->sk_err = err;
 		sk->sk_error_report(sk);
-	} else {  /* Only an error on timeout */
+	} else {
 		sk->sk_err_soft = err;
 	}
+}
+
+/* ICMP error handler. */
+static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
+		       u8 type, u8 code, int offset, __be32 info)
+{
+	struct net *net = dev_net(skb->dev);
+	struct sctp_transport *transport;
+	struct sctp_association *asoc;
+	__u16 saveip, savesctp;
+	struct sock *sk;
+
+	/* Fix up skb to look at the embedded net header. */
+	saveip	 = skb->network_header;
+	savesctp = skb->transport_header;
+	skb_reset_network_header(skb);
+	skb_set_transport_header(skb, offset);
+	sk = sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, &transport);
+	/* Put back, the original pointers. */
+	skb->network_header   = saveip;
+	skb->transport_header = savesctp;
+	if (!sk) {
+		__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
+		return -ENOENT;
+	}
 
-out_unlock:
+	sctp_v6_err_handle(transport, skb, type, code, ntohl(info));
 	sctp_err_finish(sk, transport);
-	return ret;
+
+	return 0;
 }
 
 static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *transport)
-- 
2.53.0



