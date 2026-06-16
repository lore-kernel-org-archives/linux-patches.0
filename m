Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C453C414F;
	Tue, 16 Jun 2026 15:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624822; cv=none; b=FPe3uySKs1D2qZw2fH8WHkXpE9xPucBLauLtc27cZhxF10MtXwXJfI7LupeIkJREvHfsFkLTc4yesHUywUTdbzmA6qIEH7EczBEBceAICkik51BQn6Fzrh31a9PS1qFr4KX0znesDr9QJIeyd2dkiJlrKf96nP15WD/IPaXvwcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624822; c=relaxed/simple;
	bh=SD71RHezCZZ1N1Hf7KDOa96mj/2VoERZ3pw8S2868rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVo1YsmtJKCCtdyGU+3Eq69lzLjBWlfHEUuMQgYhciFdPUnq2YHXYGLtl3pfvkoJlRzGz2leyvuiG0P+88wUKt7fbxjc4f0tMgrYvaSq1JXmIgIXnJpjfFlAPJv75eYSeC8gSbfpb+Rj6JX6bwtlC2yNXXER5rvImIj4I8dAr/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNpaAv8n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNpaAv8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129B11F000E9;
	Tue, 16 Jun 2026 15:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624821;
	bh=cNWHhbbICN98A3pP1l/Lr2qrYjoEvWttb+D8V5hqhXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNpaAv8nIxKWWk3x/geUUKyKP594EyuRmiDVygw6iTCWZ9q7XsJuBzIWd8kWOxBP2
	 0qE5ejpMJPmcEdXWcsNzFmzpiXZU3S7fD5YqbbcWbt3qOszkcH+JnIUWKDwbAIZPf5
	 lXb4bRfkduCiBgKEDT23pl5AfR60o7Yd9nkzQ6j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/325] net: Annotate sk->sk_write_space() for UDP SOCKMAP.
Date: Tue, 16 Jun 2026 20:27:11 +0530
Message-ID: <20260616145059.490824729@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5a38837a583843..82470f59fa5c50 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2654,8 +2654,12 @@ void sock_wfree(struct sk_buff *skb)
 	bool free;
 
 	if (!sock_flag(sk, SOCK_USE_WRITE_QUEUE)) {
+		void (*sk_write_space)(struct sock *sk);
+
+		sk_write_space = READ_ONCE(sk->sk_write_space);
+
 		if (sock_flag(sk, SOCK_RCU_FREE) &&
-		    sk->sk_write_space == sock_def_write_space) {
+		    sk_write_space == sock_def_write_space) {
 			rcu_read_lock();
 			free = refcount_sub_and_test(len, &sk->sk_wmem_alloc);
 			sock_def_write_space_wfree(sk);
@@ -2670,7 +2674,7 @@ void sock_wfree(struct sk_buff *skb)
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



