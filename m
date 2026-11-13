Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590961;
	b=re0FtywVNgKq0wf/Jt2XSCFGDfAJh9NpGk5iAoAejH+uxRJjLmK+6MF0Nv5PjseuYyOI
	 1gcoPE/F2RoXb+3zZQpI7je1b5IMYckbQ4YvIRRLo5EvzL54udTqTp2mi8btB9svLBinq
	 YVD/u2RyQXBWK33U/tKj3B7G1SJ+JNCneYimUWFeIHiaZ/8CObjMNVK7gy6IvY1JbvOSf
	 Qia9GAkclnv0oocFvHdjpbJU7eqiGY0SIqXKx9ru8V/TovxOQ2esvoJqz8c/RLk64kyY1
	 JvVT2LXcG5Dh0PVlyrThQL3Qtg8je1d+QQV8ExOJgzrhe4bpV02AubJN/knVjEIhf2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aF44AGuOxrTrL3cFyIKMGwhhBUT56FB/RU/c746xYWw=;
	b=quiu3w1qMAs43ozyfPa4c76u8b5s0AGNa1w8CX1rM6RsJtCao1SaCEeL8ZXLAzXsITxB
	 6EvsxcdoBFDb3xgc7o56cnusBQMC3kCpJU2wWl61choGrQQCLYS/3wOS9VFiiZxzazqfC
	 OwXHTpnrsM2v9xYowj6h985iRcChadfSuz5Ywv/zNwEm4ks94gej5VSf3ob/aUzsSwaZl
	 yPW1WrCMd4v+PWXhVBXy1ELEISuqnna7X+cdqy+v+qAHswN946edI8TlxSEAtOLjPA++U
	 vil2rT4W/7jVN5sXqbOGx5s5QL9QmfCXDl5T73GWu8ZG3ipPOssNgyDB8qe/LqTyDIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioALSyXj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F5E606B462;
	Fri, 13 Nov 2026 17:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioALSyXj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AD61F000C4;
	Fri, 13 Nov 2026 17:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590961;
	bh=aF44AGuOxrTrL3cFyIKMGwhhBUT56FB/RU/c746xYWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ioALSyXjzuAfKXqYleVEeEjDGC9LkbVkXohcqZqIGUlHTxc0dmq2MCKCT8eRHQFi7
	 wyApKCFqdLY7ivefeOzAzPHwTgDnWKyOgN51BwvZIgAOQ8E88be+wyZ/MV0fHXAzVT
	 uBM7zjdlQ7arDyPVpNS/qGpqFh49w6ddn/LTh0zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/670] rose: drop the neighbour reference once when a cleared socket is closed
Date: Fri, 13 Nov 2026 10:45:03 -0500
Message-ID: <20261113153816.551548819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

rose_release() of a socket in state 2, awaiting the Clear Confirmation
of its call, drops the neighbour reference but leaves rose->neighbour
set, then releases the socket lock before disconnecting the socket.
release_sock() runs the frames put on the socket backlog while the
lock was held: a Clear Confirmation among them goes through
rose_state2_machine() with the socket still in state 2 and drops the
same reference again. rose_kill_by_neigh(), which does not take the
socket lock, can do the same if the link restarts or fails at that
moment. The neighbour refcount then goes below the number of users,
and the neighbour is freed while it is still in the tables.

Disconnect the socket before its lock is dropped, so that the frames
on the backlog find it in state 0, and take the neighbour off the
socket under rose_list_lock, as rose_kill_by_neigh() looks at it, so
that only one of them drops the reference.

On a QEMU bench with two guests (KASAN, lockdep), A calls B with T1 set
to 2 s, B never accepts, and A closes the socket 200 ms after T1
expired, while the Clear Confirmation is on its way. With 1 s of delay
in rose_release() and 500 ms before B sends the Clear Confirmation:
before, the "use" count of the neighbour in /proc/net/rose_neigh goes
to -1 on the first close, then KASAN reports a slab-use-after-free on
the freed neighbour and A panics; after, it stays at 0 over five calls,
with or without the delays.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit bf135eb205f09dbb9581f9bf2c9c8cd62d4ea9f2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 93c43d42f1c20..332d267716813 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -698,6 +698,7 @@ static struct sock *rose_make_new(struct sock *osk)
 static int rose_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
+	struct rose_neigh *neigh;
 	struct rose_sock *rose;
 
 	if (sk == NULL) return 0;
@@ -716,10 +717,21 @@ static int rose_release(struct socket *sock)
 		break;
 
 	case ROSE_STATE_2:
-		rose_neigh_put(rose->neighbour);
-		release_sock(sk);
+		/*
+		 * Disconnect before the socket lock is dropped: frames put on
+		 * the backlog meanwhile, a Clear Confirmation for one, then
+		 * find it in state 0 instead of dropping the neighbour
+		 * reference a second time. rose_kill_by_neigh() does not take
+		 * the socket lock: take the neighbour under rose_list_lock, as
+		 * it does, so that only one of them drops the reference.
+		 */
 		rose_disconnect(sk, 0, -1, -1);
-		lock_sock(sk);
+		spin_lock_bh(&rose_list_lock);
+		neigh = rose->neighbour;
+		rose->neighbour = NULL;
+		spin_unlock_bh(&rose_list_lock);
+		if (neigh)
+			rose_neigh_put(neigh);
 		rose_destroy_socket(sk);
 		break;
 
-- 
2.53.0



