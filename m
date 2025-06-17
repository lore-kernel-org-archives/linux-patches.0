Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233A32E8DE3;
	Tue, 17 Jun 2025 16:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177350; cv=none; b=XvZbR3HqhbZ15xNbZq1/ckvYM3PMj7r+WWZWp0aOF2eswa7AG/kaBKs8X1lPj+O8jEI22rODpwNuoCMaRrrFp+bCZRU+h6Uvt7kxvVYztGegRwMu6g2E09SAaDQLJDyXnmnovbmZW746WLugtuNkVyHOm6nmzYbsZlXdC2IL6uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177350; c=relaxed/simple;
	bh=EcJYi//THipq+o6bBgR1zlA9CJFjNxxRGx91uDk3dxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sDDBcLX4r2vH+6ZzN5ng7yUt5KNa/jQz/EcEwgbhlBaVgigF/n4O7DVJcFnaDgYwnosWeW91O4jCWHuqHLOei1qF+pJNGY+Sss/4MjKrdJMV8WineNbGzXVk22qVWCDSW8z79hyunLBRjM7PJAITtOXxLV6XLUqCX9DVSGqvN/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8GLHaaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8GLHaaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D80C4CEE3;
	Tue, 17 Jun 2025 16:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177350;
	bh=EcJYi//THipq+o6bBgR1zlA9CJFjNxxRGx91uDk3dxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8GLHaaZ58Rnr8w56RntQBZCvs+o4SApuRoc0CnJnha1tbCXJNgCCgjFjXYM6p8cY
	 vh57GG+bkl3bY9Lvc9sY2SIrK7RcLMKdX22WMNoIyArIVoqha1DB34/aFx3tArPAmf
	 OvsH/+U0uUBg3AaQ2KJegC9dYaS2RCm3PHgPvxpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 280/780] wifi: ath9k_htc: Abort software beacon handling if disabled
Date: Tue, 17 Jun 2025 17:19:48 +0200
Message-ID: <20250617152502.874405755@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@toke.dk>

[ Upstream commit ac4e317a95a1092b5da5b9918b7118759342641c ]

A malicious USB device can send a WMI_SWBA_EVENTID event from an
ath9k_htc-managed device before beaconing has been enabled. This causes
a device-by-zero error in the driver, leading to either a crash or an
out of bounds read.

Prevent this by aborting the handling in ath9k_htc_swba() if beacons are
not enabled.

Reported-by: Robert Morris <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/r/88967.1743099372@localhost
Fixes: 832f6a18fc2a ("ath9k_htc: Add beacon slots")
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20250402112217.58533-1-toke@toke.dk
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 547634f82183d..81fa7cbad8921 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -290,6 +290,9 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv,
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	int slot;
 
+	if (!priv->cur_beacon_conf.enable_beacon)
+		return;
+
 	if (swba->beacon_pending != 0) {
 		priv->beacon.bmisscnt++;
 		if (priv->beacon.bmisscnt > BSTUCK_THRESHOLD) {
-- 
2.39.5



