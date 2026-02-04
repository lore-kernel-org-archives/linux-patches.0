Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EC941B36C;
	Wed,  4 Feb 2026 15:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217783; cv=none; b=f3JFNNigUdaWgvaV+/fwDHrujn8cc4IQedvLBSb+gBqYly0CcCspCSvkFXpjEPS8rq4E4zfx8rxPEETSCQD7dQonly8Kp1sDbbGDDD2VstuA3eZqaQAV+/sEG+RK4x+3GeGlMW3+4oikazTz48x0ZkdXiC/fk5QeX4vm/aldB3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217783; c=relaxed/simple;
	bh=Q9zya9JzxxAPzgjcGZtA7QmDMdT8QWyBDJO9cxesbk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqfXyJbJT6MYn6UgqWKl0Q5RxxkPBOjcYUShX7kF1WjI8KBMDIrk5fhuZ0k5JOoN8YByDI1uSENZs3tlFRy0y75S0vCNEVTUkTvbClCRYsQ8fGsu8/1BKAnpQXpxi8y/fwlheX+qkhALvT5vEoeKLq88w72WeOdOkKBwoJDnBTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=do5vSlb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="do5vSlb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E60CC4CEF7;
	Wed,  4 Feb 2026 15:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217782;
	bh=Q9zya9JzxxAPzgjcGZtA7QmDMdT8QWyBDJO9cxesbk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=do5vSlb2FYyziDFAYDQ/X5FIWP9GXalpBPNrLb+Oad1RV8iUtbEHgB2ypphcs/7jI
	 3QkXbXcL6MDp9VTGog4ub9H72s/C0WdaWm+tvF8MH7oRJmkEy1vNN+8fJNQ4gEwnrC
	 dKrMWUO4UURkmoWsTyx7hH4N+mHaLnGsIDbRb6xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.1 116/280] comedi: dmm32at: serialize use of paged registers
Date: Wed,  4 Feb 2026 15:38:10 +0100
Message-ID: <20260204143913.815595197@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/comedi/drivers/dmm32at.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/drivers/comedi/drivers/dmm32at.c
+++ b/drivers/comedi/drivers/dmm32at.c
@@ -330,6 +330,7 @@ static int dmm32at_ai_cmdtest(struct com
 
 static void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
 {
+	unsigned long irq_flags;
 	unsigned char lo1, lo2, hi2;
 	unsigned short both2;
 
@@ -342,6 +343,9 @@ static void dmm32at_setaitimer(struct co
 	/* set counter clocks to 10MHz, disable all aux dio */
 	outb(0, dev->iobase + DMM32AT_CTRDIO_CFG_REG);
 
+	/* serialize access to control register and paged registers */
+	spin_lock_irqsave(&dev->spinlock, irq_flags);
+
 	/* get access to the clock regs */
 	outb(DMM32AT_CTRL_PAGE_8254, dev->iobase + DMM32AT_CTRL_REG);
 
@@ -354,6 +358,8 @@ static void dmm32at_setaitimer(struct co
 	outb(lo2, dev->iobase + DMM32AT_CLK2);
 	outb(hi2, dev->iobase + DMM32AT_CLK2);
 
+	spin_unlock_irqrestore(&dev->spinlock, irq_flags);
+
 	/* enable the ai conversion interrupt and the clock to start scans */
 	outb(DMM32AT_INTCLK_ADINT |
 	     DMM32AT_INTCLK_CLKEN | DMM32AT_INTCLK_CLKSEL,
@@ -363,13 +369,19 @@ static void dmm32at_setaitimer(struct co
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
@@ -429,8 +441,13 @@ static irqreturn_t dmm32at_isr(int irq,
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
 
@@ -481,14 +498,25 @@ static int dmm32at_ao_insn_write(struct
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


