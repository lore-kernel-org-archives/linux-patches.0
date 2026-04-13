Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790BF307AC7;
	Mon, 13 Apr 2026 16:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098313; cv=none; b=vDp+319H9qgrztBoutK/Em9WlU2CRimfB1RbRuTxQCdZrYLZT5nX57q515dfKhqLvCvBrH+npPoBxmsq6k0GpjFggJQF0fHvMk9eV7/D8kfN+IlSev8v/ZjQGTigowB5Aa7ejr+LSrDD1SdWJ2EnrgQmYkiHxDxDExK/S6MwYrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098313; c=relaxed/simple;
	bh=qj5mFLj1SGDlSHCGilhA4ddopw3VnQqAPjs1Es5WTLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJB9nMzwJjkRy+VhAbs0ez/xe2tcwYTSdpyFgGujZ5cgLiU/Mmj9vIZbjUEnumhdEui6pDZZ7/U3zOLQuT4xSsDB3s7WDk6XZ4lIrzzrIY/E4/e+01BS7tMtKtchizO1F7pizue4rKeB2XVM8RkqXH7EV5YSqbfV5AR17ic3vf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUqlUROd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUqlUROd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6DCC2BCAF;
	Mon, 13 Apr 2026 16:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098313;
	bh=qj5mFLj1SGDlSHCGilhA4ddopw3VnQqAPjs1Es5WTLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUqlUROd7aQ/qbCDq+AEfwUeW9JqIgAM1G9jfIiLr3M+RCbOSjztb/UA85sKHj0nr
	 3wcQfNsi+esIH57WcU2buAopo0YiLRXgvZghg5uzlm0fObrpEDHwXV0TXazuxwWXwg
	 d/qMmMLUHnzIXCzSTEaxjUZMj6X2kqC6jq29aIXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasuaki Torimaru <yasuakitorimaru@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 444/570] wifi: wilc1000: fix u8 overflow in SSID scan buffer size calculation
Date: Mon, 13 Apr 2026 17:59:35 +0200
Message-ID: <20260413155847.102709959@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yasuaki Torimaru <yasuakitorimaru@gmail.com>

commit d049e56b1739101d1c4d81deedb269c52a8dbba0 upstream.

The variable valuesize is declared as u8 but accumulates the total
length of all SSIDs to scan. Each SSID contributes up to 33 bytes
(IEEE80211_MAX_SSID_LEN + 1), and with WILC_MAX_NUM_PROBED_SSID (10)
SSIDs the total can reach 330, which wraps around to 74 when stored
in a u8.

This causes kmalloc to allocate only 75 bytes while the subsequent
memcpy writes up to 331 bytes into the buffer, resulting in a 256-byte
heap buffer overflow.

Widen valuesize from u8 to u32 to accommodate the full range.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yasuaki Torimaru <yasuakitorimaru@gmail.com>
Link: https://patch.msgid.link/20260324100624.983458-1-yasuakitorimaru@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/microchip/wilc1000/hif.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -157,7 +157,7 @@ int wilc_scan(struct wilc_vif *vif, u8 s
 	u32 index = 0;
 	u32 i, scan_timeout;
 	u8 *buffer;
-	u8 valuesize = 0;
+	u32 valuesize = 0;
 	u8 *search_ssid_vals = NULL;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 


