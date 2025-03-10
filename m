Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875E3232369;
	Mon, 10 Mar 2025 17:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628809; cv=none; b=pg6iqhtYT40/w79GiZrLBkZv5keidN2hrLxnS5bF6HuSxcRxboU9in7G7IGe9dScqmWk4by07qwjpCPF8/Rnf+nrdrHdszNT4VjTNAfFjDsgNpMX2apyXSFNrhWynk6LAsNIet3vi+vVMw5YU1t7VJQBRYXr9kOLPLbRZl/kmtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628809; c=relaxed/simple;
	bh=R7BfXnaFzIli1X5dMOtZIulCNeFd3q39Np1NHpSCqp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfvI6IT3wgTEFL6iHIwCiQM45Mdzxbakw/IRXzoMoia2SKZPwEA9PRgrDu6n/IOxmRHQ35yaPiCg+cSjnhgdh0DrJqCxzQr68U7Z868b1BFd72xHYMl9BCPSxS5bZxCAg+RHmlsX/NVko0lT8sFEUW7J4S0xHrd8uGBk9hohweg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldf4FuVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldf4FuVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F88BC4CEE5;
	Mon, 10 Mar 2025 17:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628809;
	bh=R7BfXnaFzIli1X5dMOtZIulCNeFd3q39Np1NHpSCqp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldf4FuVGN2qo6Ybn7sSFeoZ+uB9BMy6y46ZZgWpwjN9ZjveEo+ZQ2tvZveKlAejXS
	 R2uqz4n9diJgbfjS3EoC8sAnv/s/CMLGBpq4asG0gQVpPzy7r2xlws1bKYLRYa7jSS
	 UNJ1DEytyAdw4cW38qAEgXItbmUyNiBhFj0SOUQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahdi Arghavani <ma.arghavani@yahoo.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Haibo Zhang <haibo.zhang@otago.ac.nz>,
	David Eyers <david.eyers@otago.ac.nz>,
	Abbas Arghavani <abbas.arghavani@mdu.se>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/620] tcp_cubic: fix incorrect HyStart round start detection
Date: Mon, 10 Mar 2025 17:58:41 +0100
Message-ID: <20250310170548.543496344@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahdi Arghavani <ma.arghavani@yahoo.com>

[ Upstream commit 25c1a9ca53db5780757e7f53e688b8f916821baa ]

I noticed that HyStart incorrectly marks the start of rounds,
leading to inaccurate measurements of ACK train lengths and
resetting the `ca->sample_cnt` variable. This inaccuracy can impact
HyStart's functionality in terminating exponential cwnd growth during
Slow-Start, potentially degrading TCP performance.

The issue arises because the changes introduced in commit 4e1fddc98d25
("tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows")
moved the caller of the `bictcp_hystart_reset` function inside the `hystart_update` function.
This modification added an additional condition for triggering the caller,
requiring that (tcp_snd_cwnd(tp) >= hystart_low_window) must also
be satisfied before invoking `bictcp_hystart_reset`.

This fix ensures that `bictcp_hystart_reset` is correctly called
at the start of a new round, regardless of the congestion window size.
This is achieved by moving the condition
(tcp_snd_cwnd(tp) >= hystart_low_window)
from before calling `bictcp_hystart_reset` to after it.

I tested with a client and a server connected through two Linux software routers.
In this setup, the minimum RTT was 150 ms, the bottleneck bandwidth was 50 Mbps,
and the bottleneck buffer size was 1 BDP, calculated as (50M / 1514 / 8) * 0.150 = 619 packets.
I conducted the test twice, transferring data from the server to the client for 1.5 seconds.
Before the patch was applied, HYSTART-DELAY stopped the exponential growth of cwnd when
cwnd = 516, and the bottleneck link was not yet saturated (516 < 619).
After the patch was applied, HYSTART-ACK-TRAIN stopped the exponential growth of cwnd when
cwnd = 632, and the bottleneck link was saturated (632 > 619).
In this test, applying the patch resulted in 300 KB more data delivered.

Fixes: 4e1fddc98d25 ("tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows")
Signed-off-by: Mahdi Arghavani <ma.arghavani@yahoo.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Haibo Zhang <haibo.zhang@otago.ac.nz>
Cc: David Eyers <david.eyers@otago.ac.nz>
Cc: Abbas Arghavani <abbas.arghavani@mdu.se>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Tested-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_cubic.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index af4fc067f2a19..741a15799ab35 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -390,6 +390,10 @@ static void hystart_update(struct sock *sk, u32 delay)
 	if (after(tp->snd_una, ca->end_seq))
 		bictcp_hystart_reset(sk);
 
+	/* hystart triggers when cwnd is larger than some threshold */
+	if (tcp_snd_cwnd(tp) < hystart_low_window)
+		return;
+
 	if (hystart_detect & HYSTART_ACK_TRAIN) {
 		u32 now = bictcp_clock_us(sk);
 
@@ -465,9 +469,7 @@ static void cubictcp_acked(struct sock *sk, const struct ack_sample *sample)
 	if (ca->delay_min == 0 || ca->delay_min > delay)
 		ca->delay_min = delay;
 
-	/* hystart triggers when cwnd is larger than some threshold */
-	if (!ca->found && tcp_in_slow_start(tp) && hystart &&
-	    tcp_snd_cwnd(tp) >= hystart_low_window)
+	if (!ca->found && tcp_in_slow_start(tp) && hystart)
 		hystart_update(sk, delay);
 }
 
-- 
2.39.5



