Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3C71E991F;
	Wed, 15 Jan 2025 10:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937560; cv=none; b=CMSGwk7p15fKcyoaB/I8vMgwHvV/4csqP6V9d2U4NGENlClIYw3vdCqnLAAquvuy2x/X8lXXk1UIE99TW8EH4vcK0uMsF1vPuzc/4TV0kKJYZ3BwXSslGrTawI1ZlEbrr14hLLL5cNM28ym9ckWBWeXHFR9Dt113iMVCIMa2abY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937560; c=relaxed/simple;
	bh=YSofo2uRGk3eru5wDP8cgJieZa2kKYMRasrFKx0zLYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+S3cTB/XeefP8SG3Y+Qo3egiVcby9LWPJ5JNKFHOVYvWkWwpKqO68/s6THSi+rZE24t9UMw7vpBvMxSKkgjgL5VE658G6xMuSPXBuoA3GRa/sl0SEUVQpJze5aF9va+sW7QWtQpXAmX7bz9mBhGP43dqnGfjlJyaSXxHtQTq3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEJ+YL6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEJ+YL6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D253DC4CEDF;
	Wed, 15 Jan 2025 10:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937559;
	bh=YSofo2uRGk3eru5wDP8cgJieZa2kKYMRasrFKx0zLYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEJ+YL6Une3Do0nMaw3MEtNXT6KRW5MJ5AudLBpJE6XlVGIkhBefkUqwLiTBvJPek
	 81j8bY6F3M0MDU9ZkScLlNHuVaulKLp3qkSCOaKeS3JWj9/XXBjD3lp8TCyPZPCOve
	 rWdL6g87+On8dlX57kZdbYrHFIwWpVzTd8R6Zm94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/92] tcp/dccp: allow a connection when sk_max_ack_backlog is zero
Date: Wed, 15 Jan 2025 11:36:34 +0100
Message-ID: <20250115103548.187703370@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>

[ Upstream commit 3479c7549fb1dfa7a1db4efb7347c7b8ef50de4b ]

If the backlog of listen() is set to zero, sk_acceptq_is_full() allows
one connection to be made, but inet_csk_reqsk_queue_is_full() does not.
When the net.ipv4.tcp_syncookies is zero, inet_csk_reqsk_queue_is_full()
will cause an immediate drop before the sk_acceptq_is_full() check in
tcp_conn_request(), resulting in no connection can be made.

This patch tries to keep consistent with 64a146513f8f ("[NET]: Revert
incorrect accept queue backlog changes.").

Link: https://lore.kernel.org/netdev/20250102080258.53858-1-kuniyu@amazon.com/
Fixes: ef547f2ac16b ("tcp: remove max_qlen_log")
Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250102171426.915276-1-dzq.aishenghu0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 1611fb656ea9..7649d4901f0c 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -281,7 +281,7 @@ static inline int inet_csk_reqsk_queue_len(const struct sock *sk)
 
 static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 {
-	return inet_csk_reqsk_queue_len(sk) >= READ_ONCE(sk->sk_max_ack_backlog);
+	return inet_csk_reqsk_queue_len(sk) > READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
-- 
2.39.5



