Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3198113B2B4;
	Tue, 27 Feb 2024 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043849; cv=none; b=jYvbkpXj1hucwKZKF0LK3/uWZ/0fIWFR7RiOZcUAS6etN5NWfLjXyAa4QAQhoamPPqhvFUxN1kJ9WYTvlc60oyloPVa9taYwR+XY+ycgLwVpUT0NojfRjkpyui7UG1mLFZ8MmntckLZFYeDu8MPFwdzuzhwhFJz52NfW/qQjhIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043849; c=relaxed/simple;
	bh=fy++m6i8iTnIgYoP6VHAr6MRMWI0z1X8OnRIO2ftZZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gipBeZzkK6GKvayuriGcEy/bYGsf9xTViBW+pjNN4Dmi5/evcungKFejmPApBu9dSfcQCkrk3v0woisto7C0Tgl5+8BrLLLDy+BoDhCgzrRqRupVSubcDQRaiL1ygHORv710+eaveXapDr9oLBk/qqbEocRNCSMGhVKoK8QH7Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfbuY4/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfbuY4/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4415C433C7;
	Tue, 27 Feb 2024 14:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043849;
	bh=fy++m6i8iTnIgYoP6VHAr6MRMWI0z1X8OnRIO2ftZZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfbuY4/yoo/Hij6J4Z6pEocXyl1uNnQOQvimoQEqRypEFVILZocmie8PTnJ0pA85h
	 6BchQScrg/LUL7F2pubmDSEHbIEYFh8q7o2z7yx6ddol4IQMFsK9yhm4lm1M6VrXPb
	 sP52ysaR26dfcHRNZrn7NFye6lndHFOmduzo3zwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/84] net: bridge: clear bridges private skb space on xmit
Date: Tue, 27 Feb 2024 14:27:08 +0100
Message-ID: <20240227131554.210832776@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit fd65e5a95d08389444e8591a20538b3edece0e15 ]

We need to clear all of the bridge private skb variables as they can be
stale due to the packet being recirculated through the stack and then
transmitted through the bridge device. Similar memset is already done on
bridge's input. We've seen cases where proxyarp_replied was 1 on routed
multicast packets transmitted through the bridge to ports with neigh
suppress which were getting dropped. Same thing can in theory happen with
the port isolation bit as well.

Fixes: 821f1b21cabb ("bridge: add new BR_NEIGH_SUPPRESS port flag to suppress arp and nd flood")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index f085b1648e66c..501f77f0f480a 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -35,6 +35,8 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	const unsigned char *dest;
 	u16 vid = 0;
 
+	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
+
 	rcu_read_lock();
 	nf_ops = rcu_dereference(nf_br_ops);
 	if (nf_ops && nf_ops->br_dev_xmit_hook(skb)) {
-- 
2.43.0



