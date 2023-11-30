Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9C3524C2;
	Thu, 30 Nov 2023 16:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3Oj5zBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4DBC433C7;
	Thu, 30 Nov 2023 16:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361518;
	bh=0zivWa7QqOBdwUNEoylSVCsOK/c/tasWvZTROKCi8pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3Oj5zBpwCfjTWYg/wt1xQR08y3rvztfneWmm9VFA7iW4iFPH0MjkBzEs5dikuvxt
	 OmrHM7rWYj6GpA3P4Q8e/Sbq4uLvEI3lngZvD0KWKWmqBPAlx3Ec223eK+8gXG0xBD
	 PJPLv/LMT8uz1zO7CcTsX4+jt6yJfrd9waaA2W/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youlun Zhang <zhangyoulun@bytedance.com>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/112] bpf: Fix devs rx stats for bpf_redirect_peer traffic
Date: Thu, 30 Nov 2023 16:21:17 +0000
Message-ID: <20231130162141.272536055@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peilin Ye <peilin.ye@bytedance.com>

[ Upstream commit 024ee930cb3c9ae49e4266aee89cfde0ebb407e1 ]

Traffic redirected by bpf_redirect_peer() (used by recent CNIs like Cilium)
is not accounted for in the RX stats of supported devices (that is, veth
and netkit), confusing user space metrics collectors such as cAdvisor [0],
as reported by Youlun.

Fix it by calling dev_sw_netstats_rx_add() in skb_do_redirect(), to update
RX traffic counters. Devices that support ndo_get_peer_dev _must_ use the
@tstats per-CPU counters (instead of @lstats, or @dstats).

To make this more fool-proof, error out when ndo_get_peer_dev is set but
@tstats are not selected.

  [0] Specifically, the "container_network_receive_{byte,packet}s_total"
      counters are affected.

Fixes: 9aa1206e8f48 ("bpf: Add redirect_peer helper")
Reported-by: Youlun Zhang <zhangyoulun@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Co-developed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20231114004220.6495-6-daniel@iogearbox.net
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c    | 8 ++++++++
 net/core/filter.c | 1 +
 2 files changed, 9 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 37444c8e22054..9bf90b2a75b6a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10054,6 +10054,14 @@ static int netdev_do_alloc_pcpu_stats(struct net_device *dev)
 {
 	void __percpu *v;
 
+	/* Drivers implementing ndo_get_peer_dev must support tstat
+	 * accounting, so that skb_do_redirect() can bump the dev's
+	 * RX stats upon network namespace switch.
+	 */
+	if (dev->netdev_ops->ndo_get_peer_dev &&
+	    dev->pcpu_stat_type != NETDEV_PCPU_STAT_TSTATS)
+		return -EOPNOTSUPP;
+
 	switch (dev->pcpu_stat_type) {
 	case NETDEV_PCPU_STAT_NONE:
 		return 0;
diff --git a/net/core/filter.c b/net/core/filter.c
index a094694899c99..b149a165c405c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2489,6 +2489,7 @@ int skb_do_redirect(struct sk_buff *skb)
 			     net_eq(net, dev_net(dev))))
 			goto out_drop;
 		skb->dev = dev;
+		dev_sw_netstats_rx_add(dev, skb->len);
 		return -EAGAIN;
 	}
 	return flags & BPF_F_NEIGH ?
-- 
2.42.0



