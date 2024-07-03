Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4BC1799F;
	Wed,  3 Jul 2024 11:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005295; cv=none; b=Q3ZjX24co3R+EHz78LXiTaZnRiysOK0rg8rQ0jML0Bp1Obvh9Yr62hVyuAPrl7kYfDHlRd/GHpk9k8UQ0pDjWGPn/5rzvKy9F4MI33N8DXmNUq0N9Zoto9DonMzNmMNXT1z3dtXzxiZFeVqN0AsFN9LsdAEdeL4svbMd6wl3AuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005295; c=relaxed/simple;
	bh=YjLh74GgS3FEobOSMYLxskdVAR3EJfxMiH9wqr2Jt6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkrVf+ltMsk4OSci2Oa36PliGEh+t7TecMrBzJivrfCoeXNMOjucSkVbJl4S0rMI5ySli3QTTKA/ei8j+53hrDiEcm+MxnkiAQMQBmRgbs1ER4imDyWmOQWnGbUcIkbKuDTOf0HcK3M3CRYHRX7AahGwwLNYRmmTS0Xp9Bf74fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLRBFJRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLRBFJRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FADC32781;
	Wed,  3 Jul 2024 11:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005295;
	bh=YjLh74GgS3FEobOSMYLxskdVAR3EJfxMiH9wqr2Jt6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLRBFJRSfRvU+sdUZOF/m+LDpKZ5j4I6KyubSH5fPSnUgDT8MB+qn8OjO1R83/y20
	 0MmWzGhT9rbGY8uQn1gs7l4OCL7uOdlC+V0CStOcdTqdEMWexDnynTYxPL1I8o8JGv
	 CWIY5pTIJ3iFnPioTT8K22LtH7+dQ8vXXVdr6SR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/356] af_unix: Use skb_queue_empty_lockless() in unix_release_sock().
Date: Wed,  3 Jul 2024 12:36:09 +0200
Message-ID: <20240703102914.350271724@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 net/unix/af_unix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -555,7 +555,7 @@ static void unix_release_sock(struct soc
 			unix_state_lock(skpair);
 			/* No more writes */
 			WRITE_ONCE(skpair->sk_shutdown, SHUTDOWN_MASK);
-			if (!skb_queue_empty(&sk->sk_receive_queue) || embrion)
+			if (!skb_queue_empty_lockless(&sk->sk_receive_queue) || embrion)
 				WRITE_ONCE(skpair->sk_err, ECONNRESET);
 			unix_state_unlock(skpair);
 			skpair->sk_state_change(skpair);


