Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7790269B13;
	Tue,  8 Apr 2025 10:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109870; cv=none; b=SaVOV4WazASK/FXFjY90j7g18tSg+zUt+l1xG5ZiB0pxQs4EP4K0ZlyD3M+4kKz+OPGfj5JP9LoaUcJREhaN/IYUNUdYpPMmPwUH95fH57U5zaRh81e5/+GEiDbyt+MpMXJ8QcNSTim6Fe4C4ajo/BkhZn4L59Zd1hQ6VM0U38s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109870; c=relaxed/simple;
	bh=Qbvvfoq2D5dr0ZkZqbHe0OMCj8bg/LYXhVMmpH+krWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1AO1Ge8PWy3qe7/OIputDZubbjBRjeCffyIHNzTY2JRYzbLJgXvgGNTtrMONcyd0IEgdSZKT98R27a3TmBt0bVRhO5s95l4CaRLM1u01ulbupCWzItfEm2PlAXbxQUsFPZD0Ga3rQWn7ZM4+0Ug3bFayol7Nrhl4EJIIhILrfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksasht1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksasht1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73711C4CEE5;
	Tue,  8 Apr 2025 10:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109869;
	bh=Qbvvfoq2D5dr0ZkZqbHe0OMCj8bg/LYXhVMmpH+krWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksasht1bb9l43lU0hEk26Qaot5dbPrwuqhE/oVhZlGKIEAVka6nEhaU9gdVLQuDVZ
	 mbCTo09MWKOzz+R5xj/lb16riVp/FUceorxDBDFt/fZFfcmRX8sSUqUwb5Z83THS28
	 e1lYT6PbM7f5zrSXoJg/yGcmco6I+TQJrqpJBfgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Andreas Kemnade <andreas@kemnade.info>,
	Nishanth Menon <nm@ti.com>,
	Aniket Limaye <a-limaye@ti.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 081/227] i2c: omap: fix IRQ storms
Date: Tue,  8 Apr 2025 12:47:39 +0200
Message-ID: <20250408104822.818998915@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kemnade <andreas@kemnade.info>

commit 285df995f90e3d61d97f327d34b9659d92313314 upstream.

On the GTA04A5 writing a reset command to the gyroscope causes IRQ
storms because NACK IRQs are enabled and therefore triggered but not
acked.

Sending a reset command to the gyroscope by
i2cset 1 0x69 0x14 0xb6
with an additional debug print in the ISR (not the thread) itself
causes

[ 363.353515] i2c i2c-1: ioctl, cmd=0x720, arg=0xbe801b00
[ 363.359039] omap_i2c 48072000.i2c: addr: 0x0069, len: 2, flags: 0x0, stop: 1
[ 363.366180] omap_i2c 48072000.i2c: IRQ LL (ISR = 0x1110)
[ 363.371673] omap_i2c 48072000.i2c: IRQ (ISR = 0x0010)
[ 363.376892] omap_i2c 48072000.i2c: IRQ LL (ISR = 0x0102)
[ 363.382263] omap_i2c 48072000.i2c: IRQ LL (ISR = 0x0102)
[ 363.387664] omap_i2c 48072000.i2c: IRQ LL (ISR = 0x0102)
repeating till infinity
[...]
(0x2 = NACK, 0x100 = Bus free, which is not enabled)
Apparently no other IRQ bit gets set, so this stalls.

Do not ignore enabled interrupts and make sure they are acked.
If the NACK IRQ is not needed, it should simply not enabled, but
according to the above log, caring about it is necessary unless
the Bus free IRQ is enabled and handled. The assumption that is
will always come with a ARDY IRQ, which was the idea behind
ignoring it, proves wrong.
It is true for simple reads from an unused address.

To still avoid the i2cdetect trouble which is the reason for
commit c770657bd261 ("i2c: omap: Fix standard mode false ACK readings"),
avoid doing much about NACK in omap_i2c_xfer_data() which is used
by both IRQ mode and polling mode, so also the false detection fix
is extended to polling usage and IRQ storms are avoided.

By changing this, the hardirq handler is not needed anymore to filter
stuff.

The mentioned gyro reset now just causes a -ETIMEDOUT instead of
hanging the system.

Fixes: c770657bd261 ("i2c: omap: Fix standard mode false ACK readings").
CC: stable@kernel.org
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Tested-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Aniket Limaye <a-limaye@ti.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250228140420.379498-1-andreas@kemnade.info
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-omap.c |   26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1049,23 +1049,6 @@ static int omap_i2c_transmit_data(struct
 	return 0;
 }
 
-static irqreturn_t
-omap_i2c_isr(int irq, void *dev_id)
-{
-	struct omap_i2c_dev *omap = dev_id;
-	irqreturn_t ret = IRQ_HANDLED;
-	u16 mask;
-	u16 stat;
-
-	stat = omap_i2c_read_reg(omap, OMAP_I2C_STAT_REG);
-	mask = omap_i2c_read_reg(omap, OMAP_I2C_IE_REG) & ~OMAP_I2C_STAT_NACK;
-
-	if (stat & mask)
-		ret = IRQ_WAKE_THREAD;
-
-	return ret;
-}
-
 static int omap_i2c_xfer_data(struct omap_i2c_dev *omap)
 {
 	u16 bits;
@@ -1096,8 +1079,13 @@ static int omap_i2c_xfer_data(struct oma
 		}
 
 		if (stat & OMAP_I2C_STAT_NACK) {
-			err |= OMAP_I2C_STAT_NACK;
+			omap->cmd_err |= OMAP_I2C_STAT_NACK;
 			omap_i2c_ack_stat(omap, OMAP_I2C_STAT_NACK);
+
+			if (!(stat & ~OMAP_I2C_STAT_NACK)) {
+				err = -EAGAIN;
+				break;
+			}
 		}
 
 		if (stat & OMAP_I2C_STAT_AL) {
@@ -1475,7 +1463,7 @@ omap_i2c_probe(struct platform_device *p
 				IRQF_NO_SUSPEND, pdev->name, omap);
 	else
 		r = devm_request_threaded_irq(&pdev->dev, omap->irq,
-				omap_i2c_isr, omap_i2c_isr_thread,
+				NULL, omap_i2c_isr_thread,
 				IRQF_NO_SUSPEND | IRQF_ONESHOT,
 				pdev->name, omap);
 


