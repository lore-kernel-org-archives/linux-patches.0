Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFEF2E3382;
	Tue, 15 Jul 2025 13:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587886; cv=none; b=Wx9G7OqTaSUaEKEDfEFvj14K7wxZvCaiEIQy3jRHimDNeZoScSpcL5GDYVsHXa0MjjVkGnjVsaD2wNbIIKyE2XStEFTKbt6f/PKFbEiiN6p7UaanGwxH6YYFRP8WqpMqxZE7yWoxKhTYIt0PrqOvLSbnW/wJt+OYUlExKw666tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587886; c=relaxed/simple;
	bh=Vfp7Mf0ede5rPm34SGRd5nc0EGTUoCOumcJHsdBdTEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N40+B1fgETAounzB8BrBWN4m7LW3jRKS+YE8b1mp1xjqo0ducLYB+sKmlhuPn0yqJEJ/bInkDw9jR330c4SOXutck/+G1ThdH2JpNriZFZXCkc+XsWHBu00tO0f5xHH7dpVM6q9pjdPMW2rkoFiS+nhkyk0U2uLW8H4X+3UlZ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KGY9NBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KGY9NBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3F7C4CEE3;
	Tue, 15 Jul 2025 13:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587886;
	bh=Vfp7Mf0ede5rPm34SGRd5nc0EGTUoCOumcJHsdBdTEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KGY9NBPs4t02s6cpDP5rtaNnlhZKKA5c84dw7KBp47bHT6mHvkGWUWYLuQjAYNUx
	 EwH2Gk5cavmQeunRrbv08Tj5OxmQFIXR0I2d8jpVrVeZL5mEDYiTTSRz5ZEBNRng5d
	 +r5MlBVkC3Ju0rwRQRAXiCDdXQ5ZbU134EQb53Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 181/208] netlink: Fix rmem check in netlink_broadcast_deliver().
Date: Tue, 15 Jul 2025 15:14:50 +0200
Message-ID: <20250715130818.211785698@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1391,7 +1391,7 @@ static int netlink_broadcast_deliver(str
 	rmem = atomic_add_return(skb->truesize, &sk->sk_rmem_alloc);
 	rcvbuf = READ_ONCE(sk->sk_rcvbuf);
 
-	if ((rmem != skb->truesize || rmem <= rcvbuf) &&
+	if ((rmem == skb->truesize || rmem <= rcvbuf) &&
 	    !test_bit(NETLINK_S_CONGESTED, &nlk->state)) {
 		netlink_skb_set_owner_r(skb, sk);
 		__netlink_sendskb(sk, skb);


