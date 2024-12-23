Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A57A2EAE6;
	Mon, 23 Dec 2024 16:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969868; cv=none; b=KfnsCmepELUT97UrOp/9Kk5afMOEz7D/us+TycZsu31EojSmfc6qciMx2Zrg5ibKqMD7x+lEn63qquedWOMlIdnH30dT9ArQj29rb1S/9QI/ithsHuhQBXS8NP4JQ61PvQn2Iu4/0t1XFSK9z9Q3tfSTwMe6g6S0qjXCmdL0nsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969868; c=relaxed/simple;
	bh=akqwb13U9I8prYGuMNvONd7y3erxG+FiOJMLmwkr3nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owipWAIe9rCuhXPAfL3HpusBurc1i2ms/lK4wcGELMSL0M3wY4/9+DvmmCLzQC1AFEao2LGHoCXKByiHnew2rW/5WdC15b+YaJqECcj7ucBonPvMNhqVyniApAyHCo3iWVe8WXtRKy21xasFd/+cnojd69rbHnqqTm8vpfI2JGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rU57DpBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rU57DpBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD878C4CED6;
	Mon, 23 Dec 2024 16:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969868;
	bh=akqwb13U9I8prYGuMNvONd7y3erxG+FiOJMLmwkr3nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rU57DpBdUb9rtgTX2DiCiOtuZWbZ2ZMF66QmmHTWaGiVXBFWSG5IBT99fG3gj7Gym
	 I6hNwTaOLxl8VEL0bA8VMwLOZRG0wJa3p3jHO3CKrNuvUA7IzXP6/C6IK3CHpo2eRd
	 bArh5OUa+TlleHWjcXeVK71Qa2IxAhEJDFwAARbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/160] netdev: fix repeated netlink messages in queue stats
Date: Mon, 23 Dec 2024 16:57:38 +0100
Message-ID: <20241223155410.505947963@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ecc391a541573da46b7ccc188105efedd40aef1b ]

The context is supposed to record the next queue to dump,
not last dumped. If the dump doesn't fit we will restart
from the already-dumped queue, duplicating the message.

Before this fix and with the selftest improvements later
in this series we see:

  # ./run_kselftest.sh -t drivers/net:stats.py
  timeout set to 45
  selftests: drivers/net: stats.py
  KTAP version 1
  1..5
  ok 1 stats.check_pause
  ok 2 stats.check_fec
  ok 3 stats.pkt_byte_sum
  # Check| At /root/ksft-net-drv/drivers/net/./stats.py, line 125, in qstat_by_ifindex:
  # Check|     ksft_eq(len(queues[qtype]), len(set(queues[qtype])),
  # Check failed 45 != 44 repeated queue keys
  # Check| At /root/ksft-net-drv/drivers/net/./stats.py, line 127, in qstat_by_ifindex:
  # Check|     ksft_eq(len(queues[qtype]), max(queues[qtype]) + 1,
  # Check failed 45 != 44 missing queue keys
  # Check| At /root/ksft-net-drv/drivers/net/./stats.py, line 125, in qstat_by_ifindex:
  # Check|     ksft_eq(len(queues[qtype]), len(set(queues[qtype])),
  # Check failed 45 != 44 repeated queue keys
  # Check| At /root/ksft-net-drv/drivers/net/./stats.py, line 127, in qstat_by_ifindex:
  # Check|     ksft_eq(len(queues[qtype]), max(queues[qtype]) + 1,
  # Check failed 45 != 44 missing queue keys
  # Check| At /root/ksft-net-drv/drivers/net/./stats.py, line 125, in qstat_by_ifindex:
  # Check|     ksft_eq(len(queues[qtype]), len(set(queues[qtype])),
  # Check failed 103 != 100 repeated queue keys
  # Check| At /root/ksft-net-drv/drivers/net/./stats.py, line 127, in qstat_by_ifindex:
  # Check|     ksft_eq(len(queues[qtype]), max(queues[qtype]) + 1,
  # Check failed 103 != 100 missing queue keys
  # Check| At /root/ksft-net-drv/drivers/net/./stats.py, line 125, in qstat_by_ifindex:
  # Check|     ksft_eq(len(queues[qtype]), len(set(queues[qtype])),
  # Check failed 102 != 100 repeated queue keys
  # Check| At /root/ksft-net-drv/drivers/net/./stats.py, line 127, in qstat_by_ifindex:
  # Check|     ksft_eq(len(queues[qtype]), max(queues[qtype]) + 1,
  # Check failed 102 != 100 missing queue keys
  not ok 4 stats.qstat_by_ifindex
  ok 5 stats.check_down
  # Totals: pass:4 fail:1 xfail:0 xpass:0 skip:0 error:0

With the fix:

  # ./ksft-net-drv/run_kselftest.sh -t drivers/net:stats.py
  timeout set to 45
  selftests: drivers/net: stats.py
  KTAP version 1
  1..5
  ok 1 stats.check_pause
  ok 2 stats.check_fec
  ok 3 stats.pkt_byte_sum
  ok 4 stats.qstat_by_ifindex
  ok 5 stats.check_down
  # Totals: pass:5 fail:0 xfail:0 xpass:0 skip:0 error:0

Fixes: ab63a2387cb9 ("netdev: add per-queue statistics")
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20241213152244.3080955-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 71359922ae8b..224d1b5b79a7 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -597,7 +597,7 @@ netdev_nl_stats_by_queue(struct net_device *netdev, struct sk_buff *rsp,
 					    i, info);
 		if (err)
 			return err;
-		ctx->rxq_idx = i++;
+		ctx->rxq_idx = ++i;
 	}
 	i = ctx->txq_idx;
 	while (ops->get_queue_stats_tx && i < netdev->real_num_tx_queues) {
@@ -605,7 +605,7 @@ netdev_nl_stats_by_queue(struct net_device *netdev, struct sk_buff *rsp,
 					    i, info);
 		if (err)
 			return err;
-		ctx->txq_idx = i++;
+		ctx->txq_idx = ++i;
 	}
 
 	ctx->rxq_idx = 0;
-- 
2.39.5



