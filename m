Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3893C30BBA5;
	Wed, 28 Jan 2026 15:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615578; cv=none; b=Z0BJ+4tz4r091osq46vVMHi9SEiJkdSKX81tLXWDMoJ0hry+05jLw25S9tRjHQG/nfPGiDKb7EU/sqoRMFPJWea4NkssBEezeUV+rIDHOBJAOdik1VZ7YY1brNygWRWlJkO3cA0+bo5mzaa0jBmmy5mZWJVubdL/ggEEiTLkYb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615578; c=relaxed/simple;
	bh=y1F3T6ZHbZm7HAKTCnws6YrmZOgvTQoL05FxKJwv164=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sH+Wjt14rvzYlVzZ5TdrTqcNQVFfGd3UfxD5PpgwsGWO4u4cfI2IQm+VIPmrFSvk1vCj8nqAoVnTR11ce/Yx+jGBcbbivRP4g/D6Kj4Lh1YqJGHbBOoQCIRYbiGOf0zBAYjLDv8xkkn4rYRlVejylw6TOLSt+zy2k56ah5nLxRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bb/0ua3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bb/0ua3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A112AC116C6;
	Wed, 28 Jan 2026 15:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615578;
	bh=y1F3T6ZHbZm7HAKTCnws6YrmZOgvTQoL05FxKJwv164=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bb/0ua3iqwWzZrHfowecSqKWm7JULxkafwE+LegwL2JCWX48fU092ydfZTLaRFdsF
	 vzxiWU+uzJ0Jq3Kol7U4gAUPP6fM6isgj0ZfN9VRUMyyQT4T4tzBgQwPHTfA5u5CFn
	 U4KaosJ9vso80FZWjamaHk3L95Oscyz1UPlAdB/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.18 050/227] serial: Fix not set tty->port race condition
Date: Wed, 28 Jan 2026 16:21:35 +0100
Message-ID: <20260128145346.143774672@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

commit 32f37e57583f869140cff445feedeea8a5fea986 upstream.

Revert commit bfc467db60b7 ("serial: remove redundant
tty_port_link_device()") because the tty_port_link_device() is not
redundant: the tty->port has to be confured before we call
uart_configure_port(), otherwise user-space can open console without TTY
linked to the driver.

This tty_port_link_device() was added explicitly to avoid this exact
issue in commit fb2b90014d78 ("tty: link tty and port before configuring
it as console"), so offending commit basically reverted the fix saying
it is redundant without addressing the actual race condition presented
there.

Reproducible always as tty->port warning on Qualcomm SoC with most of
devices disabled, so with very fast boot, and one serial device being
the console:

  printk: legacy console [ttyMSM0] enabled
  printk: legacy console [ttyMSM0] enabled
  printk: legacy bootconsole [qcom_geni0] disabled
  printk: legacy bootconsole [qcom_geni0] disabled
  ------------[ cut here ]------------
  tty_init_dev: ttyMSM driver does not set tty->port. This would crash the kernel. Fix the driver!
  WARNING: drivers/tty/tty_io.c:1414 at tty_init_dev.part.0+0x228/0x25c, CPU#2: systemd/1
  Modules linked in: socinfo tcsrcc_eliza gcc_eliza sm3_ce fuse ipv6
  CPU: 2 UID: 0 PID: 1 Comm: systemd Tainted: G S                  6.19.0-rc4-next-20260108-00024-g2202f4d30aa8 #73 PREEMPT
  Tainted: [S]=CPU_OUT_OF_SPEC
  Hardware name: Qualcomm Technologies, Inc. Eliza (DT)
  ...
  tty_init_dev.part.0 (drivers/tty/tty_io.c:1414 (discriminator 11)) (P)
  tty_open (arch/arm64/include/asm/atomic_ll_sc.h:95 (discriminator 3) drivers/tty/tty_io.c:2073 (discriminator 3) drivers/tty/tty_io.c:2120 (discriminator 3))
  chrdev_open (fs/char_dev.c:411)
  do_dentry_open (fs/open.c:962)
  vfs_open (fs/open.c:1094)
  do_open (fs/namei.c:4634)
  path_openat (fs/namei.c:4793)
  do_filp_open (fs/namei.c:4820)
  do_sys_openat2 (fs/open.c:1391 (discriminator 3))
  ...
  Starting Network Name Resolution...

Apparently the flow with this small Yocto-based ramdisk user-space is:

driver (qcom_geni_serial.c):                  user-space:
============================                  ===========
qcom_geni_serial_probe()
 uart_add_one_port()
  serial_core_register_port()
   serial_core_add_one_port()
    uart_configure_port()
     register_console()
    |
    |                                         open console
    |                                          ...
    |                                          tty_init_dev()
    |                                           driver->ports[idx] is NULL
    |
    tty_port_register_device_attr_serdev()
     tty_port_link_device() <- set driver->ports[idx]

Fixes: bfc467db60b7 ("serial: remove redundant tty_port_link_device()")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260123072139.53293-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3102,6 +3102,12 @@ static int serial_core_add_one_port(stru
 	if (uport->cons && uport->dev)
 		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
 
+	/*
+	 * TTY port has to be linked with the driver before register_console()
+	 * in uart_configure_port(), because user-space could open the console
+	 * immediately after.
+	 */
+	tty_port_link_device(port, drv->tty_driver, uport->line);
 	uart_configure_port(drv, state, uport);
 
 	port->console = uart_console(uport);


