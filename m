Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97BB33FE;
	Tue,  3 Dec 2024 15:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238370; cv=none; b=VIcDprzV4jhoGBqAmlX//IjmbGanCWou+xE2+zqFKn+e10WxIb4I7kIW5gj/YWXHlz4sVp+vePeBUKKd0B6kBzMnCFYtM52y5iaEE4/o+rwmjxVuM/tDWda6nyIEiMZajdbnVNqbu+MAxdfi+wNH6ME9gwq1y7aSW4GE5X9E6RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238370; c=relaxed/simple;
	bh=86tUrF5NbiKsN5q/zT0Q5yMNZAHRHrp5/kD5f+IgFHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qm8hVlxIgrhwitpY9PmAbLJwRvbL/uFHQ7tm/0dqtn25WHZY8rpDxqIMBKEqcw1kfN8MmCINtowaU1Q6+0GHF8cN1gbYouARGikgoPz/FYKx5BKqtfNMnnOWtyUiwQEmlvEoFTEC5NqzzOBZOLe16JgcwNCaeqbQ0ysXpjqQGZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GibygePt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GibygePt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A7BC4CECF;
	Tue,  3 Dec 2024 15:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238369;
	bh=86tUrF5NbiKsN5q/zT0Q5yMNZAHRHrp5/kD5f+IgFHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GibygePtgIIrNLLc9ZFblizOp6vVSVh2oDYUg5HQsmShR27UBih53b2XCmIf1m8jH
	 ibRtXTuopVCiUBHSSPhdZkUbd7F5Xuo7rPcd5Y+L2oDXt7hPyaz1irfUBPEDMmg+Jc
	 fmLflE7h3DKXd5+NPmApIK88txxjokYd2KDO5q7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaistra <martin.kaistra@linutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 255/817] wifi: rtl8xxxu: Perform update_beacon_work when beaconing is enabled
Date: Tue,  3 Dec 2024 15:37:07 +0100
Message-ID: <20241203144005.724396321@linuxfoundation.org>
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

From: Martin Kaistra <martin.kaistra@linutronix.de>

[ Upstream commit d7063ed6758c62e00a2f56467ded85a021fac67a ]

In STA+AP concurrent mode, performing a scan operation on one vif
temporarily stops beacons on the other. When the scan is completed,
beacons are enabled again with BSS_CHANGED_BEACON_ENABLED.

We can observe that no beacons are being sent when just
rtl8xxxu_start_tx_beacon() is being called.

Thus, also perform update_beacon_work in order to restore beaconing.

Fixes: cde8848cad0b ("wifi: rtl8xxxu: Add beacon functions")
Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240930084955.455241-1-martin.kaistra@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 043fa364e7014..a7e74ece2b4d1 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -5058,10 +5058,12 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		if (bss_conf->enable_beacon)
+		if (bss_conf->enable_beacon) {
 			rtl8xxxu_start_tx_beacon(priv);
-		else
+			schedule_delayed_work(&priv->update_beacon_work, 0);
+		} else {
 			rtl8xxxu_stop_tx_beacon(priv);
+		}
 	}
 
 	if (changed & BSS_CHANGED_BEACON)
-- 
2.43.0



