Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F0343E4B4;
	Tue, 16 Jun 2026 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623039; cv=none; b=ebffkEE5kzqp+VMuOw6h0OELo7TGV+s6BGJEXIpEdqBDOG6MyIV8WxfJNMNUvokMFiyzdbqNkHmUvfyu7c3bEOckb51IdLoyFuFzf+Dx+z4MfGF5N3MLMtfKoqcRQKTi6b0nlgc2bOhkuyCFRY6T5SzZZBJJp1AdzQJ2FmALtq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623039; c=relaxed/simple;
	bh=me3eBPMU39fmd8swu80PPQZtOrfAQFOyrXkHTekvWt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXPZa3tbLqMFmBbDAO8lFiZfVEMqO0TsjuEKhrEFDZ3U9HZOzb+mK0saYccUjeqonat68YVLM33gz4E8KeWYVFmEC+Ibz71Zh5YuIU80YNgg7Y6xCV2ETFyf0jYXcuZ6QVuN6Ata+95vG/LlYst3yDuWMMUAhA9QtUGVVP/6VwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVMknDEi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVMknDEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AE71F000E9;
	Tue, 16 Jun 2026 15:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623037;
	bh=/+232Od8jk+CVoTJ1LA7Ke/yz4gTWLPdfy4T1jmGNDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVMknDEiGqknwhHJTPLMrFZqEU7McTIFwz0Ws/aOYLTUB1upFHAUi8lqyzVD4j8/a
	 g0RxZbHqs3tG+acb/eREfHWa6MDmugDqHpYwusW1w9vE9jEga42Jgbrf8VcBhwi6Zt
	 NMVifmCDg3xgS3Ky6jlCr7iXbRMCpdWejUGHP98g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 033/378] net: Annotate sk->sk_write_space() for UDP SOCKMAP.
Date: Tue, 16 Jun 2026 20:24:24 +0530
Message-ID: <20260616145111.611489505@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit b748765019fe9e9234660327090fc1a9665cdbdd ]

UDP TX skb->destructor() is sock_wfree(), and UDP holds lock_sock()
only for UDP_CORK / MSG_MORE sendmsg().

Otherwise, sk->sk_write_space() may be read locklessly while SOCKMAP
rewrites sk->sk_write_space().

Let's use WRITE_ONCE() and READ_ONCE() for sk->sk_write_space().

Note that the write side is annotated by commit 2ef2b20cf4e0
("net: annotate data-races around sk->sk_{data_ready,write_space}").

Fixes: 7b98cd42b049 ("bpf: sockmap: Add UDP support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://patch.msgid.link/20260529193941.3897256-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 5976100a9d55a0..b197a795306392 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2673,8 +2673,12 @@ void sock_wfree(struct sk_buff *skb)
 	int old;
 
 	if (!sock_flag(sk, SOCK_USE_WRITE_QUEUE)) {
+		void (*sk_write_space)(struct sock *sk);
+
+		sk_write_space = READ_ONCE(sk->sk_write_space);
+
 		if (sock_flag(sk, SOCK_RCU_FREE) &&
-		    sk->sk_write_space == sock_def_write_space) {
+		    sk_write_space == sock_def_write_space) {
 			rcu_read_lock();
 			free = __refcount_sub_and_test(len, &sk->sk_wmem_alloc,
 						       &old);
@@ -2690,7 +2694,7 @@ void sock_wfree(struct sk_buff *skb)
 		 * after sk_write_space() call
 		 */
 		WARN_ON(refcount_sub_and_test(len - 1, &sk->sk_wmem_alloc));
-		sk->sk_write_space(sk);
+		sk_write_space(sk);
 		len = 1;
 	}
 	/*
-- 
2.53.0



