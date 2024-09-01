Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BB4208A7;
	Sun,  1 Sep 2024 16:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209893; cv=none; b=Gf20NVjKfKZtxmzinkGqoHUd5oVcRznQccwwCo9sPi7Z6tnSpwlSvV4x3HFmEA8UkJrxc/ieTuUtYRjcdFPhOKOvyE4PNH8R2vxRJxma1ZpNNAQsh5xJBypfvKm5VWj1C6krnPF6TqldgTXjAXpcFkuC1oIN5HW5uqlGCrfIGqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209893; c=relaxed/simple;
	bh=h7J++ftOOIXkcrgJ2n7exue1NwEMKne86CI+XexG/Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlQukWO/1j19YZjNnMesAnyqwhFyymdobjlO/QkrD74Oi/gQHY2BSTPcyNa4zPr6rzRC4qXn3dRkAbVbbAZS1kfgCBRiP74+qgQqrESL8nWXUouDai9MPLJK9HYgvqsK61/tK7i00KgD7NLan4iPfuy/uGvI7QUOX+6dKuBV7xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8g6gLTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8g6gLTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9286C4CEC3;
	Sun,  1 Sep 2024 16:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209893;
	bh=h7J++ftOOIXkcrgJ2n7exue1NwEMKne86CI+XexG/Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8g6gLTT3czihfmS7roZRNa4zcsbV3ih8yU4tKjqdsXn10bSGcrDIYInueLdCnqt3
	 p3tGpuK+qgMi3NGs8wURI5PHhEHMQBW3PvLSZnh84U8QvEkRS3UsdajAqba60eH9jC
	 PJoqoy12L0LYEa8uRZ+UHyfRAhP/104KTZ4gGalY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Sasha Neftin <sasha.neftin@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/215] igc: Correct the launchtime offset
Date: Sun,  1 Sep 2024 18:15:37 +0200
Message-ID: <20240901160824.213241899@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

[ Upstream commit 790835fcc0cb9992349ae3c9010dbc7321aaa24d ]

The launchtime offset should be corrected according to sections 7.5.2.6
Transmit Scheduling Latency of the Intel Ethernet I225/I226 Software
User Manual.

Software can compensate the latency between the transmission scheduling
and the time that packet is transmitted to the network by setting this
GTxOffset register. Without setting this register, there may be a
significant delay between the packet scheduling and the network point.

This patch helps to reduce the latency for each of the link speed.

Before:

10Mbps   : 11000 - 13800 nanosecond
100Mbps  : 1300 - 1700 nanosecond
1000Mbps : 190 - 600 nanosecond
2500Mbps : 1400 - 1700 nanosecond

After:

10Mbps   : less than 750 nanosecond
100Mbps  : less than 192 nanosecond
1000Mbps : less than 128 nanosecond
2500Mbps : less than 128 nanosecond

Test Setup:

Talker : Use l2_tai.c to generate the launchtime into packet payload.
Listener: Use timedump.c to compute the delta between packet arrival and
LaunchTime packet payload.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: e037a26ead18 ("igc: Fix packet still tx after gate close by reducing i226 MAC retry buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |  9 ++++++
 drivers/net/ethernet/intel/igc/igc_main.c    |  7 +++++
 drivers/net/ethernet/intel/igc/igc_regs.h    |  1 +
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 30 ++++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_tsn.h     |  1 +
 5 files changed, 48 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 703b62c5f79b5..95282dde6b8bc 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -405,6 +405,15 @@
 #define IGC_DTXMXPKTSZ_TSN	0x19 /* 1600 bytes of max TX DMA packet size */
 #define IGC_DTXMXPKTSZ_DEFAULT	0x98 /* 9728-byte Jumbo frames */
 
+/* Transmit Scheduling Latency */
+/* Latency between transmission scheduling (LaunchTime) and the time
+ * the packet is transmitted to the network in nanosecond.
+ */
+#define IGC_TXOFFSET_SPEED_10	0x000034BC
+#define IGC_TXOFFSET_SPEED_100	0x00000578
+#define IGC_TXOFFSET_SPEED_1000	0x0000012C
+#define IGC_TXOFFSET_SPEED_2500	0x00000578
+
 /* Time Sync Interrupt Causes */
 #define IGC_TSICR_SYS_WRAP	BIT(0) /* SYSTIM Wrap around. */
 #define IGC_TSICR_TXTS		BIT(1) /* Transmit Timestamp. */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6185566fbb98c..eb8c24318fdac 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5532,6 +5532,13 @@ static void igc_watchdog_task(struct work_struct *work)
 				break;
 			}
 
+			/* Once the launch time has been set on the wire, there
+			 * is a delay before the link speed can be determined
+			 * based on link-up activity. Write into the register
+			 * as soon as we know the correct link speed.
+			 */
+			igc_tsn_adjust_txtime_offset(adapter);
+
 			if (adapter->link_speed != SPEED_1000)
 				goto no_wait;
 
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 026c3b65fc37a..0e9c1298f36fe 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -227,6 +227,7 @@
 /* Transmit Scheduling Registers */
 #define IGC_TQAVCTRL		0x3570
 #define IGC_TXQCTL(_n)		(0x3344 + 0x4 * (_n))
+#define IGC_GTXOFFSET		0x3310
 #define IGC_BASET_L		0x3314
 #define IGC_BASET_H		0x3318
 #define IGC_QBVCYCLET		0x331C
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 2330b1ff915e7..93518c785c7d2 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -48,6 +48,35 @@ static unsigned int igc_tsn_new_flags(struct igc_adapter *adapter)
 	return new_flags;
 }
 
+void igc_tsn_adjust_txtime_offset(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u16 txoffset;
+
+	if (!is_any_launchtime(adapter))
+		return;
+
+	switch (adapter->link_speed) {
+	case SPEED_10:
+		txoffset = IGC_TXOFFSET_SPEED_10;
+		break;
+	case SPEED_100:
+		txoffset = IGC_TXOFFSET_SPEED_100;
+		break;
+	case SPEED_1000:
+		txoffset = IGC_TXOFFSET_SPEED_1000;
+		break;
+	case SPEED_2500:
+		txoffset = IGC_TXOFFSET_SPEED_2500;
+		break;
+	default:
+		txoffset = 0;
+		break;
+	}
+
+	wr32(IGC_GTXOFFSET, txoffset);
+}
+
 /* Returns the TSN specific registers to their default values after
  * the adapter is reset.
  */
@@ -57,6 +86,7 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 	u32 tqavctrl;
 	int i;
 
+	wr32(IGC_GTXOFFSET, 0);
 	wr32(IGC_TXPBS, I225_TXPBSIZE_DEFAULT);
 	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_DEFAULT);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.h b/drivers/net/ethernet/intel/igc/igc_tsn.h
index 1512307f5a528..b53e6af560b73 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.h
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.h
@@ -6,5 +6,6 @@
 
 int igc_tsn_offload_apply(struct igc_adapter *adapter);
 int igc_tsn_reset(struct igc_adapter *adapter);
+void igc_tsn_adjust_txtime_offset(struct igc_adapter *adapter);
 
 #endif /* _IGC_BASE_H */
-- 
2.43.0



