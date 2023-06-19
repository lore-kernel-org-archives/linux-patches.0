Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448F73C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6E1C433C8;
	Mon, 19 Jun 2023 10:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171108;
	bh=qKZvR1QW2YGF0iN2U3D93JBb0Bqy7ty4VII+Uhz/8bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jX8xA88NS3nohXs1dUzBTxeh1xw9Up7X2n2OI31oLPNFlmg+lP1A0RzEzENTMCZjo
	 xaZKHUIY8pC7ylBCbSq253/selK41npdNE7hQZ6EJUNsTEd+/gGdw5wpnjQsO9EXhd
	 TaRm1X5nqqQx8v+RTNudUJrZTMFKEn65waJ4q3ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhen Luan <eggcar.luan@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.3 125/187] igb: Fix extts capture value format for 82580/i354/i350
Date: Mon, 19 Jun 2023 12:29:03 +0200
Message-ID: <20230619102203.587661743@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuezhen Luan <eggcar.luan@gmail.com>

[ Upstream commit 6292d7436cf2f0a2ea8800a1d2cbb155d237818a ]

82580/i354/i350 features circle-counter-like timestamp registers
that are different with newer i210. The EXTTS capture value in
AUXTSMPx should be converted from raw circle counter value to
timestamp value in resolution of 1 nanosec by the driver.

This issue can be reproduced on i350 nics, connecting an 1PPS
signal to a SDP pin, and run 'ts2phc' command to read external
1PPS timestamp value. On i210 this works fine, but on i350 the
extts is not correctly converted.

The i350/i354/82580's SYSTIM and other timestamp registers are
40bit counters, presenting time range of 2^40 ns, that means these
registers overflows every about 1099s. This causes all these regs
can't be used directly in contrast to the newer i210/i211s.

The igb driver needs to convert these raw register values to
valid time stamp format by using kernel timecounter apis for i350s
families. Here the igb_extts() just forgot to do the convert.

Fixes: 38970eac41db ("igb: support EXTTS on 82580/i354/i350")
Signed-off-by: Yuezhen Luan <eggcar.luan@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230607164116.3768175-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 274c781b55473..f2f9f81c123b8 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6948,6 +6948,7 @@ static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
 	struct e1000_hw *hw = &adapter->hw;
 	struct ptp_clock_event event;
 	struct timespec64 ts;
+	unsigned long flags;
 
 	if (pin < 0 || pin >= IGB_N_SDP)
 		return;
@@ -6955,9 +6956,12 @@ static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
 	if (hw->mac.type == e1000_82580 ||
 	    hw->mac.type == e1000_i354 ||
 	    hw->mac.type == e1000_i350) {
-		s64 ns = rd32(auxstmpl);
+		u64 ns = rd32(auxstmpl);
 
-		ns += ((s64)(rd32(auxstmph) & 0xFF)) << 32;
+		ns += ((u64)(rd32(auxstmph) & 0xFF)) << 32;
+		spin_lock_irqsave(&adapter->tmreg_lock, flags);
+		ns = timecounter_cyc2time(&adapter->tc, ns);
+		spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 		ts = ns_to_timespec64(ns);
 	} else {
 		ts.tv_nsec = rd32(auxstmpl);
-- 
2.39.2



