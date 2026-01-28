Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448D326E6F9;
	Wed, 28 Jan 2026 15:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614374; cv=none; b=rpLwNolbC9VHAMm9byO/t7oeh15yLbjNAaWvLYUhPdm5X/23tpS9lamqI1Z0XXLLjW5qMA5qqkzD5S+RUMnG+5FVk74lngVc/pKF2Aq/dfsA8j7DNbtnetOc2zMY0IDrXlvVwLx5RY42mSqZWHtHMjuQYh2ZpgVY1xDzrqlQnQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614374; c=relaxed/simple;
	bh=qbRmh0BPLcfCCFUJBHTKAtrie46sDZ5+Pk+84FVTngk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1+Mx6SaPqcEmWzzFPH0kmfq4wlJYcrVMuYyk0HVWiy4CyB5K7w15Sci/F2gC7YbBW1Z8/a7ZxJ/Rgr/3s9IKxtOGlY2KatYRon8o48BMvmVPTcDlo1rjwqSpPQMSAnMoYBo8+rQkB57u4rCcoryI09wdSY6V7KKlnx7JP2xf7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvOhenNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvOhenNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B863C116C6;
	Wed, 28 Jan 2026 15:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614373;
	bh=qbRmh0BPLcfCCFUJBHTKAtrie46sDZ5+Pk+84FVTngk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvOhenNwW0edPBaxBS1zMalDlG8GJwIxIvpiqpA6UsjCmJWaBoHMlT6+aJTxhzl8I
	 js1+u6xcnOQEMcwJXCculX3N6Atgm/EUfApSskfSZG67qHGaG72imm+tbI7rFyYin7
	 bpOvaEMQFNNtINDuRG2wA78ygK2ufORpUkmUCeiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Shalev <avi.shalev@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Chwee-Lin Choong <chwee.lin.choong@intel.com>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/254] igc: fix race condition in TX timestamp read for register 0
Date: Wed, 28 Jan 2026 16:21:33 +0100
Message-ID: <20260128145349.034992836@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chwee-Lin Choong <chwee.lin.choong@intel.com>

[ Upstream commit 6990dc392a9ab10e52af37e0bee8c7b753756dc4 ]

The current HW bug workaround checks the TXTT_0 ready bit first,
then reads TXSTMPL_0 twice (before and after reading TXSTMPH_0)
to detect whether a new timestamp was captured by timestamp
register 0 during the workaround.

This sequence has a race: if a new timestamp is captured after
checking the TXTT_0 bit but before the first TXSTMPL_0 read, the
detection fails because both the "old" and "new" values come from
the same timestamp.

Fix by reading TXSTMPL_0 first to establish a baseline, then
checking the TXTT_0 bit. This ensures any timestamp captured
during the race window will be detected.

Old sequence:
  1. Check TXTT_0 ready bit
  2. Read TXSTMPL_0 (baseline)
  3. Read TXSTMPH_0 (interrupt workaround)
  4. Read TXSTMPL_0 (detect changes vs baseline)

New sequence:
  1. Read TXSTMPL_0 (baseline)
  2. Check TXTT_0 ready bit
  3. Read TXSTMPH_0 (interrupt workaround)
  4. Read TXSTMPL_0 (detect changes vs baseline)

Fixes: c789ad7cbebc ("igc: Work around HW bug causing missing timestamps")
Suggested-by: Avi Shalev <avi.shalev@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Co-developed-by: Song Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: Chwee-Lin Choong <chwee.lin.choong@intel.com>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 43 ++++++++++++++----------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index a82af96e6bd12..4c07c1e4aa997 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -758,36 +758,43 @@ static void igc_ptp_tx_reg_to_stamp(struct igc_adapter *adapter,
 static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
+	u32 txstmpl_old;
 	u64 regval;
 	u32 mask;
 	int i;
 
+	/* Establish baseline of TXSTMPL_0 before checking TXTT_0.
+	 * This baseline is used to detect if a new timestamp arrives in
+	 * register 0 during the hardware bug workaround below.
+	 */
+	txstmpl_old = rd32(IGC_TXSTMPL);
+
 	mask = rd32(IGC_TSYNCTXCTL) & IGC_TSYNCTXCTL_TXTT_ANY;
 	if (mask & IGC_TSYNCTXCTL_TXTT_0) {
 		regval = rd32(IGC_TXSTMPL);
 		regval |= (u64)rd32(IGC_TXSTMPH) << 32;
 	} else {
-		/* There's a bug in the hardware that could cause
-		 * missing interrupts for TX timestamping. The issue
-		 * is that for new interrupts to be triggered, the
-		 * IGC_TXSTMPH_0 register must be read.
+		/* TXTT_0 not set - register 0 has no new timestamp initially.
+		 *
+		 * Hardware bug: Future timestamp interrupts won't fire unless
+		 * TXSTMPH_0 is read, even if the timestamp was captured in
+		 * registers 1-3.
 		 *
-		 * To avoid discarding a valid timestamp that just
-		 * happened at the "wrong" time, we need to confirm
-		 * that there was no timestamp captured, we do that by
-		 * assuming that no two timestamps in sequence have
-		 * the same nanosecond value.
+		 * Workaround: Read TXSTMPH_0 here to enable future interrupts.
+		 * However, this read clears TXTT_0. If a timestamp arrives in
+		 * register 0 after checking TXTT_0 but before this read, it
+		 * would be lost.
 		 *
-		 * So, we read the "low" register, read the "high"
-		 * register (to latch a new timestamp) and read the
-		 * "low" register again, if "old" and "new" versions
-		 * of the "low" register are different, a valid
-		 * timestamp was captured, we can read the "high"
-		 * register again.
+		 * To detect this race: We saved a baseline read of TXSTMPL_0
+		 * before TXTT_0 check. After performing the workaround read of
+		 * TXSTMPH_0, we read TXSTMPL_0 again. Since consecutive
+		 * timestamps never share the same nanosecond value, a change
+		 * between the baseline and new TXSTMPL_0 indicates a timestamp
+		 * arrived during the race window. If so, read the complete
+		 * timestamp.
 		 */
-		u32 txstmpl_old, txstmpl_new;
+		u32 txstmpl_new;
 
-		txstmpl_old = rd32(IGC_TXSTMPL);
 		rd32(IGC_TXSTMPH);
 		txstmpl_new = rd32(IGC_TXSTMPL);
 
@@ -802,7 +809,7 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
 
 done:
 	/* Now that the problematic first register was handled, we can
-	 * use retrieve the timestamps from the other registers
+	 * retrieve the timestamps from the other registers
 	 * (starting from '1') with less complications.
 	 */
 	for (i = 1; i < IGC_MAX_TX_TSTAMP_REGS; i++) {
-- 
2.51.0



