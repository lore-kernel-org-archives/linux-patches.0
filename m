Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA88623BD1D;
	Mon, 24 Feb 2025 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408557; cv=none; b=rVt0INpl0icUUidwYlL/Jkj/vLK/hC8RxLyBD7HTgFxqI/OrozpApN6D0i/lieZTUuuRreelyGZvZJS5XYhf8ILVx6GTz39tk8GphQnodnBAoXX4mWNWixtK3QI4+Q//oM1Kef4P4B7Dm3ENlpleHzon63LnzoIO9cqJRCAafd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408557; c=relaxed/simple;
	bh=Us/kShg1y0Hp+YVyW723Yy3CvWfJJ1EM5F8cxN2CrTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjoGU8avFG550VWpUTEjCjJ8xV5G0gWI9mRrg8Cb1CjpaIwOEJgdff0dKLhD4VJSLIfuvPuy/PpPQlZgbqgoVi9syRemXyUuF84aqt3bJKb2qxyvZJj6zQe9Es4wYsY6I5qa6pB4B4h1muSRP7f3300RXieFku9usYVRJceQnmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTFoRpB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTFoRpB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C391C4CED6;
	Mon, 24 Feb 2025 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408557;
	bh=Us/kShg1y0Hp+YVyW723Yy3CvWfJJ1EM5F8cxN2CrTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTFoRpB22Gh2oJJ9aYHVKub5mmDhYulyCpJCI+SoUyvQ+AzXr8ZBtqK/OWnmdqIX5
	 UreduReZ7vkdmWs3Wj/SF/AUbbkgqCtt8N9FuIwoMEXbstmM68t0CQ9Gzp+2xsrhBF
	 ul/sFmc+W14rq9s9iRQ+bT1pH6H0ecTD66AzfYwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/154] tcp: adjust rcvq_space after updating scaling ratio
Date: Mon, 24 Feb 2025 15:34:20 +0100
Message-ID: <20250224142609.472852567@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f5da7c45188eea71394bf445655cae2df88a7788 ]

Since commit under Fixes we set the window clamp in accordance
to newly measured rcvbuf scaling_ratio. If the scaling_ratio
decreased significantly we may put ourselves in a situation
where windows become smaller than rcvq_space, preventing
tcp_rcv_space_adjust() from increasing rcvbuf.

The significant decrease of scaling_ratio is far more likely
since commit 697a6c8cec03 ("tcp: increase the default TCP scaling ratio"),
which increased the "default" scaling ratio from ~30% to 50%.

Hitting the bad condition depends a lot on TCP tuning, and
drivers at play. One of Meta's workloads hits it reliably
under following conditions:
 - default rcvbuf of 125k
 - sender MTU 1500, receiver MTU 5000
 - driver settles on scaling_ratio of 78 for the config above.
Initial rcvq_space gets calculated as TCP_INIT_CWND * tp->advmss
(10 * 5k = 50k). Once we find out the true scaling ratio and
MSS we clamp the windows to 38k. Triggering the condition also
depends on the message sequence of this workload. I can't repro
the problem with simple iperf or TCP_RR-style tests.

Fixes: a2cbb1603943 ("tcp: Update window clamping condition")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20250217232905.3162187-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2d43b29da15e2..bb17add6e4a78 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -243,9 +243,15 @@ static void tcp_measure_rcv_mss(struct sock *sk, const struct sk_buff *skb)
 			do_div(val, skb->truesize);
 			tcp_sk(sk)->scaling_ratio = val ? val : 1;
 
-			if (old_ratio != tcp_sk(sk)->scaling_ratio)
-				WRITE_ONCE(tcp_sk(sk)->window_clamp,
-					   tcp_win_from_space(sk, sk->sk_rcvbuf));
+			if (old_ratio != tcp_sk(sk)->scaling_ratio) {
+				struct tcp_sock *tp = tcp_sk(sk);
+
+				val = tcp_win_from_space(sk, sk->sk_rcvbuf);
+				tcp_set_window_clamp(sk, val);
+
+				if (tp->window_clamp < tp->rcvq_space.space)
+					tp->rcvq_space.space = tp->window_clamp;
+			}
 		}
 		icsk->icsk_ack.rcv_mss = min_t(unsigned int, len,
 					       tcp_sk(sk)->advmss);
-- 
2.39.5



