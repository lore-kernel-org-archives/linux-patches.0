Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956FF3E95AB;
	Mon, 17 Aug 2026 14:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976340; cv=none; b=aFGJ0TMZHR2Hime0TrtoGaMzlMvIWvWMjLWckqmRTEGpnEExGCrE/b9NtaDWWndaBjcUiohZdHhItf9qChKPPLMEXZRtAz9QCj+dCU4QUlllUXIt18Da5cI5fX3u1D2ou5Lo9auhg8Kusvi7TwNelkKwcdU+sVa5vQE4BsZL3t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976340; c=relaxed/simple;
	bh=Ha0tDbauMyIrRq31Hkh4N5Jtm44cMObXFwSZ1gTbFAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpkXudsITGUeK7dyLtuKmPMq3yiVVwG9HGzdsQAfpC+Y6Qr9VMHvk3dEuJ8L7XsGe+UsbmKQb1Awt6s+AXtf6XCA7oz/6KVkev+eT1jqKqc0mDD1rv3y7EQRf8VCl9KGDzyCMQ3YWk7r0Z5TO/jmwR61Gaj9qc7a+s+USAmtw7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cT3MrC8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cT3MrC8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF8D1F00A3A;
	Mon, 17 Aug 2026 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976339;
	bh=+vcOXYB5zidlbw83hIYkfX3cB8i+9v5KX2D6Hj97JQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cT3MrC8IpL4hkgJ7gqwCUiuR0cDiYNiuNvmPiBgHSoJ9JCWYeFR9p5HUoda3Emv/f
	 rvEvggF12TImdChLyyJPmHes5lWJLYkZIlQ4udjlOYCPdbYncuG1d1h+UvMqSftUbQ
	 F3tLShiPsvB624baDRFquTsNXCDe+bk62Hiy6BLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 339/389] sctp: extract sctp_v4_err_handle function from sctp_v4_err
Date: Mon, 17 Aug 2026 15:32:58 +0200
Message-ID: <20260817132552.065981405@linuxfoundation.org>
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

[ Upstream commit d83060759a652ccb64d7486fe38c8347b4a64048 ]

This patch is to extract sctp_v4_err_handle() from sctp_v4_err() to
only handle the icmp err after the sock lookup, and it also makes
the code clearer.

sctp_v4_err_handle() will be used in sctp over udp's err handling
in the following patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: af0e5cdd031f ("tls: don't abort the connection on signal-interrupted sends")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/input.c | 106 ++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 57 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 3c7761199f200..731d12e8038c5 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -556,6 +556,49 @@ void sctp_err_finish(struct sock *sk, struct sctp_transport *t)
 	sctp_transport_put(t);
 }
 
+static void sctp_v4_err_handle(struct sctp_transport *t, struct sk_buff *skb,
+			       __u8 type, __u8 code, __u32 info)
+{
+	struct sctp_association *asoc = t->asoc;
+	struct sock *sk = asoc->base.sk;
+	int err = 0;
+
+	switch (type) {
+	case ICMP_PARAMETERPROB:
+		err = EPROTO;
+		break;
+	case ICMP_DEST_UNREACH:
+		if (code > NR_ICMP_UNREACH)
+			return;
+		if (code == ICMP_FRAG_NEEDED) {
+			sctp_icmp_frag_needed(sk, asoc, t, SCTP_TRUNC4(info));
+			return;
+		}
+		if (code == ICMP_PROT_UNREACH) {
+			sctp_icmp_proto_unreachable(sk, asoc, t);
+			return;
+		}
+		err = icmp_err_convert[code].errno;
+		break;
+	case ICMP_TIME_EXCEEDED:
+		if (code == ICMP_EXC_FRAGTIME)
+			return;
+
+		err = EHOSTUNREACH;
+		break;
+	case ICMP_REDIRECT:
+		sctp_icmp_redirect(sk, t, skb);
+	default:
+		return;
+	}
+	if (!sock_owned_by_user(sk) && inet_sk(sk)->recverr) {
+		sk->sk_err = err;
+		sk->sk_error_report(sk);
+	} else {  /* Only an error on timeout */
+		sk->sk_err_soft = err;
+	}
+}
+
 /*
  * This routine is called by the ICMP module when it gets some
  * sort of error condition.  If err < 0 then the socket should
@@ -574,22 +617,19 @@ void sctp_err_finish(struct sock *sk, struct sctp_transport *t)
 int sctp_v4_err(struct sk_buff *skb, __u32 info)
 {
 	const struct iphdr *iph = (const struct iphdr *)skb->data;
-	const int ihlen = iph->ihl * 4;
 	const int type = icmp_hdr(skb)->type;
 	const int code = icmp_hdr(skb)->code;
-	struct sock *sk;
-	struct sctp_association *asoc = NULL;
+	struct net *net = dev_net(skb->dev);
 	struct sctp_transport *transport;
-	struct inet_sock *inet;
+	struct sctp_association *asoc;
 	__u16 saveip, savesctp;
-	int err;
-	struct net *net = dev_net(skb->dev);
+	struct sock *sk;
 
 	/* Fix up skb to look at the embedded net header. */
 	saveip = skb->network_header;
 	savesctp = skb->transport_header;
 	skb_reset_network_header(skb);
-	skb_set_transport_header(skb, ihlen);
+	skb_set_transport_header(skb, iph->ihl * 4);
 	sk = sctp_err_lookup(net, AF_INET, skb, sctp_hdr(skb), &asoc, &transport);
 	/* Put back, the original values. */
 	skb->network_header = saveip;
@@ -598,58 +638,10 @@ int sctp_v4_err(struct sk_buff *skb, __u32 info)
 		__ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
 		return -ENOENT;
 	}
-	/* Warning:  The sock lock is held.  Remember to call
-	 * sctp_err_finish!
-	 */
-
-	switch (type) {
-	case ICMP_PARAMETERPROB:
-		err = EPROTO;
-		break;
-	case ICMP_DEST_UNREACH:
-		if (code > NR_ICMP_UNREACH)
-			goto out_unlock;
-
-		/* PMTU discovery (RFC1191) */
-		if (ICMP_FRAG_NEEDED == code) {
-			sctp_icmp_frag_needed(sk, asoc, transport,
-					      SCTP_TRUNC4(info));
-			goto out_unlock;
-		} else {
-			if (ICMP_PROT_UNREACH == code) {
-				sctp_icmp_proto_unreachable(sk, asoc,
-							    transport);
-				goto out_unlock;
-			}
-		}
-		err = icmp_err_convert[code].errno;
-		break;
-	case ICMP_TIME_EXCEEDED:
-		/* Ignore any time exceeded errors due to fragment reassembly
-		 * timeouts.
-		 */
-		if (ICMP_EXC_FRAGTIME == code)
-			goto out_unlock;
-
-		err = EHOSTUNREACH;
-		break;
-	case ICMP_REDIRECT:
-		sctp_icmp_redirect(sk, transport, skb);
-		/* Fall through to out_unlock. */
-	default:
-		goto out_unlock;
-	}
-
-	inet = inet_sk(sk);
-	if (!sock_owned_by_user(sk) && inet->recverr) {
-		sk->sk_err = err;
-		sk->sk_error_report(sk);
-	} else {  /* Only an error on timeout */
-		sk->sk_err_soft = err;
-	}
 
-out_unlock:
+	sctp_v4_err_handle(transport, skb, type, code, info);
 	sctp_err_finish(sk, transport);
+
 	return 0;
 }
 
-- 
2.53.0



