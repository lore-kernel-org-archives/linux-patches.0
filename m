Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC5819F471;
	Thu, 15 Aug 2024 14:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730898; cv=none; b=kdCrxuxNaybWcK+Ey1Xw8t1usRRoihpy0y7g/q9cdIjPMApz1RdvBLIpaaB1QYEeKf87F8xnBjISF9NPnN99ujYdd4FpOdiGInOseIX32bFtC15V7IrCpj87udYAkioV7sEaNNxp4dXiXz/ZhsHwWmvcdUGLgKVVyKxao+an25Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730898; c=relaxed/simple;
	bh=lZQjNiQumkwsFl+y6zwUYx8p6LPO/2dTzGSqfua7OSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXh45P2bnova6jnAnQ/CJv+DkjchpfFcb0pcBa/cMV9U3HGn6l6kO4bvDfLQYd39l8xTc+PW486JqkLLIpf0gdMdTvHHwESP/BsNlSWOf3dNVuWZOg4XblsAqWBOYiIJbpdMmhNPRya62IP6IlBVv4f+5bIvEZyCmNVWrg88pCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7b8B0jd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7b8B0jd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0834C32786;
	Thu, 15 Aug 2024 14:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730898;
	bh=lZQjNiQumkwsFl+y6zwUYx8p6LPO/2dTzGSqfua7OSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7b8B0jdaWCO2D7fh68ECQ6diQOpMF4a1GM6DsHMd1DaHpgwiZq6gd0BbBM950Y0a
	 OBbSP/xvz1mvV+ZYccxhdG3sFq0ymT1pHMD66prwqJr2SrDLp3TOwSTuzQ16vzIoBk
	 L0hQ2XWuplCRKtgRYpxhxJuoLhDFvUax61E/7oLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d55372214aff0faa1f1f@syzkaller.appspotmail.com,
	Jiri Pirko <jiri@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 28/67] net: dont dump stack on queue timeout
Date: Thu, 15 Aug 2024 15:25:42 +0200
Message-ID: <20240815131839.409524345@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e316dd1cf1358ff9c44b37c7be273a7dc4349986 ]

The top syzbot report for networking (#14 for the entire kernel)
is the queue timeout splat. We kept it around for a long time,
because in real life it provides pretty strong signal that
something is wrong with the driver or the device.

Removing it is also likely to break monitoring for those who
track it as a kernel warning.

Nevertheless, WARN()ings are best suited for catching kernel
programming bugs. If a Tx queue gets starved due to a pause
storm, priority configuration, or other weirdness - that's
obviously a problem, but not a problem we can fix at
the kernel level.

Bite the bullet and convert the WARN() to a print.

Before:

  NETDEV WATCHDOG: eni1np1 (netdevsim): transmit queue 0 timed out 1975 ms
  WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:525 dev_watchdog+0x39e/0x3b0
  [... completely pointless stack trace of a timer follows ...]

Now:

  netdevsim netdevsim1 eni1np1: NETDEV WATCHDOG: CPU: 0: transmit queue 0 timed out 1769 ms

Alternatively we could mark the drivers which syzbot has
learned to abuse as "print-instead-of-WARN" selectively.

Reported-by: syzbot+d55372214aff0faa1f1f@syzkaller.appspotmail.com
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 4023c955036b1..6ab9359c1706f 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -522,8 +522,9 @@ static void dev_watchdog(struct timer_list *t)
 
 			if (unlikely(timedout_ms)) {
 				trace_net_dev_xmit_timeout(dev, i);
-				WARN_ONCE(1, "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out %u ms\n",
-					  dev->name, netdev_drivername(dev), i, timedout_ms);
+				netdev_crit(dev, "NETDEV WATCHDOG: CPU: %d: transmit queue %u timed out %u ms\n",
+					    raw_smp_processor_id(),
+					    i, timedout_ms);
 				netif_freeze_queues(dev);
 				dev->netdev_ops->ndo_tx_timeout(dev, i);
 				netif_unfreeze_queues(dev);
-- 
2.43.0



