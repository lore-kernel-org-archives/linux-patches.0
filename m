Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE473148308;
	Wed, 19 Jun 2024 13:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802057; cv=none; b=fQfsNCEXzO6Z5vbuIcEvEK4ypihtN7OXHf8Cssbkq7l7SA8xrisfi58Bj2Z9/45yYB9tsbZslQobnQUUTadZiLlGK1x93HcjumClo/ubFZTbXRcPcUiYxIV4kOIk7cNWiTbwXuMqbcOZri0RhyqJa1R9VT1gHTaYJBmJlXIYGGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802057; c=relaxed/simple;
	bh=MCryO/R7nECpny4bUZNevTE22MJK9tILiFhSneujA5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myDI5uj1Y3i/WAPAbK5gqBjNvoHrfMz8m8S0OGNVK5x5xBvvz4dYJB+JS3LuTZtuRZ6GROBvxLHTjokbDmYniYoZC9AKrMT8hWv/zxUfy7xeAxjM4v3TfNHOK+srB7hZUWMY2LvBPFvaZKLoBuENlu0hKX+Z1yM6217dQ9tvrys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t//CeGGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t//CeGGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC59FC32786;
	Wed, 19 Jun 2024 13:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802057;
	bh=MCryO/R7nECpny4bUZNevTE22MJK9tILiFhSneujA5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t//CeGGQMOg1wa20NTcr70w+NyasQ8AI3Y8fCaQ9MtXM4xL6sLW8zI4JB7s3oXMYO
	 g1fMAMF2lwfr9BogjE+tjg3rvsWltgWwc4zKDUdMpNsPfFYp9gVRdz8x65BnEalnQ4
	 pKGyPv9PYiOzCupAwekD35jizfwHLBrgh8t1qzvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/267] af_unix: Annotate data-race of sk->sk_state in unix_inq_len().
Date: Wed, 19 Jun 2024 14:53:21 +0200
Message-ID: <20240619125608.284626231@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
index bd2af62f58605..8d0918a112a9d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2983,7 +2983,7 @@ long unix_inq_len(struct sock *sk)
 	struct sk_buff *skb;
 	long amount = 0;
 
-	if (sk->sk_state == TCP_LISTEN)
+	if (READ_ONCE(sk->sk_state) == TCP_LISTEN)
 		return -EINVAL;
 
 	spin_lock(&sk->sk_receive_queue.lock);
-- 
2.43.0



