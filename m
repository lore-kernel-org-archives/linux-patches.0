Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B50B1C871E;
	Tue, 27 Aug 2024 15:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771928; cv=none; b=Uka5hqjL1AYle0aB2WljpjRHukaBVZkUoUKPgG1yMHFQSXCRpeuiRr4Q8OZkDZIROluRteOmPFOrslLLf92NarWkz3nEm5815Jpbo1BaI28lhsVZIKycpDwXWjDzeFchbaRl5S7D0o9Sv018E+SV6K/u8RtI63HWqHtem18TG/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771928; c=relaxed/simple;
	bh=lwqtUqikA00akbWUxBTEcJ9rgiEMZys0KQAYxgftQPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETGCgCv7H5X+i3YPjNpQiFOyc8zUfrz4YLFud2FEzW8b9rqrjpTmxBQQwft0ZLh4K+rB2OyOOVK1OjKjsrLzCqnb1eKYauUf0tFhDLeCc8Njdt0UcRjBImHlck35eQTTvwDF4IgwjaWBGGJh86W1v5gYVlv+bRGTaJvvkN6itAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bt2bSGjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bt2bSGjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC81C61067;
	Tue, 27 Aug 2024 15:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771928;
	bh=lwqtUqikA00akbWUxBTEcJ9rgiEMZys0KQAYxgftQPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bt2bSGjdkTr1FC7ts51yK7UPaesdz/brcHnfPgZPAdYXuaW1vhG2wbcPuSkgqocY9
	 CkO3df83LdLqOWygE+hRg/1cmiZSPk8iU5coBQ3ZRtydx3/B/lEAvNTGZQr0TGbm9B
	 yyJJQ5RNRQ0/hBGT6yfk1z4vMRiW58+qH5onRfjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6bdfd184eac7709e5cc9@syzkaller.appspotmail.com,
	Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/321] pppoe: Fix memory leak in pppoe_sendmsg()
Date: Tue, 27 Aug 2024 16:36:09 +0200
Message-ID: <20240827143840.560005336@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

[ Upstream commit dc34ebd5c018b0edf47f39d11083ad8312733034 ]

syzbot reports a memory leak in pppoe_sendmsg [1].

The problem is in the pppoe_recvmsg() function that handles errors
in the wrong order. For the skb_recv_datagram() function, check
the pointer to skb for NULL first, and then check the 'error' variable,
because the skb_recv_datagram() function can set 'error'
to -EAGAIN in a loop but return a correct pointer to socket buffer
after a number of attempts, though 'error' remains set to -EAGAIN.

skb_recv_datagram
      __skb_recv_datagram          // Loop. if (err == -EAGAIN) then
                                   // go to the next loop iteration
          __skb_try_recv_datagram  // if (skb != NULL) then return 'skb'
                                   // else if a signal is received then
                                   // return -EAGAIN

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with Syzkaller.

Link: https://syzkaller.appspot.com/bug?extid=6bdfd184eac7709e5cc9 [1]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+6bdfd184eac7709e5cc9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6bdfd184eac7709e5cc9
Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://lore.kernel.org/r/20240214085814.3894917-1-Ilia.Gavrilov@infotecs.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/pppoe.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index ce2cbb5903d7b..c6f44af35889d 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -1007,26 +1007,21 @@ static int pppoe_recvmsg(struct socket *sock, struct msghdr *m,
 	struct sk_buff *skb;
 	int error = 0;
 
-	if (sk->sk_state & PPPOX_BOUND) {
-		error = -EIO;
-		goto end;
-	}
+	if (sk->sk_state & PPPOX_BOUND)
+		return -EIO;
 
 	skb = skb_recv_datagram(sk, flags, &error);
-	if (error < 0)
-		goto end;
+	if (!skb)
+		return error;
 
-	if (skb) {
-		total_len = min_t(size_t, total_len, skb->len);
-		error = skb_copy_datagram_msg(skb, 0, m, total_len);
-		if (error == 0) {
-			consume_skb(skb);
-			return total_len;
-		}
+	total_len = min_t(size_t, total_len, skb->len);
+	error = skb_copy_datagram_msg(skb, 0, m, total_len);
+	if (error == 0) {
+		consume_skb(skb);
+		return total_len;
 	}
 
 	kfree_skb(skb);
-end:
 	return error;
 }
 
-- 
2.43.0



