Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060745;
	b=y/c+nKPwZTH49XXdJReWwlHKZI/zvSL2cqZd7E7/30cngSFWvcCZunIpqK/nNbV8OIg1
	 jyfGbtVPQHTlaLHx0V8lGY1rJCalmXbyDkLZvq5T9eMGnqwjYRHqSkL0/QwhaI5GHyoPy
	 drKYym5FTuczxKxSmrp7loWUyMobR0nwFpGxg5g/KP1ht65yJtD4cMdJLY5pPWHp7ZEHL
	 9jSgqIRIpoq9l5mBE0AV3t5T45ggiDhWiyshAAQnuoVJYPlkWAF1NhJZoEg2b9B9H/kC3
	 Axq4LkXg+PjwGsEU+quzGzL4bj4JIRX0XZ9oDcySGnLCC7XwWo7KqRZ8An0JE9OxfGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GsQvfSDQ8hW8rJBNiWfFeE9o4zQ8uKt4+5HvQjyFPpQ=;
	b=00or+m+ttMeFBEsvWF4qkZQvxzkNS/x2oVQs37qexC5H9+5eUmQrI7YFIB/mFX9BA7zu
	 5/eXLK71Ux0AekZAvizGak10WnHuEb9BDbA/3MOxQNHaTW8zDahGRgBjf2adz0svT6np1
	 GRbO3o2rcKPDqhdz574CHR+mYGvJNWZrh62MqfIk+XWShCXV82SaGGp4s8teMiMGEYu0u
	 4O8BiIepLK7zLOmGwYdt61AmAdnQE9HeLzfaUGYUWqi6eYBjS1nId+aeVeY8sVFct/AdT
	 AWI1vOXzDa6x+cyrBWoroj7os4qZchOJaasw5U+M0XWX/R8gCUv4wiXFF7oSSnfiVpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stK8cS7H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5CF606A326;
	Sat,  7 Nov 2026 14:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stK8cS7H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C061F0089F;
	Sat,  7 Nov 2026 14:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060745;
	bh=GsQvfSDQ8hW8rJBNiWfFeE9o4zQ8uKt4+5HvQjyFPpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stK8cS7HqN4ljgOpxpFktJWxXWcYB93fAVmCC4+BwD6gsvUNmdix21rs1ejH9usJj
	 bI+1wtG/WvhmOAtHkGzeI2M/HNzWkdc2gk6WFSjp59wVzsgNThl5otEhgT8gS3KeyW
	 rKkBN0BlmAlr+rL4mYbQBC1Wy7gn0wvPyjwvkmvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0160/1536] ipack: ipoctal: add rwsem to guard against TOCTOU in remove path
Date: Sat,  7 Nov 2026 08:36:16 -0500
Message-ID: <20261107135002.168273964@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



