Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EE114389C;
	Wed, 19 Jun 2024 13:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802836; cv=none; b=donxpGhlKTw50v2tBtySSlbsxS/w0khcSDMXDRu5eoEW3CP5gh8CeXPPb1VYNkL8HgBgmqY1CagZIf1tX+neQ9dvwUbtgUe2t3e7zlHpYQ7EnCj3lrZf4Rk3hyGzY2NB2t8CLBRx/VBrjENDrKO00QNCwCftWyF6vnekx+4X1e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802836; c=relaxed/simple;
	bh=fSWJ9w++qsXy3ALzpFO6HFVcUyEMV+gDESgBM3a5DQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrGfmKP+l4YPhmegAPRaYjp0Co9lAvVBc4WWsEsNt8NqiS5NnbOB/zgAiLD+OfCw1q17doogVKMFFUQsDS5JK5Sx9E+9RSVwKzJhjeBBDeH5pI52WVv5X2iYJMnl8+9M4MHuvPerAoheRInlpM59s+YT3zXvQhzoUp54sJGxSzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFDanWSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFDanWSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E824C2BBFC;
	Wed, 19 Jun 2024 13:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802836;
	bh=fSWJ9w++qsXy3ALzpFO6HFVcUyEMV+gDESgBM3a5DQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFDanWSfIyGXVY5p4+YL2LVE/kxiRs+vahHxaM5HHa77ImX6QLda1oaUQlSabPEEE
	 rNy4VFyxse3jMDIi0x21JO7+/CmtM0LLSINZ38iNcxSsRa+ZjkZba0fUt5zwzfbr3b
	 hOW14jz4a5uh+RibTPJPNTV7P+rP3tRvfoRs4gTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 063/281] af_unix: Annotate data-race of sk->sk_state in unix_stream_read_skb().
Date: Wed, 19 Jun 2024 14:53:42 +0200
Message-ID: <20240619125612.271435336@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit af4c733b6b1aded4dc808fafece7dfe6e9d2ebb3 ]

unix_stream_read_skb() is called from sk->sk_data_ready() context
where unix_state_lock() is not held.

Let's use READ_ONCE() there.

Fixes: 77462de14a43 ("af_unix: Add read_sock for stream socket types")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index d92e664032121..9f266a7679cbc 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2706,7 +2706,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 
 static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
-	if (unlikely(sk->sk_state != TCP_ESTABLISHED))
+	if (unlikely(READ_ONCE(sk->sk_state) != TCP_ESTABLISHED))
 		return -ENOTCONN;
 
 	return unix_read_skb(sk, recv_actor);
-- 
2.43.0



