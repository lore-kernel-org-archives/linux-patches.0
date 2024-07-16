Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63151CA40;
	Tue, 16 Jul 2024 15:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144204; cv=none; b=gqEueOUosw6XqW6GOy6FqJl0pCyDW+j/ZK1CCXoJo1CtSuvT+Fql4vOOV/wTGkfcireW2Zo5gR5AE/ttWdn1CM4FjSzMbPO2gGjxLGk4tnBINoIB8i6j3H+nY5j+1gkbXAibzeDo68e6oY0cW5jk3bgziJ49ZBND+QkiSH81YrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144204; c=relaxed/simple;
	bh=M9CQsdSRL1PcleO4aDkJvjQQvaMOD0MayBJqWrkCkk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYftJvtkdMOzJtqULLIOgIe6r2b9r9ntJfdA6uc67vqrVNxgp+my96FazD2186CZVJFLjTJtI13VYu+Rv0/4p7uqeea4XOy7NHd8qajKkslo0tg+5pWH0cAgb88eCtHkGY98hcSpcojFZgnTr3GAVLULqWHfER7+O2m6En0T37A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=un3yKKrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="un3yKKrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8E4C116B1;
	Tue, 16 Jul 2024 15:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144204;
	bh=M9CQsdSRL1PcleO4aDkJvjQQvaMOD0MayBJqWrkCkk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=un3yKKrWTuwrt97yRAajxmzLTOdLqzR0q4kDgIA0DUWjVMjs7dTtkTk1iV7GosUC7
	 h3ZEDOXPX/2tDzKV8KxEKLKd0SwNUsizyrkjydG+Orv9qjtX7ADYGL2jj91rxMp9QW
	 OXePawvpC3UZ7nhaCzAZv0utb8QA9f2emwXrBvls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jon Maxwell <jmaxwell37@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 63/66] tcp: avoid too many retransmit packets
Date: Tue, 16 Jul 2024 17:31:38 +0200
Message-ID: <20240716152740.569745141@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 97a9063518f198ec0adb2ecb89789de342bb8283 upstream.

If a TCP socket is using TCP_USER_TIMEOUT, and the other peer
retracted its window to zero, tcp_retransmit_timer() can
retransmit a packet every two jiffies (2 ms for HZ=1000),
for about 4 minutes after TCP_USER_TIMEOUT has 'expired'.

The fix is to make sure tcp_rtx_probe0_timed_out() takes
icsk->icsk_user_timeout into account.

Before blamed commit, the socket would not timeout after
icsk->icsk_user_timeout, but would use standard exponential
backoff for the retransmits.

Also worth noting that before commit e89688e3e978 ("net: tcp:
fix unexcepted socket die when snd_wnd is 0"), the issue
would last 2 minutes instead of 4.

Fixes: b701a99e431d ("tcp: Add tcp_clamp_rto_to_user_timeout() helper to improve accuracy")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Jon Maxwell <jmaxwell37@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20240710001402.2758273-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_timer.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -414,22 +414,34 @@ static void tcp_fastopen_synack_timer(st
 static bool tcp_rtx_probe0_timed_out(const struct sock *sk,
 				     const struct sk_buff *skb)
 {
+	const struct inet_connection_sock *icsk = inet_csk(sk);
+	u32 user_timeout = READ_ONCE(icsk->icsk_user_timeout);
 	const struct tcp_sock *tp = tcp_sk(sk);
-	const int timeout = TCP_RTO_MAX * 2;
+	int timeout = TCP_RTO_MAX * 2;
 	u32 rtx_delta;
 	s32 rcv_delta;
 
+	rtx_delta = (u32)msecs_to_jiffies(tcp_time_stamp(tp) -
+			(tp->retrans_stamp ?: tcp_skb_timestamp(skb)));
+
+	if (user_timeout) {
+		/* If user application specified a TCP_USER_TIMEOUT,
+		 * it does not want win 0 packets to 'reset the timer'
+		 * while retransmits are not making progress.
+		 */
+		if (rtx_delta > user_timeout)
+			return true;
+		timeout = min_t(u32, timeout, msecs_to_jiffies(user_timeout));
+	}
+
 	/* Note: timer interrupt might have been delayed by at least one jiffy,
 	 * and tp->rcv_tstamp might very well have been written recently.
 	 * rcv_delta can thus be negative.
 	 */
-	rcv_delta = inet_csk(sk)->icsk_timeout - tp->rcv_tstamp;
+	rcv_delta = icsk->icsk_timeout - tp->rcv_tstamp;
 	if (rcv_delta <= timeout)
 		return false;
 
-	rtx_delta = (u32)msecs_to_jiffies(tcp_time_stamp(tp) -
-			(tp->retrans_stamp ?: tcp_skb_timestamp(skb)));
-
 	return rtx_delta > timeout;
 }
 


