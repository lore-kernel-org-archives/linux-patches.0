Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590124;
	b=KhTAEWPb//AMMAaeVYxBO8Ce/Ahhp7ED1q38tx72pxkgIPG2eV4VdzJxWYRbgwxVwBCz
	 oEeHCS47lXdSWEKZuv8azGjh4dWYR+0lOAQ30qT7/B6E2Yv4zXTmjowgc/NMgMlhrQY0s
	 0WWfZFIx+sSVZtZ8o3F6XLmlwj3dqxqrUAFHInjBNmwrDH5bONAw61tmtU4I1pN6QETDP
	 gz7jYY6oB/dmPXc88RPUWagPNrCG5nvUUpzV8wnOrfS15DYnn1JzbmXdT5yfBkWllhxlj
	 k8YNVpHMuNbmO9VziGX237XCOVQUi8GB3y82lATXmLPBGnSh9bMs8ZTBnl6vvv442Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wFcuD3BTip4Z23R1yxBjuEvVpeZHOPE38Xin0ctjpmA=;
	b=PBqffNmEQxi8qQ0K74c5e3/0VtAffLWkrMPqySBCe+rLo6QTB02wPR21NpyE0dYOD2J5
	 Q/dOZ1cde3fPfwJ5AoZLHB9jdI5KMaembiYdEt+hhIhYrBb+7yMfqp7qWKsipHbT5oX/v
	 lw42slmnStZw4AObNadqY5i91tDO20SGc0hfu38vUefsOna8RhavAXcZMrm+WmQ5X1mPX
	 jRKVyYThoeg1xz/HwDJEeHAJlWNs72b+07ixxGRaNNPPPYae2kklWxsmqx3MwOSN/x0+1
	 9jROotAuauyw32gqFhA9q3v+tLc/c6sdcnWQVwT4+VvzhZACua+YokQc9+dBmGVZU0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EiNdGXAt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD2B606B22C;
	Fri, 13 Nov 2026 17:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EiNdGXAt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA2A1F000C5;
	Fri, 13 Nov 2026 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590124;
	bh=wFcuD3BTip4Z23R1yxBjuEvVpeZHOPE38Xin0ctjpmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EiNdGXAtHGD0oZiguAFH5F0LkZHn2D6927vN0znajOvQT+CtX5rWjs4Oi9f01SXDz
	 ZC1bj/YxqyWZxflWwsOj596FLwNyWA8Y+d3vl1qG2v1h3ivkX2ksvibScdJ2d9pD87
	 UU+KE0QBCQyfxgS+FdRrC1fYh15Y6GJFVDksEHAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 137/686] netrom: disconnect sockets under their lock when a device goes down
Date: Fri, 13 Nov 2026 10:44:30 -0500
Message-ID: <20261113153825.447327538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

nr_kill_by_device() disconnects every socket bound to the device going
down while holding only nr_list_lock. nr_disconnect() stops the timers,
purges the queues and changes the state of the socket, but its timers
and nr_rx_frame() work on the same socket under bh_lock_sock() only, on
other CPUs, and are not kept out by nr_list_lock: a timer can be
retransmitting from a queue being purged, or a frame received can move
the socket back to another state.

Take the socket lock around nr_disconnect(). nr_info_show() already
nests the socket lock inside nr_list_lock in the same way.

The race was not reproduced. Tested for regressions on two QEMU guests
(6.12.94, KASAN, lockdep) linked by KISS: A opens eight circuits to B
and keeps sending on them; B reads /proc/net/nr in a loop and takes nr0
down. Before and after, all eight circuits on B end with ENETUNREACH and
there is no kernel report, lockdep included.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 8ed753bc28c482baca2ac0ccfc3e2dbeda6a72a1)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/af_netrom.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 77a8f4d6a59b4..d9b2d74d44c8d 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -96,16 +96,22 @@ static void nr_remove_socket(struct sock *sk)
 }
 
 /*
- *	Kill all bound sockets on a dropped device.
+ *	Kill all bound sockets on a dropped device. Each socket is disconnected
+ *	under its lock, which its timers and nr_rx_frame() hold while they work
+ *	on it; nr_info_show() takes the two locks in the same order.
  */
 static void nr_kill_by_device(struct net_device *dev)
 {
 	struct sock *s;
 
 	spin_lock_bh(&nr_list_lock);
-	sk_for_each(s, &nr_list)
-		if (nr_sk(s)->device == dev)
-			nr_disconnect(s, ENETUNREACH);
+	sk_for_each(s, &nr_list) {
+		if (nr_sk(s)->device != dev)
+			continue;
+		bh_lock_sock(s);
+		nr_disconnect(s, ENETUNREACH);
+		bh_unlock_sock(s);
+	}
 	spin_unlock_bh(&nr_list_lock);
 }
 
-- 
2.53.0



