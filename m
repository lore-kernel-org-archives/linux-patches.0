Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207423;
	b=RtzRYe1VnVLkEz1oIZn7bNGMUQjTvs3pc3oQxpkzTkiCPV/yPDYiIBeI7c23m0sQic8p
	 p1qa8O8Dfl0AbKuqlXcd3aUbwoJFeTTAubre4ulp+jOqCFX10y9B3NBArbk349dY7wJuL
	 gSilhtpKxoa0ip+35WDVFdZ7qLu7fW6NlJTjpr8gBPML9j5AJKzF1Pb5ZivJ2gd12fqtf
	 cquLur9B3Fu+s0NvjyugGpesXnCFjPtJAEEaRvRp0RktYaE0THIJNs1w2zBke3SZJnVv3
	 XXJplJbCXZWV4Mx3C7BOh0VcIMPTrncv+5CgF90XZBjR7V0pw65WNfN3phO9/YVwu0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z2MUYgtcEfZ2twziw9ik3lTqkUmSLYR6xUncPC8kPpY=;
	b=vx1Iw6c6wH1Yi4n0Dlm34vQk7igtZ+FuCBMwaWuJqruFYJdBXplgLONHf6xlcdla1mg5
	 2wOw/g1uLCesJ181BBIOel5kmAnA1YZGcmjCR97bAD8du0HjtZ6GJpdi7xueE8YUrAMPQ
	 5ZhVTuDWg4YIQwierzD3JZQd2qRG5RzvpZYAvQukBmIkZqMER7ZVlgGO4ZHwVV/lfym0V
	 dseiFIvtpcqpL+cv0OJTb3Hc80Fhbue6EvjyIHLcjlcvaGbXsHP1Zuf09UYC84Kr/mRny
	 ZzMPCmbcUedNLApqHB3MWv6eEVWoAZTYVtGapkqVApH/xI+AWPUtPLjIV1uiIA/NI0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJClwlPm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A145F606A31C;
	Wed, 28 Oct 2026 17:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJClwlPm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0ADF1F01825;
	Wed, 28 Oct 2026 17:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207422;
	bh=z2MUYgtcEfZ2twziw9ik3lTqkUmSLYR6xUncPC8kPpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJClwlPm9PhgBHsMXbovA189jY4qC6f9B3C+VjEvWmdbyo8L/PJiY/XqUJfsa3G7h
	 qKK92MsIG60SPAztTeO4NtVzeXqpZpGSBjJ2UemEM0/R4NsLpYPNrtQd+RJq8W8kLq
	 9MWBIAnlOMqq6rv8/eKhnxby6UVvsZQrlIda5nOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/247] rose: purge rose_neigh->queue on final teardown
Date: Wed, 28 Oct 2026 17:56:55 +0100
Message-ID: <20261028165947.648237807@linuxfoundation.org>
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

rose_transmit_link() queues an outgoing frame on rose_neigh->queue
instead of sending it immediately whenever the neighbour isn't
"restarted" yet (link not up) -- notably the CLEAR_REQUEST built by
rose_write_internal() when a socket is released (e.g. its owning
process is killed) while the underlying AX.25 link to that neighbour
is still coming up.

rose_neigh_put() already tears down both timers and drops the ax25/
digipeat references before freeing the neighbour, but never empties
this queue. kfree(rose_neigh) only frees the rose_neigh struct itself
(the sk_buff_head embedded in it is just three next/prev/len words),
not the skbs still linked into it -- every frame still queued here at
that point leaks for good.

rose_remove_neigh() (rose_route.c) already purges this same queue, but
it is only one of about two dozen call sites that can drop the last
reference and trigger the real kfree() in rose_neigh_put() -- every
socket releasing its own rose->neighbour reference (af_rose.c,
rose_in.c, rose_timer.c) can just as well be the one that does. Doing
the purge once, centrally, in rose_neigh_put() itself covers all of
them regardless of which call site happens to be last, rather than
relying on whichever caller happened to remember it.

Matches a leak pattern observed and documented back in May 2026
(mailbbs killed -> rose_release() -> rose_write_internal() ->
rose_transmit_link() queues the CLEAR_REQUEST -> skb never freed),
never root-caused until now.

Deployed and running since 2026-09-13/15 on three independent nodes
(f6bvp-12, f6bvp-8, f6bvp-10 -- three different kernel bases,
6.12.94/6.18.46/6.18.34), no regression observed.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit e59e4523182e4f58f4f29b5e4bce44c1ef152d70)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rose.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/net/rose.h b/include/net/rose.h
index 0d957b8dd0ba3..49140668b3dd0 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -180,6 +180,18 @@ static inline void rose_neigh_put(struct rose_neigh *rose_neigh)
 		 */
 		timer_shutdown_sync(&rose_neigh->ftimer);
 		timer_shutdown_sync(&rose_neigh->t0timer);
+		/* rose_transmit_link() queues a frame here instead of sending
+		 * it immediately whenever the neighbour isn't "restarted" yet
+		 * (link not up) -- e.g. the CLEAR_REQUEST built by
+		 * rose_write_internal() when a socket is released while its
+		 * underlying AX.25 link is still coming up. If this neighbour
+		 * is freed before that link ever comes up, nothing else ever
+		 * empties this queue: kfree() below only frees the
+		 * rose_neigh struct itself (including the three next/prev/len
+		 * words of the sk_buff_head), not the skbs it points to,
+		 * leaking every frame still queued here.
+		 */
+		skb_queue_purge(&rose_neigh->queue);
 		if (rose_neigh->ax25)
 			ax25_cb_put(rose_neigh->ax25);
 		kfree(rose_neigh->digipeat);
-- 
2.53.0



