Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EE01C1F0A;
	Wed, 20 Nov 2024 12:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107582; cv=none; b=IE0h2NTgu0baGl77tA4Od/hyLBk4JabA3jjm+DBa1FxPE/WpErTfd56Xc0CkXZ1JE44aCcRRQvT4zYZqnD+5T7mCxTC4Z25KRQGpvO6FQce5Ch+vJ7VUXvklf7emYb92kWMvXO/7ELkxMJ+z8xZCKG4mCUjnX1MpKJEPKt5S48E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107582; c=relaxed/simple;
	bh=705Nk1twKF6NKIQBfX/l1OHSCVq65+APFQVYBRJfMO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLEz8F1VMH8XFC4LUHhn7GdrVtQATDy2h9j2Atwq6WFj5Nlww4wtN8b0G2/WlbXJjV6+xh9pWg7jW+ec/P+HGHufiOZ5xVoZrUfzmNwiUSSKN9Zq7n7k6hAEr+Qy5KZyQe49njd45SrMfkPyBi7PXBSHoWWQYovRiMuEM10/Dzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEYSBdbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEYSBdbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F921C4CECD;
	Wed, 20 Nov 2024 12:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107582;
	bh=705Nk1twKF6NKIQBfX/l1OHSCVq65+APFQVYBRJfMO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEYSBdbItm+svjhWIa67Y8GRedMs9LwIWOB+3hjuDa0+4Fjpa1/wNdVYZ3UIzREaU
	 1rZAtP7BM4uPIdHIYBBKd0sbfZ0TP48dQ0nR1x4oH41R3J/9KwaK6dqcZP2K+94dFI
	 9+veqHl1WnMBap9Vl4EZ9GdsxyCqCEj3HxKExnBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	MD Danish Anwar <danishanwar@ti.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 24/82] net: ti: icssg-prueth: Fix 1 PPS sync
Date: Wed, 20 Nov 2024 13:56:34 +0100
Message-ID: <20241120125630.153762392@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit dc065076ee7768377d7c16af7d1b0767782d8c98 ]

The first PPS latch time needs to be calculated by the driver
(in rounded off seconds) and configured as the start time
offset for the cycle. After synchronizing two PTP clocks
running as master/slave, missing this would cause master
and slave to start immediately with some milliseconds
drift which causes the PPS signal to never synchronize with
the PTP master.

Fixes: 186734c15886 ("net: ti: icssg-prueth: add packet timestamping and ptp support")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: MD Danish Anwar <danishanwar@ti.com>
Link: https://patch.msgid.link/20241111095842.478833-1-m-malladi@ti.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_prueth.c | 13 +++++++++++--
 drivers/net/ethernet/ti/icssg/icssg_prueth.h | 12 ++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.c b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
index fb120baee5532..7efb3e347c042 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -15,6 +15,7 @@
 #include <linux/genalloc.h>
 #include <linux/if_vlan.h>
 #include <linux/interrupt.h>
+#include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/kernel.h>
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
@@ -1245,6 +1246,8 @@ static int prueth_perout_enable(void *clockops_data,
 	struct prueth_emac *emac = clockops_data;
 	u32 reduction_factor = 0, offset = 0;
 	struct timespec64 ts;
+	u64 current_cycle;
+	u64 start_offset;
 	u64 ns_period;
 
 	if (!on)
@@ -1283,8 +1286,14 @@ static int prueth_perout_enable(void *clockops_data,
 	writel(reduction_factor, emac->prueth->shram.va +
 		TIMESYNC_FW_WC_SYNCOUT_REDUCTION_FACTOR_OFFSET);
 
-	writel(0, emac->prueth->shram.va +
-		TIMESYNC_FW_WC_SYNCOUT_START_TIME_CYCLECOUNT_OFFSET);
+	current_cycle = icssg_read_time(emac->prueth->shram.va +
+					TIMESYNC_FW_WC_CYCLECOUNT_OFFSET);
+
+	/* Rounding of current_cycle count to next second */
+	start_offset = roundup(current_cycle, MSEC_PER_SEC);
+
+	hi_lo_writeq(start_offset, emac->prueth->shram.va +
+		     TIMESYNC_FW_WC_SYNCOUT_START_TIME_CYCLECOUNT_OFFSET);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.h b/drivers/net/ethernet/ti/icssg/icssg_prueth.h
index 3fe80a8758d30..0713ad7897b68 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.h
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.h
@@ -257,6 +257,18 @@ static inline int prueth_emac_slice(struct prueth_emac *emac)
 
 extern const struct ethtool_ops icssg_ethtool_ops;
 
+static inline u64 icssg_read_time(const void __iomem *addr)
+{
+	u32 low, high;
+
+	do {
+		high = readl(addr + 4);
+		low = readl(addr);
+	} while (high != readl(addr + 4));
+
+	return low + ((u64)high << 32);
+}
+
 /* Classifier helpers */
 void icssg_class_set_mac_addr(struct regmap *miig_rt, int slice, u8 *mac);
 void icssg_class_set_host_mac_addr(struct regmap *miig_rt, const u8 *mac);
-- 
2.43.0



