Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1722824FBFF;
	Mon, 23 Jun 2025 13:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685737; cv=none; b=QDRXNQ4bapE9Cia0WwquVdIcFMo5kPTDCti+E4/k4uyv2IalnNVtWlWfB8qvCz6cbSMffkve0Om73xsrvzLUQFuXft/Ars+Jr5j2IinXQ5WXiDoK7Z9+l+VNxS/+L+HP2L4gDxnR1Aio9xjdghO1Pi23MHSWP7ydB9FhmJlC/rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685737; c=relaxed/simple;
	bh=zS1HuIDSHF+cT/Ca2g7jhZQDF98EnQpS5dWhLV1mPU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jVQQc+FjblynnJqw8V8J62Vzarq4G9/whF9Jlsa2AtheGWBnRZvShvN0SgWrLevY999Z6YDFT6Y/Dl04WPKjvMSts6iaY95p+58DjMIlOYmWohl8tVCeSAMayFDYpOEvieX4Q53MYXlIscwUQrcWa8hqmYfThau/jPGy3UshC7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBgyUJDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBgyUJDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47638C4CEF0;
	Mon, 23 Jun 2025 13:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685736;
	bh=zS1HuIDSHF+cT/Ca2g7jhZQDF98EnQpS5dWhLV1mPU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBgyUJDll8gRTOKbtffRYiOjJPaQVxIwAp8AqyclOtClaaAj84fCs+o6I6ZUbRkSN
	 gvrStYny8vntNYNFKRq6CNfRYmbQf6MhgMebyC7YqR46+sZPr8MSS71zEdnfwz/Qr9
	 oKOEAonKg2tHiXkOjrIwhnFxpekCOg6uu1AhAgSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/411] wifi: ath9k_htc: Abort software beacon handling if disabled
Date: Mon, 23 Jun 2025 15:03:26 +0200
Message-ID: <20250623130634.850770406@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c745897aa3d6c..259a36b4c7cb0 100644
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



