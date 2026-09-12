Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71712D0C94;
	Sat, 12 Sep 2026 07:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199225; cv=none; b=WK1Vh90N/1JbcuUBE7Uz5lKABUsR/IzqP1cw9jr1IvC5ebJW6E3zeZX1hFOyMLGZ2pmZCnLmibH3fVKWPA3XwpLVhT2f/msn2ylYsEmqS1Lm928bOHN5y/T35+F00CkBlZBLITyu3D25G+JWAL5pZJS5VjjPlDuGNj4pZhmY+hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199225; c=relaxed/simple;
	bh=b0miWlHyPQLZVxYTKW07p8VpbeQvzpSdQMiNV/RRKto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lBhBt7PVg++hEyPhcgNBYlODaN6ofKluDwKZBAjvVhWtINTbxhpNftovpvrJWpdpLaOdDSgONAW/CYJk1behLZmjSmB1RP6xmHbNKCOlrsK/D9eT1tbqZGK60OdNk7ihRvTyceqVaAXIIrtS+G1xCI1qKQAj/BPWrzWaokP8YxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OT9eY33o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OT9eY33o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2EC1F000FF;
	Sat, 12 Sep 2026 07:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199223;
	bh=u0PE6kMvDmlgehzscBfC8Vr3so14oJXbA1ViMjmlxxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OT9eY33on9Lk12KLi8DFLoUZt1ncvAO3sRqnLKcsfVputdZYDbQVsRfAl8pFzLD/F
	 PkHoGaFnkE7XW/+6Vs2YS9zPHLNvCZa6j5dpj8pgv4XYlZ3avitcB4fYp/tSDBC6Su
	 nx/Quz/ixlzRbpCV1xJUybzuv2TRUibHmA4rm75U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0504/1815] ipack: ipoctal: fix UAF, null-ptr-deref, and use-after-free in cleanup on remove
Date: Sat, 12 Sep 2026 08:37:34 +0200
Message-ID: <20260912065700.722820631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit b6b5d64cb161a28347d64dc3168a636c4abb68d5 ]

Three issues arise when the device is removed while a tty session is
still active:

1. UAF of struct ipoctal: the remove callback frees ipoctal via
   kfree() while tty ops may still access it.  Fix by introducing
   kref-based lifetime management — kref is taken in install() when
   a tty is opened and released in cleanup() when the tty is finally
   destroyed; remove() uses kref_put() instead of kfree().

2. NULL dereference in ipoctal_write_tty(): __ipoctal_remove()
   frees xmit_buf via tty_port_free_xmit_buf() while a userspace
   process may still hold the tty fd and call write().  Fix by
   checking for NULL xmit_buf in ipoctal_write_tty().

3. UAF in ipoctal_cleanup(): ipack_put_carrier(ipoctal->dev)
   dereferences ipoctal->dev after the ipack_device has been freed
   by ipack_device_del().  Fix by caching ipoctal->carrier_owner
   during probe() and calling module_put() on the cached pointer
   directly in cleanup(), avoiding any access to ipoctal->dev.

Also introduce a "removed" flag in struct ipoctal, set at the start
of __ipoctal_remove(), and checked in every tty op that accesses
hardware resources (port_activate, write_tty, set_termios, hangup,
shutdown).  This prevents page faults when devm_ioremap() regions
are unmapped after remove() returns.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/lkml/178144969601.60470.1257088106279546587@gmail.com/
Fixes: 05e5027efc9c ("Staging: ipack: move out of staging")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/e3b0a90b07f079c5bcd5ca90d1dd3b79bb29adb5.1782870760.git.xiaopei01@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ipack/devices/ipoctal.c | 56 ++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 1bbefc6de708b..bf71b8952a7c0 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -10,6 +10,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/kref.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/serial.h>
@@ -25,6 +26,8 @@
 
 static const struct tty_operations ipoctal_fops;
 
+static void ipoctal_release(struct kref *kref);
+
 struct ipoctal_channel {
 	struct ipoctal_stats		stats;
 	unsigned int			nb_bytes;
@@ -49,6 +52,9 @@ struct ipoctal {
 	struct tty_driver		*tty_drv;
 	u8 __iomem			*mem8_space;
 	u8 __iomem			*int_space;
+	struct kref			kref;
+	struct module			*carrier_owner;
+	bool				removed;
 };
 
 static inline struct ipoctal *chan_to_ipoctal(struct ipoctal_channel *chan,
@@ -70,8 +76,14 @@ static void ipoctal_reset_channel(struct ipoctal_channel *channel)
 static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 {
 	struct ipoctal_channel *channel;
+	struct ipoctal *ipoctal;
 
 	channel = dev_get_drvdata(tty->dev);
+	ipoctal = chan_to_ipoctal(channel, tty->index);
+
+
+	if (ipoctal->removed)
+		return -ENODEV;
 
 	/*
 	 * Enable RX. TX will be enabled when
@@ -95,6 +107,7 @@ static int ipoctal_install(struct tty_driver *driver, struct tty_struct *tty)
 	if (res)
 		goto err_put_carrier;
 
+	kref_get(&ipoctal->kref);
 	tty->driver_data = channel;
 
 	return 0;
@@ -460,8 +473,13 @@ static ssize_t ipoctal_write_tty(struct tty_struct *tty, const u8 *buf,
 				 size_t count)
 {
 	struct ipoctal_channel *channel = tty->driver_data;
+	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
 	size_t char_copied;
 
+
+	if (ipoctal->removed || !channel->tty_port.xmit_buf)
+		return 0;
+
 	char_copied = ipoctal_copy_write_buffer(channel, buf, count);
 
 	/* As the IP-OCTAL 485 only supports half duplex, do it manually */
@@ -501,8 +519,13 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	unsigned char mr2 = 0;
 	unsigned char csr = 0;
 	struct ipoctal_channel *channel = tty->driver_data;
+	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
 	speed_t baud;
 
+
+	if (ipoctal->removed)
+		return;
+
 	cflag = tty->termios.c_cflag;
 
 	/* Disable and reset everything before change the setup */
@@ -631,10 +654,16 @@ static void ipoctal_hangup(struct tty_struct *tty)
 {
 	unsigned long flags;
 	struct ipoctal_channel *channel = tty->driver_data;
+	struct ipoctal *ipoctal;
 
 	if (channel == NULL)
 		return;
 
+	ipoctal = chan_to_ipoctal(channel, tty->index);
+
+	if (ipoctal->removed)
+		return;
+
 	spin_lock_irqsave(&channel->lock, flags);
 	channel->nb_bytes = 0;
 	channel->pointer_read = 0;
@@ -651,10 +680,16 @@ static void ipoctal_hangup(struct tty_struct *tty)
 static void ipoctal_shutdown(struct tty_struct *tty)
 {
 	struct ipoctal_channel *channel = tty->driver_data;
+	struct ipoctal *ipoctal;
 
 	if (channel == NULL)
 		return;
 
+	ipoctal = chan_to_ipoctal(channel, tty->index);
+
+	if (ipoctal->removed)
+		return;
+
 	ipoctal_reset_channel(channel);
 	tty_port_set_initialized(&channel->tty_port, false);
 }
@@ -664,8 +699,9 @@ static void ipoctal_cleanup(struct tty_struct *tty)
 	struct ipoctal_channel *channel = tty->driver_data;
 	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
 
-	/* release the carrier driver */
-	ipack_put_carrier(ipoctal->dev);
+	/* release the carrier driver via cached owner */
+	module_put(ipoctal->carrier_owner);
+	kref_put(&ipoctal->kref, ipoctal_release);
 }
 
 static const struct tty_operations ipoctal_fops = {
@@ -683,6 +719,13 @@ static const struct tty_operations ipoctal_fops = {
 	.cleanup =              ipoctal_cleanup,
 };
 
+static void ipoctal_release(struct kref *kref)
+{
+	struct ipoctal *ipoctal = container_of(kref, struct ipoctal, kref);
+
+	kfree(ipoctal);
+}
+
 static int ipoctal_probe(struct ipack_device *dev)
 {
 	int res;
@@ -692,7 +735,10 @@ static int ipoctal_probe(struct ipack_device *dev)
 	if (ipoctal == NULL)
 		return -ENOMEM;
 
+	kref_init(&ipoctal->kref);
+
 	ipoctal->dev = dev;
+	ipoctal->carrier_owner = dev->bus->owner;
 	res = ipoctal_inst_slot(ipoctal, dev->bus->bus_nr, dev->slot);
 	if (res)
 		goto out_uninst;
@@ -701,7 +747,7 @@ static int ipoctal_probe(struct ipack_device *dev)
 	return 0;
 
 out_uninst:
-	kfree(ipoctal);
+	kref_put(&ipoctal->kref, ipoctal_release);
 	return res;
 }
 
@@ -709,6 +755,8 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 {
 	int i;
 
+	ipoctal->removed = true;
+
 	ipoctal->dev->bus->ops->free_irq(ipoctal->dev);
 
 	for (i = 0; i < NR_CHANNELS; i++) {
@@ -725,7 +773,7 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 	tty_unregister_driver(ipoctal->tty_drv);
 	kfree(ipoctal->tty_drv->name);
 	tty_driver_kref_put(ipoctal->tty_drv);
-	kfree(ipoctal);
+	kref_put(&ipoctal->kref, ipoctal_release);
 }
 
 static void ipoctal_remove(struct ipack_device *idev)
-- 
2.53.0



