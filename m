Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A30F13B2B8;
	Tue, 27 Feb 2024 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043633; cv=none; b=pmeb+AEqfl4FHOnPs5hINMF/JwFoFUb7OuIWUqWxZLa+uEAKVbn3S/huBIczkRfMQjzqXbpmQB3Efh6vhNsboKtJumbRKqWrjRWBfuELgHg4V9XX8pRDNeDv1dVCUCHMdu3HJyLLep7lDomaZN9SZ5UwnB6jVcvDrt+p3AN7EFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043633; c=relaxed/simple;
	bh=O9D09h1W5eKkDtdH8+iIRMAW7IGMLGsnJTXbj3Ck690=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QWXCZxfMmGkU6mPiiFHjNBqfI7NHlPWKUlSVQYewOnQHatTMmtSWxj0g0PO0naSrReyqt1toshzZ2eiAokSrwynlzzn3M24aOlfXYRWrqxY09HyNOOnEzEb5+6E5hjQ1Uhpd58M0ZucvTbylOi9McxKeTxUzB6hFPkCFkQ45h7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaOja+B5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaOja+B5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7962C433B1;
	Tue, 27 Feb 2024 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043633;
	bh=O9D09h1W5eKkDtdH8+iIRMAW7IGMLGsnJTXbj3Ck690=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaOja+B5D5TY4z7kjwQe2rPBCUMkrGs45qDyUe/wdyQ9khXpdqR2BzOAPLEWHqwRC
	 Y5HKh71Pg6j7Ge78ebWQa6QBecgoysDPsQCZevkIXLYukJW69SyCi0sxKXuDSVunmQ
	 npN6H6y6800ELIC1BeJ/iZrjV2PFj4W/BX39oy2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <courmisch@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/195] phonet/pep: fix racy skb_queue_empty() use
Date: Tue, 27 Feb 2024 14:27:20 +0100
Message-ID: <20240227131616.314202994@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rémi Denis-Courmont <courmisch@gmail.com>

[ Upstream commit 7d2a894d7f487dcb894df023e9d3014cf5b93fe5 ]

The receive queues are protected by their respective spin-lock, not
the socket lock. This could lead to skb_peek() unexpectedly
returning NULL or a pointer to an already dequeued socket buffer.

Fixes: 9641458d3ec4 ("Phonet: Pipe End Point for Phonet Pipes protocol")
Signed-off-by: Rémi Denis-Courmont <courmisch@gmail.com>
Link: https://lore.kernel.org/r/20240218081214.4806-2-remi@remlab.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/phonet/pep.c |   41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -917,6 +917,37 @@ static int pep_sock_enable(struct sock *
 	return 0;
 }
 
+static unsigned int pep_first_packet_length(struct sock *sk)
+{
+	struct pep_sock *pn = pep_sk(sk);
+	struct sk_buff_head *q;
+	struct sk_buff *skb;
+	unsigned int len = 0;
+	bool found = false;
+
+	if (sock_flag(sk, SOCK_URGINLINE)) {
+		q = &pn->ctrlreq_queue;
+		spin_lock_bh(&q->lock);
+		skb = skb_peek(q);
+		if (skb) {
+			len = skb->len;
+			found = true;
+		}
+		spin_unlock_bh(&q->lock);
+	}
+
+	if (likely(!found)) {
+		q = &sk->sk_receive_queue;
+		spin_lock_bh(&q->lock);
+		skb = skb_peek(q);
+		if (skb)
+			len = skb->len;
+		spin_unlock_bh(&q->lock);
+	}
+
+	return len;
+}
+
 static int pep_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
 	struct pep_sock *pn = pep_sk(sk);
@@ -930,15 +961,7 @@ static int pep_ioctl(struct sock *sk, in
 			break;
 		}
 
-		lock_sock(sk);
-		if (sock_flag(sk, SOCK_URGINLINE) &&
-		    !skb_queue_empty(&pn->ctrlreq_queue))
-			answ = skb_peek(&pn->ctrlreq_queue)->len;
-		else if (!skb_queue_empty(&sk->sk_receive_queue))
-			answ = skb_peek(&sk->sk_receive_queue)->len;
-		else
-			answ = 0;
-		release_sock(sk);
+		answ = pep_first_packet_length(sk);
 		ret = put_user(answ, (int __user *)arg);
 		break;
 


