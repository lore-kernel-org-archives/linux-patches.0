Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1015C2210F1;
	Thu, 12 Dec 2024 15:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015794; cv=none; b=shqsKD4x9tDMizofCd/qNCk4RIYJv1UxjgcapsNn/RHHUx6dZrlIpPVmX1yNrACTVX5FgOdgJcP9A6jrrRZP9o8QYycDCI1dFJ5eOTiKzZGifGEdab4x7IYByqOoUldHe0PlSeY+szS/mfz3M/WwTeBhj3J3iaek6g9J/o4oJeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015794; c=relaxed/simple;
	bh=YW7A1NFWkWZbfxuNJiPA3FBRbPz1GfLzs4rwdWwhsYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANffTgV3WIUNUwmJtez2TXsJ+HUPJ4tLL0CfFTpcgKa1vpQ9Ax640pqWtlF+C913GDuR6Bks8p7m0oWe7qd5wwNrqWKVdkfOtIVxA3eiKpmT3T74LF7ozAivVcowJM9zalQgAEmq8U2bAazfYt97QpPckZ2m5/XN+dfMQXVAN/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fC9tsvQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fC9tsvQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D45C4CEDF;
	Thu, 12 Dec 2024 15:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015793;
	bh=YW7A1NFWkWZbfxuNJiPA3FBRbPz1GfLzs4rwdWwhsYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fC9tsvQGG+3TkcW4iwURr7KlZ12tjuaWijabs5286WmJYdT765ow1Hx7wHUQc2ACf
	 DqVnkfw1yG3G7OG7ovM6LUHwwjkX669Vg5nRcqtVatgt4Pa8MQloBo6IBCv4vhTTvs
	 oPmQhtYIU2tUalLdM+RXXRqUgcGOP68n/Wo9Es+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/466] Revert "udp: avoid calling sock_def_readable() if possible"
Date: Thu, 12 Dec 2024 15:53:35 +0100
Message-ID: <20241212144308.506406224@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

[ Upstream commit 3d501f562f63b290351169e3e9931ffe3d57b2ae ]

This reverts commit 612b1c0dec5bc7367f90fc508448b8d0d7c05414. On a
scenario with multiple threads blocking on a recvfrom(), we need to call
sock_def_readable() on every __udp_enqueue_schedule_skb() otherwise the
threads won't be woken up as __skb_wait_for_more_packets() is using
prepare_to_wait_exclusive().

Link: https://bugzilla.redhat.com/2308477
Fixes: 612b1c0dec5b ("udp: avoid calling sock_def_readable() if possible")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241202155620.1719-1-ffmancera@riseup.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2849b273b1310..ff85242720a0a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1516,7 +1516,6 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 	struct sk_buff_head *list = &sk->sk_receive_queue;
 	int rmem, err = -ENOMEM;
 	spinlock_t *busy = NULL;
-	bool becomes_readable;
 	int size, rcvbuf;
 
 	/* Immediately drop when the receive queue is full.
@@ -1557,19 +1556,12 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 	 */
 	sock_skb_set_dropcount(sk, skb);
 
-	becomes_readable = skb_queue_empty(list);
 	__skb_queue_tail(list, skb);
 	spin_unlock(&list->lock);
 
-	if (!sock_flag(sk, SOCK_DEAD)) {
-		if (becomes_readable ||
-		    sk->sk_data_ready != sock_def_readable ||
-		    READ_ONCE(sk->sk_peek_off) >= 0)
-			INDIRECT_CALL_1(sk->sk_data_ready,
-					sock_def_readable, sk);
-		else
-			sk_wake_async_rcu(sk, SOCK_WAKE_WAITD, POLL_IN);
-	}
+	if (!sock_flag(sk, SOCK_DEAD))
+		INDIRECT_CALL_1(sk->sk_data_ready, sock_def_readable, sk);
+
 	busylock_release(busy);
 	return 0;
 
-- 
2.43.0



