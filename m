Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CD1470450;
	Fri,  9 Oct 2026 14:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556850; cv=none; b=kUUCdzQJ4B6ZtAGIZWvyOWTcnSyzmIT7vr7PtCpGJ7vvyMgY3DkwOYz1w6lYDIEAeLB7LKHuCyzYyTdLmSdTb4X+u8/+d8vvtGAkqLT4ZEP1wC4eG6+3V2qzBzzsmgdLHIXZIEA08PDPvUQDmAOSLbc2o2JDeksECNNm7YCgSp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556850; c=relaxed/simple;
	bh=zESyKwx94RfVGR23b8a1cVnVVlHyR278s+4nMEmbq64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ix18ppHjsEPQLtJvjGIsWgGwZWdMtccsquZVNqPSdn7bjFAun8bs8q/yZWFLXJhGlRkGPjhC1IWpLur731NWfDRyIxIf2qBPMS6lDPzMbjzhwMmQQbUWkj9ku5k+68Y25iXW6nYi5SID8N8GTI+qUBU+CJ+i8reG3wYmlvIg98Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CX5e4LeT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CX5e4LeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8D11F000FF;
	Fri,  9 Oct 2026 14:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556849;
	bh=gePhDVg88QxLjNy8p0PnwLTyzXnVchhmpGY3Xx471i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CX5e4LeTGi6K1tbcTk8+nxPNUuOVqHmAQ6WLo6evQqvgSPu1NwnlQ1o/gFVj7bEJh
	 7YxkHQq5P7tAankQr+tZ87dyyy7yjEEPqRDzCQyswIPYPkvAKfgT3UndGzdYO+swGB
	 GsUBxLcvFmqTJmaZF49sXdvGkgB1j1zXQGL+myK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9f57c1b2792029198fcf@syzkaller.appspotmail.com,
	stable@kernel.org,
	Ruslan Valiyev <linuxoid@gmail.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>
Subject: [PATCH 7.2 252/428] serial: core: fix NULL pointer dereference in serial_core_unregister_port()
Date: Fri,  9 Oct 2026 16:09:49 +0200
Message-ID: <20261009140951.640530062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruslan Valiyev <linuxoid@gmail.com>

commit 499485a67fbacf4d9afbdb43522388c64f853428 upstream.

port->port_dev is NULL when no port device is installed: it is cleared
on teardown, and never set if registration failed before
serial_core_port_device_add().  serial_core_unregister_port() passes it
straight to serial_core_get_ctrl_dev(), which dereferences it:

  KASAN: null-ptr-deref in range [0x0000000000000040-0x0000000000000047]
  RIP: serial_core_unregister_port
  Call Trace:
   serial8250_unregister_port
   serial8250_remove
   unbind_store

Return early when there is no port device, and read port->port_dev
under port_mutex.

Also clear port->port_dev on the serial_core_register_port() error
path, where the port device has already been removed.

Fixes: 84a9582fd203 ("serial: core: Start managing serial controllers to enable runtime PM")
Reported-by: syzbot+9f57c1b2792029198fcf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9f57c1b2792029198fcf
Cc: stable@kernel.org
Assisted-by: Claude:claude-opus-5
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>
Link: https://syzkaller.appspot.com/bug?extid=9f57c1b2792029198fcf
Link: https://lore.kernel.org/all/20260826073237.1377668-1-linuxoid@gmail.com/
Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Link: https://patch.msgid.link/20260826084654.1392851-1-linuxoid@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3336,6 +3336,7 @@ int serial_core_register_port(struct uar
 
 err_unregister_port_dev:
 	serial_base_port_device_remove(port->port_dev);
+	port->port_dev = NULL;
 
 err_unregister_ctrl_dev:
 	serial_base_ctrl_device_remove(new_ctrl_dev);
@@ -3350,12 +3351,24 @@ err_unregister_ctrl_dev:
 void serial_core_unregister_port(struct uart_driver *drv, struct uart_port *port)
 {
 	struct device *phys_dev = port->dev;
-	struct serial_port_device *port_dev = port->port_dev;
-	struct serial_ctrl_device *ctrl_dev = serial_core_get_ctrl_dev(port_dev);
+	struct serial_port_device *port_dev;
+	struct serial_ctrl_device *ctrl_dev;
 	int ctrl_id = port->ctrl_id;
 
 	guard(mutex)(&port_mutex);
 
+	/*
+	 * A NULL port device means there is no registered port device to
+	 * remove: serial_core_remove_one_port() clears port_dev on
+	 * teardown, and it is never set if registration failed before
+	 * serial_core_port_device_add().
+	 */
+	port_dev = port->port_dev;
+	if (!port_dev)
+		return;
+
+	ctrl_dev = serial_core_get_ctrl_dev(port_dev);
+
 	port->flags |= UPF_DEAD;
 
 	serial_core_remove_one_port(drv, port);


