Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5850417B50F;
	Tue, 10 Sep 2024 10:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964214; cv=none; b=XKvaXZlTWaBzFKOuHYlttOA40foM58J8w4pN0n0V+kK3fe9XZ3ABBKnG27QXBl4ucIlaf2HHrY0HqpGMaCKd5M4Oy8y3HxgtJRWUzUA69AeKNOIMFfu28T37N4rAUw0MYSxLO6xgSE2BoYUGsYMKdNqqVtEPtV72lJvLfYJscto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964214; c=relaxed/simple;
	bh=mtEQ9Ua/Fs+MZ4lNGlZ24Bko3Mvsxxm1rxqvfqYyu/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9eKpSG9S+zh4sngeYImsRGrhrmH6dSMZPcwG92McCCWdY9Sq1H2lFhYsPWE2RMDDKEMUjC3hoDHPG5m3RaYER9vps5nNA5MofiKRnQYcVNYjxM7Zg3BpeDqsApyGilg2So/tjRA880VFMv43EpnE9jqjjvKbr336eHiCvIEPxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuLp6Bsy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuLp6Bsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA291C4CEC3;
	Tue, 10 Sep 2024 10:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964214;
	bh=mtEQ9Ua/Fs+MZ4lNGlZ24Bko3Mvsxxm1rxqvfqYyu/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuLp6BsyjjHQWJut6KsySBJGRahVDfVXWYPwveQwcm9/aD1Lg40f5Yh5J7hmRzxP7
	 CxUT2XPD1W7/E0omhhtLLn6wX525B/Dkyf/8Z0CnnPJUS5L6MgYpTef4rZ9YJTHhsX
	 7PMT8scW7aKG63PvGBYScUYAbs9xNRcrsW2Accms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Jocic <martin.jocic@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/269] can: kvaser_pciefd: Skip redundant NULL pointer check in ISR
Date: Tue, 10 Sep 2024 11:31:33 +0200
Message-ID: <20240910092611.986303174@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Martin Jocic <martin.jocic@kvaser.com>

[ Upstream commit ac765219c2c4e44f29063724c8d36435a3e61985 ]

This check is already done at the creation of the net devices in
kvaser_pciefd_setup_can_ctrls called from kvaser_pciefd_probe.

If it fails, the driver won't load, so there should be no need to
repeat the check inside the ISR. The number of channels is read
from the FPGA and should be trusted.

Signed-off-by: Martin Jocic <martin.jocic@kvaser.com>
Link: https://lore.kernel.org/all/20240614151524.2718287-3-martin.jocic@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: dd885d90c047 ("can: kvaser_pciefd: Use a single write when releasing RX buffers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index a57005faa04f..076fc2f5b34b 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1641,12 +1641,6 @@ static irqreturn_t kvaser_pciefd_irq_handler(int irq, void *dev)
 		kvaser_pciefd_receive_irq(pcie);
 
 	for (i = 0; i < pcie->nr_channels; i++) {
-		if (!pcie->can[i]) {
-			dev_err(&pcie->pci->dev,
-				"IRQ mask points to unallocated controller\n");
-			break;
-		}
-
 		/* Check that mask matches channel (i) IRQ mask */
 		if (board_irq & irq_mask->kcan_tx[i])
 			kvaser_pciefd_transmit_irq(pcie->can[i]);
-- 
2.43.0



