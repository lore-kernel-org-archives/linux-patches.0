Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE05143888;
	Tue, 23 Apr 2024 21:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908633; cv=none; b=MB/Xy1ZdbZl2ckUCmdNXxagaw0KK/M+V7gFBlZLbk/RkU0qlez2SLJNiAvL9bNSrBlwPFuJFaiidCs3ewkbDNibogwojSH8UfBxTcjyYvYR576+6IEAU4eu0+WOykPkxJLCvbJT88Di4sWuaLCgj4o5ObFwg1CV+c1mUxHELM8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908633; c=relaxed/simple;
	bh=jsaM5oU1fwbv0OwfNF8oaMkpQ1xompy4OkJDJH4Q9eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cg4qj05EcUK+EIbkdOcOVN2Oa7i07/G3PqpFjMMhtbTSQwWuBl6zrdx6Sj9X2bh3oIWl1i+XRadvalKgcq3riQSRw6iK5a4miENqYUeJcGZr0S5A8kQx1vTktKvz/kdWZ2nyFEWB2hPx1CrRbW+qgrH5pxnCXBSCeDcv0HZMHd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8wWelJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8wWelJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86BDC32782;
	Tue, 23 Apr 2024 21:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908633;
	bh=jsaM5oU1fwbv0OwfNF8oaMkpQ1xompy4OkJDJH4Q9eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8wWelJT1rt8oDvIY+oqbXRJj61M0pY2JOKI+g9u7G9kWWjTCvPF4WETZYWVIMEKS
	 EeAs4rSdE2+jY22ydCQKUuk1e4rQBVW3GAtuXn7TM704f3yLIzSDWUidcx0yQWaR2b
	 DU5uaThaaUPmTOtgBabFnMaahDP8+nhdS0M1lyE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	kernel test robot <oliver.sang@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.6 113/158] serial: core: Clearing the circular buffer before NULLifying it
Date: Tue, 23 Apr 2024 14:39:10 -0700
Message-ID: <20240423213859.416573484@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 9cf7ea2eeb745213dc2a04103e426b960e807940 upstream.

The circular buffer is NULLified in uart_tty_port_shutdown()
under the spin lock. However, the PM or other timer based callbacks
may still trigger after this event without knowning that buffer pointer
is not valid. Since the serial code is a bit inconsistent in checking
the buffer state (some rely on the head-tail positions, some on the
buffer pointer), it's better to have both aligned, i.e. buffer pointer
to be NULL and head-tail possitions to be the same, meaning it's empty.
This will prevent asynchronous calls to dereference NULL pointer as
reported recently in 8250 case:

  BUG: kernel NULL pointer dereference, address: 00000cf5
  Workqueue: pm pm_runtime_work
  EIP: serial8250_tx_chars (drivers/tty/serial/8250/8250_port.c:1809)
  ...
  ? serial8250_tx_chars (drivers/tty/serial/8250/8250_port.c:1809)
  __start_tx (drivers/tty/serial/8250/8250_port.c:1551)
  serial8250_start_tx (drivers/tty/serial/8250/8250_port.c:1654)
  serial_port_runtime_suspend (include/linux/serial_core.h:667 drivers/tty/serial/serial_port.c:63)
  __rpm_callback (drivers/base/power/runtime.c:393)
  ? serial_port_remove (drivers/tty/serial/serial_port.c:50)
  rpm_suspend (drivers/base/power/runtime.c:447)

The proposed change will prevent ->start_tx() to be called during
suspend on shut down port.

Fixes: 43066e32227e ("serial: port: Don't suspend if the port is still busy")
Cc: stable <stable@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202404031607.2e92eebe-lkp@intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240404150034.41648-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1782,6 +1782,7 @@ static void uart_tty_port_shutdown(struc
 	 * Free the transmit buffer.
 	 */
 	spin_lock_irq(&uport->lock);
+	uart_circ_clear(&state->xmit);
 	buf = state->xmit.buf;
 	state->xmit.buf = NULL;
 	spin_unlock_irq(&uport->lock);


