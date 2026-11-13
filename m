Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585690;
	b=Fqiz/1JIrSuuBSUaMa+9o42AFYUlO4DVnx4sCptHPsQiIzOD9+nCB3guu815ICk4Kepc
	 emkbg+U2P6VKurcmsirbfoKt4k+krSz/gUs5OwcjQZpfs+N4WeC5HOrcI31KgoQNpDnzu
	 dC1oaX5nzWo9b4eEugKbj9CHzrokQXdU+/TJ2hyiFLK3+ZMt+JX+NIoEXmVADPzc08h1J
	 vnAYzhmm/s+UxXPtl5cDUB+H1udwTm7qxeJeUdvGJ8CBr6dV52YEn4Uefoh3HjU4GPtuc
	 psaGX7inygG2iVIsc9BEvUsL5xVzn0lAz5hcFdH0p+gji6v/bqq48d9qnwWvNf7Kvrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mLb/GMWG7IEbMC07nH0uU/MsFovfU/l4zyyaDgnWWSg=;
	b=fyxVXpVBUM3aWx9tnsY0vTxWRe+we65VmZX5K1ZVoTMX69M7lj3w+KHb3VVLHHV1oDoJ
	 Ck7xh0lKRPiReIAYLlhAUIaP8sUFYM8HyapKdYEwtHWln+W0HUyOR0m+sj5coguU7Qh9f
	 SrfrJs1F3Zq5HvGRc1dLJpRCLp/VCJg8zLBo5X4eSe+xxnI6u8vfbeSwJVWCjesA4gW12
	 rindMTd6WTEoI1S0HHOlfvane6Z1pwGEG2STq+F5US+Zb785u5AU39suXFBbmHHxs1Apq
	 IyovndZzrFFeRfX6IZvaUJlfRXh+WbI5/VQuZv7udrTyrhmbyYDPz/qdfHYe/n/vAiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8UU8yup;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0CF60744FC;
	Fri, 13 Nov 2026 16:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8UU8yup
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D0E1F000C4;
	Fri, 13 Nov 2026 16:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585690;
	bh=mLb/GMWG7IEbMC07nH0uU/MsFovfU/l4zyyaDgnWWSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8UU8yupwgL3FmlwsAVDrTaLJNddMLZVRqSSlGvJRkaW74fFL90knMsjSFn6F+Lm2
	 FmWpxxse8RyhOxkb1sTiJOVzgFaRtTuzU3VqCX/0Hr//C6go4hGYOA7ft7mqxI36qP
	 gEBeP9APCTartznxJwy/eYI+YE9x/RMqiWoGoVUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 299/507] can: proc: skip stats calculation after reset in can_stat_update()
Date: Fri, 13 Nov 2026 10:50:03 -0500
Message-ID: <20261113153805.382630852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit 01b19ed9fa031a649f3dd103ebe6e0102602e542 ]

Commit 80b5f90158d1 ("can: statistics: use atomic access in hot path")
introduced local snapshots of the statistics counters at the beginning
of can_stat_update(). When can_init_stats() resets the statistics, these
stale pre-reset snapshots are still used for the following total/current
/max calculations and overwrite the freshly reset values. Additionally a
jiffies tick between the snapshot and the reset could trigger a second
can_init_stats() call.

Merge the reset conditions into a single check and skip the calculation
for the current interval when the statistics have been reset.

Fixes: 80b5f90158d1 ("can: statistics: use atomic access in hot path")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20261027-can-rx-lock-v12-6-eb5afc2d8b9b@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/proc.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/net/can/proc.c b/net/can/proc.c
index 70104f13077e0..fb144d2adc35d 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -149,25 +149,18 @@ void can_stat_update(struct timer_list *t)
 	long tx_frames_delta = atomic_long_xchg(&pkg_stats->tx_frames_delta, 0);
 	long matches_delta = atomic_long_xchg(&pkg_stats->matches_delta, 0);
 
-	/* restart counting in timer context on user request */
-	if (user_reset)
-		can_init_stats(net);
-
-	/* restart counting on jiffies overflow */
-	if (j < pkg_stats->jiffies_init)
-		can_init_stats(net);
-
-	/* prevent overflow in calc_rate() */
-	if (rx_frames > (LONG_MAX / HZ))
-		can_init_stats(net);
-
-	/* prevent overflow in calc_rate() */
-	if (tx_frames > (LONG_MAX / HZ))
-		can_init_stats(net);
-
-	/* matches overflow - very improbable */
-	if (matches > (LONG_MAX / 100))
+	/*
+	 * Restart counting in timer context on user request, on jiffies
+	 * overflow or to prevent overflows in calc_rate() and in the
+	 * match ratio calculation. The local snapshots are stale after
+	 * the reset, so skip the calculation for this interval.
+	 */
+	if (user_reset || j < pkg_stats->jiffies_init ||
+	    rx_frames > (LONG_MAX / HZ) || tx_frames > (LONG_MAX / HZ) ||
+	    matches > (LONG_MAX / 100)) {
 		can_init_stats(net);
+		goto out;
+	}
 
 	/* calc total values */
 	if (rx_frames)
@@ -196,6 +189,7 @@ void can_stat_update(struct timer_list *t)
 	if (pkg_stats->max_rx_match_ratio < pkg_stats->current_rx_match_ratio)
 		pkg_stats->max_rx_match_ratio = pkg_stats->current_rx_match_ratio;
 
+out:
 	/* restart timer (one second) */
 	mod_timer(&net->can.stattimer, round_jiffies(jiffies + HZ));
 }
-- 
2.53.0



