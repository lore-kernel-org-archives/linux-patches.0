Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623AE13F435;
	Wed, 19 Jun 2024 13:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802916; cv=none; b=OOBMw/OhEvCfaL2T78DZWR/q64GCw99aMeysG0yPdnAstESPU3lDbWRTxO7UKkxbtXrstLlZlPMuA/LN5Kl0thrTQdAYg1zgCe7mMqGr6gb6j2zFOjyyJX0h3A7GQbyaw1n+jyO00Ct4Yz8jVsZN5nIbQPQPE7OUABp9ikJ9j80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802916; c=relaxed/simple;
	bh=alXwxlzL1N6Til8nNRq5Dp6M5p8xJz0cDS2ndNkrh1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9StuyzmtoQxql6dRiKPYkaiJLm5RhRPXx4ur/deO39MQbSL0Gb/dmKG1oHpYbAMgJHwA95SHzCvbRjsAvhObYRE6EknhXgtNIK/n6mRfAFQgMmJN6yXKXj6jnzvue5GzNbAmZ8alwkWlVvZwsWpA8oDlI6W5PRX1nGNhz7E4DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIZ8WSpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIZ8WSpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1A8C2BBFC;
	Wed, 19 Jun 2024 13:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802916;
	bh=alXwxlzL1N6Til8nNRq5Dp6M5p8xJz0cDS2ndNkrh1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIZ8WSpy39TDFTuXpZdqqa8xDomCmJlwP2Y9/vJTe38aq0eunud+tNZpkffZahuiy
	 M4zP4pGJ4BRd9XvLSCL+7x+869vmU4P3sOmUCNTndmaxBnKFhQfYyiuZk7ksBne3Qr
	 rEQVoPubrC/KEfTLwvHzFXqPp7HyWGJ0rUwi6/fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.9 091/281] serial: port: Dont block system suspend even if bytes are left to xmit
Date: Wed, 19 Jun 2024 14:54:10 +0200
Message-ID: <20240619125613.352391252@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

commit ca84cd379b45e9b1775b9e026f069a3a886b409d upstream.

Recently, suspend testing on sc7180-trogdor based devices has started
to sometimes fail with messages like this:

  port a88000.serial:0.0: PM: calling pm_runtime_force_suspend+0x0/0xf8 @ 28934, parent: a88000.serial:0
  port a88000.serial:0.0: PM: dpm_run_callback(): pm_runtime_force_suspend+0x0/0xf8 returns -16
  port a88000.serial:0.0: PM: pm_runtime_force_suspend+0x0/0xf8 returned -16 after 33 usecs
  port a88000.serial:0.0: PM: failed to suspend: error -16

I could reproduce these problems by logging in via an agetty on the
debug serial port (which was _not_ used for kernel console) and
running:
  cat /var/log/messages
...and then (via an SSH session) forcing a few suspend/resume cycles.

Tracing through the code and doing some printf()-based debugging shows
that the -16 (-EBUSY) comes from the recently added
serial_port_runtime_suspend().

The idea of the serial_port_runtime_suspend() function is to prevent
the port from being _runtime_ suspended if it still has bytes left to
transmit. Having bytes left to transmit isn't a reason to block
_system_ suspend, though. If a serdev device in the kernel needs to
block system suspend it should block its own suspend and it can use
serdev_device_wait_until_sent() to ensure bytes are sent.

The DEFINE_RUNTIME_DEV_PM_OPS() used by the serial_port code means
that the system suspend function will be pm_runtime_force_suspend().
In pm_runtime_force_suspend() we can see that before calling the
runtime suspend function we'll call pm_runtime_disable(). This should
be a reliable way to detect that we're called from system suspend and
that we shouldn't look for busyness.

Fixes: 43066e32227e ("serial: port: Don't suspend if the port is still busy")
Cc: stable@vger.kernel.org
Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240531080914.v3.1.I2395e66cf70c6e67d774c56943825c289b9c13e4@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_port.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/tty/serial/serial_port.c
+++ b/drivers/tty/serial/serial_port.c
@@ -63,6 +63,13 @@ static int serial_port_runtime_suspend(s
 	if (port->flags & UPF_DEAD)
 		return 0;
 
+	/*
+	 * Nothing to do on pm_runtime_force_suspend(), see
+	 * DEFINE_RUNTIME_DEV_PM_OPS.
+	 */
+	if (!pm_runtime_enabled(dev))
+		return 0;
+
 	uart_port_lock_irqsave(port, &flags);
 	if (!port_dev->tx_enabled) {
 		uart_port_unlock_irqrestore(port, flags);


