Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A33A1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF985C433C8;
	Mon, 21 Aug 2023 20:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648601;
	bh=jkyfypRiDzJyk1RjDal3jKbyNclTlmBoJgSXq8CvOZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQDWVsKgzCj2y/9fGeuCXehjQEhyvNnhq8FrrFLO6qc3akyE7gBK/wx7HFQftvOi6
	 5a54Oc6lIV1N00ovKp64o+7YPflYARI1SnKEi8jt9l1mGifUZNng5hsF+jSR/Gqo3M
	 7SWbeEWFnbRLoiufUSXD1hGkBwjNaD2demSNtsfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jason Xing <kernelxing@tencent.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.4 234/234] net: fix the RTO timer retransmitting skb every 1ms if linear option is enabled
Date: Mon, 21 Aug 2023 21:43:17 +0200
Message-ID: <20230821194139.288531958@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Xing <kernelxing@tencent.com>

commit e4dd0d3a2f64b8bd8029ec70f52bdbebd0644408 upstream.

In the real workload, I encountered an issue which could cause the RTO
timer to retransmit the skb per 1ms with linear option enabled. The amount
of lost-retransmitted skbs can go up to 1000+ instantly.

The root cause is that if the icsk_rto happens to be zero in the 6th round
(which is the TCP_THIN_LINEAR_RETRIES value), then it will always be zero
due to the changed calculation method in tcp_retransmit_timer() as follows:

icsk->icsk_rto = min(icsk->icsk_rto << 1, TCP_RTO_MAX);

Above line could be converted to
icsk->icsk_rto = min(0 << 1, TCP_RTO_MAX) = 0

Therefore, the timer expires so quickly without any doubt.

I read through the RFC 6298 and found that the RTO value can be rounded
up to a certain value, in Linux, say TCP_RTO_MIN as default, which is
regarded as the lower bound in this patch as suggested by Eric.

Fixes: 36e31b0af587 ("net: TCP thin linear timeouts")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_timer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -586,7 +586,9 @@ out_reset_timer:
 	    tcp_stream_is_thin(tp) &&
 	    icsk->icsk_retransmits <= TCP_THIN_LINEAR_RETRIES) {
 		icsk->icsk_backoff = 0;
-		icsk->icsk_rto = min(__tcp_set_rto(tp), TCP_RTO_MAX);
+		icsk->icsk_rto = clamp(__tcp_set_rto(tp),
+				       tcp_rto_min(sk),
+				       TCP_RTO_MAX);
 	} else {
 		/* Use normal (exponential) backoff */
 		icsk->icsk_rto = min(icsk->icsk_rto << 1, TCP_RTO_MAX);


