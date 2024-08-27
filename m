Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614E51C93A3;
	Tue, 27 Aug 2024 14:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770504; cv=none; b=A+FnjxbpW4WP8gCWMpmKx7jPH2yhuSHcFEdoPzZaMsjLVzh2XPlLKq0x2up9RMFli47SNA2yaGeGDjIhgQVWjPFdPshyfcs1E656eSI9Uq1aqlNw8e9uT1i//nQ0dnN1XydvtAdogliZ0yHt3kjVU8G/mPasZ3anIOYh5HMMaOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770504; c=relaxed/simple;
	bh=l2I0UAtcj2cOZLV2W+oHp5RgElvH6QnPAxkTy6q5N6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkM9kWaPPcv8F3xuggIpE9LtV+KdFEcnXbrc9eL0zdS5OMGXQRtjLgYCyr4WqClDnfOe8ZFnRn083Qp51C7tUE2OmJy4vLk/DyZ+HlKYGsiBfIAdNw21MeIRJCKf3GFaj4p6Dq9shIli46uJSoqXBhedHf9FEZQKKGtgURLyzVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChXjHAna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChXjHAna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C765FC4E699;
	Tue, 27 Aug 2024 14:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770504;
	bh=l2I0UAtcj2cOZLV2W+oHp5RgElvH6QnPAxkTy6q5N6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChXjHAnaX+dqeHolsKitJAwefr8K+8lNdlal1o6UXV5vEUXIUUPccSMCqrBQn2WAV
	 Rc7RbKgqgUkamIVbu088I7O6I7GfcsoXBcQuAnugFfpO7IDRVJrKAQr8mlutELpjtK
	 JKZZ82/hfFr52YeFUtzRGkxvJk5WGT7QTI5NEfZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/341] tcp/dccp: bypass empty buckets in inet_twsk_purge()
Date: Tue, 27 Aug 2024 16:37:59 +0200
Message-ID: <20240827143852.842590370@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 50e2907ef8bb52cf80ecde9eec5c4dac07177146 ]

TCP ehash table is often sparsely populated.

inet_twsk_purge() spends too much time calling cond_resched().

This patch can reduce time spent in inet_twsk_purge() by 20x.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240327191206.508114-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 565d121b6998 ("tcp: prevent concurrent execution of tcp_sk_exit_batch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_timewait_sock.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 757ae3a4e2f1a..55f60d1b46f2d 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -281,12 +281,17 @@ EXPORT_SYMBOL_GPL(__inet_twsk_schedule);
 /* Remove all non full sockets (TIME_WAIT and NEW_SYN_RECV) for dead netns */
 void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family)
 {
+	struct inet_ehash_bucket *head = &hashinfo->ehash[0];
+	unsigned int ehash_mask = hashinfo->ehash_mask;
 	struct hlist_nulls_node *node;
 	unsigned int slot;
 	struct sock *sk;
 
-	for (slot = 0; slot <= hashinfo->ehash_mask; slot++) {
-		struct inet_ehash_bucket *head = &hashinfo->ehash[slot];
+	for (slot = 0; slot <= ehash_mask; slot++, head++) {
+
+		if (hlist_nulls_empty(&head->chain))
+			continue;
+
 restart_rcu:
 		cond_resched();
 		rcu_read_lock();
-- 
2.43.0



