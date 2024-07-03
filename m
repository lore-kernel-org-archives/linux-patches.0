Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054B716DEC3;
	Wed,  3 Jul 2024 11:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005260; cv=none; b=YsS155XctVDRVm/9J/r2iNNLvjU1cIxr/bhLMq9QKeBPo7KtQF9HLkVdWAEVf7LtX3BRZX8xlM/0lo0Naz5wlo0qjtpoEA8VdtCdluwvNcfG7Lvi7WolGwA0fpLGOkH9VzS9IE19OMiMIw/G8a9pb3ISGZlAF6Gq8ErW8p4stmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005260; c=relaxed/simple;
	bh=JPzX0V/JWz80CaDpNXtzBrXWb0IF8TcyTQXd8XqGDXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kr6FdSm7Slf+HJBx4lyOF8PrW66sU3vxYwbxMB3xrQbX4wYgzDgHQ/OACBl4NHRSpoYV/BaZSMqyuI7BwzrdYsvbSL/KPvqeMz76oJVSnub9DAx/+BxB4f3NVutyRCGaUmZBooN6fBGA+BsexxZ1ldPLxEzbsYI7DFZQsrKv2XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dh2YB7Ga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dh2YB7Ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E31C2BD10;
	Wed,  3 Jul 2024 11:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005259;
	bh=JPzX0V/JWz80CaDpNXtzBrXWb0IF8TcyTQXd8XqGDXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dh2YB7GaT8Kd0291URW2uqV9OBAYQrg9PXzhmrSAXezPNeBJEjz8Lj2AXRCLf0G07
	 eTTRCxiMx90Wx4tgi69REScrL/jKxykF52yLfJPnpbXilQ+/xYLVcLh4S4dz1an+cl
	 BqLSg3Rr6wiRfoQnDe2A+2YpNUxEzLlM2TtpVO3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/356] af_unix: Annotate data-race of sk->sk_state in unix_inq_len().
Date: Wed,  3 Jul 2024 12:35:58 +0200
Message-ID: <20240703102913.940174917@linuxfoundation.org>
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
index 616d6c34d6102..18e2dea699720 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2957,7 +2957,7 @@ long unix_inq_len(struct sock *sk)
 	struct sk_buff *skb;
 	long amount = 0;
 
-	if (sk->sk_state == TCP_LISTEN)
+	if (READ_ONCE(sk->sk_state) == TCP_LISTEN)
 		return -EINVAL;
 
 	spin_lock(&sk->sk_receive_queue.lock);
-- 
2.43.0



