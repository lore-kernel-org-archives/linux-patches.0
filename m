Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829543;
	b=c2lxKFzbOz/nNDI1ObHoEUffccfK7ny6RYD+HmcMK3OUnIY+NufhQ7hXd83In2T9cYBJ
	 Q4CjmgWl29XuvREaUwngJ2Ad33ULPY6Tu5Mes/ZOZ4lU3DEN68yW2aa+bhSL4khCc830G
	 8Zwaso+T+EQwGxGW50nLI0roJoZJnZky0wn39CKH9JMePPutg1PX7FHJQf3JCCJZq5C8h
	 YyussobD3PFBCXv0sYVBmbsglqcSbyP3L+p90Dpg2oVWpDDt6s72uZEZcH31pFPSawHW0
	 +eU9c1rbswEqBq6IDmLwl/qf7zJId2lRD5hA4JSbndQGRAw5L0UJBC/7uIb9i5Do/rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lhlOlHEK28LwQ7m91NdWCWuxJSoe1ZTM424POaKDywE=;
	b=bdh40goET95LVcnxqbAvi3EDZ4Amf0g475vh2VPqZZq0XoS8fpy+KjcfHHV2zoxGIbdG
	 p6/R4v+DBUiNqjx8qJ32c0C8hwVRhTCZk4eNMK2osqE/G+9Y/pAL87h7REl9lPAUJXkmv
	 SeOQkO3glhg21ngFvt20pPVaonxUeufLvv1o9dXKL+y8XZ2jNlz039uIAVPF9zpF8hXOH
	 rR+HVPeYBp3VCaHCJENanxPb6IVc/WulRomJ4t2LZ5x2p9iUIatk8IjjBFUmPNxbsq5SV
	 jP6SLDdd52F5Zd/Gnu5ic/YlavP3L9l7dnk8NMwlEn038tMIlXaPygc5+lvAnEBKDVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JSUcnkh3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE286074FBD;
	Wed,  4 Nov 2026 21:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JSUcnkh3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4EF1F00A1A;
	Wed,  4 Nov 2026 21:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829543;
	bh=lhlOlHEK28LwQ7m91NdWCWuxJSoe1ZTM424POaKDywE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSUcnkh3mGzWynCmdJ4lTuBq+e5ebOzB5yOi5DSksPkJWAhF+3R00TzyKOXi0sPJO
	 wdzHVti+JrpzDVUcSMO41yMhnQ0yLd0AqlAX65FDKN8+rs891bVkW/jzP5yC2DipI6
	 jZLTY6JCUVA2YG7IiO0eQZmTfOSbrVDTsOLlBDWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0193/1005] ipack: ipoctal: add rwsem to guard against TOCTOU in remove path
Date: Wed,  4 Nov 2026 15:58:46 -0500
Message-ID: <20261104211049.201357667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



