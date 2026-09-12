Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA194352022;
	Sat, 12 Sep 2026 15:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227541; cv=none; b=sSLxtX4DvY1CK8+I9vvyogvjCJo3Gb1+SVcr/uliIDeAghDVD8ZNvEG/ElvtLE1jKuIQcfZSne/hfH9CSNkS9SfOqM8X3kBYyin7lrIZVgn9smUoCL6+V5msKw+0vlc27O41J2vl8ewaUtgR1YFzOQFdvsjvtK3m7mnijHH27tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227541; c=relaxed/simple;
	bh=d7zUtrFPQZvfZly2aOOKW0G/Wr+RISsBdAluwV9wA2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otEr/JHpOVRg3pt/AJOVNxRh3/h19n03zRLuEghAYiKEU3EZ9A9c9RMGn1xecA4DDLdryLxi6u/66ZObjdsVCp+Szme+ZtK51KgHHak0B0Twa5OM9kKj3hDpomT46xvLxXZv3D44JfSkMwZzDY2+lO0FAXfEdd7OkpzYb5oO8NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTujhCOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTujhCOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11D91F000FF;
	Sat, 12 Sep 2026 15:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227539;
	bh=DnxrOhRYTyteXQba7zMuumoto7haPMW9dfcKfwggUTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTujhCOk4cKJHXKPIa+q0wnX2PFfK1SvbXO6Q86EA+mtL+76uo7+5l/NFkBz3Joc5
	 gF5CNc2oDF+sGGW7oN4lLl6lRGV79amyGNP8TMV6s0zNoaqkCYnaMWOcZVjKMMUKZk
	 NrCg3+uNn+S4hgy1LNGuiav+Pvv5gPpOaGppSsyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Aleksandr Khromov <haa@amicon.ru>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 0203/1191] slip: fix use-after-free in sl_sync()
Date: Sat, 12 Sep 2026 08:48:51 +0200
Message-ID: <20260912065552.770644264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Khromov <haa@amicon.ru>

commit 2c4e7c42d77e78ad595dbb9e4b5886b58b45d89d upstream.

slip_devs[] stores bare net_device pointers and takes no reference on
them.  sl_sync() and sl_alloc() walk that table from slip_open() under
rtnl_lock(), while an entry is dropped by sl_free_netdev(), which
sl_setup() installs as dev->priv_destructor.

priv_destructor is called from netdev_run_todo(), which deliberately
runs with the RTNL semaphore released so that it can sleep while waiting
for the device refcount to drop:

	/* Snapshot list, allow later requests */
	list_replace_init(&net_todo_list, &list);

	__rtnl_unlock();
	...
		if (dev->priv_destructor)
			dev->priv_destructor(dev);	/* slip_devs[i] = NULL */
		if (dev->needs_free_netdev)
			free_netdev(dev);
		...
		/* Free network device */
		kobject_put(&dev->dev.kobj);

So rtnl_lock() does not serialise slip_open() against the teardown at
all.  sl_sync() can load slip_devs[i] while the entry is still published
and dereference it after netdev_run_todo() has run the destructor and
released the device:

  CPU0 (slip_open)                 CPU1 (slip_close)
                                   unregister_netdev()
                                     rtnl_unlock()
                                       netdev_run_todo()
                                         __rtnl_unlock()
  rtnl_lock()
  sl_sync()
    dev = slip_devs[i]
                                         priv_destructor(dev)
                                           slip_devs[i] = NULL
                                         kobject_put(&dev->dev.kobj)
                                           /* dev is freed */
    sl = netdev_priv(dev)
    if (sl->tty || sl->leased)     /* use-after-free */

  BUG: KASAN: use-after-free in sl_sync drivers/net/slip/slip.c:730 [inline]
  BUG: KASAN: use-after-free in slip_open+0xef4/0x1210 drivers/net/slip/slip.c:806
  Read of size 1 at addr ffff8880712dac71 by task syz-executor.2/6506

  CPU: 2 PID: 6506 Comm: syz-executor.2 Not tainted 6.1.134-syzkaller-00260-g0c8fc3469765 #0
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
  Call Trace:
   sl_sync drivers/net/slip/slip.c:730 [inline]
   slip_open+0xef4/0x1210 drivers/net/slip/slip.c:806
   tty_ldisc_open+0xa2/0x120 drivers/tty/tty_ldisc.c:433
   tty_set_ldisc+0x324/0x720 drivers/tty/tty_ldisc.c:564
   tiocsetd drivers/tty/tty_io.c:2428 [inline]
   tty_ioctl+0x5f0/0x1530 drivers/tty/tty_io.c:2712

  Allocated by task 6502:
   alloc_netdev_mqs+0x98/0xfe0 net/core/dev.c:10719
   sl_alloc drivers/net/slip/slip.c:756 [inline]
   slip_open+0x36d/0x1210 drivers/net/slip/slip.c:817
   tty_ldisc_open+0xa2/0x120 drivers/tty/tty_ldisc.c:433
   tty_set_ldisc+0x324/0x720 drivers/tty/tty_ldisc.c:564

  Freed by task 6497:
   device_release+0xa2/0x240 drivers/base/core.c:2507
   kobject_put+0x179/0x280 lib/kobject.c:729
   netdev_run_todo+0x6c8/0xef0 net/core/dev.c:10509
   slip_close+0x166/0x1c0 drivers/net/slip/slip.c:906
   tty_ldisc_close+0x113/0x1a0 drivers/tty/tty_ldisc.c:456
   tty_ldisc_kill+0x94/0x160 drivers/tty/tty_ldisc.c:614
   tty_ldisc_release+0xe3/0x2b0 drivers/tty/tty_ldisc.c:782
   tty_release+0xbcc/0xe70 drivers/tty/tty_io.c:1860

Commit e58c19124189 ("slip: Fix use-after-free Read in slip_open") fixed
a different source of stale entries - a device left in slip_devs[] after
slip_open() freed it on the registration error path - and does not
address this race, which is why the report survives it.

Drop the entry from ndo_uninit instead.  unregister_netdevice() calls
ndo_uninit under RTNL, before the device is queued to netdev_run_todo(),
so an entry that sl_sync() can still see while holding RTNL belongs to a
device that cannot be freed until RTNL is dropped.  sl_free_netdev()
stays only for the slip_open() error path, where register_netdevice()
may have failed before ndo_init and ndo_uninit is then not called
either.  Both running for the same device is harmless: they run under
the same RTNL section, so the slot cannot have been reused in between.

This also removes the second symptom of the missing exclusion: a
destructor running after sl_alloc() had already handed the slot out to
another channel used to clear a live entry, so sl_sync() stopped at that
NULL, sl_alloc() returned the same index again, and
register_netdevice() failed with -EEXIST because slN was still there.

Reproduced on x86_64 with several threads looping over
open("/dev/ptmx") + ioctl(TIOCSETD, N_SLIP) + close().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 5342b77c4123 ("slip: Clean up create and destroy")
Cc: stable@vger.kernel.org
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
Link: https://patch.msgid.link/20260824100547.164773-1-haa@amicon.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/slip/slip.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -628,9 +628,15 @@ static void sl_uninit(struct net_device
 	struct slip *sl = netdev_priv(dev);
 
 	sl_free_bufs(sl);
+	/* Drop the slip_devs[] entry here rather than from the destructor:
+	 * ndo_uninit runs under RTNL, so it cannot race sl_sync().
+	 */
+	slip_devs[dev->base_addr] = NULL;
 }
 
-/* Hook the destructor so we can free slip devices at the right point in time */
+/* Only for the slip_open() error path: register_netdevice() can fail before
+ * ndo_init, and then ndo_uninit is not called either.
+ */
 static void sl_free_netdev(struct net_device *dev)
 {
 	int i = dev->base_addr;
@@ -657,7 +663,6 @@ static void sl_setup(struct net_device *
 {
 	dev->netdev_ops		= &sl_netdev_ops;
 	dev->needs_free_netdev	= true;
-	dev->priv_destructor	= sl_free_netdev;
 
 	dev->hard_header_len	= 0;
 	dev->addr_len		= 0;
@@ -908,7 +913,7 @@ static void slip_close(struct tty_struct
 #endif
 	/* Flush network side */
 	unregister_netdev(sl->dev);
-	/* This will complete via sl_free_netdev */
+	/* sl_uninit() has dropped the slip_devs[] entry by now */
 }
 
 static void slip_hangup(struct tty_struct *tty)


