Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A843D34A2;
	Fri,  9 Oct 2026 14:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556794; cv=none; b=Ty6rTDsuh2TvLdsrJ17a7pRTRj9I7B7jvdU3JpDnxoSOlkeM4LLKJfVHu0aI9MQZvHjhz5wCzTqMldXBFgVmPfhPApZaRxwO19SCxiV/6Od8jH28cIvB1oMhu0mu+/x0MjjWfTo4myf4W3IXy7sEgIpn7diWKY5tif05h3B4jrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556794; c=relaxed/simple;
	bh=bnIzc3tz+oqqonwIBW6coK9kdw/IM81GnWCvRrz1H5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XN1Yj+/FfsGE7Yj8mg8KzGuGQHFpEVby6E7KN2VWXfgGkGVq9daM6VW45RVTmuDzYPu+qZvudCHV08YdLaqK8AA4hqbEn+WuwWcAfGUdysFe/XIwoXOiJBRE/nTZNFqd3JuIKlsFMooI5V+Ulb7gQ4C+8Idbis+sEDOh/1s4KHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmZFTyVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmZFTyVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC481F000FF;
	Fri,  9 Oct 2026 14:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556793;
	bh=mmisyCIRwg3UJGIKsdkqdJA6kV+FQV20b53VyL8SENc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fmZFTyVwMHl4vBTYa578vgo2SFQhxUMw2TsLmElmjwjhFpyB6HdrauTCzhuRblMES
	 8mLoh8XesnSvo0M2nmMQqazdyNtIAGaRfZRM2KMBXJMM12AIIzdO3sKFD1ULqTer5g
	 Wqp5VygFOf0TZYKejTIayZhouVEjmKCw5s6egcKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5fabc1ae99ff40690d84@syzkaller.appspotmail.com,
	Johan Hovold <johan@kernel.org>,
	stable@kernel.org
Subject: [PATCH 7.2 243/428] tty: port: fix tty_port_tty_vhangup() race
Date: Fri,  9 Oct 2026 16:09:40 +0200
Message-ID: <20261009140951.449278984@linuxfoundation.org>
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
@@ -340,19 +340,9 @@ void tty_port_tty_set(struct tty_port *p
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
@@ -373,6 +363,23 @@ static void tty_port_shutdown(struct tty
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
@@ -385,36 +392,58 @@ void tty_port_hangup(struct tty_port *po
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
@@ -245,7 +245,8 @@ bool tty_port_carrier_raised(struct tty_
 void tty_port_raise_dtr_rts(struct tty_port *port);
 void tty_port_lower_dtr_rts(struct tty_port *port);
 void tty_port_hangup(struct tty_port *port);
-void __tty_port_tty_hangup(struct tty_port *port, bool check_clocal, bool async);
+void tty_port_tty_hangup(struct tty_port *port, bool check_clocal);
+void tty_port_tty_vhangup(struct tty_port *port);
 void tty_port_tty_wakeup(struct tty_port *port);
 int tty_port_block_til_ready(struct tty_port *port, struct tty_struct *tty,
 		struct file *filp);
@@ -264,25 +265,6 @@ static inline int tty_port_users(struct
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


