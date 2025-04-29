Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B7D188A0E;
	Tue, 29 Apr 2025 18:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950634; cv=none; b=jEdICKDBBb4w2VPppmaLhRlpjJZmjb0RrkFLuCyz2Eputujie35XmRYlHQNZkPsF0DQpbzS5k5MR8BLhJm6HPZ/8x+Q/vGofKrNuQJSx+dyoFRyWdc6bkI7S8NjGTdccY3f0m2D/yHMTU/3/Ende0Jynyr6ZWi6gay4daIrWweU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950634; c=relaxed/simple;
	bh=2Dzh63Ix5Vs24UrOW2W/St1vzhtaLr0RFV0lex/i4BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqYTM1y4/HCaMUKakkX4F2yevPjWxqDuD0P41TIQCSCeeaR1mnkFrXmAO86OKpaRDVCmkmXRh5yi20VEmFbiIOd8tt69EUOdi1lcFhrt6mgjZFqiclhtPbOr9tPCvP34aG4IEjPDz+hhkrP+cM9+FJnk3H1umU6uI++Kn0b3oZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBNDaMCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBNDaMCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6CCC4CEE3;
	Tue, 29 Apr 2025 18:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950634;
	bh=2Dzh63Ix5Vs24UrOW2W/St1vzhtaLr0RFV0lex/i4BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBNDaMCURNJXWxt279wWiwZUy26O2jqvsO9jhd8yc0DJ3ML8LI0x3jxpz2J0VN4o+
	 bblB3+GzMUMKn579B5A8TAYudU1IQBdB43KGD/xr2iJinUbWM8X+0a15e79EWeQHi3
	 J+2dBRLLNFsS1yEk8WS05358bp+pJBsmEzHD2Ubc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robbie King <robbiek@xsightlabs.com>,
	Huisong Li <lihuisong@huawei.com>,
	Adam Young <admiyo@os.amperecomputing.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/204] mailbox: pcc: Always clear the platform ack interrupt first
Date: Tue, 29 Apr 2025 18:43:38 +0200
Message-ID: <20250429161104.748541627@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit cf1338c0e02880cd235a4590eeb15e2039c873bc ]

The PCC mailbox interrupt handler (pcc_mbox_irq()) currently checks
for command completion flags and any error status before clearing the
interrupt.

The below sequence highlights an issue in the handling of PCC mailbox
interrupts, specifically when dealing with doorbell notifications and
acknowledgment between the OSPM and the platform where type3 and type4
channels are sharing the interrupt.

-------------------------------------------------------------------------
| T |       Platform Firmware         |    OSPM/Linux PCC driver        |
|---|---------------------------------|---------------------------------|
| 1 |                                 | Build message in shmem          |
| 2 |                                 | Ring Type3 chan doorbell        |
| 3 | Receives the doorbell interrupt |                                 |
| 4 | Process the message from OSPM   |                                 |
| 5 | Build response for the message  |                                 |
| 6 | Ring Platform ACK interrupt on  |                                 |
|   |  Type3 chan to OSPM             | Received the interrupt          |
| 7 | Build Notification in Type4 Chan|                                 |
| 8 |                                 | Start processing interrupt in   |
|   |                                 |  pcc_mbox_irq() handler         |
| 9 |                                 | Enter PCC handler for Type4 chan|
|10 |                                 | Check command complete cleared  |
|11 |                                 | Read the notification           |
|12 |                                 | Clear Platform ACK interrupt    |
|   | No effect from the previous step yet as the Platform ACK          |
|   |  interrupt has not yet been triggered for this channel            |
|13 | Ring Platform ACK interrupt on  |                                 |
|   | Type4 chan to OSPM              |                                 |
|14 |                                 | Enter PCC handler for Type3 chan|
|15 |                                 | Command complete is set.        |
|16 |                                 | Read the response.              |
|17 |                                 | Clear Platform ACK interrupt    |
|18 |                                 | Leave PCC handler for Type3     |
|19 |                                 | Leave pcc_mbox_irq() handler    |
|20 |                                 | Re-enter pcc_mbox_irq() handler |
|21 |                                 | Enter PCC handler for Type4 chan|
|22 |                                 | Leave PCC handler for Type4 chan|
|23 |                                 | Enter PCC handler for Type3 chan|
|24 |                                 | Leave PCC handler for Type3 chan|
|25 |                                 | Leave pcc_mbox_irq() handler    |
-------------------------------------------------------------------------

The key issue occurs when OSPM tries to acknowledge platform ack
interrupt for a notification which is ready to be read and processed
but the interrupt itself is not yet triggered by the platform.

This ineffective acknowledgment leads to an issue later in time where
the interrupt remains pending as we exit the interrupt handler without
clearing the platform ack interrupt as there is no pending response or
notification. The interrupt acknowledgment order is incorrect.

To resolve this issue, the platform acknowledgment interrupt should
always be cleared before processing the interrupt for any notifications
or response.

Reported-by: Robbie King <robbiek@xsightlabs.com>
Reviewed-by: Huisong Li <lihuisong@huawei.com>
Tested-by: Huisong Li <lihuisong@huawei.com>
Tested-by: Adam Young <admiyo@os.amperecomputing.com>
Tested-by: Robbie King <robbiek@xsightlabs.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 8fd4d0f79b090..f8215a8f656a4 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -313,6 +313,10 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 	int ret;
 
 	pchan = chan->con_priv;
+
+	if (pcc_chan_reg_read_modify_write(&pchan->plat_irq_ack))
+		return IRQ_NONE;
+
 	if (pchan->type == ACPI_PCCT_TYPE_EXT_PCC_MASTER_SUBSPACE &&
 	    !pchan->chan_in_use)
 		return IRQ_NONE;
@@ -330,9 +334,6 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 		return IRQ_NONE;
 	}
 
-	if (pcc_chan_reg_read_modify_write(&pchan->plat_irq_ack))
-		return IRQ_NONE;
-
 	/*
 	 * Clear this flag after updating interrupt ack register and just
 	 * before mbox_chan_received_data() which might call pcc_send_data()
-- 
2.39.5



