Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8339446D5;
	Mon,  1 Apr 2024 16:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988723; cv=none; b=ihVHcnQkBAHart6gHK6iJOc2jzVO73pjwXtw4VDsjvXNX3GLhnBw3iWyvV3noIdBNHZxqIXZfWwGBUFztaSplBhIBABTjifTIuJi75ScJrp424DjEaQo9eoHjF3cmYhzFYj/i0bebJdkoVEwGVHfiyTCbJh8bociWSzB38gw8KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988723; c=relaxed/simple;
	bh=bAZHJmUBM8FQoHS7UtTF6BauW+4J2C1E+ho7gRNH3kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MpOHciryUSeM+6uaz5L/DzLv8YtUChzb73jDK8q6boVufo5ea7Qq86Q80ERE4BmRzgr9huTVjyG3xAboO1useWw8CUgWegoFc/TfsWQ5he4/tpBTE0bTuNFD9IL+XjaWrF0NH5nT+ijvRsvFLgvRpECVz8dkeLdLxPSRF/dRJ4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1lk3NjA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1lk3NjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499B7C433F1;
	Mon,  1 Apr 2024 16:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988723;
	bh=bAZHJmUBM8FQoHS7UtTF6BauW+4J2C1E+ho7gRNH3kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1lk3NjAaw+izWqM8gbIBkWFrbkdg9Xb4CWe3mhoDhGxLBeyRrtrAYrLBa2BFew1s
	 FyvZg5Fa+eKzDceqWG+cNPbxxKMv7qTgVmB8PgiWLfHIsMYsU7VkPIiZXjbeZfOsD9
	 xOxEehH6pcuZJpulsFW572hLGG0NnMF570h7GGEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Yicong Yang <yangyicong@hisilicon.com>
Subject: [PATCH 6.7 270/432] serial: port: Dont suspend if the port is still busy
Date: Mon,  1 Apr 2024 17:44:17 +0200
Message-ID: <20240401152601.230073965@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yangyicong@hisilicon.com>

commit 43066e32227ecde674e8ae1fcdd4a1ede67680c2 upstream.

We accidently met the issue that the bash prompt is not shown after the
previous command done and until the next input if there's only one CPU
(In our issue other CPUs are isolated by isolcpus=). Further analysis
shows it's because the port entering runtime suspend even if there's
still pending chars in the buffer and the pending chars will only be
processed in next device resuming. We are using amba-pl011 and the
problematic flow is like below:

Bash                                         kworker
tty_write()
  file_tty_write()
    n_tty_write()
      uart_write()
        __uart_start()
          pm_runtime_get() // wakeup waker
            queue_work()
                                             pm_runtime_work()
                                               rpm_resume()
                                                status = RPM_RESUMING
                                                serial_port_runtime_resume()
                                                  port->ops->start_tx()
                                                    pl011_tx_chars()
                                                      uart_write_wakeup()
        […]
        __uart_start()
          pm_runtime_get() < 0 // because runtime status = RPM_RESUMING
                               // later data are not commit to the port driver
                                                status = RPM_ACTIVE
                                                rpm_idle() -> rpm_suspend()

This patch tries to fix this by checking the port busy before entering
runtime suspending. A runtime_suspend callback is added for the port
driver. When entering runtime suspend the callback is invoked, if there's
still pending chars in the buffer then flush the buffer.

Fixes: 84a9582fd203 ("serial: core: Start managing serial controllers to enable runtime PM")
Cc: stable <stable@kernel.org>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20240226152351.40924-1-yangyicong@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_port.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_port.c
+++ b/drivers/tty/serial/serial_port.c
@@ -46,8 +46,31 @@ out:
 	return 0;
 }
 
+static int serial_port_runtime_suspend(struct device *dev)
+{
+	struct serial_port_device *port_dev = to_serial_base_port_device(dev);
+	struct uart_port *port = port_dev->port;
+	unsigned long flags;
+	bool busy;
+
+	if (port->flags & UPF_DEAD)
+		return 0;
+
+	uart_port_lock_irqsave(port, &flags);
+	busy = __serial_port_busy(port);
+	if (busy)
+		port->ops->start_tx(port);
+	uart_port_unlock_irqrestore(port, flags);
+
+	if (busy)
+		pm_runtime_mark_last_busy(dev);
+
+	return busy ? -EBUSY : 0;
+}
+
 static DEFINE_RUNTIME_DEV_PM_OPS(serial_port_pm,
-				 NULL, serial_port_runtime_resume, NULL);
+				 serial_port_runtime_suspend,
+				 serial_port_runtime_resume, NULL);
 
 static int serial_port_probe(struct device *dev)
 {


