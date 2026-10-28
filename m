Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211300;
	b=EBOGemWKfPQVRC9d+AE6wdEWnun2URLE9FYFaZru76FFeOfynOuOi1pVR+8yRdliDqe4
	 TRcwYj1fB4cmKXxUNsfx6r02BPJxeMjO2LNMFBoEdHBWZxmu0/zwxSdstGHSxeZnE8Xqo
	 cFuh9rApr2TSQ4eBGRV5kSQprVx0cMMhnPBNUtjrFta1kHA7lDkHJWSdZNPPtmXkIjJ1a
	 ec/5McvIhD8MELruixsincDXh4OTTsnOP2nz2Z//f3j44UrrqgVVSx5rTUgL1HQZvKpOm
	 UW1B/6ZX9V6HIyUcSiXVrKJrs6gXbZQK/3dNADX9+xli5AD2Gxux2oc7rxXLOtMh4SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RzDN/CfNuxC36qzWqhARZMB9OxKSlhFOBZeRI7QecwU=;
	b=C/DtSjUump3J+stWXk0KSr0X3fU+u+qKB+8hkRqd9hvgjXZvE5sw/QSUPXbDkkRBa1xS
	 NzfRH03xS3P75tFc6enCGFYx8UqUpYdziAxlhis2YunijP2wft+zb4E94j/xofWik82vb
	 oaOH9V26sysjYO3UuOVGqfAogekrdQgjLKZ6I3i+d4HF38UET8ywfD/2s4Lv77/ZHfu7b
	 QZXzhVqkperFt8iw3+jsTO4FYolkNHG8Xh+l4Hf0cdRCusC53EmaTggIvAYcA1+IL+YyC
	 WyjCWzpbSE1y1qBqJFzYbkPdxrdM01WgJqSHze7vDndBPyaLOgeeFp9g8+NFR6pnI4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tvjt4uXr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352A860A6F4B;
	Wed, 28 Oct 2026 18:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tvjt4uXr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE421F01828;
	Wed, 28 Oct 2026 18:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211299;
	bh=RzDN/CfNuxC36qzWqhARZMB9OxKSlhFOBZeRI7QecwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tvjt4uXrlraDQ+t538O/GbU9/ztNemrrr137qGPQjlpqIyGXMSnBoJrZi5/z9H3rn
	 vUB/XphSiZCAuFdIgE+HjwCOQX/uEGJXoGTaHk6zWWj+0LNw6+OoOaQXWIZBEsGKVJ
	 ZbEnTwQP4MXgUEBM8kRVV2/SNkFwBEAdFMA6lcCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5fabc1ae99ff40690d84@syzkaller.appspotmail.com,
	Johan Hovold <johan@kernel.org>,
	Ting-Han Hou <ue081723@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.15 330/571] tty: port: fix tty_port_tty_vhangup() race
Date: Wed, 28 Oct 2026 17:57:57 +0100
Message-ID: <20261028170015.836198027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
  in this version of tty_port.c; tty_port_shutdown() has no kernel-doc
  here, so there is none to move ]
Assisted-by: LLM
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_port.c   | 54 ++++++++++++++++++++++++++++------------
 include/linux/tty_port.h | 13 ++--------
 2 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 4a146f003fc33..7dbfabf2d902d 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -312,11 +312,12 @@ void tty_port_tty_set(struct tty_port *port, struct tty_struct *tty)
 }
 EXPORT_SYMBOL(tty_port_tty_set);
 
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
 		tty_port_set_initialized(port, 0);
@@ -330,7 +331,12 @@ static void tty_port_shutdown(struct tty_port *port, struct tty_struct *tty)
 		if (port->ops->shutdown)
 			port->ops->shutdown(port);
 	}
-out:
+}
+
+static void tty_port_shutdown(struct tty_port *port, struct tty_struct *tty)
+{
+	mutex_lock(&port->mutex);
+	tty_port_shutdown_locked(port, tty);
 	mutex_unlock(&port->mutex);
 }
 
@@ -348,6 +354,7 @@ void tty_port_hangup(struct tty_port *port)
 	struct tty_struct *tty;
 	unsigned long flags;
 
+	mutex_lock(&port->mutex);
 	spin_lock_irqsave(&port->lock, flags);
 	port->count = 0;
 	tty = port->tty;
@@ -356,7 +363,8 @@ void tty_port_hangup(struct tty_port *port)
 	port->tty = NULL;
 	spin_unlock_irqrestore(&port->lock, flags);
 	tty_port_set_active(port, 0);
-	tty_port_shutdown(port, tty);
+	tty_port_shutdown_locked(port, tty);
+	mutex_unlock(&port->mutex);
 	tty_kref_put(tty);
 	wake_up_interruptible(&port->open_wait);
 	wake_up_interruptible(&port->delta_msr_wait);
@@ -364,24 +372,38 @@ void tty_port_hangup(struct tty_port *port)
 EXPORT_SYMBOL(tty_port_hangup);
 
 /**
- * tty_port_tty_hangup - helper to hang up a tty
- *
+ * tty_port_tty_hangup - helper to hang up a tty asynchronously
  * @port: tty port
- * @check_clocal: hang only ttys with CLOCAL unset?
+ * @check_clocal: hang only ttys with %CLOCAL unset?
  */
-void __tty_port_tty_hangup(struct tty_port *port, bool check_clocal, bool async)
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
index 03d889398c5ed..7b0a1c360ff4f 100644
--- a/include/linux/tty_port.h
+++ b/include/linux/tty_port.h
@@ -186,7 +186,8 @@ int tty_port_carrier_raised(struct tty_port *port);
 void tty_port_raise_dtr_rts(struct tty_port *port);
 void tty_port_lower_dtr_rts(struct tty_port *port);
 void tty_port_hangup(struct tty_port *port);
-void __tty_port_tty_hangup(struct tty_port *port, bool check_clocal, bool async);
+void tty_port_tty_hangup(struct tty_port *port, bool check_clocal);
+void tty_port_tty_vhangup(struct tty_port *port);
 void tty_port_tty_wakeup(struct tty_port *port);
 int tty_port_block_til_ready(struct tty_port *port, struct tty_struct *tty,
 		struct file *filp);
@@ -205,14 +206,4 @@ static inline int tty_port_users(struct tty_port *port)
 	return port->count + port->blocked_open;
 }
 
-static inline void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
-{
-	__tty_port_tty_hangup(port, check_clocal, true);
-}
-
-static inline void tty_port_tty_vhangup(struct tty_port *port)
-{
-	__tty_port_tty_hangup(port, false, false);
-}
-
 #endif
-- 
2.53.0



