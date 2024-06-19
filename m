Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC62714373E;
	Wed, 19 Jun 2024 13:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803692; cv=none; b=VvH1sbxWMpd0+/99dyWnIZUvZnU2yFATYFOvy3nrruCbUu6EF9pmOjwTx/38gf9bbvyM+KUk4cgNZPnovYTll5Hok7mlk5ujzZYaxmQu9dV1p7KXKPkWqWygK1XHaSF3+C2QSBOldfOe2eTYuTqDESDmtwBoMOPjcju6e2BOSoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803692; c=relaxed/simple;
	bh=tilytx/vJIwgbdX7lQhePOB7xPCsYjQQpO6nvcCFi1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=az8hku1/bB6kNLJedlwdGvEhcp9gOXIuNFlVC5njVEr5SX8T5Xq0wMhrGS0TWR3shQRWp7+HEW7f1Q0cgKwdXZktSAYQnQQfxJzco4Lc3iXAVhdZZTobWCHoTNa2ElX8/Q3/41y/V8QfBzlMj9zkEIFqtlYW8cFA+R2GNNYFqkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NyLtbd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NyLtbd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301D2C4AF1D;
	Wed, 19 Jun 2024 13:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803692;
	bh=tilytx/vJIwgbdX7lQhePOB7xPCsYjQQpO6nvcCFi1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NyLtbd7x+9mFcPz6FGCTn51qJJSpymQ1xjEaTXcjg4osQ68MKExe8s1y59UqR6Ie
	 G+WMn7VdDUoWMOgmg6JrKNwpato5HDj5hq5kqFbHUDzlG3+pHHPQMeBMQKqWT/psTl
	 MJ8n3v8wKCzA7vTyQzKSn82oyq0CuuqWDwCesYPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/217] af_unix: Annotate data-race of sk->sk_state in unix_stream_read_skb().
Date: Wed, 19 Jun 2024 14:54:44 +0200
Message-ID: <20240619125558.242279611@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2e25d9eaa82ea..f6ba015fffd2f 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2716,7 +2716,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 
 static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
-	if (unlikely(sk->sk_state != TCP_ESTABLISHED))
+	if (unlikely(READ_ONCE(sk->sk_state) != TCP_ESTABLISHED))
 		return -ENOTCONN;
 
 	return unix_read_skb(sk, recv_actor);
-- 
2.43.0



