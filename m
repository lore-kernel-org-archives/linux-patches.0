Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136603FAE1D;
	Wed, 20 May 2026 18:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302426; cv=none; b=upZ4fEo/FLnuY2ofoFBn5o7cEO+8+21rbXaxb7XEmC8kXYsTK7aWEsSmeuDmQp01mxxYrmHenkVni+acifzivORoC2Xykg9mhP/4MWDANf9n97zTSq6Okzfl0mWpfAfEQtPflbsk6YiOEnLXidjdl9e3aMWNroDouMHwNJO4lzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302426; c=relaxed/simple;
	bh=643pwF0IEwRSVpvY1bl7hcyak6qvquCGhWbKp7Sv9gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCBEH1+3CMQBFR/tPJWzsJHL1xL7u6K4drX+C4e71avFIpYO3VIoJsOdogm2o37wZLxUOk+KROHkLMTAY9LSInZd77ITjKQ83HvslFk88f5hjX0un38r7fK6vsZfD/GSOwvr1hw4azo42Y+1J5CFinXUUxR1uZmr0rVLcd5lLbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emU0fBrI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emU0fBrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780C11F00893;
	Wed, 20 May 2026 18:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302425;
	bh=LrGwM6GOugYHsAiwME5KQlsP0OeyrqREPBTxWeNExtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emU0fBrI9fvG8xTCIopaRzhFDBp3dpnHV+XRP0LGnqjfmep8+uQQWMFdY/LQNfWYM
	 UOGK80Lns60APy1PPF92rWt+P7IhdV1kwjn185Wm2Vvb65NxnZGVsfZqjKklObOKf1
	 cLKwLmM4E+pGOShdW1orqJr64mxWJLA/otN3vLA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhang <zhangjian.3032@bytedance.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/508] ipmi: ssif_bmc: fix message desynchronization after truncated response
Date: Wed, 20 May 2026 18:21:18 +0200
Message-ID: <20260520162104.173098638@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Jian Zhang <zhangjian.3032@bytedance.com>

[ Upstream commit 1d38e849adb6851ee280aa1a1d687b2181549a66 ]

A truncated response, caused by host power-off, or other conditions,
can lead to message desynchronization.

Raw trace data (STOP loss scenario, add state transition comment):

1. T-1: Read response phase (SSIF_RES_SENDING)
8271.955342  WR_RCV [03]                          <- Read polling cmd
8271.955348  RD_REQ [04]  <== SSIF_RES_SENDING    <- start sending response
8271.955436  RD_PRO [b4]
8271.955527  RD_PRO [00]
8271.955618  RD_PRO [c1]
8271.955707  RD_PRO [00]
8271.955814  RD_PRO [ad]  <== SSIF_RES_SENDING     <- last byte
	<- !! STOP lost (truncated response)

2. T: New Write request arrives, BMC still in SSIF_RES_SENDING
8271.967973  WR_REQ []    <== SSIF_RES_SENDING >> SSIF_ABORTING  <- log: unexpected WR_REQ in RES_SENDING
8271.968447  WR_RCV [02]  <== SSIF_ABORTING  <- do nothing
8271.968452  WR_RCV [02]  <== SSIF_ABORTING  <- do nothing
8271.968454  WR_RCV [18]  <== SSIF_ABORTING  <- do nothing
8271.968456  WR_RCV [01]  <== SSIF_ABORTING  <- do nothing
8271.968458  WR_RCV [66]  <== SSIF_ABORTING  <- do nothing
8271.978714  STOP []      <== SSIF_ABORTING >> SSIF_READY  <- log: unexpected SLAVE STOP in state=SSIF_ABORTING

3. T+1: Next Read polling, treated as a fresh transaction
8271.979125  WR_REQ []    <== SSIF_READY >> SSIF_START
8271.979326  WR_RCV [03]  <== SSIF_START >> SSIF_SMBUS_CMD        <- smbus_cmd=0x03
8271.979331  RD_REQ [04]  <== SSIF_RES_SENDING      <- sending response
8271.979427  RD_PRO [b4]                            <- !! this is T's stale response -> desynchronization

When in SSIF_ABORTING state, a newly arrived command should still be
handled to avoid dropping the request or causing message
desynchronization.

Fixes: dd2bc5cc9e25 ("ipmi: ssif_bmc: Add SSIF BMC driver")
Signed-off-by: Jian Zhang <zhangjian.3032@bytedance.com>
Message-ID: <20260403090603.3988423-3-zhangjian.3032@bytedance.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ssif_bmc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/char/ipmi/ssif_bmc.c b/drivers/char/ipmi/ssif_bmc.c
index 6928adb5df5ab..a13dc48120581 100644
--- a/drivers/char/ipmi/ssif_bmc.c
+++ b/drivers/char/ipmi/ssif_bmc.c
@@ -457,6 +457,15 @@ static bool supported_write_cmd(u8 cmd)
 	return false;
 }
 
+static bool supported_write_start_cmd(u8 cmd)
+{
+	if (cmd == SSIF_IPMI_SINGLEPART_WRITE ||
+	    cmd == SSIF_IPMI_MULTIPART_WRITE_START)
+		return true;
+
+	return false;
+}
+
 /* Process the IPMI response that will be read by master */
 static void handle_read_processed(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 {
@@ -708,6 +717,11 @@ static void on_write_received_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 			ssif_bmc->state = SSIF_ABORTING;
 		else
 			ssif_bmc->state = SSIF_REQ_RECVING;
+	} else if (ssif_bmc->state == SSIF_ABORTING) {
+		if (supported_write_start_cmd(*val)) {
+			ssif_bmc->state = SSIF_SMBUS_CMD;
+			ssif_bmc->aborting = false;
+		}
 	}
 
 	/* This is response sending state */
-- 
2.53.0



