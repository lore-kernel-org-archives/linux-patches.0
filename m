Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1E6177980;
	Wed,  3 Jul 2024 10:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003761; cv=none; b=Gp6mVzLss7WUhP3VncR8OevV1YtB4bFW3ycQ4kNXiIJ8MH8EJkLc1+4whhtxm7VbCigNQuObeC9AyY8MUtZAKL3hRepn41YU0Zf1SaF2E47VZWSmLzI7UmpnnbJ3AxNcPayvonWVa3sUJ2ufQcOGZtMtpoSrUiJsHKPas9LpoM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003761; c=relaxed/simple;
	bh=fZ2JjWH2jlTddkk/YxXIVz9rsrR7kE0BQ3h0faRpY+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psLUB3AoU8GPblWbJ57Gf/fvvrVcQT8oLHrd3cQcgXTZ3ZGm/hHSfegWwsbUr7p49Zjh5uJ3W5aCQ+gv1L9oukimc9XUa+0cwxxnVF14h27atN1OZ1ydtoheftF5hDF0Swio3aIrvclBa+CEa14/fEVUwziGSPaobIb0QoFfabw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0euNFZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0euNFZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E540DC4AF0B;
	Wed,  3 Jul 2024 10:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003761;
	bh=fZ2JjWH2jlTddkk/YxXIVz9rsrR7kE0BQ3h0faRpY+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0euNFZysAKWeLo3gN3KNb9NHnJBx/wKwkfAmYydBdwM8J+eyI+fF6/JdpeDAUKUh
	 o6t3UtBrflbqjVYLlgDgFm2+9ueJPx6qy7JIkkxHV4OIKMCNSBi4VR/1S3Apb0IMOe
	 I+NZBabAa3RUqKuEO8Wf9vhpXaBvjoLK1DUVngYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/189] af_unix: Annotate data-race of sk->sk_state in unix_inq_len().
Date: Wed,  3 Jul 2024 12:37:55 +0200
Message-ID: <20240703102842.042272426@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 3a0f38eb285c8c2eead4b3230c7ac2983707599d ]

ioctl(SIOCINQ) calls unix_inq_len() that checks sk->sk_state first
and returns -EINVAL if it's TCP_LISTEN.

Then, for SOCK_STREAM sockets, unix_inq_len() returns the number of
bytes in recvq.

However, unix_inq_len() does not hold unix_state_lock(), and the
concurrent listen() might change the state after checking sk->sk_state.

If the race occurs, 0 is returned for the listener, instead of -EINVAL,
because the length of skb with embryo is 0.

We could hold unix_state_lock() in unix_inq_len(), but it's overkill
given the result is true for pre-listen() TCP_CLOSE state.

So, let's use READ_ONCE() for sk->sk_state in unix_inq_len().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e8bad973285e4..8ab1e2a781195 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2579,7 +2579,7 @@ long unix_inq_len(struct sock *sk)
 	struct sk_buff *skb;
 	long amount = 0;
 
-	if (sk->sk_state == TCP_LISTEN)
+	if (READ_ONCE(sk->sk_state) == TCP_LISTEN)
 		return -EINVAL;
 
 	spin_lock(&sk->sk_receive_queue.lock);
-- 
2.43.0



