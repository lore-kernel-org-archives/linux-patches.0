Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA6215E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyjaGKHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBC4C433C7;
	Mon, 23 Oct 2023 11:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060987;
	bh=eCWYMqgcKLJJCKBfo4FHEbljcgB8yx8x3MaDsvAinsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyjaGKHpa+m9Nwiv0V9kzDdEfEBxaynBvHX+nGckWCor6S9Oc6Cvwu9JJBU01r76J
	 0Vv2fb1YSKTF4rd22vRSnHB8Y2ECHbV5XE9ivfiltipH9iEW7GPv5a3YDBFOACROoq
	 GY1vu23yI1jRCntZnXm83W45L09qwO3MQ+lkBoGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 035/137] tcp: fix excessive TLP and RACK timeouts from HZ rounding
Date: Mon, 23 Oct 2023 12:56:32 +0200
Message-ID: <20231023104822.217032479@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

commit 1c2709cfff1dedbb9591e989e2f001484208d914 upstream.

We discovered from packet traces of slow loss recovery on kernels with
the default HZ=250 setting (and min_rtt < 1ms) that after reordering,
when receiving a SACKed sequence range, the RACK reordering timer was
firing after about 16ms rather than the desired value of roughly
min_rtt/4 + 2ms. The problem is largely due to the RACK reorder timer
calculation adding in TCP_TIMEOUT_MIN, which is 2 jiffies. On kernels
with HZ=250, this is 2*4ms = 8ms. The TLP timer calculation has the
exact same issue.

This commit fixes the TLP transmit timer and RACK reordering timer
floor calculation to more closely match the intended 2ms floor even on
kernels with HZ=250. It does this by adding in a new
TCP_TIMEOUT_MIN_US floor of 2000 us and then converting to jiffies,
instead of the current approach of converting to jiffies and then
adding th TCP_TIMEOUT_MIN value of 2 jiffies.

Our testing has verified that on kernels with HZ=1000, as expected,
this does not produce significant changes in behavior, but on kernels
with the default HZ=250 the latency improvement can be large. For
example, our tests show that for HZ=250 kernels at low RTTs this fix
roughly halves the latency for the RACK reorder timer: instead of
mostly firing at 16ms it mostly fires at 8ms.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Fixes: bb4d991a28cc ("tcp: adjust tail loss probe timeout")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20231015174700.2206872-1-ncardwell.sw@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h       |    3 +++
 net/ipv4/tcp_output.c   |    9 +++++----
 net/ipv4/tcp_recovery.c |    2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -141,6 +141,9 @@ void tcp_time_wait(struct sock *sk, int
 #define TCP_RTO_MAX	((unsigned)(120*HZ))
 #define TCP_RTO_MIN	((unsigned)(HZ/5))
 #define TCP_TIMEOUT_MIN	(2U) /* Min timeout for TCP timers in jiffies */
+
+#define TCP_TIMEOUT_MIN_US (2*USEC_PER_MSEC) /* Min TCP timeout in microsecs */
+
 #define TCP_TIMEOUT_INIT ((unsigned)(1*HZ))	/* RFC6298 2.1 initial RTO value	*/
 #define TCP_TIMEOUT_FALLBACK ((unsigned)(3*HZ))	/* RFC 1122 initial RTO value, now
 						 * used as a fallback RTO for the
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2731,7 +2731,7 @@ bool tcp_schedule_loss_probe(struct sock
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
-	u32 timeout, rto_delta_us;
+	u32 timeout, timeout_us, rto_delta_us;
 	int early_retrans;
 
 	/* Don't do any loss probe on a Fast Open connection before 3WHS
@@ -2755,11 +2755,12 @@ bool tcp_schedule_loss_probe(struct sock
 	 * sample is available then probe after TCP_TIMEOUT_INIT.
 	 */
 	if (tp->srtt_us) {
-		timeout = usecs_to_jiffies(tp->srtt_us >> 2);
+		timeout_us = tp->srtt_us >> 2;
 		if (tp->packets_out == 1)
-			timeout += TCP_RTO_MIN;
+			timeout_us += tcp_rto_min_us(sk);
 		else
-			timeout += TCP_TIMEOUT_MIN;
+			timeout_us += TCP_TIMEOUT_MIN_US;
+		timeout = usecs_to_jiffies(timeout_us);
 	} else {
 		timeout = TCP_TIMEOUT_INIT;
 	}
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -109,7 +109,7 @@ bool tcp_rack_mark_lost(struct sock *sk)
 	tp->rack.advanced = 0;
 	tcp_rack_detect_loss(sk, &timeout);
 	if (timeout) {
-		timeout = usecs_to_jiffies(timeout) + TCP_TIMEOUT_MIN;
+		timeout = usecs_to_jiffies(timeout + TCP_TIMEOUT_MIN_US);
 		inet_csk_reset_xmit_timer(sk, ICSK_TIME_REO_TIMEOUT,
 					  timeout, inet_csk(sk)->icsk_rto);
 	}


