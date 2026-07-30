Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8416D3C3F4C;
	Thu, 30 Jul 2026 14:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421902; cv=none; b=hVvmfed2bFezMLKIFZf6whvT4QDNk+//CLWQzhP2Cr2sh/gLrB8aw/9SZC0GjI7jhWDYiySD1Sm94fkG/bSp+dQecsQoYXP1jS7RP3G5yX97dS8J3e8+KpEr0JnH9OU584Y1rWZAQg99UpW0SYxFDcNj9butle4LQbdJ2iysjf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421902; c=relaxed/simple;
	bh=xRiLTqUl1b21O6xBvhj4md3pP2pFimSxbPjkZ2TQEhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmbKZ9IdxWZ8UYidZZaS5OcVqXCOCfRuEu01MBiqp13w/y3gp7Gh9tKOBE1RXoigCWk0baBtBChuuuegA4LOS88sWNTpKwdJJ5Dnm4NG5sXcTPWupB3Igni7b88PbKi2x0FAloyLLB6f0wGYfPU6OO6P70BAAFdiOicClErcyy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIFEF2qk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIFEF2qk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C34F1F000E9;
	Thu, 30 Jul 2026 14:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421901;
	bh=dHig/fcGUkSqvlbWgkt5qKEb5AVizzYK6t3DVZ7Pg5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIFEF2qkXMXjRDnjBrhcWkN9lP/qwvD11FhFgJJ0FCAcxI+Q7nOeLM6bz6TVB8C0G
	 WtrWQ9EfXxz30dKdU8ecwUG0PJ7KxwfYKOm50OUi4QxXSpRbTINc0O1WxAGHIGgXLq
	 PkY+Ji6EcOXV1audkKxiukzQSaCpBM43zNhzUbyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 257/744] soreuseport: Clear sk_reuseport_cb before failure in sk_clone().
Date: Thu, 30 Jul 2026 16:08:50 +0200
Message-ID: <20260730141449.756313369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 98da8ce87dd561f08fbe44f75865edc5d9b2ba5f ]

When sk_clone() fails, sk_destruct() is called for the new socket.

If the parent socket has sk->sk_reuseport_cb, the child will call
reuseport_detach_sock() for the reuseport group.

Let's clear sk->sk_reuseport_cb before any failure path in sk_clone().

Note that this was not a problem before the cited commit because
reuseport_detach_sock() did nothing if the socket was not found in
the reuseport array.

Fixes: 5dc4c4b7d4e8 ("bpf: Introduce BPF_MAP_TYPE_REUSEPORT_SOCKARRAY")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260709032007.9E4D61F000E9@smtp.kernel.org/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260709183315.965751-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 1c73b6841d0ae9..d0f518381334ca 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2547,6 +2547,8 @@ struct sock *sk_clone(const struct sock *sk, const gfp_t priority,
 
 	cgroup_sk_clone(&newsk->sk_cgrp_data);
 
+	RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
+
 	rcu_read_lock();
 	filter = rcu_dereference(sk->sk_filter);
 	if (filter != NULL)
@@ -2569,8 +2571,6 @@ struct sock *sk_clone(const struct sock *sk, const gfp_t priority,
 		goto free;
 	}
 
-	RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
-
 	if (bpf_sk_storage_clone(sk, newsk))
 		goto free;
 
-- 
2.53.0



