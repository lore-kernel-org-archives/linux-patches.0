Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDC11DED6F;
	Tue,  8 Oct 2024 13:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393625; cv=none; b=vDgj6cpyuBul5e2oq03bL/U0+wlwQS9JP58dWgwpKv6kHLrlpwjBi8+ZvRgFbK18Jw77rpi+ULovYEnuq8FmwBmLiJRckQRivZKDCTg5P035FtMU5b7+SAg1kmF3zBx+GUHD7xy4tYk54d/F3fRRgQ+bij8L6c8+7DNjTeD+7S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393625; c=relaxed/simple;
	bh=kORK4qc3BvYUv0hdqw2t9u2xSQmnKDD40KILabS4bNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTuJ0xiMA+qdowpNaxAlitkt3h6Yck7UORdBDFs8DfmpDuI/Jo23eFiZTVl0KPbWNTuHFKCY5p6qX6F/n9aU4cnoknnfNeUkXXZ62qYJpWhpzpsvcGH5TAKCDTJ4JO52FPkSuDRgei+vxatxHfwFAoSwj7D0TWASr6tpQLIv5DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caq/8lEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caq/8lEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF32C4CEC7;
	Tue,  8 Oct 2024 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393625;
	bh=kORK4qc3BvYUv0hdqw2t9u2xSQmnKDD40KILabS4bNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caq/8lEtds592gN7NHgLZeScsm/yCauplSL202LLtN8Q2gXZRxMyNebw3XFgqCDvh
	 /KcQGQvS2KrurATtNtzwiKk7MriWrG8jNNbSDQCuqN+gFLqlX3IKB9c7uA+G4BiRgV
	 6d7oyfjdBHGwZSH20TRXOECV2kwWMza9r6Q5QvGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	Manikanta Guntupalli <manikanta.guntupalli@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 208/386] i2c: xiic: Wait for TX empty to avoid missed TX NAKs
Date: Tue,  8 Oct 2024 14:07:33 +0200
Message-ID: <20241008115637.591714149@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
@@ -772,14 +772,17 @@ static irqreturn_t xiic_process(int irq,
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
@@ -790,11 +793,7 @@ static irqreturn_t xiic_process(int irq,
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
 
 	if (pend & XIIC_INTR_BNB_MASK) {


