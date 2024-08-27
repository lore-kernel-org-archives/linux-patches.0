Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2121D1C5793;
	Tue, 27 Aug 2024 15:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771998; cv=none; b=cES31mBYw3sxFRUBoPYyMBgIX1ioDQigSvEBKgeWBKjdM1j2xdwVmRENJ0Al44ouh7n8ZXP2+fzgdD0q9y2OX6mhHNeTwTBX5xyhlWTUGi6wy9nUurfJGQ78pmHNyXF/+j0qRD83AjT/zGY4s/T/AwSuLel4+5Nrm4Ol1RePxsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771998; c=relaxed/simple;
	bh=CT1ux54aaa4gp00PTf1A81MQbupNoleKrP1dbJ1tU/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3KmGWaZaQ7E2Fy5LLrtFCZWQ7gK2t18/KEpc+Sz8Ki8wnWF9lvvGm+AwgMoo94F9O/QChehNaFzBmKxID5tNqzQotruBowNyruTdJA36lMsGaVMFyVJWLn/rJIM3VY+0nlfVWj0a5EC6igeiySc6P+QO8BJUhW4pKgusTaStwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpaD47XI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpaD47XI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA22C4DDE5;
	Tue, 27 Aug 2024 15:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771996;
	bh=CT1ux54aaa4gp00PTf1A81MQbupNoleKrP1dbJ1tU/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpaD47XIW/nSv+M5keYS5Kmp1styO4rx7aguE8ZQttLAiSJ2qJN6+8PfVJirEIuHU
	 EyFx/B3S7dqV2ao9hZ+XN0Fq+tnzZ1PY/6YHLB3KN8IpqSXIu7ZBbSAx342DH9TG4t
	 SYtAti6pw6uwyYwVpJxVZ49EKyfCDLbr3cefqVg8=
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
Subject: [PATCH 6.1 083/321] igc: Correct the launchtime offset
Date: Tue, 27 Aug 2024 16:36:31 +0200
Message-ID: <20240827143841.401161408@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index efdabcbd66ddd..63fa7608861b2 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -402,6 +402,15 @@
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
index e052f49cc08d7..39f8f28288aaa 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5586,6 +5586,13 @@ static void igc_watchdog_task(struct work_struct *work)
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
index c0d8214148d1d..01c86d36856d2 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -224,6 +224,7 @@
 /* Transmit Scheduling Registers */
 #define IGC_TQAVCTRL		0x3570
 #define IGC_TXQCTL(_n)		(0x3344 + 0x4 * (_n))
+#define IGC_GTXOFFSET		0x3310
 #define IGC_BASET_L		0x3314
 #define IGC_BASET_H		0x3318
 #define IGC_QBVCYCLET		0x331C
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 31ea0781b65ec..83f02b00735d3 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -49,6 +49,35 @@ static unsigned int igc_tsn_new_flags(struct igc_adapter *adapter)
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
@@ -58,6 +87,7 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
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



