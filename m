Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED421422B8;
	Wed, 19 Jun 2024 13:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802851; cv=none; b=aRl54BKsUWzR945sSYGG+Dz4qunTMFR3NVteQlQb3aXGdIn6ix4bWnKyJLa3CQhvGCJzUFZ5c6gw35YcXpAXr8vk1h1lGTDmab9ybliUehLVEXTuVX82gBShd4WZ6xA8gOT9lorwxXuoVfl+35eB4cz+iU5L3901KSYqp78Pyt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802851; c=relaxed/simple;
	bh=068A3g2vCJG71gkG876ahjKCR3yaYnbVUsQIt8zsF7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbCmH+XfB8Iojr1R7EYs1MTMb7luKLK1u7uzs1v5F/u8ltxAygL8O9kY9DMKjwF+nedSamDMzwMQ6+QjewA044HNBENyIvJHEnhLJP7g7QS7f9RQ/jROiu8zxI2EDbJcEODBWvi6JpGPk81DAD9QyvNdchRt81ERwRrCoDM2LJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FW8VbUBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FW8VbUBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADB4C2BBFC;
	Wed, 19 Jun 2024 13:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802851;
	bh=068A3g2vCJG71gkG876ahjKCR3yaYnbVUsQIt8zsF7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FW8VbUBjyvkndS5PLFa1KcYtxVcCNuWdcsg2crbN4zojxVQ9fAECoEzcWb69MzRCw
	 FE56nxX/r4v05Am7fuj7z1ONqOAhDAwbzLzbNZ8cXgz4f5XyB0PrRZnKd/109U9Jev
	 h0cZkbvPS/35Hu5hS9pAVdbjtnEpuUVdPpHKF+yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 068/281] af_unix: Use skb_queue_empty_lockless() in unix_release_sock().
Date: Wed, 19 Jun 2024 14:53:47 +0200
Message-ID: <20240619125612.461380641@linuxfoundation.org>
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

[ Upstream commit 83690b82d228b3570565ebd0b41873933238b97f ]

If the socket type is SOCK_STREAM or SOCK_SEQPACKET, unix_release_sock()
checks the length of the peer socket's recvq under unix_state_lock().

However, unix_stream_read_generic() calls skb_unlink() after releasing
the lock.  Also, for SOCK_SEQPACKET, __skb_try_recv_datagram() unlinks
skb without unix_state_lock().

Thues, unix_state_lock() does not protect qlen.

Let's use skb_queue_empty_lockless() in unix_release_sock().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f0760afad71fe..cbc011ceb89b4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -631,7 +631,7 @@ static void unix_release_sock(struct sock *sk, int embrion)
 			unix_state_lock(skpair);
 			/* No more writes */
 			WRITE_ONCE(skpair->sk_shutdown, SHUTDOWN_MASK);
-			if (!skb_queue_empty(&sk->sk_receive_queue) || embrion)
+			if (!skb_queue_empty_lockless(&sk->sk_receive_queue) || embrion)
 				WRITE_ONCE(skpair->sk_err, ECONNRESET);
 			unix_state_unlock(skpair);
 			skpair->sk_state_change(skpair);
-- 
2.43.0



