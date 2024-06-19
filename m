Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E489451C5A;
	Wed, 19 Jun 2024 13:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802031; cv=none; b=SKuBgVtuYOyzCccYTvnUZoJKFFeXBRpxqS12Gi3PHx9WqGKGXK8I3qdHVfgokk9yRkROTzWqXDvg65QKNmXdylF0Ax4JaX/vMpYB1XBDIXeeRMrXP/Ipyfufv4tobkZMiJS77eYk93+kU5Re2v2uUOKSGc5tB5MR+Xd+aLWjxAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802031; c=relaxed/simple;
	bh=QpqCSwZUPUtrTMbdtCJQsFMysusECXKG4S17rZJ7ZGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M130FNS5uuce1md6xh9mrnuP9NYfLDiQwTiQo4Z63JMkPnr3CmI4xiMWE13y94uOVW6PM0a4KU1yVm7UKrgDicm/acANMKLJrv9ySc8wtvOzHn45qIqGeuL66w0DEm8+vWKwAG9RRG6bKupJbyI5kH1/X1Y8E2Yi8oba0dNMxGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02z7LNWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02z7LNWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B44C2BBFC;
	Wed, 19 Jun 2024 13:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802030;
	bh=QpqCSwZUPUtrTMbdtCJQsFMysusECXKG4S17rZJ7ZGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02z7LNWSy3jIxtk59Ny8XRGH5MVAGJpByAE7jy0GbtTfCVemWoVBQj4cs7c2fsMZx
	 igC4r1eKA20c/JMeMbAcFAvbVdtzImY0KDURYdGGDHVHFLFMnaQUf01MUhcSJqS2Kk
	 pEM5WRteWWg1MgpWWujoOCb2G9z8Q08TYQF5EqAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/267] af_unix: Use skb_queue_empty_lockless() in unix_release_sock().
Date: Wed, 19 Jun 2024 14:53:30 +0200
Message-ID: <20240619125608.626399865@linuxfoundation.org>
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
index ea68472847cae..e6395647558af 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -632,7 +632,7 @@ static void unix_release_sock(struct sock *sk, int embrion)
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



