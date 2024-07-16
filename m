Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA98B641;
	Tue, 16 Jul 2024 15:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144444; cv=none; b=PJdmSfEVI0VGwcnjOCJ4QdHg/0ZJs4qtYaHgEhV2sxy5jiUN3yBVknD6TT3F51AZPZUJFaozwMheuV42FhfhCdkzBXlW7n8cGwlKFse2PDoN0/Rk8IxW2OmGXQWqJKj6gnuJkUFVQISSPyvNxcGYwwtE6FYhnBZ2htQHWT3NvjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144444; c=relaxed/simple;
	bh=BMfkVUMgJTHzvxxEj/ELBoDrY1jGg9ymkTofbD2FCr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzB7xGmn8RCq1BwcEOlloJuJp3tFgiFudI0sB76/1/PpJSOBt+DCeFhwLChCpIf40l83k+XSurLSNOypDba/UD5cQDOWz3WPgYNzo+GQbmGG4S//S1BRuhKAfEz66aD4xuHPa++LJYOsO3ylFrfE0JWyaWkdVU2NmTF2wmXXcrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1LXYOi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1LXYOi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85226C4AF0B;
	Tue, 16 Jul 2024 15:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144443;
	bh=BMfkVUMgJTHzvxxEj/ELBoDrY1jGg9ymkTofbD2FCr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1LXYOi540Rksar3blA5bWW4xSOXFmLHzpA606wP2j0QMTfeOsWdxlPgzv3Q5PeG/
	 skczvhJwue2AealPISnmTEZ4Rt/okJSJN4iin5+CtOov6RFvxEFK+EU/EZQsaetjMa
	 UpF6n3Sx47P/idlw1zJJ2HMQfYaNMGgK1dQnimpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <imagedong@tencent.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 74/78] net: tcp: fix unexcepted socket die when snd_wnd is 0
Date: Tue, 16 Jul 2024 17:31:46 +0200
Message-ID: <20240716152743.502125303@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Menglong Dong <imagedong@tencent.com>

commit e89688e3e97868451a5d05b38a9d2633d6785cd4 upstream.

In tcp_retransmit_timer(), a window shrunk connection will be regarded
as timeout if 'tcp_jiffies32 - tp->rcv_tstamp > TCP_RTO_MAX'. This is not
right all the time.

The retransmits will become zero-window probes in tcp_retransmit_timer()
if the 'snd_wnd==0'. Therefore, the icsk->icsk_rto will come up to
TCP_RTO_MAX sooner or later.

However, the timer can be delayed and be triggered after 122877ms, not
TCP_RTO_MAX, as I tested.

Therefore, 'tcp_jiffies32 - tp->rcv_tstamp > TCP_RTO_MAX' is always true
once the RTO come up to TCP_RTO_MAX, and the socket will die.

Fix this by replacing the 'tcp_jiffies32' with '(u32)icsk->icsk_timeout',
which is exact the timestamp of the timeout.

However, "tp->rcv_tstamp" can restart from idle, then tp->rcv_tstamp
could already be a long time (minutes or hours) in the past even on the
first RTO. So we double check the timeout with the duration of the
retransmission.

Meanwhile, making "2 * TCP_RTO_MAX" as the timeout to avoid the socket
dying too soon.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/netdev/CADxym3YyMiO+zMD4zj03YPM3FBi-1LHi6gSD2XT8pyAMM096pg@mail.gmail.com/
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_timer.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -434,6 +434,22 @@ static void tcp_fastopen_synack_timer(st
 			  TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
 }
 
+static bool tcp_rtx_probe0_timed_out(const struct sock *sk,
+				     const struct sk_buff *skb)
+{
+	const struct tcp_sock *tp = tcp_sk(sk);
+	const int timeout = TCP_RTO_MAX * 2;
+	u32 rcv_delta, rtx_delta;
+
+	rcv_delta = inet_csk(sk)->icsk_timeout - tp->rcv_tstamp;
+	if (rcv_delta <= timeout)
+		return false;
+
+	rtx_delta = (u32)msecs_to_jiffies(tcp_time_stamp(tp) -
+			(tp->retrans_stamp ?: tcp_skb_timestamp(skb)));
+
+	return rtx_delta > timeout;
+}
 
 /**
  *  tcp_retransmit_timer() - The TCP retransmit timeout handler
@@ -497,7 +513,7 @@ void tcp_retransmit_timer(struct sock *s
 					    tp->snd_una, tp->snd_nxt);
 		}
 #endif
-		if (tcp_jiffies32 - tp->rcv_tstamp > TCP_RTO_MAX) {
+		if (tcp_rtx_probe0_timed_out(sk, skb)) {
 			tcp_write_err(sk);
 			goto out;
 		}


