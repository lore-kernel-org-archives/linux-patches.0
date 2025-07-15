Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6452472AE;
	Tue, 15 Jul 2025 13:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585609; cv=none; b=SEHoaCKZYJgroWzwqFA4YtQqDUlegwzeZdWZznJAu0MxgJvhrvL1kh8FAoFBjwO6NNMeTSM30Iz91VK3Sf++I/0/TApSDYJRa/bcQCc6N6XD7xPnsNulHd9xuHxrizMrFZNMtDCe62azP6XHS8O8bowkY4MsO61l3SvQxkDjWqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585609; c=relaxed/simple;
	bh=svep4TRvTCJFUpV6/op7dIlowU1foafecS0s9B77HVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJApgs34iXBNabV7qd3T+nYFDc4JCiMxF3BEVwHfa3Yi7aqOkIYy5kueS+xoRPavYbUa2rXbzKEgtFNSHDFyFQliRq0hr6KZ6TGJtEEUavnYAjYI3flL1cOo6x+SZ4H6m66A4bdm9e095mYVdyd3QRpSKJlHXtY1K5wn2o3k0j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPWK2vYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPWK2vYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58A0C4CEF8;
	Tue, 15 Jul 2025 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585609;
	bh=svep4TRvTCJFUpV6/op7dIlowU1foafecS0s9B77HVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPWK2vYPdNkaqAmOWAEIlK9QZSwvQCyMwZP4G8+EZsWIsVB3hUCLhKFWbcygqMPHs
	 QvyNAwJPBzBl9nstmzm0Q4UZrOaTPtC+T3jGEiG8L6YLuQ1BIrjwLz3StzLnQL1P9x
	 FHDRpFXPoe1dGlHKvkrZV3LDhp1gJSen3facdm7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 104/163] netlink: Fix rmem check in netlink_broadcast_deliver().
Date: Tue, 15 Jul 2025 15:12:52 +0200
Message-ID: <20250715130813.034518051@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

commit a3c4a125ec725cefb40047eb05ff9eafd57830b4 upstream.

We need to allow queuing at least one skb even when skb is
larger than sk->sk_rcvbuf.

The cited commit made a mistake while converting a condition
in netlink_broadcast_deliver().

Let's correct the rmem check for the allow-one-skb rule.

Fixes: ae8f160e7eb24 ("netlink: Fix wraparounds of sk->sk_rmem_alloc.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250711053208.2965945-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1398,7 +1398,7 @@ static int netlink_broadcast_deliver(str
 	rmem = atomic_add_return(skb->truesize, &sk->sk_rmem_alloc);
 	rcvbuf = READ_ONCE(sk->sk_rcvbuf);
 
-	if ((rmem != skb->truesize || rmem <= rcvbuf) &&
+	if ((rmem == skb->truesize || rmem <= rcvbuf) &&
 	    !test_bit(NETLINK_S_CONGESTED, &nlk->state)) {
 		netlink_skb_set_owner_r(skb, sk);
 		__netlink_sendskb(sk, skb);


