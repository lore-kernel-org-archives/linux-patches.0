Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033786;
	b=adgaAjIVnqJ+zvg60SKjobHP54DkQZfXRR0iT+ktorqjlij+/NRd3GH0bAYfHh9dfC+w
	 WlhndvoWd9ik935HkW+aHGYLw7RETZg5lUoLijOaCLQyjhEcU+b3steekRay2kV2Pa6wP
	 CA8FU1oxi2emZCqCAI8SWzqKM10DFRppH1GfR+oQkoKi8BKRYgA2/GiruYGdLNBtqYc91
	 QEF/RAk+T6eK1QpmlvysCQQ9+1HSj7/NoqTp18b6BOYqAPYtpgv+tH97uNjAMU0BzcFJW
	 2YblK4sYsvFDSLpD6sRQnkpI6MEydRLRMg5tepHbiHE7Pi2JN7K8qeu3PkEJIoUTrcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RLk190App9SLRKCCxnNvWA9JRHld+SDHJJDXB7wdEq4=;
	b=H16BN7SRBJXO6fIA1+qQSQBefBeW6SZloBsKAoC3POqUk1MVYTlvHkb5ym6QPQmZBqa8
	 mZe/6cZ7gl7yXi9k1jGbRqfv8Gw3jlmlotBUokhGLDmftGGpsQrLklRNARsfmALV61sJ3
	 ACjH7F3Buweu4KMkDhOzcVhcmxcE3OFKGrxLGD0WGPd+7tFpLjmN2VT4op2z+vZwGU/kc
	 yaA/Z7ityyboPV2ZQhuw5+8vedRhQ0b/09b5dwUJNEjrHDM020AVebpbWN2wfJxFQjuPv
	 28625k2hogAgCVQ1pxM4V1ifsnGmJ5JFNl+V4xd1GATvm4JKqW5sk5suCeHUi22X2tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ff3KkqMF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1486F606A325;
	Wed, 18 Nov 2026 20:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ff3KkqMF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F5D1F000C4;
	Wed, 18 Nov 2026 20:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033785;
	bh=RLk190App9SLRKCCxnNvWA9JRHld+SDHJJDXB7wdEq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ff3KkqMFrSW8tWEiSuWw9ioBOORYFMWHXsmrGNyTo4RU4Bts/umNUZaiqtbBTkZJw
	 DzuDrD6Y1bu2IIpgUtubYTWEGAcXVPejG6wp9YardWVynnjysMdA83eW1Nl0mPoyTI
	 8AV8P9JKXNkczXEspITK1S+r0qzvmucrK9u37yLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0138/3318] ipack: ipoctal: add rwsem to guard against TOCTOU in remove path
Date: Wed, 18 Nov 2026 15:12:40 +0100
Message-ID: <20261118150318.581086857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 7d3a708af7f4e2af9e114d731bd60d30c1ec884e ]

The "removed" flag check in each tty op has a TOCTOU race with
__ipoctal_remove(): the device could be removed between the flag
check and the subsequent access to hardware resources (channel
registers via iowrite8, or xmit_buf in write_tty).

Close this race by introducing a read-write semaphore (remove_sem).
The tty ops acquire the read lock via guard(rwsem_read) for the
full duration of the operation, while __ipoctal_remove() acquires
the write lock via scoped_guard(rwsem_write) when setting the
removed flag.  This ensures that once removed is true, no in-flight
tty op can still be accessing resources that are about to be freed
by the remove path.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/fbce75010a0f0a3a3709a5e06fd0ffd19ca0a0ed.1782870760.git.xiaopei01@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ipack/devices/ipoctal.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 474b58858dca6..aab303c4a9837 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/kref.h>
+#include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/serial.h>
@@ -54,6 +55,7 @@ struct ipoctal {
 	u8 __iomem			*int_space;
 	struct kref			kref;
 	struct module			*carrier_owner;
+	struct rw_semaphore		remove_sem;
 	bool				removed;
 };
 
@@ -81,7 +83,7 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 	channel = dev_get_drvdata(tty->dev);
 	ipoctal = chan_to_ipoctal(channel, tty->index);
 
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed)
 		return -ENODEV;
 
@@ -476,7 +478,7 @@ static ssize_t ipoctal_write_tty(struct tty_struct *tty, const u8 *buf,
 	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
 	size_t char_copied;
 
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed || !channel->tty_port.xmit_buf)
 		return 0;
 
@@ -522,7 +524,7 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
 	speed_t baud;
 
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed)
 		return;
 
@@ -660,7 +662,7 @@ static void ipoctal_hangup(struct tty_struct *tty)
 		return;
 
 	ipoctal = chan_to_ipoctal(channel, tty->index);
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed)
 		return;
 
@@ -686,7 +688,7 @@ static void ipoctal_shutdown(struct tty_struct *tty)
 		return;
 
 	ipoctal = chan_to_ipoctal(channel, tty->index);
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed)
 		return;
 
@@ -736,6 +738,7 @@ static int ipoctal_probe(struct ipack_device *dev)
 		return -ENOMEM;
 
 	kref_init(&ipoctal->kref);
+	init_rwsem(&ipoctal->remove_sem);
 
 	ipoctal->dev = dev;
 	ipoctal->carrier_owner = dev->bus->owner;
@@ -755,7 +758,8 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 {
 	int i;
 
-	ipoctal->removed = true;
+	scoped_guard(rwsem_write, &ipoctal->remove_sem)
+		ipoctal->removed = true;
 
 	ipoctal->dev->bus->ops->free_irq(ipoctal->dev);
 
-- 
2.53.0



