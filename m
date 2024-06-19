Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4058382871;
	Wed, 19 Jun 2024 13:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802205; cv=none; b=KL4IJiPyfj86b6MRyYvxjJV5q55RfCEpXhMFU2cL0vbmPo0FK3zjbDjW9WiduIHK0q+ObVY/ZTAiYIzeR0lCtub4o/Ign03GlZW++X426lsV2/6BE6yhgDtmw51sDn7t5mG2GbmeiqfVY1Dzs1wq226/tVCMpSD5a/y3w4/agag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802205; c=relaxed/simple;
	bh=JJPP7MJgZbH+njx/bAV38YV4Fxeflfm2h+OqEIicuZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jauW9ovWhjlgI4GuKV2E66LSjYHv8AndnN30L1SmNJkksoi3YzVP+Hrx7hJbU9ttj1SOIRmAWHK7rKWILAof4DGKC4F3/ks/TJ3GYIzqdpC6GE2uUhb3rIqhTs4jDjdDtgOSRD4uV0v/9JbeyUsUgoNhd83x1EoJl6/zpOVrhj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUGg5VLQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUGg5VLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A1BC2BBFC;
	Wed, 19 Jun 2024 13:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802205;
	bh=JJPP7MJgZbH+njx/bAV38YV4Fxeflfm2h+OqEIicuZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUGg5VLQ1TBE/4smlf1xdx56dXR2xkisZsDd9ftTq3UWQnP5GftVdRt1nWDWpnZhu
	 Ki8DmsDYvsfLQyFxS1ojus2qo94reuoL3Uyf/VRbuoXrTugePGIVO+/RXVBL9VmmXo
	 ml2iqcdEgzF5PBo3yoaAuFVz5zyRtJZXRMSA3v14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.6 086/267] serial: port: Dont block system suspend even if bytes are left to xmit
Date: Wed, 19 Jun 2024 14:53:57 +0200
Message-ID: <20240619125609.651361774@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
@@ -60,6 +60,13 @@ static int serial_port_runtime_suspend(s
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


