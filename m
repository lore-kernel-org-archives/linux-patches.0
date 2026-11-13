Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590954;
	b=JsITSs6rUVaF/XgT7dep2yA5pk85fMeet9GOiNRD2qIyp0MmvT3aMVm1CHqVMTZ6PLg/
	 XKa/fH46VF489nt8HkNNEbRKNTvCXvoPX8ftQniBxiWddnAYib6OCSVulwrkUHUifCXTq
	 J5lQFuLtySrQfqzRKl7pz8Wsqeu5AZDBlGnrceuE8NgqX42UnyUpC4svSIU3tJeDuYQ3M
	 YgFgEN64JF+Z21cdvnQrvjQq/S+t1sY471HkBrYOnpLfMEbZmm6yQVXkGl6RktDJ0yJdh
	 OwS3NAkois0JEA5FUa4BwVo5Z/ovEE5y8zcdLEF1GYISh3u58pLp7qDgBlgsT8q5hBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H1ESnCQeMZUieI7lmzkgVLUpLJCTXlXQSaj42+jn+GY=;
	b=JvWFcIgFlHWx7BvCKcqWJvC6fwt+sj64uBJJu8xuLHiMhaNGV0A6TGy0oD8U/8YP7uft
	 97RSuXlLnKq2LtOOk2Lz80TD8tfkC3rruy+D+1AQHmQ5OAgxUyujcEs29iiRqYMjd7F0n
	 9gaABBrzlFk8nOwHrimkomLxWbcWxDazkFbVol5wt0pgV8hoYhXo03GtTHkZ+3BLS9wZF
	 FY5N7Ttc1/jNZQdsfUAXNg6c9VxTQwnVX7xKDWAhg4ypm5OBDTR1xkxucqv8HbN4WKi39
	 Vg8XFUWWQZWXxrt+ALnqLp/86cX9wpRTWoDrFrGyZqjN1dRjHm4F7+RmJRt8NnVG+aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nOwnTgZh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810CD606F708;
	Fri, 13 Nov 2026 17:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nOwnTgZh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BCE1F000C4;
	Fri, 13 Nov 2026 17:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590954;
	bh=H1ESnCQeMZUieI7lmzkgVLUpLJCTXlXQSaj42+jn+GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOwnTgZh0pJzoF3WrsQSClPm7BlWJje8fjqFqdqRYThBKXb/CZ9YgbLYFgZm8beKX
	 B9LDv1wTD422tr4cPRLQUgdJlYspEgTkmvtJpIMEAlW9PPsxZGqr62Tcr9Fp1NUCuy
	 MHvlTj8TmbOKlvo3ZmvcGDxFp89GA0ZfGIdlsU0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/670] netrom: disconnect sockets under their lock when a device goes down
Date: Fri, 13 Nov 2026 10:44:58 -0500
Message-ID: <20261113153816.371939177@linuxfoundation.org>
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
index 37952f858908e..55abdeaeb6fec 100644
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



