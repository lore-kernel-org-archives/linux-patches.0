Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39771F582A;
	Mon, 23 Jun 2025 21:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713305; cv=none; b=WwIQbB9fWiis6zrpN8Hqcw1kZy1qqOTwTjAO0seE08yRks1QD8W5ThFXJILBwtqYleI+mppn8A6HBJUYaKELcNUGbnK7ivfI3OfmGDTCLZxj1Mis0I+sk9QF9sce27a6peQznpJoLAxmBuZZudfMXeX/N4hUCEpSNRzUh4ys7Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713305; c=relaxed/simple;
	bh=TXfOg6V4Nusi8oRr9YjPcN8AV3lAW40IYlQUfeeEQvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hRuni3AIaiflGG3ST5ceK5ZtBZVW/7rXrQ/aMHCdMi+eiZw8OlCCl3rXht2PLyzCAoj7oOjne9FTwsrPO0yhvNJtpRsZU85I1DSbjjegHBImRBtlrijJsggvEX2d3/nksjEXZpqOmn5a7rNF6dl9VuxxT80/Mlmp0MTrqnzu7wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/1Sd52P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/1Sd52P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9E6C4CEEA;
	Mon, 23 Jun 2025 21:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713304;
	bh=TXfOg6V4Nusi8oRr9YjPcN8AV3lAW40IYlQUfeeEQvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/1Sd52PS/CBB73Di+xWFXSL4VuKrTjLWKrjptoqDdMzdprj3drNw6Z+kfgReBcFK
	 HMheNfs092YV1roi2X1L1okPKYaTX4vqPAN81lv7hArMcpDuZyIOKRTv4JD9/MJHxf
	 6URB5H41c8vlsPWWI6NmSww94n8HrfDl6v/RALjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/508] wifi: ath9k_htc: Abort software beacon handling if disabled
Date: Mon, 23 Jun 2025 15:02:14 +0200
Message-ID: <20250623130647.440808967@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 533471e694007..18c7654bc539d 100644
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



