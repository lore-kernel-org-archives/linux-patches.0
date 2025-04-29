Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23FF2472B9;
	Tue, 29 Apr 2025 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949074; cv=none; b=SCxUcZ67JiO2J1D7lYQcD0k6BpnzhgzQNCjV1+WEt7j25eY8obcB/4J8Sxn/SewBOlm0o6pjz5h0U+txzzdfHKaeKILOah176UnUV2K/e14IJNx8ZF37qLW+JAAwcJ4nhRjejr0aKl04mHkuL3Tue5kj6i/zEqv1Npsy7bdbn/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949074; c=relaxed/simple;
	bh=/gMo7YWm+7G4QqVktOch7ytkdK7VIpLhpqRSlTG+F3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iegw86tJVG3w3ZnPtEWEnCxPHNOv08bdMTX8K6NoLtrWglo31zcaMhDcE8FyP1byboRnsEQtUNH5GYj0pRy4RctaBgtoxW8EzCs15fOvfw14HNrPE6fA2pgpTRoPoXSi2Dbb/Us8Td8sC/6L3xG1fh+9NSSdqpzkuoeGBIx04fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opazBSvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opazBSvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63804C4CEE3;
	Tue, 29 Apr 2025 17:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949073;
	bh=/gMo7YWm+7G4QqVktOch7ytkdK7VIpLhpqRSlTG+F3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opazBSvCZjM2iCzJcAsp5UzGS3CgZiZApZ2UsawZSKzU9Ug+BUpdiMxaYneks6gUh
	 3IfYHjxthaa6J1/S0lm8n/mA+d5lqg2bNqxxF249ObBW9RxyovXEGjxb1wophOZ23n
	 ZOuhTkXfXJSUfDqXFjqGy7QsoyIhqN7Xjv/zft9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <courmisch@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 206/373] phonet/pep: fix racy skb_queue_empty() use
Date: Tue, 29 Apr 2025 18:41:23 +0200
Message-ID: <20250429161131.638270468@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[Harshit: backport to 5.15.y, clean cherrypick from 6.1.y commit]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pep.c |   41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -916,6 +916,37 @@ static int pep_sock_enable(struct sock *
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
@@ -929,15 +960,7 @@ static int pep_ioctl(struct sock *sk, in
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
 


