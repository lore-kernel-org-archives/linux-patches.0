Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A315632E151;
	Sat, 17 Oct 2026 17:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256992; cv=none; b=o4fv2FtDF70obOCEHVacPlAECq179VzmJaMSA80Qn9MSglHGQsqbaJY9Qab1PfKAMhU9FAIR+KDd7dcpGjVbShCYMyxrjAedSn3UfcqFmY+JVPzW0HwU2XFdSKiwq8hrpajmyDAGVckDue6n55fxDabu4SDcnYd3cJE4keD9OSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256992; c=relaxed/simple;
	bh=iIi5BKwpwjDqYEVToHNfHiFEiDdNAgKuCuOwCo2Z3Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rv2SeLBGw2iwUTFWskWvU1Jvr/yNauC2ZKmPxXOXvvdH3PxVqE9NML/0HayeRCeSVh3odNSP3JlgwSBjkIs8J6sbr7P9gonIq23tv+yd67Cxd0KlItlf6gut6KQ6Zsc+1Bv0uFRwCGcdEP3QaaUXH87PqXad6MLHzFOYwH7tToQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDnWgKnr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDnWgKnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1171F000C4;
	Sat, 17 Oct 2026 17:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256991;
	bh=wPmShyJFsEZ+FBEz72maz/gNYC5SdxfQ7jdEAT0xCDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDnWgKnrgqA1GJJ9+BFJT9T4K60PcpuSCwJe8uONOAZeYM9TE1HaLXLHmN5XDl1R0
	 prs+e9kw/UEJu3Qg7nrDtZJZfXa324+8LKXrYuJNd+25dcIHJW6ZUnk2YaY9KkSXhz
	 hchTAsslCYBTgQlBtrsCMY7FD8XjiOOv7/Wosmwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5fabc1ae99ff40690d84@syzkaller.appspotmail.com,
	Johan Hovold <johan@kernel.org>,
	Ting-Han Hou <ue081723@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.6 0416/1674] tty: port: fix tty_port_tty_vhangup() race
Date: Sat, 17 Oct 2026 17:44:48 +0200
Message-ID: <20261017160441.805781952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit b48820de8c1a596c5b99775524dfce73c6576c5d ]

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
[ Ting-Han: use mutex_lock()/spin_lock_irqsave() instead of guard(),
  scoped_guard() and the tty_port_tty class, matching the existing code
  in this version of tty_port.c ]
Assisted-by: LLM
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_port.c   | 74 +++++++++++++++++++++++++++-------------
 include/linux/tty_port.h | 22 ++----------
 2 files changed, 53 insertions(+), 43 deletions(-)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 7ee96882e0e48..75a2f1a61e634 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -348,21 +348,12 @@ void tty_port_tty_set(struct tty_port *port, struct tty_struct *tty)
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
-	mutex_lock(&port->mutex);
+	lockdep_assert_held(&port->mutex);
+
 	if (port->console)
-		goto out;
+		return;
 
 	if (tty_port_initialized(port)) {
 		tty_port_set_initialized(port, false);
@@ -376,7 +367,22 @@ static void tty_port_shutdown(struct tty_port *port, struct tty_struct *tty)
 		if (port->ops->shutdown)
 			port->ops->shutdown(port);
 	}
-out:
+}
+
+/**
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
+	mutex_lock(&port->mutex);
+	tty_port_shutdown_locked(port, tty);
 	mutex_unlock(&port->mutex);
 }
 
@@ -394,6 +400,7 @@ void tty_port_hangup(struct tty_port *port)
 	struct tty_struct *tty;
 	unsigned long flags;
 
+	mutex_lock(&port->mutex);
 	spin_lock_irqsave(&port->lock, flags);
 	port->count = 0;
 	tty = port->tty;
@@ -402,26 +409,47 @@ void tty_port_hangup(struct tty_port *port)
 	port->tty = NULL;
 	spin_unlock_irqrestore(&port->lock, flags);
 	tty_port_set_active(port, false);
-	tty_port_shutdown(port, tty);
+	tty_port_shutdown_locked(port, tty);
+	mutex_unlock(&port->mutex);
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
 	struct tty_struct *tty = tty_port_tty_get(port);
 
-	if (tty && (!check_clocal || !C_CLOCAL(tty))) {
-		if (async)
-			tty_hangup(tty);
-		else
-			tty_vhangup(tty);
-	}
+	if (tty && (!check_clocal || !C_CLOCAL(tty)))
+		tty_hangup(tty);
 	tty_kref_put(tty);
 }
-EXPORT_SYMBOL_GPL(__tty_port_tty_hangup);
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
+	}
+}
+EXPORT_SYMBOL_GPL(tty_port_tty_vhangup);
 
 /**
  * tty_port_tty_wakeup - helper to wake up a tty
diff --git a/include/linux/tty_port.h b/include/linux/tty_port.h
index 0b97e562894b2..6db28a4ec4537 100644
--- a/include/linux/tty_port.h
+++ b/include/linux/tty_port.h
@@ -235,7 +235,8 @@ bool tty_port_carrier_raised(struct tty_port *port);
 void tty_port_raise_dtr_rts(struct tty_port *port);
 void tty_port_lower_dtr_rts(struct tty_port *port);
 void tty_port_hangup(struct tty_port *port);
-void __tty_port_tty_hangup(struct tty_port *port, bool check_clocal, bool async);
+void tty_port_tty_hangup(struct tty_port *port, bool check_clocal);
+void tty_port_tty_vhangup(struct tty_port *port);
 void tty_port_tty_wakeup(struct tty_port *port);
 int tty_port_block_til_ready(struct tty_port *port, struct tty_struct *tty,
 		struct file *filp);
@@ -254,23 +255,4 @@ static inline int tty_port_users(struct tty_port *port)
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
 #endif
-- 
2.53.0



