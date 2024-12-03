Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853761E0496;
	Tue,  3 Dec 2024 15:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241112; cv=none; b=qpMYNtoDP/s4QoN3qlRpLae9ZOY4COGgGkIXwiJQeEScswxbcVJz9T/dyd70/sgoVilfBhReTz3bDAapp7Q6jdxfqv1q+V1XhDaGJfGaBIUtT8laHQaSH2MuXYtb3XjwJDC6MOgLO6MaAeccDr16JN22nPppuDWsdOrbOJWm2Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241112; c=relaxed/simple;
	bh=sGO8qoZ8b8mJOtUeVZFr1TQ8yz6GMFa4Jv/YYAVTlGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBgMJqjU9vXk4uU/SDD0epEWAH4cc12dgHJgNVwfWu6lWDuYSZLSqee1AC+BSv8IiqKfuNm3fVifZynVqjEOmXhpRoLQGYlquq/++2TDmxDDsFilL0edysEUe2TzFbDjnTckhTjzyLDqkHJJ5MXD1CBWbsxeFO4F5+xC7PMvHj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dclpyUjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dclpyUjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B241CC4CECF;
	Tue,  3 Dec 2024 15:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241112;
	bh=sGO8qoZ8b8mJOtUeVZFr1TQ8yz6GMFa4Jv/YYAVTlGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dclpyUjGr8wN2jdP9bRQQW19EAS28gFLMUXeDI8aWabb6b25f/2iwAkJMLrJXjiYt
	 LllxMsC5RvyoZYBTlJe29xi33U06E3t/gF822t8BlzFakWPPpDIHFCmCSmyTuHxN8F
	 1IPx26zV8lD4nhO7TfPyDX9teUH8RGXxasDtuZXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alf Marius <post@alfmarius.net>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 328/826] Revert "wifi: iwlegacy: do not skip frames with bad FCS"
Date: Tue,  3 Dec 2024 15:40:55 +0100
Message-ID: <20241203144756.555674615@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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
index 14d2331ee6cb9..b0656b143f77a 100644
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
index fcccde7bb6592..05c4af41bdb96 100644
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



