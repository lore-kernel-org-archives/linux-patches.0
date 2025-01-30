Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D221E8835;
	Thu, 30 Jan 2025 14:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246893; cv=none; b=RFP3zuTP/ZSWxv5xBojAmAgM88OdK58qaXnnpewxIUG7z+xvF25TIXSKD1XVHL8/eUvTuRw6yJxkOYx54PVpIRPTNtPLPmcarZqb7FYcTeaqmjZqKQP9/QyH2wzGwMfQW8av6V+UWISjibMUUuKy9Jx0Yg5Ag4wJlePkAL1gOxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246893; c=relaxed/simple;
	bh=L13nqKmtOl1qjnBLrkXR9ma7tyYRtVRveIBkzhZlp2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYVZ1FZg7MNIr6s2rdNoM1z405ktjHoqVmonTZVH5R6CxTEY6mwfv+yoQRbg5GwG0VBK2x9YMd4SDeQmljav+zfGRELfAos/TYbcUvczSTJn42HPxWwq+rwx91TK2uiYwOTx8PYDdBChyF6kmr4m0TDAiumyRZ/fyYX5cOuIJzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rmti66QK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rmti66QK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3449DC4CED2;
	Thu, 30 Jan 2025 14:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246893;
	bh=L13nqKmtOl1qjnBLrkXR9ma7tyYRtVRveIBkzhZlp2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rmti66QKPgn1iG1qGqSSMn1Bzcvx8O6WuOFh8t0X/1AZhO1vYFHBS3lNkVR2Oynfq
	 Fro0M40Y87dpKTZDt9MMcKsXJ0VrLBZ5Jm9nZPXWNK+1x//QQjgEOHaRPFFBE/ZZ3n
	 DMfxawG+HZAw3/UT0UozM3cXKJxDuMSz43J+KCtM=
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
Subject: [PATCH 5.10 012/133] tcp/dccp: allow a connection when sk_max_ack_backlog is zero
Date: Thu, 30 Jan 2025 15:00:01 +0100
Message-ID: <20250130140142.994206459@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2a4bf2553476..cfb66f5a5076 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -282,7 +282,7 @@ static inline int inet_csk_reqsk_queue_len(const struct sock *sk)
 
 static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 {
-	return inet_csk_reqsk_queue_len(sk) >= READ_ONCE(sk->sk_max_ack_backlog);
+	return inet_csk_reqsk_queue_len(sk) > READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
-- 
2.39.5



