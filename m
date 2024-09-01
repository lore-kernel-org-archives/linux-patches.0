Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA901DFD1;
	Sun,  1 Sep 2024 17:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210547; cv=none; b=qi4UGaS/KOqxS9hE/skB30EpC/HTU/kfq5JRd9IgEi5VVoB4ED8bayDcDpTbbW4uoxmcAJ6nmgvq4ufytfxkmOZWYahTYkn3u91MoMnlLBmoZZNFLy064lN73w/5hEj7VKUWp2SaCiD2xxDxbAYprIhqvsdZiWqiZjAbWHjv1f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210547; c=relaxed/simple;
	bh=47tP9u89Kf557zVPEZNbK6AV9ATFJPAaOqIjA+/tI0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2GbOWAutLLqaAHQO8zmLQ1cxxLciL1CSTeCabo33J+2vouCH15hnWoN+8oeoFWEbm95SaMPA8I9hghZk1bhUZl4g/QVhW1l686/A7D5OLu3nYr8CGhhXhlWXhs8IA7rsW6LlPpY51+4EwOsNVl93rTWnwdovzRusf3Fio2vYlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQLjA47d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQLjA47d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C2CC4CEC3;
	Sun,  1 Sep 2024 17:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210547;
	bh=47tP9u89Kf557zVPEZNbK6AV9ATFJPAaOqIjA+/tI0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQLjA47dP691DCn2c0AtDrV5G15CxD8sxbID/+WwtHjbq/vsOydULw3dgvaTfz6xJ
	 soYILS56AUG8HCHheCFdY1AVgrhVb5KXlvnLXvz/ZsQuQ805aj80FtHT46e/ajRGVF
	 IT38yOOrXE8K7DHFYjkOjTe4TqRhwMommlaimJh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faizal Rahim <faizal.abdul.rahim@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 212/215] igc: Fix reset adapter logics when tx mode change
Date: Sun,  1 Sep 2024 18:18:44 +0200
Message-ID: <20240901160831.365002759@linuxfoundation.org>
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

From: Faizal Rahim <faizal.abdul.rahim@linux.intel.com>

commit 0afeaeb5dae86aceded0d5f0c3a54d27858c0c6f upstream.

Following the "igc: Fix TX Hang issue when QBV Gate is close" changes,
remaining issues with the reset adapter logic in igc_tsn_offload_apply()
have been observed:

1. The reset adapter logics for i225 and i226 differ, although they should
   be the same according to the guidelines in I225/6 HW Design Section
   7.5.2.1 on software initialization during tx mode changes.
2. The i225 resets adapter every time, even though tx mode doesn't change.
   This occurs solely based on the condition  igc_is_device_id_i225() when
   calling schedule_work().
3. i226 doesn't reset adapter for tsn->legacy tx mode changes. It only
   resets adapter for legacy->tsn tx mode transitions.
4. qbv_count introduced in the patch is actually not needed; in this
   context, a non-zero value of qbv_count is used to indicate if tx mode
   was unconditionally set to tsn in igc_tsn_enable_offload(). This could
   be replaced by checking the existing register
   IGC_TQAVCTRL_TRANSMIT_MODE_TSN bit.

This patch resolves all issues and enters schedule_work() to reset the
adapter only when changing tx mode. It also removes reliance on qbv_count.

qbv_count field will be removed in a future patch.

Test ran:

1. Verify reset adapter behaviour in i225/6:
   a) Enrol a new GCL
      Reset adapter observed (tx mode change legacy->tsn)
   b) Enrol a new GCL without deleting qdisc
      No reset adapter observed (tx mode remain tsn->tsn)
   c) Delete qdisc
      Reset adapter observed (tx mode change tsn->legacy)

2. Tested scenario from "igc: Fix TX Hang issue when QBV Gate is closed"
   to confirm it remains resolved.

Fixes: 175c241288c0 ("igc: Fix TX Hang issue when QBV Gate is closed")
Signed-off-by: Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
[ Only want the igc_tsn_is_tx_mode_in_tsn() portion of this for older stable
  kernels - gregkh ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc_tsn.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -49,6 +49,13 @@ static unsigned int igc_tsn_new_flags(st
 	return new_flags;
 }
 
+static bool igc_tsn_is_tx_mode_in_tsn(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+
+	return !!(rd32(IGC_TQAVCTRL) & IGC_TQAVCTRL_TRANSMIT_MODE_TSN);
+}
+
 void igc_tsn_adjust_txtime_offset(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;


