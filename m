Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FF053365;
	Thu, 12 Dec 2024 16:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021513; cv=none; b=YNAcsZIhlpjsqVxn7+9WVl39EflySJzFKSmjCYzyYwBxhVzjhFrX9J46t+XkZQQt+ZOQJv01EtqYI7kYukF+JG/6BemTlnZYELECCv8R2H/b/Ctxabyshq8RlFx1NItu+cb/quVOUI8q2NsH5wE/1AnbI0du+VC3xB2aJOoGY9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021513; c=relaxed/simple;
	bh=wiY/Hhr+VoK1MBNtqglqPd5/z/44OxtaqIFs0v+wr7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkJodDodEZykgDY0v1fIrUhNSwj04LuTD8f5chs6YO2LX0nQWNWq1iTG7pWAmHwLP9GeLxZ2auGU0HT53UOxTEcyYfBgDMrZJa6QumXMhIZaMttm6MpHrqasG0Skv4sw8KJYuJp1VivpvKC1h3J4S/l/VFr1kUWkuhR62wULveU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vF2Gk2f+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vF2Gk2f+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84ED1C4CECE;
	Thu, 12 Dec 2024 16:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021512;
	bh=wiY/Hhr+VoK1MBNtqglqPd5/z/44OxtaqIFs0v+wr7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vF2Gk2f+kzZ6Q2IwnyIiYg7gV2HIwBkztYFwNK9m2/3U5AvtEySU7v0p9qTV+1tgv
	 cXJTB2iQATJM8oODLOEFBmyVf+JqSKuXj7hclvmGh+2HSXry5Rahh0Up4kyTE/JbNR
	 XURgTPtaVxBOQPk/7kTspUHV3bfbP/1uAvMaIBio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youlun Zhang <zhangyoulun@bytedance.com>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH 6.1 759/772] bpf: Fix devs rx stats for bpf_redirect_peer traffic
Date: Thu, 12 Dec 2024 16:01:44 +0100
Message-ID: <20241212144421.302712850@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c    |    8 ++++++++
 net/core/filter.c |    1 +
 2 files changed, 9 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9995,6 +9995,14 @@ static int netdev_do_alloc_pcpu_stats(st
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
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2491,6 +2491,7 @@ int skb_do_redirect(struct sk_buff *skb)
 			     net_eq(net, dev_net(dev))))
 			goto out_drop;
 		skb->dev = dev;
+		dev_sw_netstats_rx_add(dev, skb->len);
 		return -EAGAIN;
 	}
 	return flags & BPF_F_NEIGH ?


