Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149A11F76DE;
	Tue,  3 Dec 2024 15:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238638; cv=none; b=SwpMQ4+/hpB9nuCj3XskgZrZv97/lHcunYKk4VZ5k3SoDDKLywKA/PBrpwA8RlavjcAN3HLw8l2g1gmvY9CAm59LWEPwex6As8xQE3oxk7oLYVRUnqwD44nfyoGCpKI+AbjRrcbGwKksnJH69QsYOTLlTgQB5Z3zMe5SDr173/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238638; c=relaxed/simple;
	bh=OoeXgeiEM17jwBe0/UhC31719VuO/mYleO5W5PIwapM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8ojF5kXRlz+1HDyMyz+lOX5szOL/SkHoIA7h2yRKyaqHBuF2lSKYbCm8cmiGxDVpkZKTi/35EFIIAmyTh2lRjTzRuKEC9RW5MuP97L0OAW2pQapcvCjTV5zRbl/kyBfXTMUBq15BzmXfix43cxvyIa4fUIWxiXCt1Io9KxxDk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCFfzM3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCFfzM3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4A0C4CECF;
	Tue,  3 Dec 2024 15:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238637;
	bh=OoeXgeiEM17jwBe0/UhC31719VuO/mYleO5W5PIwapM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCFfzM3PCXDiXNBQmcQEuq+lqXa4IKB0pMEsA7PNhctlv4GJxtEZiBfFeCQeI+gE1
	 DlE9qVeNxr6ZdN90ZVEurpj6MpkU5K5pWJZ7qEVCBPaF33wfX5VIZsZD65i0lnbsJX
	 ECb/jBADaDagQPip2m2h/WEMteEbFJ2qlV5FCQQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alf Marius <post@alfmarius.net>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 347/817] Revert "wifi: iwlegacy: do not skip frames with bad FCS"
Date: Tue,  3 Dec 2024 15:38:39 +0100
Message-ID: <20241203144009.372043219@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalle Valo <kvalo@kernel.org>

[ Upstream commit 11597043d74809daf5d14256b96d6781749b3f82 ]

This reverts commit 02b682d54598f61cbb7dbb14d98ec1801112b878.

Alf reports that this commit causes the connection to eventually die on
iwl4965. The reason is that rx_status.flag is zeroed after
RX_FLAG_FAILED_FCS_CRC is set and mac80211 doesn't know the received frame is
corrupted.

Fixes: 02b682d54598 ("wifi: iwlegacy: do not skip frames with bad FCS")
Reported-by: Alf Marius <post@alfmarius.net>
Closes: https://lore.kernel.org/r/60f752e8-787e-44a8-92ae-48bdfc9b43e7@app.fastmail.com/
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241112142419.1023743-1-kvalo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/3945.c     | 2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945.c b/drivers/net/wireless/intel/iwlegacy/3945.c
index 1fab7849f56d1..a773939b8c2aa 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945.c
@@ -566,7 +566,7 @@ il3945_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 	if (!(rx_end->status & RX_RES_STATUS_NO_CRC32_ERROR) ||
 	    !(rx_end->status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
 		D_RX("Bad CRC or FIFO: 0x%08X.\n", rx_end->status);
-		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+		return;
 	}
 
 	/* Convert 3945's rssi indicator to dBm */
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 1600c344edbb2..11c15e0bc779a 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -664,7 +664,7 @@ il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 	if (!(rx_pkt_status & RX_RES_STATUS_NO_CRC32_ERROR) ||
 	    !(rx_pkt_status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
 		D_RX("Bad CRC or FIFO: 0x%08X.\n", le32_to_cpu(rx_pkt_status));
-		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+		return;
 	}
 
 	/* This will be used in several places later */
-- 
2.43.0



