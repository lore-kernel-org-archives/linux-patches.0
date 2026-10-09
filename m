Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD90125AA;
	Fri,  9 Oct 2026 14:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556476; cv=none; b=hXsh+DyAm9eAIbnXEnEUImGSzZFel247S1cg24D50DnuVI+UkoKdqKa2wrGR0M71oPjMI0BlG9fhlyL+AmUvlnNoNI57cTDu5ZBA8aPwa7TjDXZs1lPmAQWIXL9PNBMo3rNh8rXjxb8g2W3QE/ZpSGlzlHeKDpLSRZn1X/Lx134=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556476; c=relaxed/simple;
	bh=yXbC6ZV6RUDnJWug2Yr9efvV4MLhrTaC2+eBqBdb/p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptUlLr31xcOl4YgT+gPOjNLb0+gkUNhd9UGQjKuhrwQCeZv+3MbpJbmYu2pwKzsbM5e7HKCBQm9vmZ/K1QJtTJTuqbDZY8UdxVGobr2KWV/Nh3rhd9HilJB/S32GbN8mg3XncBktwJe/KxjY3W6/fDYwhRl08kosaFuPyODkAUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbpgfoSv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbpgfoSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718F91F000FF;
	Fri,  9 Oct 2026 14:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556474;
	bh=VVOjhzKKl7vy/Nn8+Kb3d4XMuJ5lxlrbLsgsfgHUJ8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CbpgfoSvMfzAhFjhUHwWp6E2ShM/OyeFUdhvnde7gFseOo7FvET+JNPPTGNNHbxZ4
	 OJfL7Y34CA0oOOfbmld/jtCDOpgr6P2weQZUB2iah/ERfUBPtSxSx++1A1N9A+LgjP
	 HvKDnh1vT9Y0QyVW/s6REcy+rkuVcC8cP/rYy73Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5fabc1ae99ff40690d84@syzkaller.appspotmail.com,
	Johan Hovold <johan@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.18 195/403] tty: port: fix tty_port_tty_vhangup() race
Date: Fri,  9 Oct 2026 16:09:16 +0200
Message-ID: <20261009140956.690318916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit b48820de8c1a596c5b99775524dfce73c6576c5d upstream.

Drivers rely on tty_port_tty_vhangup() to synchronously hang up their
ports before tearing down resources as part of deregistration (e.g. on
physical disconnect).

If tty_port_tty_vhangup() races with another hangup it may however
return before the port has been shut down. This is in turn can lead to
use-after-free and NULL-pointer dereferences in racing ioctls (including
a synchronous hangup) and in processing of racing asynchronous hangups
(carrier loss).

Add the missing serialisation to tty_port_tty_vhangup() and
tty_port_hangup() so that the former does not return until the port has
been shut down also when there is a racing hangup.

Note that serial core does not use tty_port_hangup(), but it already
holds the port mutex when clearing port->tty and shutting down the port
in uart_hangup().

Fixes: 7ca0ff9ab321 ("tty: Add a full port_close function")
Cc: stable@kernel.org	# 2.6.32: 2b5eac0f8c6e: tty: introduce and use tty_port_tty_vhangup() helper
Cc: stable@kernel.org	# 2.6.32
Reported-by: syzbot+5fabc1ae99ff40690d84@syzkaller.appspotmail.com
Link: https://lore.kernel.org/6a944641.4d659fcc.734b4.003c.GAE@google.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260910125114.640880-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_port.c   |   87 +++++++++++++++++++++++++++++++----------------
 include/linux/tty_port.h |   22 +----------
 2 files changed, 60 insertions(+), 49 deletions(-)

--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -319,19 +319,9 @@ void tty_port_tty_set(struct tty_port *p
 }
 EXPORT_SYMBOL(tty_port_tty_set);
 
-/**
- * tty_port_shutdown - internal helper to shutdown the device
- * @port: tty port to be shut down
- * @tty: the associated tty
- *
- * It is used by tty_port_hangup() and tty_port_close(). Its task is to
- * shutdown the device if it was initialized (note consoles remain
- * functioning). It lowers DTR/RTS (if @tty has HUPCL set) and invokes
- * @port->ops->shutdown().
- */
-static void tty_port_shutdown(struct tty_port *port, struct tty_struct *tty)
+static void tty_port_shutdown_locked(struct tty_port *port, struct tty_struct *tty)
 {
-	guard(mutex)(&port->mutex);
+	lockdep_assert_held(&port->mutex);
 
 	if (port->console)
 		return;
@@ -352,6 +342,23 @@ static void tty_port_shutdown(struct tty
 }
 
 /**
+ * tty_port_shutdown - internal helper to shutdown the device
+ * @port: tty port to be shut down
+ * @tty: the associated tty
+ *
+ * It is used by tty_port_hangup() and tty_port_close(). Its task is to
+ * shutdown the device if it was initialized (note consoles remain
+ * functioning). It lowers DTR/RTS (if @tty has HUPCL set) and invokes
+ * @port->ops->shutdown().
+ */
+static void tty_port_shutdown(struct tty_port *port, struct tty_struct *tty)
+{
+	guard(mutex)(&port->mutex);
+
+	tty_port_shutdown_locked(port, tty);
+}
+
+/**
  * tty_port_hangup		-	hangup helper
  * @port: tty port
  *
@@ -364,36 +371,58 @@ void tty_port_hangup(struct tty_port *po
 {
 	struct tty_struct *tty;
 
-	scoped_guard(spinlock_irqsave, &port->lock) {
-		port->count = 0;
-		tty = port->tty;
-		if (tty)
-			set_bit(TTY_IO_ERROR, &tty->flags);
-		port->tty = NULL;
-	}
+	scoped_guard(mutex, &port->mutex) {
+		scoped_guard(spinlock_irqsave, &port->lock) {
+			port->count = 0;
+			tty = port->tty;
+			if (tty)
+				set_bit(TTY_IO_ERROR, &tty->flags);
+			port->tty = NULL;
+		}
 
-	tty_port_set_active(port, false);
-	tty_port_shutdown(port, tty);
+		tty_port_set_active(port, false);
+		tty_port_shutdown_locked(port, tty);
+	}
 	tty_kref_put(tty);
 	wake_up_interruptible(&port->open_wait);
 	wake_up_interruptible(&port->delta_msr_wait);
 }
 EXPORT_SYMBOL(tty_port_hangup);
 
-void __tty_port_tty_hangup(struct tty_port *port, bool check_clocal, bool async)
+/**
+ * tty_port_tty_hangup - helper to hang up a tty asynchronously
+ * @port: tty port
+ * @check_clocal: hang only ttys with %CLOCAL unset?
+ */
+void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
 {
 	scoped_guard(tty_port_tty, port) {
 		struct tty_struct *tty = scoped_tty();
 
-		if (!check_clocal || !C_CLOCAL(tty)) {
-			if (async)
-				tty_hangup(tty);
-			else
-				tty_vhangup(tty);
-		}
+		if (!check_clocal || !C_CLOCAL(tty))
+			tty_hangup(tty);
+	}
+}
+EXPORT_SYMBOL_GPL(tty_port_tty_hangup);
+
+/**
+ * tty_port_tty_vhangup - helper to hang up a tty synchronously
+ * @port: tty port
+ */
+void tty_port_tty_vhangup(struct tty_port *port)
+{
+	struct tty_struct *tty;
+
+	mutex_lock(&port->mutex);
+	tty = tty_port_tty_get(port);
+	mutex_unlock(&port->mutex);
+
+	if (tty) {
+		tty_vhangup(tty);
+		tty_kref_put(tty);
 	}
 }
-EXPORT_SYMBOL_GPL(__tty_port_tty_hangup);
+EXPORT_SYMBOL_GPL(tty_port_tty_vhangup);
 
 /**
  * tty_port_tty_wakeup - helper to wake up a tty
--- a/include/linux/tty_port.h
+++ b/include/linux/tty_port.h
@@ -232,7 +232,8 @@ bool tty_port_carrier_raised(struct tty_
 void tty_port_raise_dtr_rts(struct tty_port *port);
 void tty_port_lower_dtr_rts(struct tty_port *port);
 void tty_port_hangup(struct tty_port *port);
-void __tty_port_tty_hangup(struct tty_port *port, bool check_clocal, bool async);
+void tty_port_tty_hangup(struct tty_port *port, bool check_clocal);
+void tty_port_tty_vhangup(struct tty_port *port);
 void tty_port_tty_wakeup(struct tty_port *port);
 int tty_port_block_til_ready(struct tty_port *port, struct tty_struct *tty,
 		struct file *filp);
@@ -251,25 +252,6 @@ static inline int tty_port_users(struct
 	return port->count + port->blocked_open;
 }
 
-/**
- * tty_port_tty_hangup - helper to hang up a tty asynchronously
- * @port: tty port
- * @check_clocal: hang only ttys with %CLOCAL unset?
- */
-static inline void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
-{
-	__tty_port_tty_hangup(port, check_clocal, true);
-}
-
-/**
- * tty_port_tty_vhangup - helper to hang up a tty synchronously
- * @port: tty port
- */
-static inline void tty_port_tty_vhangup(struct tty_port *port)
-{
-	__tty_port_tty_hangup(port, false, false);
-}
-
 #ifdef CONFIG_TTY
 void tty_kref_put(struct tty_struct *tty);
 __DEFINE_CLASS_IS_CONDITIONAL(tty_port_tty, true);


