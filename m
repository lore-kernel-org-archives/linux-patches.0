Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DC614389E;
	Tue, 23 Apr 2024 21:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908519; cv=none; b=IQZQWzKR4VBO0CSSHGPqc7XG564O5OqjQXwiHVt84GoCI+06BECHERCEh1htAHQGGIm4CLRx5AALVw5ge8Z4hspaohMdxTLoDqk/KrRlzr6jIA7Td7zemLm11vRn3aWFO0uDUKzbvHMi9ibXw2bmEiwMrP8Nmv/GsTEbgiqUXGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908519; c=relaxed/simple;
	bh=LbnetHrY63/kNcC+ga5wC5L5zR/PmHSZ2QQwoyWQuVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIUzldhi84oHxLSRB7Z16M5IoGveqedxMHX9N6gB+GTZ1VtHZ4RqNyPxENFuGGK/Ccl4TWGNrH4LyCVc868YHmhXIQKVPkZcCAKQ9sLJQ7NOlNb1RuQXIV0q7jBntQU/44o+uUW4TelI5AKEO1Vu6vIMfknOgX0nMkwJHH57wHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8zN/HMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8zN/HMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2B1C32781;
	Tue, 23 Apr 2024 21:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908519;
	bh=LbnetHrY63/kNcC+ga5wC5L5zR/PmHSZ2QQwoyWQuVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8zN/HMJj+Kxe4LbaXa0VyaWeBDbPk96ceTIIho+I9jN0R0TlZ4PgvtjqjVmjyE/t
	 XHVFc1ZoRpWQqd3llDvHbB53zf6APCJZ1kbLG3p19In5mKiFQaf1z4ZxsDj0f/jzaC
	 NVhgTlAH2YMhTmn1kLLhPOrn1qNpj85S+HPKmyZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	kernel test robot <oliver.sang@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.8 107/158] serial: core: Clearing the circular buffer before NULLifying it
Date: Tue, 23 Apr 2024 14:38:49 -0700
Message-ID: <20240423213859.416046605@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1788,6 +1788,7 @@ static void uart_tty_port_shutdown(struc
 	 * Free the transmit buffer.
 	 */
 	uart_port_lock_irq(uport);
+	uart_circ_clear(&state->xmit);
 	buf = state->xmit.buf;
 	state->xmit.buf = NULL;
 	uart_port_unlock_irq(uport);


