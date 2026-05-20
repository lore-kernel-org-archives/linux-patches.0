Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E473F20E5;
	Wed, 20 May 2026 17:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298718; cv=none; b=JnlC17DZosmtKDSI/bDQAp6QlUBKVUIsu0G4ALzd9QHrPWNu5t/b52ZWFt8nXDfrJ1Z/gKe7jGLftN3eZYjbWhJfXSYpjUdU0Ge4PgtBisaYQLeO1dbydXGSHHQniyFSppS90Zr3BHLmIMsjCz0nKeMv+L3wST+z5Jv4AqvrU2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298718; c=relaxed/simple;
	bh=lc0DmCzLpvM+yjNf8jDXgWNtlNeLQyNdtsAqAiQz5SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JX70INnaWZokhNivyAxjuuDjMSTuqymV5B3riw1TYO2EsHhOj1s4ECSUR9tFxPcwyVaaABc75WDfbC1k3YqRprP/BGCQObB5aWfo4U8OjVreNN0XKWpvpLezIXdDpRdRdqFeYJk+DlsP1Z4Mnayn5ouy3hisv7XockeVKvw3jTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDAs1yYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDAs1yYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD8B1F000E9;
	Wed, 20 May 2026 17:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298717;
	bh=aU3i8r08yoRW6tPJEz/QrGgBxG0lVLXkKnPQkKQBEBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDAs1yYhVxumEzvo7LmoWnNqBkVNL7M7FnoVyTvuUmyisGXyO7MjqOOHUbiV5M2jX
	 KrSGU67X42TEMHIuGpqOqUA9Lvw+gZ8baYtyi0qZoWSvkZgDKKiGJ9lPF/AP+J6zjn
	 qVsYnyzALRzpPAp06bMRmgdWSI61P/8oJoJOo12o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhang <zhangjian.3032@bytedance.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 516/957] ipmi: ssif_bmc: change log level to dbg in irq callback
Date: Wed, 20 May 2026 18:16:39 +0200
Message-ID: <20260520162145.724676374@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Zhang <zhangjian.3032@bytedance.com>

[ Upstream commit c9c99b7b7051eb7121b3224bfce181fb023b0269 ]

Long-running tests indicate that this logging can occasionally disrupt
timing and lead to request/response corruption.

Irq handler need to be executed as fast as possible,
most I2C slave IRQ implementations are byte-level, logging here
can significantly affect transfer behavior and timing. It is recommended
to use dev_dbg() for these messages.

Fixes: dd2bc5cc9e25 ("ipmi: ssif_bmc: Add SSIF BMC driver")
Signed-off-by: Jian Zhang <zhangjian.3032@bytedance.com>
Message-ID: <20260403090603.3988423-4-zhangjian.3032@bytedance.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ssif_bmc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/char/ipmi/ssif_bmc.c b/drivers/char/ipmi/ssif_bmc.c
index ca185793cf978..a45e80d13e10e 100644
--- a/drivers/char/ipmi/ssif_bmc.c
+++ b/drivers/char/ipmi/ssif_bmc.c
@@ -569,7 +569,7 @@ static void process_request_part(struct ssif_bmc_ctx *ssif_bmc)
 		len = ssif_bmc->request.len + part->length;
 		/* Do the bound check here, not allow the request len exceed 254 bytes */
 		if (len > IPMI_SSIF_PAYLOAD_MAX) {
-			dev_warn(&ssif_bmc->client->dev,
+			dev_dbg(&ssif_bmc->client->dev,
 				 "Warn: Request exceeded 254 bytes, aborting");
 			/* Request too long, aborting */
 			ssif_bmc->aborting =  true;
@@ -615,7 +615,7 @@ static void on_read_requested_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 	    ssif_bmc->state == SSIF_START ||
 	    ssif_bmc->state == SSIF_REQ_RECVING ||
 	    ssif_bmc->state == SSIF_RES_SENDING) {
-		dev_warn(&ssif_bmc->client->dev,
+		dev_dbg(&ssif_bmc->client->dev,
 			 "Warn: %s unexpected READ REQUESTED in state=%s\n",
 			 __func__, state_to_string(ssif_bmc->state));
 		ssif_bmc->state = SSIF_ABORTING;
@@ -624,7 +624,7 @@ static void on_read_requested_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 
 	} else if (ssif_bmc->state == SSIF_SMBUS_CMD) {
 		if (!supported_read_cmd(ssif_bmc->part_buf.smbus_cmd)) {
-			dev_warn(&ssif_bmc->client->dev, "Warn: Unknown SMBus read command=0x%x",
+			dev_dbg(&ssif_bmc->client->dev, "Warn: Unknown SMBus read command=0x%x",
 				 ssif_bmc->part_buf.smbus_cmd);
 			ssif_bmc->aborting = true;
 		}
@@ -659,7 +659,7 @@ static void on_read_processed_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 	    ssif_bmc->state == SSIF_START ||
 	    ssif_bmc->state == SSIF_REQ_RECVING ||
 	    ssif_bmc->state == SSIF_SMBUS_CMD) {
-		dev_warn(&ssif_bmc->client->dev,
+		dev_dbg(&ssif_bmc->client->dev,
 			 "Warn: %s unexpected READ PROCESSED in state=%s\n",
 			 __func__, state_to_string(ssif_bmc->state));
 		ssif_bmc->state = SSIF_ABORTING;
@@ -684,7 +684,7 @@ static void on_write_requested_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 	} else if (ssif_bmc->state == SSIF_START ||
 		   ssif_bmc->state == SSIF_REQ_RECVING ||
 		   ssif_bmc->state == SSIF_RES_SENDING) {
-		dev_warn(&ssif_bmc->client->dev,
+		dev_dbg(&ssif_bmc->client->dev,
 			 "Warn: %s unexpected WRITE REQUEST in state=%s\n",
 			 __func__, state_to_string(ssif_bmc->state));
 		ssif_bmc->state = SSIF_ABORTING;
@@ -699,7 +699,7 @@ static void on_write_received_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 {
 	if (ssif_bmc->state == SSIF_READY ||
 	    ssif_bmc->state == SSIF_RES_SENDING) {
-		dev_warn(&ssif_bmc->client->dev,
+		dev_dbg(&ssif_bmc->client->dev,
 			 "Warn: %s unexpected WRITE RECEIVED in state=%s\n",
 			 __func__, state_to_string(ssif_bmc->state));
 		ssif_bmc->state = SSIF_ABORTING;
@@ -709,7 +709,7 @@ static void on_write_received_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 
 	} else if (ssif_bmc->state == SSIF_SMBUS_CMD) {
 		if (!supported_write_cmd(ssif_bmc->part_buf.smbus_cmd)) {
-			dev_warn(&ssif_bmc->client->dev, "Warn: Unknown SMBus write command=0x%x",
+			dev_dbg(&ssif_bmc->client->dev, "Warn: Unknown SMBus write command=0x%x",
 				 ssif_bmc->part_buf.smbus_cmd);
 			ssif_bmc->aborting = true;
 		}
@@ -738,7 +738,7 @@ static void on_stop_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 	    ssif_bmc->state == SSIF_START ||
 	    ssif_bmc->state == SSIF_SMBUS_CMD ||
 	    ssif_bmc->state == SSIF_ABORTING) {
-		dev_warn(&ssif_bmc->client->dev,
+		dev_dbg(&ssif_bmc->client->dev,
 			 "Warn: %s unexpected SLAVE STOP in state=%s\n",
 			 __func__, state_to_string(ssif_bmc->state));
 		ssif_bmc->state = SSIF_READY;
@@ -805,7 +805,7 @@ static int ssif_bmc_cb(struct i2c_client *client, enum i2c_slave_event event, u8
 		break;
 
 	default:
-		dev_warn(&ssif_bmc->client->dev, "Warn: Unknown i2c slave event\n");
+		dev_dbg(&ssif_bmc->client->dev, "Warn: Unknown i2c slave event\n");
 		break;
 	}
 
-- 
2.53.0



