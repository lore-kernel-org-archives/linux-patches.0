Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA0943CE4B;
	Mon, 17 Aug 2026 14:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977147; cv=none; b=lj5Rn7CUcV8UZNOT7SJvlwm9EGnIdT6EtdO69KC+yx+2lR2d8DRLMppuOcT4djstfHM3ZlCsydbHEUILTDbN4C/zjtAugZrI//Xtd3kvCBT92qBPSeVqbmp0h5gFeCMhJg2xMUR+Ac5qNLcYZgt+hTH1mAJuEfPGHC3R7Ox2tCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977147; c=relaxed/simple;
	bh=yf0ZFz9L6BxoCCQt+lrWaVIXJXRhfHiH6iR4GTt0j9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObdUhwKhV3C826PjKKu0e7YgSxluwkr7PoNnHyqqOBu3O0a78fjvBv8BCXfI3kcuDj4mhF383LpX9zd9+FE1mC9bwCwbevv9wGzxjfryqApCvE8AuL8ascvYcXOWXbKJLynheiM8ZRr4FSXNSDDUPlFbQHJDnkk/6j6hlVB18Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5ran1OL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5ran1OL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261441F00A3A;
	Mon, 17 Aug 2026 14:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977145;
	bh=iu0RbXmmLZcI7f2oVkDcnHnnEx3PiG7G3vNI+JDJFjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5ran1OLTORWleVbAVcNMWaPGAT2Qnj9yOBld8Bxx34XhchHBVLxgTtTBU1HqncY6
	 J4TUYrzg87nGKa/nXyKq8IdMICxubiDA95RSxBYLW6oYGdGYIDEeU/iquSPttvwGmj
	 z3kb1pHGNYsIdJk8lQY17VxxXCY07s7mWIpDledc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f24c3d5d316011bacc70@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.15 189/456] comedi: comedi_parport: deal with premature interrupt
Date: Mon, 17 Aug 2026 15:29:39 +0200
Message-ID: <20260817132547.514614416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 17221216ae8ce6a24e8a4e787382e3ebc81b88a8 upstream.

Syzbot reported a general protection fault in
`comedi_get_is_subdevice_running()`, which was called from the interrupt
handler `parport_interrupt()` in the "comedi_parport" driver, but it
does not currently have a C reproducer for the problem.  It's
probably due to a premature interrupt for one of two reasons:

1. The driver sets up the interrupt handler before the comedi subdevices
   used by the interrupt handler have been allocated, but does not
   disable the interrupt in the parallel port's CTRL register first.
2. The driver uses a user-supplied I/O port base address which Syzbot
   would have supplied, but it might not be backed by real parallel port
   hardware.

Change the initialization order in the driver's comedi "attach" handler
(`parport_attach()`) so that the hardware registers are initialized
before the interrupt handler is requested.  This should prevent
premature interrupts occurring for real hardware.

Also add a test to the interrupt handler to ensure the comedi device is
fully attached and return early if it isn't.

Fixes: 241ab6ad7108e ("Staging: comedi: add comedi_parport driver")
Reported-by: syzbot+f24c3d5d316011bacc70@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260527125104.96596-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/comedi_parport.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/comedi/drivers/comedi_parport.c
+++ b/drivers/comedi/drivers/comedi_parport.c
@@ -212,6 +212,13 @@ static irqreturn_t parport_interrupt(int
 	unsigned int ctrl;
 	unsigned short val = 0;
 
+	/*
+	 * Check device is fully attached.  Device interrupts should have
+	 * been disabled, but do this in case of bad hardware.
+	 */
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	ctrl = inb(dev->iobase + PARPORT_CTRL_REG);
 	if (!(ctrl & PARPORT_CTRL_IRQ_ENA))
 		return IRQ_NONE;
@@ -232,6 +239,9 @@ static int parport_attach(struct comedi_
 	if (ret)
 		return ret;
 
+	outb(0, dev->iobase + PARPORT_DATA_REG);
+	outb(0, dev->iobase + PARPORT_CTRL_REG);
+
 	if (it->options[1]) {
 		ret = request_irq(it->options[1], parport_interrupt, 0,
 				  dev->board_name, dev);
@@ -287,9 +297,6 @@ static int parport_attach(struct comedi_
 		s->cancel	= parport_intr_cancel;
 	}
 
-	outb(0, dev->iobase + PARPORT_DATA_REG);
-	outb(0, dev->iobase + PARPORT_CTRL_REG);
-
 	return 0;
 }
 


