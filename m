Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4193D151988;
	Wed,  5 Feb 2025 14:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766032; cv=none; b=sRkbbjAykVTvYwM8iEkew3RxrdoyHOOiNCmw83BuiNe3vrpLhrp3xINutvgtvYKToLNRW2modklUdD7LyqgwHinAz5WWz8SPhAyYssQWcL2ETYpngJwC9C85WVEcZ3ldmF4r8cVwgEBAjnr4FqsuGxaqzFr1Gibd/uCN6BZQ9fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766032; c=relaxed/simple;
	bh=l8w4JU8r6TrRXkczLp7KfW7LKD1cJ89F2bgBwIzd3UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmy2mtDs6oCSz0+rMPos3J5Sp4Zug8mTu0cIRP2w8EWorvQ827iFqkdrvFAGXFa4Q1JILkgk3tdCvgWDQTJk9wWK18DMdx7eDsSi6b9OaVJd/9IeMdnXfKFhYI3rxpU0zyLhsT4ZnQ3yUaWoizBloZOKMS/Og+zLBs4tMUsBows=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHuNRI3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHuNRI3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45094C4CED1;
	Wed,  5 Feb 2025 14:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766031;
	bh=l8w4JU8r6TrRXkczLp7KfW7LKD1cJ89F2bgBwIzd3UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHuNRI3rrimNkSj2E+SYv5mANFKnhvj7CiZfFWB09xYiSW2KcDh62TKoO4axaO2A+
	 yYu/yADQadzbqLSLTq0FRekHwYVU4Vjlwl3oSHl/fv5fHb4LbID7Uh5ol7O+aDH4eK
	 sgIo3rYRaQv2VzaC2g67u1jvOkIH8VZ54Pa3rI1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinas Rasheed <srasheed@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 236/623] octeon_ep_vf: remove firmware stats fetch in ndo_get_stats64
Date: Wed,  5 Feb 2025 14:39:38 +0100
Message-ID: <20250205134505.254981567@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shinas Rasheed <srasheed@marvell.com>

[ Upstream commit cc0e510cc89fe0a6479203bc20cd964962dc6a43 ]

The firmware stats fetch call that happens in ndo_get_stats64()
is currently not required, and causes a warning to issue.

The corresponding warn log for the PF is given below:

[  123.316837] ------------[ cut here ]------------
[  123.316840] Voluntary context switch within RCU read-side critical section!
[  123.316917] pc : rcu_note_context_switch+0x2e4/0x300
[  123.316919] lr : rcu_note_context_switch+0x2e4/0x300
[  123.316947] Call trace:
[  123.316949]  rcu_note_context_switch+0x2e4/0x300
[  123.316952]  __schedule+0x84/0x584
[  123.316955]  schedule+0x38/0x90
[  123.316956]  schedule_timeout+0xa0/0x1d4
[  123.316959]  octep_send_mbox_req+0x190/0x230 [octeon_ep]
[  123.316966]  octep_ctrl_net_get_if_stats+0x78/0x100 [octeon_ep]
[  123.316970]  octep_get_stats64+0xd4/0xf0 [octeon_ep]
[  123.316975]  dev_get_stats+0x4c/0x114
[  123.316977]  dev_seq_printf_stats+0x3c/0x11c
[  123.316980]  dev_seq_show+0x1c/0x40
[  123.316982]  seq_read_iter+0x3cc/0x4e0
[  123.316985]  seq_read+0xc8/0x110
[  123.316987]  proc_reg_read+0x9c/0xec
[  123.316990]  vfs_read+0xc8/0x2ec
[  123.316993]  ksys_read+0x70/0x100
[  123.316995]  __arm64_sys_read+0x20/0x30
[  123.316997]  invoke_syscall.constprop.0+0x7c/0xd0
[  123.317000]  do_el0_svc+0xb4/0xd0
[  123.317002]  el0_svc+0xe8/0x1f4
[  123.317005]  el0t_64_sync_handler+0x134/0x150
[  123.317006]  el0t_64_sync+0x17c/0x180
[  123.317008] ---[ end trace 63399811432ab69b ]---

Fixes: c3fad23cdc06 ("octeon_ep_vf: add support for ndo ops")
Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Link: https://patch.msgid.link/20250117094653.2588578-4-srasheed@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
index 7e6771c9cdbba..4c699514fd57a 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
@@ -799,14 +799,6 @@ static void octep_vf_get_stats64(struct net_device *netdev,
 	stats->tx_bytes = tx_bytes;
 	stats->rx_packets = rx_packets;
 	stats->rx_bytes = rx_bytes;
-	if (!octep_vf_get_if_stats(oct)) {
-		stats->multicast = oct->iface_rx_stats.mcast_pkts;
-		stats->rx_errors = oct->iface_rx_stats.err_pkts;
-		stats->rx_dropped = oct->iface_rx_stats.dropped_pkts_fifo_full +
-				    oct->iface_rx_stats.err_pkts;
-		stats->rx_missed_errors = oct->iface_rx_stats.dropped_pkts_fifo_full;
-		stats->tx_dropped = oct->iface_tx_stats.dropped;
-	}
 }
 
 /**
-- 
2.39.5



