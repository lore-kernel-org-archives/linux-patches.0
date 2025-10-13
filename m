Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B14431280A;
	Mon, 13 Oct 2025 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368277; cv=none; b=BCQMsEKwGJEVLIniUGJ3vaZAyBordyIHioInY8AQ4SuTgC7C7NjNohqMVh+VmpIes61lgKJ4h/GPeI98DT6IyNq3pkiCkU1mZNa7wR8cdw2VviVi2dC6kocKQii1C82QvnRUoZolY9+rICUPq1LD858qfbfF1v0wkXEQQEHL6ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368277; c=relaxed/simple;
	bh=JTJJ4xVkghIwdg8GNyvlbwZEBhSvHbc7Y4d/YFJMjnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S14gEXsbhuZ6FGmSNo7hKZRL++HheS2ng6tYaWUxvijUMuVHsrQnagpRyuKWuVZh3Pv0m8lhYlymslKgoUs8qAMMRl0y5J6zukgstgRMrXw08XeEcoynQMSSEEevZ64nEbhqG+v9/pbIJmDAKhkblOy+oLZfcSo4vu7g0e6UKv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHXewjkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHXewjkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5539C4CEE7;
	Mon, 13 Oct 2025 15:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368277;
	bh=JTJJ4xVkghIwdg8GNyvlbwZEBhSvHbc7Y4d/YFJMjnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHXewjkTp6f7T0pETLz2AVY7yJjEapVwgLB9RFoaIS+BtO4M+ayC4w2TTODtJTtJV
	 3DvLo6pSxDHrT7MdOCT1aMDLbyOGxdtd2l+8MRReFb3CoKsTC0JAq59Q1EhvwnptZS
	 2J7nT1rQG/Bp0vvZJz/IcLC34YucX01kMYkkOess=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/262] i3c: master: svc: Use manual response for IBI events
Date: Mon, 13 Oct 2025 16:43:34 +0200
Message-ID: <20251013144328.719936706@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit a7869b0a2540fd122eccec00ae7d4243166b0a60 ]

Driver wants to nack the IBI request when the target is not in the
known address list. In below code, svc_i3c_master_nack_ibi() will
cause undefined behavior when using AUTOIBI with auto response rule,
because hw always auto ack the IBI request.

    switch (ibitype) {
    case SVC_I3C_MSTATUS_IBITYPE_IBI:
            dev = svc_i3c_master_dev_from_addr(master, ibiaddr);
            if (!dev || !is_events_enabled(master, SVC_I3C_EVENT_IBI))
                    svc_i3c_master_nack_ibi(master);
            ...
            break;

AutoIBI has another issue that the controller doesn't quit AutoIBI state
after IBIWON polling timeout when there is a SDA glitch(high->low->high).
1. SDA high->low: raising an interrupt to execute IBI ISR
2. SDA low->high
3. Driver writes an AutoIBI request
4. AutoIBI process does not start because SDA is not low
5. IBIWON polling times out
6. Controller reamins in AutoIBI state and doesn't accept EmitStop request

Emitting broadcast address with IBIRESP_MANUAL avoids both issues.

Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250829012309.3562585-2-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 30 ++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 474a96ebda226..7d8e1540f02ae 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -438,9 +438,24 @@ static void svc_i3c_master_ibi_work(struct work_struct *work)
 	 */
 	writel(SVC_I3C_MINT_IBIWON, master->regs + SVC_I3C_MSTATUS);
 
-	/* Acknowledge the incoming interrupt with the AUTOIBI mechanism */
-	writel(SVC_I3C_MCTRL_REQUEST_AUTO_IBI |
-	       SVC_I3C_MCTRL_IBIRESP_AUTO,
+	/*
+	 * Write REQUEST_START_ADDR request to emit broadcast address for arbitration,
+	 * instend of using AUTO_IBI.
+	 *
+	 * Using AutoIBI request may cause controller to remain in AutoIBI state when
+	 * there is a glitch on SDA line (high->low->high).
+	 * 1. SDA high->low, raising an interrupt to execute IBI isr.
+	 * 2. SDA low->high.
+	 * 3. IBI isr writes an AutoIBI request.
+	 * 4. The controller will not start AutoIBI process because SDA is not low.
+	 * 5. IBIWON polling times out.
+	 * 6. Controller reamins in AutoIBI state and doesn't accept EmitStop request.
+	 */
+	writel(SVC_I3C_MCTRL_REQUEST_START_ADDR |
+	       SVC_I3C_MCTRL_TYPE_I3C |
+	       SVC_I3C_MCTRL_IBIRESP_MANUAL |
+	       SVC_I3C_MCTRL_DIR(SVC_I3C_MCTRL_DIR_WRITE) |
+	       SVC_I3C_MCTRL_ADDR(I3C_BROADCAST_ADDR),
 	       master->regs + SVC_I3C_MCTRL);
 
 	/* Wait for IBIWON, should take approximately 100us */
@@ -460,10 +475,15 @@ static void svc_i3c_master_ibi_work(struct work_struct *work)
 	switch (ibitype) {
 	case SVC_I3C_MSTATUS_IBITYPE_IBI:
 		dev = svc_i3c_master_dev_from_addr(master, ibiaddr);
-		if (!dev || !is_events_enabled(master, SVC_I3C_EVENT_IBI))
+		if (!dev || !is_events_enabled(master, SVC_I3C_EVENT_IBI)) {
 			svc_i3c_master_nack_ibi(master);
-		else
+		} else {
+			if (dev->info.bcr & I3C_BCR_IBI_PAYLOAD)
+				svc_i3c_master_ack_ibi(master, true);
+			else
+				svc_i3c_master_ack_ibi(master, false);
 			svc_i3c_master_handle_ibi(master, dev);
+		}
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_HOT_JOIN:
 		if (is_events_enabled(master, SVC_I3C_EVENT_HOTJOIN))
-- 
2.51.0



