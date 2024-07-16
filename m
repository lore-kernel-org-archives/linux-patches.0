Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B805CA40;
	Tue, 16 Jul 2024 15:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144198; cv=none; b=KlxbiEFaBC569oa8KV8Fbby4y431i3M1acQqnRoYpGnxdqneHSbB4fcOf/g/WIalhawK+LpcJtuCoIMIT2rXIt2Fs9LZsx9HqdM+yZQ/kp8GqlREEURpFck8Vo8mFMZnUTtHZixDbIdGO5JW0XV9llDbUjBxONnUf0YNBQaiK+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144198; c=relaxed/simple;
	bh=RUti4fjVeJ84CcEQuFxC6AqZbNkTmINzgel98cs4LQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJU6Sf0BEjPyVE+65xMp7unq3aRd5sT+y2Em4oMehVMdZ2GmaFLF8lBoQNlO0nuUOyqf2JxGB4YHDXAXrClrx7fDBFqiZWLg8N/yKkg4tD5kN8KN3JAQAXEHiZnZpm6/yqSfRLI4RvxwT1/+DVmKPdTKBe95DWE8wI5XfpyuwD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMoQqnGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMoQqnGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F58C116B1;
	Tue, 16 Jul 2024 15:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144198;
	bh=RUti4fjVeJ84CcEQuFxC6AqZbNkTmINzgel98cs4LQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMoQqnGjQ+E3l0Kb5noAfUo9g/LMHzZQahAnjLJl+BJb8Zegiga260PriN7cQnMlN
	 JZIa82761j0IxukO9V/FYbSS+/8I97+Jl7iz4JnRx367bOahGkKVu2WpM70tz/fuGX
	 LNX4pDaVRSTop/6SZhFKwmAEnmBc2Q/WVBdwODYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <imagedong@tencent.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 61/66] net: tcp: fix unexcepted socket die when snd_wnd is 0
Date: Tue, 16 Jul 2024 17:31:36 +0200
Message-ID: <20240716152740.489875072@linuxfoundation.org>
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
@@ -411,6 +411,22 @@ static void tcp_fastopen_synack_timer(st
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
@@ -471,7 +487,7 @@ void tcp_retransmit_timer(struct sock *s
 					    tp->snd_una, tp->snd_nxt);
 		}
 #endif
-		if (tcp_jiffies32 - tp->rcv_tstamp > TCP_RTO_MAX) {
+		if (tcp_rtx_probe0_timed_out(sk, skb)) {
 			tcp_write_err(sk);
 			goto out;
 		}


