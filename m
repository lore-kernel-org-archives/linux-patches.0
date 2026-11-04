Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827185;
	b=TJ01E34SCecIYCzeQPLJ1CsN4SztB65SX2RecDGOtAJ6ZZFZdoqzMqkqrxRCA1XMBZLt
	 PPUiQoGUuTgA/ZKG1ehz/1RVJrJu9xdud2BU4sy3t6vLVziADNDsW5D6TcV5iHCzlLAEq
	 FoKhUShPPfsLHavPo1tLXmuaPF8Z7N5PpH6T6C81uLjAdJw2DnuhrkNQZG5Lvu62dHFvk
	 7X47yUROy8dbXLV0UNnHdbqmPEoWHemp31if5+/DnSkJLtNzWMgQEfabxMRiWM3OzTv32
	 oIcCzP8TytFWcAex1VSKOAbof4XCWzpOh7QRxMM9oOAkiCmr4KyCyGXOtfSayM1/eZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b5vqHxZL9mBcqMeWvgEhbsQ0JvIxfOJszoZnH8Y9CQs=;
	b=N3cRF8gW93fcjxHuhnBe1ny71gN7ZeItxTei1II/aIzGaFmHFZ2TW+VW/bBcyldEqE8R
	 I9/rHhVsnrZHpHvQZANLfQUiLjMg0CN6qX7R6Owsvhm9LW4fShwT15DchiKKTNgDz9LOe
	 HRs3QxF2t8ZOtMAmVI2dfbPUlTXW0JXjpEd2pr8vifhA5+2ruTIHho745RjcaCiLDzs4j
	 elv+FawSTYL3A+VJ1WJPKaDgI53LIwimlyKm3dHjt6ikaDpKh6O73EV1ZzEGOOdIjX7eV
	 HrhcoUdD6pyrZ0QMeRGcAjqXC4Z885SFVJ7ZXhy3We+f75QJ7vFWAx497rUNSPjsYTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xEsFOU+c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7272A606A846;
	Wed,  4 Nov 2026 21:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xEsFOU+c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A281F00919;
	Wed,  4 Nov 2026 21:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827185;
	bh=b5vqHxZL9mBcqMeWvgEhbsQ0JvIxfOJszoZnH8Y9CQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xEsFOU+c72D1y1aZUxKGAPI42YtdVY082ELU+07TKqbaDbFurZyPOqDchAPxXX+RZ
	 ovKwIhNPtnV5/DfLeNkCSTrxB4lJ2lWRv/D7xvF5Mf6hxTaQYEtm4RinX/b5x8iaE/
	 TjurEQBFeGvJTlCJtuuVaCqWAYPfdHf2rIedBqPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+843bf2f48f4d12e6682e@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH 7.3 245/547] serial: core: shut down initialized port on removal
Date: Wed,  4 Nov 2026 16:07:09 -0500
Message-ID: <20261104211045.133017433@linuxfoundation.org>
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

From: Igor Putko <igorpetindev@gmail.com>

commit 810d467c11f0c85107874d08dfdd11acba6aa0c0 upstream.

When a serial port configured as a console is opened and subsequently
closed, tty_port_shutdown() skips invoking port->ops->shutdown() because
port->console is true. As a result, tty_port_initialized() remains true
and the port's interrupt handler stays registered in the irq subsystem.

If the underlying device is later unbound or removed (e.g. via sysfs
driver unbind or device hot-unplug), serial_core_remove_one_port()
unregisters the console, frees uport->name via kfree(), and tears down
the port without shutting it down or freeing its IRQ. Consequently, the
irqaction descriptor remains registered in genirq with action->name
pointing to freed memory.

This triggers a use-after-free read whenever genirq accesses action->name,
such as when reading /proc/interrupts:

  BUG: KASAN: slab-use-after-free in string+0x476/0x570
  Call Trace:
   string+0x476/0x570
   vsnprintf+0x422/0x1300
   seq_printf+0x...
   show_interrupts+...

Fix this by acquiring port->mutex in serial_core_remove_one_port() after
console unregistration, clearing port->console under the mutex to prevent
data races with concurrent tty_port_shutdown(), and invoking
uart_shutdown(NULL, state) if the port remains initialized. This ensures
that port->ops->shutdown() is called and the IRQ is freed before
kfree(uport->name).

Reported-by: syzbot+843bf2f48f4d12e6682e@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Closes: https://syzkaller.appspot.com/bug?extid=843bf2f48f4d12e6682e
Fixes: 761ed4a94582 ("tty: serial_core: convert uart_close to use tty_port_close")
Fixes: f7048b15900f ("tty: serial_core: Add name field to uart_port struct")
Signed-off-by: Igor Putko <igorpetindev@gmail.com>
Link: https://patch.msgid.link/20261003163337.45577-1-igorpetindev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3241,6 +3241,13 @@ static void serial_core_remove_one_port(
 	if (uart_console(uport))
 		unregister_console(uport->cons);
 
+	scoped_guard(mutex, &port->mutex) {
+		port->console = false;
+
+		if (tty_port_initialized(port))
+			uart_shutdown(NULL, state);
+	}
+
 	/*
 	 * Free the port IO and memory resources, if any.
 	 */


