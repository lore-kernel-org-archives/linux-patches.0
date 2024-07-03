Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34ABC13A27E;
	Wed,  3 Jul 2024 11:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005292; cv=none; b=ZP7Pjyw/KMyDM9jPR9R0QYwBVHCnsnWCArlTM7/Tp4exfdrzu4DF41tEdGjYf6i4epLfOnmAJg2Pqfjlg1yRuWY4HzWBGyTUKEuY8N99EvZm6X8kE/l/sBbl1VAZ2C0BYWYySI6d8u4Rmw3dHcNNRkuhGiYVL454S/SUrdVcWLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005292; c=relaxed/simple;
	bh=b5mU3tsATx48Y0lqNGrYOEkwCL/5+GDYRYNXUtQft30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R35gO0/wG7HFqr2uwnZ2AQnnEBfFBtoKFrW2uLmW3Z3UFwTNKQDawS4ENLa8//7bO2955j6p2Nk7hlX2PRlxw1GKVazaHfh+AsnuFxL8pBdBYrELGK3+apQE142mpvxqTfgCz/vRf1cgWH6Rp/Y/MTTIo0DWtWC0TPcRniOxCYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFNzFxcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFNzFxcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F77C2BD10;
	Wed,  3 Jul 2024 11:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005292;
	bh=b5mU3tsATx48Y0lqNGrYOEkwCL/5+GDYRYNXUtQft30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFNzFxcVPD7VOrgvbQOv+rR2eTmFnEQY+33fz8pUuQLESXpTNyBrjlnBwaYlveX+t
	 E7T7m/apmkKYe69+VjMHJ+ktFSHUjV2OkZKpHq4jPW1RodjTWOzhJUaidYX2B/rbmF
	 +Ph9imiecCx1XWDrB6MDfF3NSd8mLfgaRMlv8Sg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/356] af_unix: annotate lockless accesses to sk->sk_err
Date: Wed,  3 Jul 2024 12:36:08 +0200
Message-ID: <20240703102914.312891691@linuxfoundation.org>
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
 net/unix/af_unix.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -485,7 +485,7 @@ static void unix_dgram_disconnected(stru
 		 * when peer was not connected to us.
 		 */
 		if (!sock_flag(other, SOCK_DEAD) && unix_peer(other) == sk) {
-			other->sk_err = ECONNRESET;
+			WRITE_ONCE(other->sk_err, ECONNRESET);
 			sk_error_report(other);
 		}
 	}
@@ -556,7 +556,7 @@ static void unix_release_sock(struct soc
 			/* No more writes */
 			WRITE_ONCE(skpair->sk_shutdown, SHUTDOWN_MASK);
 			if (!skb_queue_empty(&sk->sk_receive_queue) || embrion)
-				skpair->sk_err = ECONNRESET;
+				WRITE_ONCE(skpair->sk_err, ECONNRESET);
 			unix_state_unlock(skpair);
 			skpair->sk_state_change(skpair);
 			sk_wake_async(skpair, SOCK_WAKE_WAITD, POLL_HUP);
@@ -3066,7 +3066,7 @@ static __poll_t unix_poll(struct file *f
 	state = READ_ONCE(sk->sk_state);
 
 	/* exceptional events? */
-	if (sk->sk_err)
+	if (READ_ONCE(sk->sk_err))
 		mask |= EPOLLERR;
 	if (shutdown == SHUTDOWN_MASK)
 		mask |= EPOLLHUP;
@@ -3113,7 +3113,8 @@ static __poll_t unix_dgram_poll(struct f
 	state = READ_ONCE(sk->sk_state);
 
 	/* exceptional events? */
-	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
+	if (READ_ONCE(sk->sk_err) ||
+	    !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 


