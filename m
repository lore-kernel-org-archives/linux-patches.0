Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590175;
	b=mxqFNfX1LoTJmHHH5OVGJJbJKuLHqUsERM7x+2h3pgENGuRr+ip66Jnutp1i4cAnX8Fy
	 Dq+s+4uvnFrXpRuahobsSko80bzlV2xberdv4ZdgQ8DCq1X1RSIfSTdSckUd5rPfDQUya
	 TucTHUOgOxefiRCK3SAxmRwopnLaEJGI2D1Xp9yjXflaxCDbMz2lOMVyf8UjUc2HLdcuf
	 +N4BNNwMSkbO6gwWOhMN9UHBiIbjynA940quFXodisfNMyu5bBhamNFECeUbzVCF4LGnM
	 ea3KXx1IVl/i6KdgILO2YHE8cIcJ3aiFUdEKKlfrbaLK5A5AmOt0XlHATmoSDym7JQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/9awbat99N3wHnI9ZSDp6JBwYfpvKCNGM3yPdh9DBO4=;
	b=LMYBoB9bKV1kDGMCQshFObvSpAJL/H/nTz40eMPnPG/cZpOA7jIqCy04jMoKpaYQJl9k
	 8rzBGfcWTPGMoe4cp5lr6uPSmtQYeGSZvl5PlToXI2U7lwHPeFHioXlOD0LKHEwwcAabJ
	 Ajhlngb8RG/B8eZTLNTZ/D1aDXtnVZzVEJP/i9ib/iZJLuiSTcqKQsg4QFBEvl/jCwP3d
	 Ihc2dUAnFuM9BLY1aLvZclGXoYG97c0rV9pD4Owy9kRtkfPKkbC1nOwh79VabZBu/NnF5
	 g9mleSqDcUe9FbCVY5P8sj8Yo5R3kMC42a7bFkkBWYrQL9Bk2xC3iTc8JonhDVAVtkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0eV1QiU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F410260703CA;
	Fri, 13 Nov 2026 17:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0eV1QiU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E43A1F000CB;
	Fri, 13 Nov 2026 17:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590174;
	bh=/9awbat99N3wHnI9ZSDp6JBwYfpvKCNGM3yPdh9DBO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0eV1QiUVXY0yuRkOfWwpdjUG1SUyPyHzLwNBRJZAoGOFzXX8nbs3wDpT9gNRunYX
	 J6RwiTaF/+JDCWbHud70ZvS/DtYMFwohX3e0lT7OaRibCcvcS8r4OgpL47W86GP0DK
	 pWsF6Hi69z1JE+qW60HizU+La+E54mEUA9u30ZUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 141/686] rose: report a timed out call to connect()
Date: Fri, 13 Nov 2026 10:44:34 -0500
Message-ID: <20261113153825.582125364@linuxfoundation.org>
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

When the Call Request of a connecting socket gets no answer within T1,
rose_timer_expiry() sends a Clear Request and moves the socket to
state 2, leaving sk_state at TCP_SYN_SENT. The neighbour then confirms
the clearing, or clears the call itself, and rose_state2_machine()
calls rose_disconnect() with a reason of 0. sk_err stays 0, so a
blocking connect() leaves its wait with sock_error() returning 0 and
reports success on a call that never got through, and a non-blocking
caller reads 0 from SO_ERROR. The first send() then fails with EPIPE.

Report ETIMEDOUT when the socket is cleared from state 2 while it is
still connecting, as rose_timer_expiry() already does when T3 runs
out. A socket that was released or timed out while connected goes on
being cleared without an error.

On a QEMU bench with two guests, B listening with ROSE_DEFER and never
accepting, A calling it with T1 set to 3 s, twice blocking and twice
non-blocking: before, connect() or SO_ERROR returned 0 in all four
calls; after, ETIMEDOUT in all four. A call to nobody still gets
ECONNREFUSED at once.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit fc29d2c97f98f96d371e20d9b36b5ba08a914ff3)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_in.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/rose/rose_in.c b/net/rose/rose_in.c
index 4eec54b24afb0..befb4c55e4597 100644
--- a/net/rose/rose_in.c
+++ b/net/rose/rose_in.c
@@ -75,17 +75,24 @@ static int rose_state1_machine(struct sock *sk, struct sk_buff *skb, int framety
 static int rose_state2_machine(struct sock *sk, struct sk_buff *skb, int frametype)
 {
 	struct rose_sock *rose = rose_sk(sk);
+	/*
+	 * A call whose Call Request timed out (T1) is cleared from state 2
+	 * while connect() is still waiting for it: report the timeout, or
+	 * connect() and SO_ERROR would find no error on a call that never
+	 * got through.
+	 */
+	int reason = sk->sk_state == TCP_SYN_SENT ? ETIMEDOUT : 0;
 
 	switch (frametype) {
 	case ROSE_CLEAR_REQUEST:
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
-		rose_disconnect(sk, 0, skb->data[3], skb->data[4]);
+		rose_disconnect(sk, reason, skb->data[3], skb->data[4]);
 		rose_neigh_put(rose->neighbour);
 		rose->neighbour = NULL;
 		break;
 
 	case ROSE_CLEAR_CONFIRMATION:
-		rose_disconnect(sk, 0, -1, -1);
+		rose_disconnect(sk, reason, -1, -1);
 		rose_neigh_put(rose->neighbour);
 		rose->neighbour = NULL;
 		break;
-- 
2.53.0



