Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5551DDE9;
	Thu, 30 Jan 2025 14:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246636; cv=none; b=nczI9AkdJI1GJzBSJ6vIOobJlsteWdEM+pwmbQUKJEzUNLlDV5qCnAhePbI1smYPkWy1BcOpoeykoQq7v0eMbNB/B71VGLbXIzER+h6X47s5WjSqxqu3DWC28QeXQpkEavV+T1yMcN5SbOEpt6PMsygrOQAmmupKIlRtGXM0PnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246636; c=relaxed/simple;
	bh=9N6WH7Xgjhl8M10wlfW2W+yG6LjJ12y6EqOJGWq88L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtQEGdJbJ1vzqJmg+LEHgWcOukoPoJkAk/yCykhQrYtWepwr5uWhV4RLUQ50p7dnmhZBUFy0n9JF6FLgSmZGPm83Lf4YVEDMdiuQO2EpT72mL0MLH8420VNxxXL76d7+AMY0PFvE+ZYrkSixazzKZfWQOJi3LbL38yJ8cDlgtKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKmQ6f+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKmQ6f+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBCDC4CED2;
	Thu, 30 Jan 2025 14:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246636;
	bh=9N6WH7Xgjhl8M10wlfW2W+yG6LjJ12y6EqOJGWq88L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKmQ6f+BJfG6tSq3yzjOY3nVG/xgWLhLME9fO5NfWJHMUJmigHgP0qLmgWMint5CG
	 Wy+vU6FEQ7f8xlgM2G5uh+wqkKHPPscEK4LG/D1ie+LtR7Zef5vE+NbPtaNCLt9YNp
	 po6xB1r7NEJq6L784Gfu43eiT4pdXdcctnigGp0g=
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
Subject: [PATCH 5.4 08/91] tcp/dccp: allow a connection when sk_max_ack_backlog is zero
Date: Thu, 30 Jan 2025 15:00:27 +0100
Message-ID: <20250130140134.005137243@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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
index c81bbfc5f4df..05f07bf60c89 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -285,7 +285,7 @@ static inline int inet_csk_reqsk_queue_len(const struct sock *sk)
 
 static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 {
-	return inet_csk_reqsk_queue_len(sk) >= READ_ONCE(sk->sk_max_ack_backlog);
+	return inet_csk_reqsk_queue_len(sk) > READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
-- 
2.39.5



