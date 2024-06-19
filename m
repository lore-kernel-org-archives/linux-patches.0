Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501BA14D6FF;
	Wed, 19 Jun 2024 13:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802119; cv=none; b=HzL6sM3uVVAKNUVLhlRAEkEZab3nWGXCMMKOE3ZFdCp2NCy0Ty76hAyfnyqrgoJukrZxZU5Xud9SiFLEFXeHWKdSk4rfYjo4HQYE8B9FxKSSB/fZ89G+nYIHsP6YxmxVupmw6aDQiP2i0kEgz5CJKgJoU73C6bVbRCwcJ7VEh6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802119; c=relaxed/simple;
	bh=boYJKt/P5yriSnnkSRqyafLC5v67NijfvKduTrvs0rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OL7U+9qGi253+DcwY3Fbvf9EEmQXJti1BmRLzqLR7PrXYqzdtKcjbqoBidplMpk4kQ64f2JKjGu2Z5oiSyNWyuQdp5fW1tK5U7wk+P3EHAaR1/D0yIawj7l+R6m1tgnGCINEy7P3+iB/s1vHPLO4yIfG5oATDjimLhtmFRwjfLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1be7kBtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1be7kBtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE30CC2BBFC;
	Wed, 19 Jun 2024 13:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802119;
	bh=boYJKt/P5yriSnnkSRqyafLC5v67NijfvKduTrvs0rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1be7kBtgEuXZtZwWlm+WHpeIs1gnnhYongrwSl4YkWLqp+2NQi1L9rFo4MgoadQpp
	 HDkw/xlCp7Wt0Ry+TZ8TaKR+AWP36AL/a1b5KW1NyegKWTWRn4SJLEoI9pAXsZY5p2
	 TNjz7rEn969KjB+5fxv5ZH3YgbHQXMt37We5wAVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/267] af_unix: Annotate data-race of net->unx.sysctl_max_dgram_qlen.
Date: Wed, 19 Jun 2024 14:53:28 +0200
Message-ID: <20240619125608.549796944@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit bd9f2d05731f6a112d0c7391a0d537bfc588dbe6 ]

net->unx.sysctl_max_dgram_qlen is exposed as a sysctl knob and can be
changed concurrently.

Let's use READ_ONCE() in unix_create1().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 4640497c29da4..2b35c517be718 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -990,7 +990,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 	sk->sk_hash		= unix_unbound_hash(sk);
 	sk->sk_allocation	= GFP_KERNEL_ACCOUNT;
 	sk->sk_write_space	= unix_write_space;
-	sk->sk_max_ack_backlog	= net->unx.sysctl_max_dgram_qlen;
+	sk->sk_max_ack_backlog	= READ_ONCE(net->unx.sysctl_max_dgram_qlen);
 	sk->sk_destruct		= unix_sock_destructor;
 	u = unix_sk(sk);
 	u->inflight = 0;
-- 
2.43.0



