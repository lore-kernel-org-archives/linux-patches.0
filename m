Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623902;
	b=zYgHy5u6e9zSxSxB5LgOOSO5cV+UGwqVfRvW5fYidGziXj4wsTHEEApBj8IuF1MqBQcz
	 tcMi17lVl/+4Pdg1vk4t2NLSOCFalNRIux+QUWvcfgw2IdKdK/f0Jbq0A3kAHCOchhmT3
	 nGMX6bpcm3wtHqdM4+gWuKT7JDKancPgiwln6Ll80/9/t8tNazLB9rxxLCVJuupubCPht
	 tv7iq02T+lNO4avWFAa/Qq48Mr/nSP47AcZxHMkaTu5jgIzLKoA7lFTX/PmhZbBBRCR4f
	 VQBnTLI6V5+YP/RVvWymQNeKEieFIj5YpE5/cjBf0mdRbyG1r0qgXZs44KIIsUXIKFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+VSw/2Hlx4LYII3SuaVeVSlqy+gbkzEM+BouKBLstzc=;
	b=T3P3CZQtz6HJtRz/pH0OAfVtxgdIW6Bs/61lS5ZSh7dNyMX/zlsvjFQXSNEfYhhb9Dp4
	 lr1jAShOiE3aRIs+Qqz2vkvbEfil5PEeTcHPU165XaFWmv/Lbgy+A6BtzHjqTtXHgR6vA
	 XaOKkKGp6tj0UmhKVu5h0DLWgEBNUdAXRH7edxnHeiQLaIx7yaBuRIrk1njqHQbjElRVW
	 ARkg4/KNp3q/clUoXWghGRhGlu06z6KogP03No76H/F31XaqG2l4gLcyklx6UFuTHzNQB
	 8he7xvxET77JAtB2atH7+K2C89sweyuKW8j/8IjFK4EhKGz0fVgxnc6wzuhDD2/Od1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1JXhTyz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3552A606A31E;
	Wed, 25 Nov 2026 16:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1JXhTyz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8842B1F000C0;
	Wed, 25 Nov 2026 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623902;
	bh=+VSw/2Hlx4LYII3SuaVeVSlqy+gbkzEM+BouKBLstzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1JXhTyzPJjmZy2deCVLdvwXrb8UQtSMcsMDJEGkAffs0ieRuwE9MHOrQiIdhtEHb
	 d8zjWzxvAMrge9Iq49f2+EU9F6r+hfSOGnqV3DZbMRcw0GsDrhKReXhxzWUvH9LT3B
	 /hOw2lwKE6as9tJyxRD17ShudCZ99AbHfaDAM6g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/816] netrom: send the unacknowledged frames again when T1 or T4 expires
Date: Wed, 25 Nov 2026 15:26:10 +0100
Message-ID: <20261125143849.729578210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

When T1 expires in state 3, nr_t1timer_expiry() moves the frames of the
ack queue back to the write queue with nr_requeue_frames(), but does not
call nr_kick(). nr_kick() only runs when a frame comes in from the peer
or when the application writes, so if the peer stays silent (one way
transfer, last frame or its acknowledgment lost) nothing is sent
again: after N2 expiries the circuit is cleared with ETIMEDOUT without
a single retransmission. The comment above nr_requeue_frames() says the
frames are "picked up by nr_kick called from the timer", but no timer
calls it.

T4 has the same gap: when the peer's busy condition times out, the
frames held back while it was choked stay queued until something else
calls nr_kick().

Call nr_kick() after nr_requeue_frames() in the T1 expiry, and after
clearing NR_COND_PEER_RX_BUSY in the T4 expiry. nr_kick() already does
nothing outside state 3 or while the peer is busy, and sends from V(A)
once the ack queue is empty, so the T1 retransmission resends the
window from the first unacknowledged frame. The N2 count and the time
at which the circuit is cleared are unchanged.

Tested in two QEMU guests (6.12.94, KASAN and lockdep) linked over a
serial mkiss port: the guest under test runs netrom with T1 = 5 s,
N2 = 3 and T4 = 3 s; the other guest plays a NET/ROM node from user
space with an AX.25 socket and acknowledges nothing.

 - three frames written on a circuit: before, each was sent once and
   the circuit was cleared 20.7 s later; after, the three are sent
   again at 5.4, 10.5 and 15.6 s and the circuit is still cleared
   20.7 s later;
 - the peer acknowledges the first frame with CHOKE, then a second
   frame is written: before, it was never sent; after, it goes out when
   T4 expires (3.1 s after the CHOKE), then again on T1.

No kernel report in either run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit d07ed33f39eca24db1f1b15e00ef7c4447408a0d)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_subr.c  | 6 +++---
 net/netrom/nr_timer.c | 4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netrom/nr_subr.c b/net/netrom/nr_subr.c
index c3bbd5880850b..144d9c5ea5b17 100644
--- a/net/netrom/nr_subr.c
+++ b/net/netrom/nr_subr.c
@@ -61,9 +61,9 @@ void nr_frames_acked(struct sock *sk, unsigned short nr)
 }
 
 /*
- * Requeue all the un-ack-ed frames on the output queue to be picked
- * up by nr_kick called from the timer. This arrangement handles the
- * possibility of an empty output queue.
+ * Requeue all the un-ack-ed frames on the output queue to be sent
+ * again by nr_kick(), which the T1 timer calls next. This arrangement
+ * handles the possibility of an empty output queue.
  */
 void nr_requeue_frames(struct sock *sk)
 {
diff --git a/net/netrom/nr_timer.c b/net/netrom/nr_timer.c
index 5e3ca068f04e0..efa5cf6d7bf55 100644
--- a/net/netrom/nr_timer.c
+++ b/net/netrom/nr_timer.c
@@ -171,6 +171,8 @@ static void nr_t4timer_expiry(struct timer_list *t)
 
 	bh_lock_sock(sk);
 	nr_sk(sk)->condition &= ~NR_COND_PEER_RX_BUSY;
+	/* the peer is assumed ready again: send what was held back */
+	nr_kick(sk);
 	bh_unlock_sock(sk);
 	sock_put(sk);
 }
@@ -238,6 +240,8 @@ static void nr_t1timer_expiry(struct timer_list *t)
 		} else {
 			nr->n2count++;
 			nr_requeue_frames(sk);
+			/* nothing else sends them if the peer stays silent */
+			nr_kick(sk);
 		}
 		break;
 	}
-- 
2.53.0



