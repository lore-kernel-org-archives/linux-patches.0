Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773781;
	b=cTT4O+ZiLc+dgjCIKkpz1QFUs5luyT/ffaKKIudMCPz56hUDhgw5rDK3NHsQJTABsdA+
	 uJsfhVfHo0jlmJ9tVqvQEpZqmbCvl3gNIYXTBaDz6D1wd3rK1eil7UW2bzkUG7ltKCGnl
	 47BTQmBdtLPnudcRSz7HksCUdB37g7TLg+DfuBu6kLzJeuCQSWzaArarDn+SuQIQ13riM
	 Et0IUKGQitWFfvLUqsQ2uyBGlGYvBX9gNSEZD0GJ1zmpv+sH85D8FZym4JKd2LCnp6P9b
	 yvWnyCJk5El2YTCzIwiMWzrSx8tUH76SBBhKSHep9ZESFIMxqJbAHmS+9mbZJBi9j4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RYiMP0Tigdya7zhZbz9gPe3MNAY7tj0PBGUDNt+05cA=;
	b=L4z4uFg5BljZG5NvIb5Dq+UGaA809cbcUwsbE/PrvQtdkI0cfmIZjMpzadH63QloQn84
	 d+dovtm9VpbFGqPmdv/iIi7/SrPZr6ViLqGbwuBjBo/GruWmh3f0vv/Dd3IIfvi9cuTlu
	 3X5ZGgauVU+ZfJAnRzXW/ZufXnElbt3XiU02aI9WsoMBHFiBMrs41J95xUMB5suk5Lp6L
	 9JZpBOiR4G+zzbkMhkF79r8FZCZYvLGS2L/CHmDiVgsoGyc6pc5PVWsw/roOMD+Bt2xQ2
	 SpWVyT/u/OFakrIl/1Rv3e1Jgf7H/nBCpeiLxu9mKgIR2zZqnc6uUKWCFKCP0ByE7zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BsNIPWpP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A1C606A31F;
	Fri, 23 Oct 2026 16:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BsNIPWpP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AA61F01825;
	Fri, 23 Oct 2026 16:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773781;
	bh=RYiMP0Tigdya7zhZbz9gPe3MNAY7tj0PBGUDNt+05cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BsNIPWpP7tJfKunsUYVrHfZ+35JFA0tEa0xeR3VO4DT8qLYR2HoG1oppQAJpaxgeP
	 vu1EC5pRZpUPC8ZXNXom5X5bbkG8ohW/ai+X9bYIIHueiOPHkfAyJV9hMI/HLSsP7k
	 YU1+uLtQ9UYXzF8LO22WDj8y+y4P4UJCjnJCEGgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 006/193] rose: purge rose_neigh->queue on final teardown
Date: Fri, 23 Oct 2026 18:34:43 +0200
Message-ID: <20261023163714.355984094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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



