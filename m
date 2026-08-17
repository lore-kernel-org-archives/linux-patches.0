Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F141938E8B9;
	Mon, 17 Aug 2026 14:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976332; cv=none; b=h9DhTTyYSqKLB8/hK+jTQ66+tvMKJztLRLvVjow6r/sNPrP4wgo+zvHPbzXxRm+5mbP8LkjXQ2Lgqqr1bnR3OHfsFgtqgwFL7j9naZ7qrqe5vM2tw0rc/lzhQhJ1Y4HyVlBNHMfZWuPzaGgi1lsIdpQTMjwDr2q2ILO/Vo25jW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976332; c=relaxed/simple;
	bh=EfJzNhV0HRO4hr0Y6wdv5oSQ3EgeIWBuKtNnXBGXJFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwb3vVP8QcBmvFYcuY0zGAahPsiqLVjR41KRMY8Z4HimH/DOSpVLdQcW/0GnyC441KxxR7TG2DBkSFd4Rn9YZ+i46egQHgnCm5H0TSUala0FJNVEUpFdtWWveX3aBWJiCTDaBt82T3WhNtJFtL+7JgJPeG2/SO7N/9IsqyAefqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqUP5+3m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqUP5+3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EE01F00A3A;
	Mon, 17 Aug 2026 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976330;
	bh=1SeFgx7FNU6ORY2AYPt4j6lB3BEIQUC3cLExZSQ90FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uqUP5+3mNRJojqeh0lCd7Kdo7nQRZtoFsDljUZPPfUSQ4pNtW+SaTui7SdUi8oJhP
	 F/K3rRgZk4gu/7jTB/qjrFCBneXpjMIvodNUEFuH6I1RDhdZimnOEiJ0N6TUFBM2kc
	 AIOeOO64u2gN0j1KorqTDG/1ukngr02dnOyxZdbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 337/389] sctp: remove the unessessary hold for idev in sctp_v6_err
Date: Mon, 17 Aug 2026 15:32:56 +0200
Message-ID: <20260817132551.998522353@linuxfoundation.org>
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

[ Upstream commit 237a6a2e318c1ed7429e72f2640054bdda91646f ]

Same as in tcp_v6_err() and __udp6_lib_err(), there's no need to
hold idev in sctp_v6_err(), so just call __in6_dev_get() instead.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: af0e5cdd031f ("tls: don't abort the connection on signal-interrupted sends")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/ipv6.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index a9cfe4d62df83..984ec00ad6384 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -125,7 +125,6 @@ static struct notifier_block sctp_inet6addr_notifier = {
 static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 			u8 type, u8 code, int offset, __be32 info)
 {
-	struct inet6_dev *idev;
 	struct sock *sk;
 	struct sctp_association *asoc;
 	struct sctp_transport *transport;
@@ -134,8 +133,6 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	int err, ret = 0;
 	struct net *net = dev_net(skb->dev);
 
-	idev = in6_dev_get(skb->dev);
-
 	/* Fix up skb to look at the embedded net header. */
 	saveip	 = skb->network_header;
 	savesctp = skb->transport_header;
@@ -146,9 +143,8 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	skb->network_header   = saveip;
 	skb->transport_header = savesctp;
 	if (!sk) {
-		__ICMP6_INC_STATS(net, idev, ICMP6_MIB_INERRORS);
-		ret = -ENOENT;
-		goto out;
+		__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
+		return -ENOENT;
 	}
 
 	/* Warning:  The sock lock is held.  Remember to call
@@ -184,10 +180,6 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 out_unlock:
 	sctp_err_finish(sk, transport);
-out:
-	if (likely(idev != NULL))
-		in6_dev_put(idev);
-
 	return ret;
 }
 
-- 
2.53.0



