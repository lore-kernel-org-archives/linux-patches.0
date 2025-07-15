Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04C32E62D8;
	Tue, 15 Jul 2025 13:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586600; cv=none; b=E1zcC2W1agf6dCUkC35QMxP7fQvTvklfwHW/bC32lQs0aR+VoQBJPb/buJxjJsBWid3dyO5RNYw2CpZ/kGBJ7boPBnDHRJQ/XFDAViUU3DZq1BA+SCGQKOmztB13qiMBy4hlcp6Vua7WxybbWJ5/S/iIqHKNWWKLIeTdHzHQJCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586600; c=relaxed/simple;
	bh=A6WgEmhyxehoktpG5uLNkIk9ZQKu7OtHQnJg3Mvu09k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUTwHSWWhvgl09Ue0OOlgbCZY3njvbxwYvdfuo6m3YHIRpBRU766hinTw5+Z8AsOP5SHCvC2PEXZ5OnBIiyMOqnHJC2W5MiDXnMlw6M7RXAFH/SSi/H590l51lq2MtqTxWSfvuo8Zi4ww2HdQNnvUsQqdVmmxnaYx68q0PPXoRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mq7rvtTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mq7rvtTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A904C4CEE3;
	Tue, 15 Jul 2025 13:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586599;
	bh=A6WgEmhyxehoktpG5uLNkIk9ZQKu7OtHQnJg3Mvu09k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mq7rvtTFImdz66C64NT1g65w4gv45/A25+P1D+Z5kOOK80g6Zlh+epOPhLmb8wVkV
	 34LTKumi609k8rOx+mFuz4CwmaAIYdeIbWSltNTZl4BHUcEOgk2phUKUgfzzPLoxnz
	 kFCePCdx9CkZE2kT7DdfYKkfN37s9zMFq9u89xyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 126/148] netlink: Fix rmem check in netlink_broadcast_deliver().
Date: Tue, 15 Jul 2025 15:14:08 +0200
Message-ID: <20250715130805.338395847@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1390,7 +1390,7 @@ static int netlink_broadcast_deliver(str
 	rmem = atomic_add_return(skb->truesize, &sk->sk_rmem_alloc);
 	rcvbuf = READ_ONCE(sk->sk_rcvbuf);
 
-	if ((rmem != skb->truesize || rmem <= rcvbuf) &&
+	if ((rmem == skb->truesize || rmem <= rcvbuf) &&
 	    !test_bit(NETLINK_S_CONGESTED, &nlk->state)) {
 		netlink_skb_set_owner_r(skb, sk);
 		__netlink_sendskb(sk, skb);


