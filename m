Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853B44C97;
	Tue, 11 Nov 2025 00:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822534; cv=none; b=WA1TWP6iwP/v0jwVMRWn8OaZL0vNhoXuCpT3+L3/kA30RwRCr3uQKPDVObheiZCvxcTCSCwsbr7oz8IFl8J0MSK3HA7zLB3gvEyx8EwiI+fWFFa6QGJJ6eqUQl+nfTb+M7pxrFr73dY4tERXE/Y8yxWPpTOEsMlY8Q8UE7qfcRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822534; c=relaxed/simple;
	bh=4ihAXwSMs6F+MmfR1F6oaTsr/rMhs4psg/OV9E/reaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyzkQhf4CNTvWkVfugp8UTJaKGd9zgOwwhjqS5hGUD+hru2hsojdJyOK2JAhJDtdDLE4FNQcG79C6gKhYMpytzPsWipHyfjT+TKuZL1vvAcyyzae6qNEEo+EBUpwRKLfc1qG43qMOMwLsdkeyjU9QKgv9qub6NkUCIuuP+497Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPRdRfbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPRdRfbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CA2C113D0;
	Tue, 11 Nov 2025 00:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822534;
	bh=4ihAXwSMs6F+MmfR1F6oaTsr/rMhs4psg/OV9E/reaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPRdRfbZa96gDOSpDNXQfApuk0RpczQ8Usull9eo7d7gZs9r6TdilUStgNP4Hf7mP
	 HL1uEutO0ccbf0A77b7a8xp1HBvyvqpuLBiszPXnoX3J17fvWSjreiPnkIbOdj7fsW
	 idjJFCTDhK4ukIZggBZQJPf+4f6LmYKiLHq1yqoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 132/849] firewire: ohci: move self_id_complete tracepoint after validating register
Date: Tue, 11 Nov 2025 09:35:02 +0900
Message-ID: <20251111004539.586112014@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 696968262aeee51e1c0529c3c060ddd180702e02 ]

The value of OHCI1394_SelfIDCount register includes an error-indicating
bit. It is safer to place the tracepoint probe after validating the
register value.

Link: https://lore.kernel.org/r/20250823030954.268412-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/ohci.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 5d8301b0f3aa8..421cf87e93c1f 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2063,6 +2063,9 @@ static void bus_reset_work(struct work_struct *work)
 		ohci_notice(ohci, "self ID receive error\n");
 		return;
 	}
+
+	trace_self_id_complete(ohci->card.index, reg, ohci->self_id, has_be_header_quirk(ohci));
+
 	/*
 	 * The count in the SelfIDCount register is the number of
 	 * bytes in the self ID receive buffer.  Since we also receive
@@ -2231,15 +2234,8 @@ static irqreturn_t irq_handler(int irq, void *data)
 	if (event & OHCI1394_busReset)
 		reg_write(ohci, OHCI1394_IntMaskClear, OHCI1394_busReset);
 
-	if (event & OHCI1394_selfIDComplete) {
-		if (trace_self_id_complete_enabled()) {
-			u32 reg = reg_read(ohci, OHCI1394_SelfIDCount);
-
-			trace_self_id_complete(ohci->card.index, reg, ohci->self_id,
-					       has_be_header_quirk(ohci));
-		}
+	if (event & OHCI1394_selfIDComplete)
 		queue_work(selfid_workqueue, &ohci->bus_reset_work);
-	}
 
 	if (event & OHCI1394_RQPkt)
 		queue_work(ohci->card.async_wq, &ohci->ar_request_ctx.work);
-- 
2.51.0



