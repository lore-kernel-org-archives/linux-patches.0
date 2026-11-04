Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827000;
	b=NVHw8RvYd2h79nfFFzhNR7qJ3xzTB0fHC99Rh9Yxknnsf+QKt4STlVojfhCWE8s8QSAo
	 jz89xqj4NBxP2awbXbF89Rh3T1HdzxcPmsku70W2ZRxjDRD3WwwzT7sxE5pgoIIhp0DEw
	 u80uHFXAvRmtJFrB1ZiTCqz/BN0bCeaLm6if+kMnd+PPMO6Xww/MntkstnyuBEz32PqOW
	 WnkwoR4/H2qx7+5omHvO6zk5gAOxGYNrolcLs7q3JzhwtTQa/90IpyhmjLlwqWNPbi5ZI
	 jlA6O4tmssjwZqxsqa+cssdrIbL5ROO4JqupXk1WP8fYVJJmCbLUz/YSnILpfgz5JYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nMk/fHUd17nrUFvRUZq3X5kfpQypf8pgpiMzZvwHvF4=;
	b=deF/4CL/vlQG2ldan0TFkY9m5PGAUNEwenfJcUME0cuM4jDx04uFmb/Ryhg3D9lMUV2j
	 Q6dYqXTj2alLSU4LRH/pvqzAZb69Dr6CuyqRBmVruxxegfQWYxlutm4bmwneZAcWrcqNK
	 BLFiT+H/oJfWIB67MTAGuKbVgbIOfKw0rMjdreEJKZRONhaBa7Vnn/c7kpNesT62H4KZi
	 hsmKXj5aivbXnQCXyffF8qwbbxk8TeqSTh0rFhjBfeZdXGsZ0YwAPIBHKCblHXL6JWkvv
	 OGibSSOZ/nOMXrztOkjw5GTDKpUGcvyhgxDvm3Ymc65hYW7OQBfm9RcDnyyZS+WUs8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNl8mwcg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7886074905;
	Wed,  4 Nov 2026 21:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNl8mwcg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213E51F000C1;
	Wed,  4 Nov 2026 21:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827000;
	bh=nMk/fHUd17nrUFvRUZq3X5kfpQypf8pgpiMzZvwHvF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNl8mwcgWQj8eu2vBh2VAGapzFzJe4DVdYHfAJG5uNcYIqUatHwsoXZ/0mhboasNy
	 EW6jgdN3ZKXC49h3Lp2tH/3CaI0c4au/YQWZ0Ly03GIQ9LIQicA+k3iLxepXA35isS
	 CVMgPx8h7ubaXtXumRmV0NsGUbbu83R1vVXjBW60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 097/547] serial: core: fix TIOCSSERIAL and TIOCSERCONFIG on uninitialised ports
Date: Wed,  4 Nov 2026 16:04:41 -0500
Message-ID: <20261104211040.982049220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengyu Liang <hengyul@cs.unc.edu>

[ Upstream commit e1f46a09df93650288babb23de6e34bff73e80e6 ]

Commit 8ca59f7baee7 ("serial: fix ioctl hangup race") made
uart_set_info() and uart_do_autoconfig() return -EIO when TTY_IO_ERROR
is set, so that they do not run on a port that has been hung up.

However, TTY_IO_ERROR is also set on a port that could not be started,
for example because its type is unknown, and by uart_shutdown(), which
both functions call. As of now, setserial cannot configure a port that
the kernel did not detect, and an autoconfig that follows a port, irq or
type change in the same setserial call fails on any port.

The issue can be reproduced with setserial (busybox) on a port without
a detected UART, for example ttyS3 of a QEMU guest:

    setserial /dev/ttyS3 uart 16550A
    setserial -g /dev/ttyS3

Before commit 8ca59f7baee7 ("serial: fix ioctl hangup race"), the
result is:

    /dev/ttyS3, UART: 16550A, Port: 0x02e8, IRQ: 3

After that commit, the result is:

    setserial: can't set serial info: Input/output error
    /dev/ttyS3, UART: unknown, Port: 0x02e8, IRQ: 3

This patch will check tty_port_active() in these two functions instead.
uart_hangup() clears it under the port mutex, and it stays set on an
open port that could not be started.

Fixes: 8ca59f7baee7 ("serial: fix ioctl hangup race")
Cc: stable@kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Tested-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20261010034616.3915864-1-hengyul@cs.unc.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 6332ed545c899..81a985424694c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -896,7 +896,11 @@ static int uart_set_info(struct tty_struct *tty, struct tty_port *port,
 	upf_t old_flags, new_flags;
 	int retval;
 
-	if (!uport || tty_io_error(tty))
+	/*
+	 * TTY_IO_ERROR is also set on a port that could not be started, and
+	 * this is how such a port is configured. Only refuse a hung up port.
+	 */
+	if (!uport || !tty_port_active(port))
 		return -EIO;
 
 	new_port = new_info->port;
@@ -1144,7 +1148,8 @@ static int uart_do_autoconfig(struct tty_struct *tty, struct uart_state *state)
 	 */
 	scoped_cond_guard(mutex_intr, return -ERESTARTSYS, &port->mutex) {
 		uport = uart_port_check(state);
-		if (!uport || tty_io_error(tty))
+		/* As in uart_set_info(), only refuse a hung up port. */
+		if (!uport || !tty_port_active(port))
 			return -EIO;
 
 		if (tty_port_users(port) != 1)
-- 
2.53.0



