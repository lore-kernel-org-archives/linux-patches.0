Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211949;
	b=1Zge3dAjLBxLXjpdrVIW8DB0+O8NJY4vfqFkLjj5RZo4XdLP338KpcB0QbbS9x0p70dp
	 AXIkWNPFncWe4vA9D2lLMJPUn1WfwczM26yh9ieQWRUOnbQVW7kLWlPPV1BixJD9wDPek
	 5ltsJbE8XEm+gp1/s2JiMh4CqU5KmLISzmESIdsBq75oXgDL/0HOiR6F8l0mqEVzLIoiX
	 J+7dO0Wderc82IndXMUMK/+iBBVBnJNIk+SmDvfHnEGwSYQadNXhgKFlrDQr2agU+6cZu
	 ZT90g/dG+vrRGNvpyAAK4fccYvp2BxWkVbNkvPPwWLoUSG8pxYexPJyVwo3ybwqsV0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=H7rvVu9M4jCvftj+gUnD5elP1z7NvaMkfhp6yRWaUQI=;
	b=Ccc+s49sEVMtG7zAY2uAKI5hNIzavzkBxPqFJvobW947kzVbzAZcdlRxTw+LPadiF79x
	 IC4YcUaaUoaX2DSw3wTRmGUk/fcDdOnUaXQZCUFpmem+HLmi83h88I/7xqEMo1aRfWC/w
	 MKxRjHCW9Kgfi0COqm+59Jmcf+PuICjz3KZS7+2oUZdv7PXbNbtzedInKv1iFX7hMVHjj
	 4hIgf+uoXLcuXniqbhkGUY9DOpgLwqg2MWAiO6bQzz1doz+zVeSpU6n7vsFSLkjJGNjO7
	 iHgEX9iAL6HpCxlWA+UYOPQ27FEOWwjH4UoeSzd/VvbCEuTFHjP3uTMW3ES/WiKr3NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJRbvc2P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F62606A31C;
	Wed, 28 Oct 2026 18:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJRbvc2P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7259E1F01825;
	Wed, 28 Oct 2026 18:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211949;
	bh=H7rvVu9M4jCvftj+gUnD5elP1z7NvaMkfhp6yRWaUQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJRbvc2Pei2owOh8EVJij4+ohD5481gNcUXQ2Z0mj3aZBL6TxL3UYEcsdW4H1t0eK
	 bxlacxIUUmj1hNRQdyX32SJnjT82TxJtmmcTqb4ImcShWUxN4oMaDhAVaak303bj3G
	 9xJQtQu+G92Ehgrr5GHKvFgooknNW3BFSaxBYZCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	=?UTF-8?q?Jonas=20K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>,
	Chris Arges <carges@cloudflare.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 555/571] net_sched: codel: fix stale state for empty flows in fq_codel
Date: Wed, 28 Oct 2026 18:01:42 +0100
Message-ID: <20261028170021.206204207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Köppeler <j.koeppeler@tu-berlin.de>

[ Upstream commit 815980fe6dbb01ad4007e8b260a45617f598b76d ]

When codel_dequeue() finds an empty queue, it resets vars->dropping
but does not reset vars->first_above_time.  The reference CoDel
algorithm (Nichols & Jacobson, ACM Queue 2012) resets both:

  dodeque_result codel_queue_t::dodeque(time_t now) {
      ...
      if (r.p == NULL) {
          first_above_time = 0;   // <-- Linux omits this
      }
      ...
  }

Note that codel_should_drop() does reset first_above_time when called
with a NULL skb, but codel_dequeue() returns early before ever calling
codel_should_drop() in the empty-queue case.  The post-drop code paths
do reach codel_should_drop(NULL) and correctly reset the timer, so a
dropped packet breaks the cycle -- but the next delivered packet
re-arms first_above_time and the cycle repeats.

For sparse flows such as ICMP ping (one packet every 200ms-1s), the
first packet arms first_above_time, the flow goes empty, and the
second packet arrives after the interval has elapsed and gets dropped.
The pattern repeats, producing sustained loss on flows that are not
actually congested.

Test: veth pair, fq_codel, BQL disabled, 30000 iptables rules in the
consumer namespace (NAPI-64 cycle ~14ms, well above fq_codel's 5ms
target), ping at 5 pps under UDP flood:

  Before fix:  26% ping packet loss
  After fix:    0% ping packet loss

Fix by resetting first_above_time to zero in the empty-queue path
of codel_dequeue(), matching the reference algorithm.

Fixes: 76e3cc126bb2 ("codel: Controlled Delay AQM")
Fixes: d068ca2ae2e6 ("codel: split into multiple files")
Co-developed-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: Jonas Köppeler <j.koeppeler@tu-berlin.de>
Reported-by: Chris Arges <carges@cloudflare.com>
Tested-by: Jonas Köppeler <j.koeppeler@tu-berlin.de>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/all/20260318134826.1281205-7-hawk@kernel.org/
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260323174920.253526-1-hawk@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/codel_impl.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
index d289b91dcd65e..f7615981d39ef 100644
--- a/include/net/codel_impl.h
+++ b/include/net/codel_impl.h
@@ -154,6 +154,7 @@ static struct sk_buff *codel_dequeue(void *ctx,
 	bool drop;
 
 	if (!skb) {
+		vars->first_above_time = 0;
 		vars->dropping = false;
 		return skb;
 	}
-- 
2.53.0



