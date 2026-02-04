Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475A82BE056;
	Wed,  4 Feb 2026 14:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216474; cv=none; b=Tqc0lG7tsEIbweETO9f5AfPDmJgdm+0H2gqwytMVdSj281Lu7TAsCTvshZiTaOpoZmvtb/0XQBD5cQcq9Rdi7jtOBPGb0COxrQncnxQBR7toSGNllGGBfpMDg//eW8GvA3t/lXhHudWglP2cYn8kH3ZMVKB118/NYhioqO3x4FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216474; c=relaxed/simple;
	bh=7UuCj/36J80PeFpoUxPxXLivIm71QdCkGPTMOzw0FzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVZr8DbU4G6LeHKF1QCtbD9oNK5WGiNeRqFUI9BOAdIf3n3u2L7lBQzCeKTZKAnXiPMd7FCFaEi4D8z7C3Xwpcl1kqCGhVLXKGwgGLLH1CNWuz6cEJpFE3ui094o7KbvG9IZozBpDBZrtPGbW1XjKS29cZ/qpAyPit3atn8qups=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mil4ilba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mil4ilba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66291C4CEF7;
	Wed,  4 Feb 2026 14:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216473;
	bh=7UuCj/36J80PeFpoUxPxXLivIm71QdCkGPTMOzw0FzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mil4ilbaL27zuseIMkYYqfXUiwUZVy2ROAgPn8o7K6tmWBlQayDWl9e4iy7aFbQGQ
	 Dg2tHhWKZNPGu6bsBA9guc9TEtg+FYQwJKynzIVFGarxPEyswDRaYUtOzg4BQUjLBW
	 LvhOxlTHAXENtBkMMvFyPwgs14rN5UmrScIR2ZmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.10 065/161] comedi: dmm32at: serialize use of paged registers
Date: Wed,  4 Feb 2026 15:38:48 +0100
Message-ID: <20260204143854.097022191@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit e03b29b55f2b7c345a919a6ee36633b06bf3fb56 upstream.

Some of the hardware registers of the DMM-32-AT board are multiplexed,
using the least significant two bits of the Miscellaneous Control
register to select the function of registers at offsets 12 to 15:

 00 => 8254 timer/counter registers are accessible
 01 => 8255 digital I/O registers are accessible
 10 => Reserved
 11 => Calibration registers are accessible

The interrupt service routine (`dmm32at_isr()`) clobbers the bottom two
bits of the register with value 00, which would interfere with access to
the 8255 registers by the `dm32at_8255_io()` function (used for Comedi
instruction handling on the digital I/O subdevice).

Make use of the generic Comedi device spin-lock `dev->spinlock` (which
is otherwise unused by this driver) to serialize access to the
miscellaneous control register and paged registers.

Fixes: 3c501880ac44 ("Staging: comedi: add dmm32at driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260112162835.91688-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dmm32at.c |   32 +++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -331,6 +331,7 @@ static int dmm32at_ai_cmdtest(struct com
 
 static void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
 {
+	unsigned long irq_flags;
 	unsigned char lo1, lo2, hi2;
 	unsigned short both2;
 
@@ -343,6 +344,9 @@ static void dmm32at_setaitimer(struct co
 	/* set counter clocks to 10MHz, disable all aux dio */
 	outb(0, dev->iobase + DMM32AT_CTRDIO_CFG_REG);
 
+	/* serialize access to control register and paged registers */
+	spin_lock_irqsave(&dev->spinlock, irq_flags);
+
 	/* get access to the clock regs */
 	outb(DMM32AT_CTRL_PAGE_8254, dev->iobase + DMM32AT_CTRL_REG);
 
@@ -355,6 +359,8 @@ static void dmm32at_setaitimer(struct co
 	outb(lo2, dev->iobase + DMM32AT_CLK2);
 	outb(hi2, dev->iobase + DMM32AT_CLK2);
 
+	spin_unlock_irqrestore(&dev->spinlock, irq_flags);
+
 	/* enable the ai conversion interrupt and the clock to start scans */
 	outb(DMM32AT_INTCLK_ADINT |
 	     DMM32AT_INTCLK_CLKEN | DMM32AT_INTCLK_CLKSEL,
@@ -364,13 +370,19 @@ static void dmm32at_setaitimer(struct co
 static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	struct comedi_cmd *cmd = &s->async->cmd;
+	unsigned long irq_flags;
 	int ret;
 
 	dmm32at_ai_set_chanspec(dev, s, cmd->chanlist[0], cmd->chanlist_len);
 
+	/* serialize access to control register and paged registers */
+	spin_lock_irqsave(&dev->spinlock, irq_flags);
+
 	/* reset the interrupt just in case */
 	outb(DMM32AT_CTRL_INTRST, dev->iobase + DMM32AT_CTRL_REG);
 
+	spin_unlock_irqrestore(&dev->spinlock, irq_flags);
+
 	/*
 	 * wait for circuit to settle
 	 * we don't have the 'insn' here but it's not needed
@@ -430,8 +442,13 @@ static irqreturn_t dmm32at_isr(int irq,
 		comedi_handle_events(dev, s);
 	}
 
+	/* serialize access to control register and paged registers */
+	spin_lock(&dev->spinlock);
+
 	/* reset the interrupt */
 	outb(DMM32AT_CTRL_INTRST, dev->iobase + DMM32AT_CTRL_REG);
+
+	spin_unlock(&dev->spinlock);
 	return IRQ_HANDLED;
 }
 
@@ -482,14 +499,25 @@ static int dmm32at_ao_insn_write(struct
 static int dmm32at_8255_io(struct comedi_device *dev,
 			   int dir, int port, int data, unsigned long regbase)
 {
+	unsigned long irq_flags;
+	int ret;
+
+	/* serialize access to control register and paged registers */
+	spin_lock_irqsave(&dev->spinlock, irq_flags);
+
 	/* get access to the DIO regs */
 	outb(DMM32AT_CTRL_PAGE_8255, dev->iobase + DMM32AT_CTRL_REG);
 
 	if (dir) {
 		outb(data, dev->iobase + regbase + port);
-		return 0;
+		ret = 0;
+	} else {
+		ret = inb(dev->iobase + regbase + port);
 	}
-	return inb(dev->iobase + regbase + port);
+
+	spin_unlock_irqrestore(&dev->spinlock, irq_flags);
+
+	return ret;
 }
 
 /* Make sure the board is there and put it to a known state */


