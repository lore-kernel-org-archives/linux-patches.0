Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A9623EAB7;
	Wed, 28 Jan 2026 15:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614442; cv=none; b=oJYtYbHRbCOE/wHKJzdrlfdeZBVkJbdYyRKEig+nw4lDZR+Z9tYDN6WJ7o/tJpXq1xMJf6TDTynXahPMT72J5merO4FIljeZ354sXrRlXu9KAxRexh6flIXYZSjE4iLChzQUuzLaDdq7dymTUmpU6P1NtDbh2v8N9/zxyG0l48s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614442; c=relaxed/simple;
	bh=NourgyrRn74PAkGG9nXj+essKIqEe0fmhHOeEEnH9K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0W4e8XGxqXZYcgdN6/jBBAdfxCNk2AKiua6HcFMg8b/Be2aQ2/XhHvz0To+kKpv9ebkwrYzDMLG0ObqpLBGUDXRZ8Y4nfopv3aQlmTtRG9Mbjo9CvT+lgGwUJEc4AKTsgxKvy98XAXSwehdhZGSR8pDVp8F+x6aLtMOfShBeWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwUXXB/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwUXXB/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BF2C4CEF1;
	Wed, 28 Jan 2026 15:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614442;
	bh=NourgyrRn74PAkGG9nXj+essKIqEe0fmhHOeEEnH9K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwUXXB/GbwK0+X6CgeETFFyf29ePBp9BK3yCm+KVBskDfOZFA/Y/fGpJehoZHI0i/
	 xDVmCIUj3AXJbwdO2MpbMduK88cAd5uYPIC3SSNUfOP2R3Kd5DIrQSlS6vBSOci+jF
	 BQlCSgqW8V7ANAg4hMpEX2BUL3vvo2ujGRQMhM7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.6 136/254] comedi: dmm32at: serialize use of paged registers
Date: Wed, 28 Jan 2026 16:21:52 +0100
Message-ID: <20260128145349.712501757@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


