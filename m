Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3971F0E36;
	Tue, 21 Jan 2025 18:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482884; cv=none; b=d1lBExjcPC+NKAbXF5JQu5jyRqZszp/RqKqOKtjUT7tLrbuNJduVwTCYkj8yXKDClJtOqJ3Y1Mh/ZkqEUlpCml6CFNrM725q4+5RTfElNrT0LTy/l7glZEISpIojnjz4E6qXoAf1QUfndkdTv1gBxe7cYxhQS1iXAmQzABOkVPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482884; c=relaxed/simple;
	bh=kOS1LeywJNTIuNq/i22g82+CVWtakqVE+rxGgaQo5yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NE+i0tRe5BPoV1pdGpUh/HjqzKEhTGUE8k9GReSX3z9GeAfHvBui1Fu+Qj5StokNzxO5h8jO8LQHQMtGNOtuB466D3b0sd4c6Tww4VTb/Rj4/TTQy3BgbEN4avnTvrOGsEW940r8BeD7CM/1nrqAg79Uq0gQR9pBeTAJXZdFwd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSWpEFjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSWpEFjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64873C4CEDF;
	Tue, 21 Jan 2025 18:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482883;
	bh=kOS1LeywJNTIuNq/i22g82+CVWtakqVE+rxGgaQo5yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSWpEFjsfcL+vG6OZj9w29y3UIQhBp12O3c8Qfy8lQ3PG0+rOWd/K7IT9l7zeIqcy
	 T91XsMT3/KZnu5wqDIHBm42bRIhuTUThP1vQ/OUwtQx/9vQBoMlguWXJ+TQIjlnFWX
	 2cQr/LqT2I6hNFd87zQK5T2zSmh3ad9D4BvvuXDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/127] tcp/dccp: complete lockless accesses to sk->sk_max_ack_backlog
Date: Tue, 21 Jan 2025 18:51:23 +0100
Message-ID: <20250121174530.109315110@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 9a79c65f00e2b036e17af3a3a607d7d732b7affb ]

Since commit 099ecf59f05b ("net: annotate lockless accesses to
sk->sk_max_ack_backlog") decided to handle the sk_max_ack_backlog
locklessly, there is one more function mostly called in TCP/DCCP
cases. So this patch completes it:)

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240331090521.71965-1-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3479c7549fb1 ("tcp/dccp: allow a connection when sk_max_ack_backlog is zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 53ec06703fe4..0bf19c1926ee 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -278,7 +278,7 @@ static inline int inet_csk_reqsk_queue_len(const struct sock *sk)
 
 static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 {
-	return inet_csk_reqsk_queue_len(sk) >= sk->sk_max_ack_backlog;
+	return inet_csk_reqsk_queue_len(sk) >= READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
-- 
2.39.5



