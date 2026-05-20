Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19ABA37DE8A;
	Wed, 20 May 2026 18:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302455; cv=none; b=fPuCRDuOV5eLxrap5pPmEm9W+IzqN0T06Saua0KeOeCFcAYYWeaKTUU6OkHdLTWnApsDihcd5U8XglmweWRKGvx0MK38TLev2UsNYnHd7Sl5p2gJvamXEqrUEMGue5r0nnKc/IiI6I2Lf84QSezwZprsimLXZbrFODzxG5/ACLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302455; c=relaxed/simple;
	bh=y8TCZdjB0Jwe5nsvvQtjb9gyuUDwXeeCVsRVZaqkxSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBogrdI+cjVl9dngqS56k5lRzAt3rwl9cCaUssx6gM+4Zu7eNdrchJQ8QMbqpEnLGCfy1I/6hsIU+WPSG3uY1TRjYtFFpmpdRiLImKzleY/i86lFSWDDr3Fcj5QC65KQ+hWt5zrFaDi0m0KBrn0d8+tJHDvGbMSkhH9cfQ8R8YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sN3JIUDw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sN3JIUDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9401F000E9;
	Wed, 20 May 2026 18:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302454;
	bh=DvEi1H5Ltae3JHQYJquWs4Q8NfC3gykaogpJJ41kUbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sN3JIUDwnrBYpyDYYPs8LdNnsN0cU1rQXt3yVbzzPPK4vBlGigqLWUNPJuzmckWOO
	 x1gQOg8sU3UJFFN1uSY54W85k4ICkvAlCUJGJJUkpq9KkvtXbQ8oyWjou0NlwDut+z
	 QufJ7+u+ltejsYooGnFQxdOVXC6Q6YR3YNqsc1j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhang <zhangjian.3032@bytedance.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 256/508] ipmi: ssif_bmc: change log level to dbg in irq callback
Date: Wed, 20 May 2026 18:21:19 +0200
Message-ID: <20260520162104.194051247@linuxfoundation.org>
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
index a13dc48120581..5d5444b567a04 100644
--- a/drivers/char/ipmi/ssif_bmc.c
+++ b/drivers/char/ipmi/ssif_bmc.c
@@ -568,7 +568,7 @@ static void process_request_part(struct ssif_bmc_ctx *ssif_bmc)
 		len = ssif_bmc->request.len + part->length;
 		/* Do the bound check here, not allow the request len exceed 254 bytes */
 		if (len > IPMI_SSIF_PAYLOAD_MAX) {
-			dev_warn(&ssif_bmc->client->dev,
+			dev_dbg(&ssif_bmc->client->dev,
 				 "Warn: Request exceeded 254 bytes, aborting");
 			/* Request too long, aborting */
 			ssif_bmc->aborting =  true;
@@ -614,7 +614,7 @@ static void on_read_requested_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 	    ssif_bmc->state == SSIF_START ||
 	    ssif_bmc->state == SSIF_REQ_RECVING ||
 	    ssif_bmc->state == SSIF_RES_SENDING) {
-		dev_warn(&ssif_bmc->client->dev,
+		dev_dbg(&ssif_bmc->client->dev,
 			 "Warn: %s unexpected READ REQUESTED in state=%s\n",
 			 __func__, state_to_string(ssif_bmc->state));
 		ssif_bmc->state = SSIF_ABORTING;
@@ -623,7 +623,7 @@ static void on_read_requested_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 
 	} else if (ssif_bmc->state == SSIF_SMBUS_CMD) {
 		if (!supported_read_cmd(ssif_bmc->part_buf.smbus_cmd)) {
-			dev_warn(&ssif_bmc->client->dev, "Warn: Unknown SMBus read command=0x%x",
+			dev_dbg(&ssif_bmc->client->dev, "Warn: Unknown SMBus read command=0x%x",
 				 ssif_bmc->part_buf.smbus_cmd);
 			ssif_bmc->aborting = true;
 		}
@@ -658,7 +658,7 @@ static void on_read_processed_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 	    ssif_bmc->state == SSIF_START ||
 	    ssif_bmc->state == SSIF_REQ_RECVING ||
 	    ssif_bmc->state == SSIF_SMBUS_CMD) {
-		dev_warn(&ssif_bmc->client->dev,
+		dev_dbg(&ssif_bmc->client->dev,
 			 "Warn: %s unexpected READ PROCESSED in state=%s\n",
 			 __func__, state_to_string(ssif_bmc->state));
 		ssif_bmc->state = SSIF_ABORTING;
@@ -683,7 +683,7 @@ static void on_write_requested_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 	} else if (ssif_bmc->state == SSIF_START ||
 		   ssif_bmc->state == SSIF_REQ_RECVING ||
 		   ssif_bmc->state == SSIF_RES_SENDING) {
-		dev_warn(&ssif_bmc->client->dev,
+		dev_dbg(&ssif_bmc->client->dev,
 			 "Warn: %s unexpected WRITE REQUEST in state=%s\n",
 			 __func__, state_to_string(ssif_bmc->state));
 		ssif_bmc->state = SSIF_ABORTING;
@@ -698,7 +698,7 @@ static void on_write_received_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 {
 	if (ssif_bmc->state == SSIF_READY ||
 	    ssif_bmc->state == SSIF_RES_SENDING) {
-		dev_warn(&ssif_bmc->client->dev,
+		dev_dbg(&ssif_bmc->client->dev,
 			 "Warn: %s unexpected WRITE RECEIVED in state=%s\n",
 			 __func__, state_to_string(ssif_bmc->state));
 		ssif_bmc->state = SSIF_ABORTING;
@@ -708,7 +708,7 @@ static void on_write_received_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 
 	} else if (ssif_bmc->state == SSIF_SMBUS_CMD) {
 		if (!supported_write_cmd(ssif_bmc->part_buf.smbus_cmd)) {
-			dev_warn(&ssif_bmc->client->dev, "Warn: Unknown SMBus write command=0x%x",
+			dev_dbg(&ssif_bmc->client->dev, "Warn: Unknown SMBus write command=0x%x",
 				 ssif_bmc->part_buf.smbus_cmd);
 			ssif_bmc->aborting = true;
 		}
@@ -737,7 +737,7 @@ static void on_stop_event(struct ssif_bmc_ctx *ssif_bmc, u8 *val)
 	    ssif_bmc->state == SSIF_START ||
 	    ssif_bmc->state == SSIF_SMBUS_CMD ||
 	    ssif_bmc->state == SSIF_ABORTING) {
-		dev_warn(&ssif_bmc->client->dev,
+		dev_dbg(&ssif_bmc->client->dev,
 			 "Warn: %s unexpected SLAVE STOP in state=%s\n",
 			 __func__, state_to_string(ssif_bmc->state));
 		ssif_bmc->state = SSIF_READY;
@@ -804,7 +804,7 @@ static int ssif_bmc_cb(struct i2c_client *client, enum i2c_slave_event event, u8
 		break;
 
 	default:
-		dev_warn(&ssif_bmc->client->dev, "Warn: Unknown i2c slave event\n");
+		dev_dbg(&ssif_bmc->client->dev, "Warn: Unknown i2c slave event\n");
 		break;
 	}
 
-- 
2.53.0



