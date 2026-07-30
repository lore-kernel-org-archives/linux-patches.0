Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E6B3E95A8;
	Thu, 30 Jul 2026 15:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424687; cv=none; b=JJCpt6Js5coKOJaXjjAcdCleSfbI0BPF1Qwl0MP3/4XVmY3v9ti5DGqdEz9zvUvK4q3lKGt8j1wmgXw0Ov45/PzcGIiakI6EjMhMMgRyBS6Cej23z3wDAdt/Vauf/DnlF4RwXGcdamuWZRRdah5+hh+ZyWhgPBD24zR2CWatWcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424687; c=relaxed/simple;
	bh=cTiWqplc1ICrE8Oz0jkinddf7l9b0Xza7y5popjn6BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7C4ff02B9rotc/3cGyjiW6EctfCtHx5LgMQZJru9ZUZoFUpETGOLlHyOsYlUqmU/2VDotdFah5PoDihHhhMy5fpNWtF8RiEuCxOIDwyswrfKFvuM9cwgGWeRCvnKAAIyQRhGKv6HYUiTIGUScBoJuWW4Ld+p1rh/3IIfNLta7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0ziwjTm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0ziwjTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DAD1F000E9;
	Thu, 30 Jul 2026 15:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424686;
	bh=+USP2nKoLRU4K+w6UTAA0LvdSUSfHI9VRYjDqRn9sOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0ziwjTmBxKqo5nYflPWs7KKTofbdnsQp+mzkIQCW8YvN2b9F276tEOei9ONmGS+d
	 c2S+nqgeykwzj6HqvAiZJrbKyMCg9gkkYrvCHJmqg83kYJB/vyNU8kVH9zH5Giytw5
	 KDLdqO0dma9HmVwGYeJyFoseW5vNk/42AsTaxWbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f24c3d5d316011bacc70@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.18 481/675] comedi: comedi_parport: deal with premature interrupt
Date: Thu, 30 Jul 2026 16:13:31 +0200
Message-ID: <20260730141455.349210161@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -211,6 +211,13 @@ static irqreturn_t parport_interrupt(int
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
@@ -231,6 +238,9 @@ static int parport_attach(struct comedi_
 	if (ret)
 		return ret;
 
+	outb(0, dev->iobase + PARPORT_DATA_REG);
+	outb(0, dev->iobase + PARPORT_CTRL_REG);
+
 	if (it->options[1]) {
 		ret = request_irq(it->options[1], parport_interrupt, 0,
 				  dev->board_name, dev);
@@ -286,9 +296,6 @@ static int parport_attach(struct comedi_
 		s->cancel	= parport_intr_cancel;
 	}
 
-	outb(0, dev->iobase + PARPORT_DATA_REG);
-	outb(0, dev->iobase + PARPORT_CTRL_REG);
-
 	return 0;
 }
 


