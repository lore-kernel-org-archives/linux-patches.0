Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210221;
	b=e0bWpcbFDzJzhdbaOSe6vpQqFBjlhq31iwLi5xltT/i6/fP/HXGm/Cw9FkK//oUQ3Pqx
	 QdAXS9Ds0rzcDnmpd7WL3J7O/N2y/Vm2wHYC06hVr7LTGnE/4n9Fo2gfYNaJdwmYWOylW
	 w1jXIwN+AqX9V6YwVcR6OCc3oBSf7VcDH/ydsdO0Xh6fKfUgyPGwPdQo1cKL3mHv1AtCG
	 zaZ4Lk3vLuUJLVq7MSNcct7k56LfvOGsSUKh9SPSRTR1Rp5vRq7H5ilwBAgte+fqwEw5d
	 IehC2u+/Ual+TsV0Idkq/0lndV/yWxlazArFgceeAEK78NXSLL57JaLINyDlDFPHO1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FpPLQ2+BteCErRbPQAG0Rm1tLJ6qj9y4GcWsIw+9Azk=;
	b=OIYa66Q9AkGjK+9oTrG4zeE87p1TnuAy2lll8NE+3HIYtqPfBPtB9Vaj5hxTZiCGh/rV
	 qLQ0HyY0QV1YQpRNaQyCN3WFVNKABi2W9LZivshkncrTsTuLYVN9VrLFSSL5zgeGllDmQ
	 lDWw9HM6jlW9A4gTz0mR3IHZH760oTKYheHhxUMX13T/yuMyo6bT8jXH+FyN15ZJao4eh
	 pADVPS7OZo9dSwFtOtypmDrw0bBPKlzajjOnTlrynSDV9FDCbHWiw18dl3QXPuYKJ9HRz
	 xkSS2o/9ghEQAxdQ1H7PG/2gyYKLs31qOu8Ray6HBVij0XX86nEGYSVD1e3xvP5SG0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLHFQ97u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E937606A323;
	Wed, 28 Oct 2026 17:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLHFQ97u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31631F01825;
	Wed, 28 Oct 2026 17:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210221;
	bh=FpPLQ2+BteCErRbPQAG0Rm1tLJ6qj9y4GcWsIw+9Azk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLHFQ97u4+Ms/QifGbbnF8WBKuLg2U7CUwBfF9076tuATNocp3Ho9/w8qDfTnL1CH
	 XG3TbyynKEkGJjtCeFoaWuYa+MV9Ly4rKGpfVhdnvklTQ6tDDNcJxoP265WjQSXnPw
	 5rGZU7EB17Cz7BhXHHbdpsoaJRfxgl1kuyB1naMg=
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
Subject: [PATCH 6.6 119/168] net_sched: codel: fix stale state for empty flows in fq_codel
Date: Wed, 28 Oct 2026 18:00:55 +0100
Message-ID: <20261028165945.905888550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 78a27ac730700..b2c359c6dd1b8 100644
--- a/include/net/codel_impl.h
+++ b/include/net/codel_impl.h
@@ -158,6 +158,7 @@ static struct sk_buff *codel_dequeue(void *ctx,
 	bool drop;
 
 	if (!skb) {
+		vars->first_above_time = 0;
 		vars->dropping = false;
 		return skb;
 	}
-- 
2.53.0



