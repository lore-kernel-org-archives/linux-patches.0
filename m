Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209532;
	b=CMJ7VYDhyMRcp1R9f8sXDd7aurDS5xXPuP6e7FXzzS0hXr6YhSV9YZ7rYabZa5Hhezyu
	 sJwm69zsWeS8oJrW4/p35TUerZCSqnEUafa30cENoUBVsAlH9XzfCQieeCcvTaBuZTlux
	 bwjKagOA324fEX4TK399DnFoFBSvpE24uohdHwoRzJGKIkxZMe0/E9brvyoulyJqq7JA4
	 VsyZ93RIyA+NDOSJke9QVEvFO5Hf9HdhhxsTKUHQlA37C+0JlpZO5GgrAs1l4cR0+8etw
	 JtuAkmtQHBVcwJ3iMiUw80vPj18jej20+KgNnsoIs+79TqIGTnrQEdPs0uv2tcbeXjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CrrIjEMeFlyyfuh/1wEdYrcV5f+QqWOlyhlp3sNoFeU=;
	b=mNoMEGDricb5eg6p+KFJAOISHgSi2ZZFZqYUHyUvrzM3Y1fqkjc9kfD91ZA3D9E9WFgk
	 IkbvNVZKuYrRvypf5KrjHVzOYxAy/ibQ37nDZ49R+BofYxjPauw85YbfpKDZCSCNuhYy6
	 9COkY1eaK6JfWV+DpS9YSL8omndC8mVGYle+ac4LEMXSh+Pn0/1Uew4E4xgktrHLheRxk
	 c3NkuTJ7yC5ohbfaQG8nW/94F7W7luGRaHCzF5Gvp+EdYyatppxu1AxpSx9RLyO3VlVSS
	 EvJn9kbnQCRkTih/TizFs0dRDSWWFvdhhCoCXRo4qUE2sE291Lh0Nj1WrOJCily/pvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m2Sb0HtE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96FF606A321;
	Wed, 28 Oct 2026 17:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m2Sb0HtE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1BA1F01825;
	Wed, 28 Oct 2026 17:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209531;
	bh=CrrIjEMeFlyyfuh/1wEdYrcV5f+QqWOlyhlp3sNoFeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2Sb0HtEnbtL1cUA554o7u9iHauLj7AMdLEDWwTa2lQk0470XXGTMPtFdVlt3G2T3
	 JIXh2PmuRs/nzFx0NL5xb2apktca84kXsgYI2d6jBgjPtXTD1UpmqT1tjyrNQODlD9
	 y2EyP441IKA19Lx68m/FlfUvgaTUvq2Y/YsT00hQ=
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
Subject: [PATCH 5.10 503/516] net_sched: codel: fix stale state for empty flows in fq_codel
Date: Wed, 28 Oct 2026 18:00:55 +0100
Message-ID: <20261028170015.393728573@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



