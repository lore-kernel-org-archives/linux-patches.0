Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDB72E7172;
	Tue, 15 Jul 2025 13:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586245; cv=none; b=stgP8BZP5z4GRuGmd0/VMsp6QjpwPFmRH7gLOT3FaUPjCFc/CfFYh2t3udXWtB8E3cOiuiBDWlK74db+X3IFFwWOA2EYZMsf0lV9yO41Tc7b9iBPoV9U/wypVSroaip5o4EcQmOHBMNvRawh7RtRVeFnKMWbsS/4biNyYfA0ASI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586245; c=relaxed/simple;
	bh=WNplIKHBG7QR0kMTXhvUaaXVdIccg9QUGoQerkee/sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZFQiV2nMypZKjgwuzxQsswzM2xm49sKDNyyTUEWWpbkrSkKkBH7yE+TnIFzoAP9L9n/3Wif8agOp5cLLz+KVwvlvfjwtP0gKHLx4KZNWi/pIjtFEnSlw7oElsb9EYG/UbdKhiIlsW4GwjP/XIpMe5E93OilPmWrHQdFFLc+jAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lD4qaYEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lD4qaYEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A18C4CEE3;
	Tue, 15 Jul 2025 13:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586245;
	bh=WNplIKHBG7QR0kMTXhvUaaXVdIccg9QUGoQerkee/sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lD4qaYEtGf1PHgNlztmOeNT6C9q1z7QU7+0lSZGnNmwm/nZO8eCBNftwH2+KVJdiu
	 LXGXQvnIpJ7qapgbLUa7crU2akeL9UTNxgtxAfnc/aPEY136+a8EvKjvTsAu0w4pU/
	 YfznmNnx3uIY8LBCES05n9iPZNslPM/D4rkQBXI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 39/77] netlink: Fix rmem check in netlink_broadcast_deliver().
Date: Tue, 15 Jul 2025 15:13:38 +0200
Message-ID: <20250715130753.279486941@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1395,7 +1395,7 @@ static int netlink_broadcast_deliver(str
 	rmem = atomic_add_return(skb->truesize, &sk->sk_rmem_alloc);
 	rcvbuf = READ_ONCE(sk->sk_rcvbuf);
 
-	if ((rmem != skb->truesize || rmem <= rcvbuf) &&
+	if ((rmem == skb->truesize || rmem <= rcvbuf) &&
 	    !test_bit(NETLINK_S_CONGESTED, &nlk->state)) {
 		netlink_skb_set_owner_r(skb, sk);
 		__netlink_sendskb(sk, skb);


