Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975EA1C57B1;
	Tue, 15 Oct 2024 12:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993806; cv=none; b=DFlWO5IhEiG/aMI69hWjP6Ury1QWIlcapXC9XYroNkoYEaPheJLcupO59blFNSztU7JHWExt+EpkwmEgx8TSujiDo8+8D5qIm/Lf5tMI4KslNgu1IIqGhfGbV9w+Q7LtVyQt5pgHYcrY/5TZAUmLX/5wKk8uJcxFqffbWySvS5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993806; c=relaxed/simple;
	bh=WqsdEYdzAKXvx53Nx9jbcGWr2VQazqs3qq9Z2BRiuhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sn5qaCsZIBHCjI02OwzafdVJMEryTa7xxHvxfdrKyC/Ykt/vqfBNt7dfJfxTyHNC7NIjdzDb3GW7LzsnK6iDE8hk+Hh8uoCDdcG4BB/KpHQXTY1Hin9J/t4P2Y246HcSapon93k8D4bVL8WWd67HQ7t0+5sX/GdIxEgtOlYi4Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oX0Gg3fV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oX0Gg3fV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004A7C4CECE;
	Tue, 15 Oct 2024 12:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993806;
	bh=WqsdEYdzAKXvx53Nx9jbcGWr2VQazqs3qq9Z2BRiuhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oX0Gg3fVhfsTg2X6L9fifaYiQYo2pWcbxU/q2irPcx8iYTLf9W6Ud/6FQUtNeF4yy
	 gqM5Gd2cBz+gvlNe/U9Gazt2E/SMoa4zq2VQPMOYliOx3tFD8mhk3Ny0jj8SflSTjT
	 r74qbI9fo7L13GAeuHoEvxbGAlI7YNo4DVm6o6eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	Manikanta Guntupalli <manikanta.guntupalli@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 491/691] i2c: xiic: Wait for TX empty to avoid missed TX NAKs
Date: Tue, 15 Oct 2024 13:27:19 +0200
Message-ID: <20241015112459.830386592@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Hancock <robert.hancock@calian.com>

commit 521da1e9225450bd323db5fa5bca942b1dc485b7 upstream.

Frequently an I2C write will be followed by a read, such as a register
address write followed by a read of the register value. In this driver,
when the TX FIFO half empty interrupt was raised and it was determined
that there was enough space in the TX FIFO to send the following read
command, it would do so without waiting for the TX FIFO to actually
empty.

Unfortunately it appears that in some cases this can result in a NAK
that was raised by the target device on the write, such as due to an
unsupported register address, being ignored and the subsequent read
being done anyway. This can potentially put the I2C bus into an
invalid state and/or result in invalid read data being processed.

To avoid this, once a message has been fully written to the TX FIFO,
wait for the TX FIFO empty interrupt before moving on to the next
message, to ensure NAKs are handled properly.

Fixes: e1d5b6598cdc ("i2c: Add support for Xilinx XPS IIC Bus Interface")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Cc: <stable@vger.kernel.org> # v2.6.34+
Reviewed-by: Manikanta Guntupalli <manikanta.guntupalli@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-xiic.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -494,14 +494,17 @@ static irqreturn_t xiic_process(int irq,
 			goto out;
 		}
 
-		xiic_fill_tx_fifo(i2c);
-
-		/* current message sent and there is space in the fifo */
-		if (!xiic_tx_space(i2c) && xiic_tx_fifo_space(i2c) >= 2) {
+		if (xiic_tx_space(i2c)) {
+			xiic_fill_tx_fifo(i2c);
+		} else {
+			/* current message fully written */
 			dev_dbg(i2c->adap.dev.parent,
 				"%s end of message sent, nmsgs: %d\n",
 				__func__, i2c->nmsgs);
-			if (i2c->nmsgs > 1) {
+			/* Don't move onto the next message until the TX FIFO empties,
+			 * to ensure that a NAK is not missed.
+			 */
+			if (i2c->nmsgs > 1 && (pend & XIIC_INTR_TX_EMPTY_MASK)) {
 				i2c->nmsgs--;
 				i2c->tx_msg++;
 				xfer_more = 1;
@@ -512,11 +515,7 @@ static irqreturn_t xiic_process(int irq,
 					"%s Got TX IRQ but no more to do...\n",
 					__func__);
 			}
-		} else if (!xiic_tx_space(i2c) && (i2c->nmsgs == 1))
-			/* current frame is sent and is last,
-			 * make sure to disable tx half
-			 */
-			xiic_irq_dis(i2c, XIIC_INTR_TX_HALF_MASK);
+		}
 	}
 out:
 	dev_dbg(i2c->adap.dev.parent, "%s clr: 0x%x\n", __func__, clr);


