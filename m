Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96796385D67;
	Tue, 21 Jul 2026 19:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660783; cv=none; b=XrgsIf9eaRPTd2Swpz4Jx9rwd0VTQqdR8x3Z4C12i/WPns+JQ5+S/MHZ2VjZd1P8EeFuFHS6Z3mVXShp7r6M9r2zQfgexwnvikuWqLVc4tnP/9lMXL+k2mlbGuUDGpt9fetiA+jneJs4XdSd8D19iqFTA4Udwiqhr4yZ7guY/RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660783; c=relaxed/simple;
	bh=fkaH6joHURdDpOGQw9rgHd0soOFT+PbWEenMTTKbABg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUlkuTfed+vNHYBfYYs1CJ2oU9LL2mqcXTSzaQggiUbgKk2jIgohT2Cys9kPbfDtr7wFsdUqqy5ZL8fAVqjROY/ygGhTOtzt6qfZmO8VpMbCs4rWNE07yyh/196VunBU+5mqm8A66Ej727/1Q9JX5YpCELF46NrjWJSft2T18D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5Qr3EsJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5Qr3EsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BB61F000E9;
	Tue, 21 Jul 2026 19:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660782;
	bh=belwcfiUr0GB8Hw96acfO0m/l9BsgtwMiaAt3I6VwqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p5Qr3EsJGy9EF/6OTuaW367i2g4xepYVPToy/J1siMQNek1BDncJwVXVh3zHiw2lZ
	 4r3wvevPHmVGT3NOOy+XUPYXbCIJfoWdE/he2E2jv/8kBdRuOyPWV2J5CBiQF2XZ/b
	 x8yx2TXQ9niW4+P0fgOsMQ4PLdgXn2EWenOqJmR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1057/2077] i3c: mipi-i3c-hci: Preserve RUN bit when aborting DMA ring
Date: Tue, 21 Jul 2026 17:12:10 +0200
Message-ID: <20260721152617.752752364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 093eb8e73c90aa0c8cfb0421aa85bd70c23488be ]

The MIPI I3C HCI specification does not require the DMA ring RUN bit
(RUN_STOP) to be cleared when issuing an ABORT.  That allows the DMA ring
to continue to receive IBIs, although an IBI is anyway not lost because it
can be received once the ring restarts if the I3C device has not given up.
Note, currently ABORT is only used on a timeout error path so the change
has very little effect in practice.  In the more common case of a transfer
error, the ring (bundle) operation is halted by the controller anyway.

Adjust the RING_CONTROL handling to set ABORT without clearing RUN_STOP,
bringing the driver into alignment with the specification.

Fixes: b795e68bf3073 ("i3c: mipi-i3c-hci: Correct RING_CTRL_ABORT handling in DMA dequeue")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260603090754.16252-3-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index e4daaa6120550d..bdffdd8b892368 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -554,7 +554,7 @@ static bool hci_dma_dequeue_xfer(struct i3c_hci *hci,
 	if (ring_status & RING_STATUS_RUNNING) {
 		/* stop the ring */
 		reinit_completion(&rh->op_done);
-		rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_ABORT);
+		rh_reg_write(RING_CONTROL, rh_reg_read(RING_CONTROL) | RING_CTRL_ABORT);
 		wait_for_completion_timeout(&rh->op_done, HZ);
 		ring_status = rh_reg_read(RING_STATUS);
 		if (ring_status & RING_STATUS_RUNNING) {
-- 
2.53.0



