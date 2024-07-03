Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2128B178374;
	Wed,  3 Jul 2024 11:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005298; cv=none; b=S/rq0WrASVveC0Vmu4ugvk2IxGwl9fLXhROh8AEt8KMHOT15BwTtkmSHFTZSZCZdhatI8G4ayDdh9UxaEwcWaXds58Tj/RjZxulUmuPLQ2J2QbTLUVobmjSnn9DpO7skr9IgESv7q9GtmFYB5ilcAbz51aVNsFOhP73509Gtd8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005298; c=relaxed/simple;
	bh=lG0oCdre0Fp7vASOKeYlwyzvsNKBHPzUWZHR1R+ySLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yu1unzypW0Cdm/YofO6gMV9PT6WVQbm8l/tW3hkfsLjWAz3Sr2Ne/nsbewGiZgk5wqSEhcIgpucn/EkcZqu1WLWpwJykx+HpAwDDwzwzh3GlBTf6kW5utfnf1HvEzHP5LE8JfLYJ1PW0O+f4LaKA6PrNY8nZ1oTgVqYQgHyzqrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smohL/9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smohL/9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92442C2BD10;
	Wed,  3 Jul 2024 11:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005298;
	bh=lG0oCdre0Fp7vASOKeYlwyzvsNKBHPzUWZHR1R+ySLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smohL/9+JsUFuLhu8t62jkbNanDJvGwfSlEKJkXxJ1lINzGJjhUqT+xx7keK5247O
	 vqrM0444lihBy2Pxpt+28vEIIN6gRDawIGiTh1A4kG4aLsoknVmKfqq30yiFQIDGUM
	 djbFpP5DMYjwE2b3TP8GIIwBRZeZoPv18ujWkPDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/356] af_unix: Use skb_queue_len_lockless() in sk_diag_show_rqlen().
Date: Wed,  3 Jul 2024 12:36:10 +0200
Message-ID: <20240703102914.387508428@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 5d915e584d8408211d4567c22685aae8820bfc55 ]

We can dump the socket queue length via UNIX_DIAG by specifying
UDIAG_SHOW_RQLEN.

If sk->sk_state is TCP_LISTEN, we return the recv queue length,
but here we do not hold recvq lock.

Let's use skb_queue_len_lockless() in sk_diag_show_rqlen().

Fixes: c9da99e6475f ("unix_diag: Fixup RQLEN extension report")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/diag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -103,7 +103,7 @@ static int sk_diag_show_rqlen(struct soc
 	struct unix_diag_rqlen rql;
 
 	if (READ_ONCE(sk->sk_state) == TCP_LISTEN) {
-		rql.udiag_rqueue = sk->sk_receive_queue.qlen;
+		rql.udiag_rqueue = skb_queue_len_lockless(&sk->sk_receive_queue);
 		rql.udiag_wqueue = sk->sk_max_ack_backlog;
 	} else {
 		rql.udiag_rqueue = (u32) unix_inq_len(sk);


