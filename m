Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590114;
	b=aprwZ3Ug/4IqyT9Aor2d5PuqoPN00I4d1K3BndSjvy3Cc1LmD2558gHqD3+aCvQjANB9
	 KvtDx15gMZvowlTy2/cWvDzTMJLIwmRi7Vm9QTlk9D/1tO233vP3yfF4tuPWZA5vI3vJf
	 9CYfmF5N6rdGDh03hgZDGGIyY5+l0eVSh/mg7hHe7Lo/2aPMwxD32J5Gz8THezM/KJFhj
	 O+32FoFs5wHjGOtgV3gQ4smSgvbk6icEmqZMwPvMuwOrf+OzN4Q8zqTczLUXcglKwnW2T
	 dsy9AZByeRcBXD0NMKj5A2LUdIxcgwrQKyELn2hFjDcbCWb9/5MPLdrH8OND3B/pZLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i20W1BAjft8DL5rJUZ0iCrxUFeQEnFLud2zaKMMBDYk=;
	b=U/URByC8jsuEh1FP34iKdE19Yli8EqjyPP7B27AR09EOFuY08HSchGQq0vnvMfUQCQUH
	 caZpboI/EUJz6y+v33cGc7aKdmzuH9eKSeUtazWRRKg0ctxE1P4XXX5SzBvzmjxTLxkM3
	 XWwin8THFqUqUXQI5mw7yw2+whIcuk/xD7j/T3MKyAIV9rFKH4FG4fRGZ5JaofcbCO97b
	 pFui/SpIdMCRQtD9i2TZWZrP2d6AR/oyS/FOyFMfIbD3sBFeInzuoLESsac8xhhsw3NaF
	 6MIICEyqjA94o1L6h0JN8dRGor17PVuG/tnAWR+8DUAhKadegLry1rtSGmGMC5VmJFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lt4YG4TH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6123D606B222;
	Fri, 13 Nov 2026 17:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lt4YG4TH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCE21F000C5;
	Fri, 13 Nov 2026 17:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590114;
	bh=i20W1BAjft8DL5rJUZ0iCrxUFeQEnFLud2zaKMMBDYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lt4YG4THcGR+xDOjyXq9m5LYD8tpLaJGLNsEGKPT0aP1eNWsRGw/O14KNlyTHlvyz
	 y/BTen/OOlUpXnahMoWeFKGrhuL56qfqYIjK9WaJh4e6Tj6jMdYRQFR90RReaLiRoy
	 zI/A8qZjkYmtpcT9yWNp5k0RRTrEdxfbn9cdcjaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 134/686] netrom: drop a frame received with a TTL of 0
Date: Fri, 13 Nov 2026 10:44:27 -0500
Message-ID: <20261113153825.351766761@linuxfoundation.org>
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

nr_route_frame() drops a frame to forward when its time to live is 1,
then decrements the TTL of the copy it sends on. A frame that arrives
with a TTL of 0 passes the test and leaves with a TTL of 255: in a
routing loop it can then go round up to 255 more times instead of
dying.

Drop frames with a TTL of 0 as well.

Tested on two QEMU guests (6.12.94, KASAN, lockdep) linked by KISS: A
sends B three NET/ROM frames for nodes that B routes through neighbour
TESTC, with TTL 0, 1 and 2, and listens as TESTC to see what B sends
on.

  before: TTL 0 sent on with TTL 255, TTL 1 dropped, TTL 2 sent on with 1
  after:  TTL 0 dropped,              TTL 1 dropped, TTL 2 sent on with 1

No kernel report in either run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 303f110f8f2adc6f8b313fbfd4d53a1fc56c29e6)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_route.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 8397a319932c1..7fbacc5fee84f 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -785,10 +785,12 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 	if (!READ_ONCE(sysctl_netrom_routing_control) && ax25 != NULL)
 		return 0;
 
-	/* Its Time-To-Live has expired */
-	if (skb->data[14] == 1) {
+	/*
+	 * Its Time-To-Live has expired. A frame received with a TTL of 0
+	 * has expired too: decremented below, it would leave with 255.
+	 */
+	if (skb->data[14] <= 1)
 		return 0;
-	}
 
 	nr_node = nr_node_get(nr_dest);
 	if (nr_node == NULL)
-- 
2.53.0



