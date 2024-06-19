Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E2214EC4C;
	Wed, 19 Jun 2024 13:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803613; cv=none; b=izBZL+aqhDiH6rd5bF0HW3h6kjk3rKJtUAn5Qd12ouNdiqE2Ein3by3QHMabhGYuMb+nnsDBzqWaZqtuHPAPIhbI2XX6uyH0pKwvrFEWSqFB9J4OeCaYVxBmw2fSJTAdppREn2y3+RJTr6dUrsPBGBkTpvIClU3x65f1v3oYQ9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803613; c=relaxed/simple;
	bh=C7UeVYEXHTh1PJTkd9YWm0awVV4ePILgOMCfsUOmWm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9ijUI75ULVL6qBSaycCxjH79keor7vcncOxvgIrcAVAbkgelWmkLsBOSL8JQcyBJM3TFQLweR7+CUbh6VD5pEmh59VNIZlqFAOBdDHYYDUzK7PFpJffdoYf0TWb0zZwzhUTmnWDk28ZEWlWi2ovsRE2SbuQmWWmc2aoOiAHp6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jjd6WgaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jjd6WgaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2E5C2BBFC;
	Wed, 19 Jun 2024 13:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803613;
	bh=C7UeVYEXHTh1PJTkd9YWm0awVV4ePILgOMCfsUOmWm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jjd6WgaImxReehBaBNJntkYSgvcO5e/yJCQ8Nsa0w8gJxgTs5SMFtqfvteCK8Vevy
	 JACkUFRuz9aJdHiTzeIJ03NCzzWGSMAG2f6yDWD8hG4XILoyYHUdHeX2CAX1BRiPK/
	 W7+mtWSubdUjEVZDE0R9U48HW2dWxKI4RkaaTP2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/217] af_unix: annotate lockless accesses to sk->sk_err
Date: Wed, 19 Jun 2024 14:54:48 +0200
Message-ID: <20240619125558.402096371@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cc04410af7de348234ac36a5f50c4ce416efdb4b ]

unix_poll() and unix_dgram_poll() read sk->sk_err
without any lock held.

Add relevant READ_ONCE()/WRITE_ONCE() annotations.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 83690b82d228 ("af_unix: Use skb_queue_empty_lockless() in unix_release_sock().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 359d4f604ebda..02d8612385bd9 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -548,7 +548,7 @@ static void unix_dgram_disconnected(struct sock *sk, struct sock *other)
 		 * when peer was not connected to us.
 		 */
 		if (!sock_flag(other, SOCK_DEAD) && unix_peer(other) == sk) {
-			other->sk_err = ECONNRESET;
+			WRITE_ONCE(other->sk_err, ECONNRESET);
 			sk_error_report(other);
 		}
 	}
@@ -620,7 +620,7 @@ static void unix_release_sock(struct sock *sk, int embrion)
 			/* No more writes */
 			WRITE_ONCE(skpair->sk_shutdown, SHUTDOWN_MASK);
 			if (!skb_queue_empty(&sk->sk_receive_queue) || embrion)
-				skpair->sk_err = ECONNRESET;
+				WRITE_ONCE(skpair->sk_err, ECONNRESET);
 			unix_state_unlock(skpair);
 			skpair->sk_state_change(skpair);
 			sk_wake_async(skpair, SOCK_WAKE_WAITD, POLL_HUP);
@@ -3181,7 +3181,7 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
 	state = READ_ONCE(sk->sk_state);
 
 	/* exceptional events? */
-	if (sk->sk_err)
+	if (READ_ONCE(sk->sk_err))
 		mask |= EPOLLERR;
 	if (shutdown == SHUTDOWN_MASK)
 		mask |= EPOLLHUP;
@@ -3228,7 +3228,8 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 	state = READ_ONCE(sk->sk_state);
 
 	/* exceptional events? */
-	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
+	if (READ_ONCE(sk->sk_err) ||
+	    !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 
-- 
2.43.0



