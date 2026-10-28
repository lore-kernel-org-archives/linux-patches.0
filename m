Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207445;
	b=fjunV/dILOd7LXJwKnBobJw0Q3wiMJ0rCNskTesNE5loK1Y0E+bty1EHt4koqxGwG/cW
	 QUz6sEdp7C3opZgr2JhSSs3GyXdz9YiIJ19mfPlGOxN7LfvAFjqkCwUDXVqhpLl2RWTTa
	 A/it5uDcN2we78VPZ/0zdyc1CRBRi/4LQPBClMgTqTEPAFK+8OQVyVVKHvMbUnX3bPc5B
	 m9iHBmiDYFFwJo6DV2t2NYQAhtlnXZzamiiuMgEWVR86LFvIhU0+4CR1nCoecU578rGgD
	 VTuKqPIbNzFP+CUIdlGdpfcWhk3Usgj9UUG9vsMfLIyYx8Cc8kZKNKvxdIoAgIMp68w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l7ddvb3BthbcwhfthpGe6Ta85n0/OS5POD/Bij7Yofs=;
	b=YmzlRhM/5vAFqGEv4a67Uuli8+I4eAF7KHaWEHrxfRx/d0WTCwxkjV8AQlDeBkQ4W5PE
	 eeg71T2ojvS0jo6SuHf1+MK5tvRaoCDnzXIJsBp3UxreRITLP3ffrH3w6ryTsycFXBwun
	 cg1xA5SIsKKfxhly8+ee/IWR/iRF8ax7lYTW7Kg60ewWaEYeRZO7Ni8/P/1h222ltFQZ9
	 0IKjEF7F99YMpNrlHs+lBtu7KpBZEEin19gk4L0lFj6Uakvkwa98QINJzxGYWAQgkRqOl
	 CGCj946b0SLgwlYxN7tsnmv9ZX/uIX1ol7ugGbX+QGPtGu2ScWnfwxCrcr41gdEEs9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O586Y4E6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2CD606A31A;
	Wed, 28 Oct 2026 17:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O586Y4E6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3DC1F01825;
	Wed, 28 Oct 2026 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207445;
	bh=l7ddvb3BthbcwhfthpGe6Ta85n0/OS5POD/Bij7Yofs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O586Y4E6pkVujHt6HSQj3N3lAQeDXM5AF/epWPYqyx2y96CA+xhiJNuX4b6PKIzWm
	 Jy/A0lLWHprYoth6LwGXOWrvrIkNZY5OAlUVxjNqhDq21622vNK0Nwmxqai8VqMjRr
	 sdblKVp+qofUv5bqpD5JJ0AAT21spFLcDz6uWw+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/247] rose: disconnect orphaned STATE_2 sockets when device is gone
Date: Wed, 28 Oct 2026 17:56:45 +0100
Message-ID: <20261028165947.413647316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

When ax25stop brings down ROSE interfaces, sockets in ROSE_STATE_2
(awaiting CLEAR CONFIRM) whose device pointer is already NULL are not
reached by rose_kill_by_device() and wait for T3 (up to 180s) before
self-cleaning via rose_timer_expiry().  This keeps the rose module
usecount at 1, blocking rmmod for the full T3 duration.

In rose_heartbeat_expiry(), detect ROSE_STATE_2 sockets with no device,
cancel T3, release the neighbour reference, and call rose_disconnect()
+ sock_set_flag(SOCK_DESTROY).  The next heartbeat tick (<=5s) then
destroys the socket via the existing ROSE_STATE_0/SOCK_DESTROY path,
allowing clean module unload within 10s instead of up to 180s.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>

(cherry picked from commit d4f4cf9f09a3f5fafa8f09110a7c1b5d10f2f261)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_timer.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/rose/rose_timer.c b/net/rose/rose_timer.c
index 53d198ac96e89..92c07ceaa3899 100644
--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -139,6 +139,20 @@ static void rose_heartbeat_expiry(struct timer_list *t)
 		}
 		break;
 
+	case ROSE_STATE_2:
+		/* Device gone before CLEAR CONFIRM arrived: stop waiting for T3
+		 * and disconnect now instead of blocking rmmod for up to 180s. */
+		if (!rose->device) {
+			rose_stop_timer(sk);
+			if (rose->neighbour) {
+				rose_neigh_put(rose->neighbour);
+				rose->neighbour = NULL;
+			}
+			rose_disconnect(sk, ENETDOWN, -1, -1);
+			sock_set_flag(sk, SOCK_DESTROY);
+		}
+		break;
+
 	case ROSE_STATE_3:
 		/*
 		 * Check for the state of the receive buffer.
-- 
2.53.0



