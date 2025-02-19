Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D561E1DF27F;
	Wed, 19 Feb 2025 08:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954127; cv=none; b=jGT1ownbaODFbYdWon1pOoIvwJHbXwTpv7vYR2ftxnTobczGaaoea22YlYMvq0bzXN1/74ezS1IEhxOz2SlpZRHzkpPww67r2vGoDXySUjcxDJL+/+XjcwtOXC8ovG+qAABogxWGXS3dlVPcPerPXkjI59hV/BgF/8IXlKeNLbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954127; c=relaxed/simple;
	bh=+dy0LmEogKpBPb9Qr0iZIR+nwj5EFfRkUr/dvSs5iG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+YsCeoWqN2+/5/AVQ+er9sCNs/+x5Ih1cHdfYy3wujgEggOImrtCAxE9h2FhPb4gZxQe2XGS7x2Ozofu6zp8j9PBoGNSOJvvzWpjx/wMell9r1MHtea/5rclWlVwCC/QPcszKCnqzdOQ8JixszOYacOABj6SnBsDZfNu9m8084=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaPr02ov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaPr02ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576CDC4CEE8;
	Wed, 19 Feb 2025 08:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954127;
	bh=+dy0LmEogKpBPb9Qr0iZIR+nwj5EFfRkUr/dvSs5iG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaPr02ovG8MFl36vRie1S+jZ/zTc6VbDMh3BwBdzP9Aoflxg/8aHjB8SfFb5GwI/o
	 2ba5dsHMdrvjLYv27+KjpZIxpr5NLz/nkzKT4MmioFW8/yRbsKGpKogRJ8We6zVbKs
	 ZN5TXdRdrT+mTVtt23SrcDlMjr4NZrwqtACudNgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 074/274] i3c: mipi-i3c-hci: Add Intel specific quirk to ring resuming
Date: Wed, 19 Feb 2025 09:25:28 +0100
Message-ID: <20250219082612.518470252@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit ccdb2e0e3b00d13df90ac7a0524dd855173f1171 ]

MIPI I3C HCI on Intel hardware requires a quirk where ring needs to stop
and set to run again after resuming the halted controller. This is not
expected from the MIPI I3C HCI specification and is Intel specific.

Add this quirk to generic aborted transfer handling and execute it only
when ring is not in running state after a transfer error and attempted
controller resume. This is the case on Intel hardware.

It is not fully clear to me what is the ring running state in generic
hardware in such case. I would expect if ring is not running, then stop
request is a no-op and run request is either required or does the same
what controller resume would do.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20241231115904.620052-1-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index e8e56a8d20573..491dfe70b6600 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -758,9 +758,26 @@ static bool hci_dma_irq_handler(struct i3c_hci *hci)
 			complete(&rh->op_done);
 
 		if (status & INTR_TRANSFER_ABORT) {
+			u32 ring_status;
+
 			dev_notice_ratelimited(&hci->master.dev,
 				"ring %d: Transfer Aborted\n", i);
 			mipi_i3c_hci_resume(hci);
+			ring_status = rh_reg_read(RING_STATUS);
+			if (!(ring_status & RING_STATUS_RUNNING) &&
+			    status & INTR_TRANSFER_COMPLETION &&
+			    status & INTR_TRANSFER_ERR) {
+				/*
+				 * Ring stop followed by run is an Intel
+				 * specific required quirk after resuming the
+				 * halted controller. Do it only when the ring
+				 * is not in running state after a transfer
+				 * error.
+				 */
+				rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE);
+				rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE |
+							   RING_CTRL_RUN_STOP);
+			}
 		}
 		if (status & INTR_WARN_INS_STOP_MODE)
 			dev_warn_ratelimited(&hci->master.dev,
-- 
2.39.5



