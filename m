Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43782F8EB5;
	Sat, 30 May 2026 16:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159223; cv=none; b=YS7hlO6BoxIICf9VpTPxTuZiFAzRWOCkJWiseqhZohHxd6k/Ntzmf/UfaJ+ATwXJ9NVPNEJm5u5Em0Zkv6MJKbVN5mU1626baKeDfZJW4PifSCfi0hGlraIBHG6svcT2gKupwo4n8NLHmwn7MjJXb7gDXJKSMMiCwjCVkC2JutY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159223; c=relaxed/simple;
	bh=tbLLDzcH4iZWiKr7WwcyI8gKyYcIp9u/DvO1rf1TJ7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOXJ+PE2EfQBJ7Mp9Fcwu+ZG5RUKufhb1Ghh5f9/oCow/5B2dfMNyGmy3aDv8Sg3zNnrtxj7GcqHImvJF7ol6a8M33TAfKaqVkWpSz6Z6IiZj5empM/3FNYCXU/kWmiMrUB2Xk1eB4VHQqdBP6R1nybrZhTBewCjPrdxLs3crHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCjpo4hx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCjpo4hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AA61F00893;
	Sat, 30 May 2026 16:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159222;
	bh=zOAfvMZN/xvD8QKSTQLhy2ZzAlUVcHhPPVkTMYkwTMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCjpo4hx7mMlkqrZKipihy9yn1jnA9YvoYQ+65s63IpDlnM+ohbm3rclo63J0ThZD
	 xlqcE2pjS9D+DqTCm8fm4dYiFkrwxgvy3xOabN3fVfN/AaPG4IZanvgj7yGqrfBnHE
	 6WMld380H2NBsY7ogxI+xPC0MOp0UeVAXBR1v1pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/969] Revert "net: ethernet: xscale: Check for PTP support properly"
Date: Sat, 30 May 2026 17:53:54 +0200
Message-ID: <20260530160303.351568961@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

This reverts commit 5195b10c34b8993194ad12ad7d8f54d861be084b.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 5 ++++-
 drivers/net/ethernet/xscale/ptp_ixp46x.c | 3 ---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index aa6d30dd35c38..a5e03e66cfd38 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -395,12 +395,15 @@ static int ixp4xx_hwtstamp_set(struct net_device *netdev,
 	int ret;
 	int ch;
 
+	if (!cpu_is_ixp46x())
+		return -EOPNOTSUPP;
+
 	if (!netif_running(netdev))
 		return -EINVAL;
 
 	ret = ixp46x_ptp_find(&port->timesync_regs, &port->phc_index);
 	if (ret)
-		return -EOPNOTSUPP;
+		return ret;
 
 	ch = PORT2CHANNEL(port);
 	regs = port->timesync_regs;
diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index b8953745a9f2e..9abbdb71e629f 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -243,9 +243,6 @@ static struct ixp_clock ixp_clock;
 
 int ixp46x_ptp_find(struct ixp46x_ts_regs *__iomem *regs, int *phc_index)
 {
-	if (!cpu_is_ixp46x())
-		return -ENODEV;
-
 	*regs = ixp_clock.regs;
 	*phc_index = ptp_clock_index(ixp_clock.ptp_clock);
 
-- 
2.53.0



