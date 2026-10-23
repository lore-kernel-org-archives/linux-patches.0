Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774383;
	b=QLX/OeP1PKhu9TE3NnSoqoCrdwvTqCdcCsnkuSC5UTGc+bqEenb6h/Jsthc4UCbJ1I9f
	 /sZ69rPxlNmMHG8YQq8j2jAYfMg8B9C8TEIpbNPR7J1J5yXbq95rPlOqmQcAHYv3OTMZ9
	 3qi9tarj8P1uFj0qmMgbER5oVk5fhjsOzMLevijg6vGJGMxDlTHfe6x7w8s1mLmQeNw6L
	 d49YJbishXdc0GAeTGvX+UlXQllfh3S2ixnD/Un5KAiEEb6oqkOHyi0yfYhkJbyyRvKRf
	 to+m1O28UV72rSbNE5cpV7tjIuIeoJhDBZbhcq0O4HojPEmGuS+20NbJguJ9hR5oFfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JYZpcCPSqKdv/1mbAQeBTrB3yW7a5A3NwkVkSO6ARcw=;
	b=tPupWEtvPaBTVvOAxmuCVKzrmf40SUJHRaKyU/L67MWJDpAc00d2306Z6tIBaNdXhNgs
	 XHVDw2C+nJK9D1RWGiWnqXpU0/riTofsPp2RxEDKs7FinX3Wx5QBpXyosK9tAu8MwuUYA
	 IEfWYkN9PrV8zXaGTKXM99/lwtnP1B7qR0GgJryHq2MH/X5Cbms9biWECm8oYbayIxFFi
	 NA+Vmt2LuVMkUDSnt2ZysL0fm8GA3NehBDUmPv7nETmGMlyKk3Pm8YVLd5o4W9g8vGzdh
	 e1tzvfyMnq3Q/rP7/gdcrtwtTeG4PeHcTQboNCF08DNnO7TtDwKkkrFVCNo7zXcPNaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PU0aqz6P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7858D606A31A;
	Fri, 23 Oct 2026 16:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PU0aqz6P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70561F01825;
	Fri, 23 Oct 2026 16:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774383;
	bh=JYZpcCPSqKdv/1mbAQeBTrB3yW7a5A3NwkVkSO6ARcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PU0aqz6PQb95V9hbUdHO/4rnTbVGboudQBC41e39cs2WGhmQPjQ/LSQXAHXqU/VYk
	 mMbjnUdtncKYWyYF+TafpucNP+j9uzKYzOOaTjIZ777NlvOV4nKBXby5TcAmdi0lcB
	 WYnQ7ZbG+3f6fIOVI4EfKGTgNFf1Ok1DN1vnN5Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 023/242] power: supply: core: prevent unregistering a power supply while a callback runs
Date: Fri, 23 Oct 2026 18:37:45 +0200
Message-ID: <20261023163714.331346403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@flipper.net>

[ Upstream commit 5b4bd13e0552926648a46c2c9a12a24dfaee3715 ]

Once a power supply is registered, its callbacks can immediately start
firing from other contexts, such as external_power_changed() triggered by
the TCPM stack. If a power supply is unregistered while the callback is
still running, the driver data can already be freed when the callback
tries to access it, leading to a use-after-free.

This happens e.g. when the hardware bus carrying the power supply device
malfunctions (e.g. I2C is hogged down by another malfunctioning device)
immediately after the power supply is registered, and thus the core is
still processing the callbacks which were queued up when the driver
starts the removal, leading in some cases to a kernel crash, e.g.:

[   11.645942] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000005
[   11.646751] Mem abort info:
[   11.647006]   ESR = 0x0000000096000004
[   11.647338]   EC = 0x25: DABT (current EL), IL = 32 bits
[   11.647806]   SET = 0, FnV = 0
[   11.648077]   EA = 0, S1PTW = 0
[   11.648356]   FSC = 0x04: level 0 translation fault
[   11.648785] Data abort info:
[   11.649041]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[   11.649524]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[   11.649981]   GCS = 0, Overlay = 0, DirtyBit = 0
[   11.650390] [0000000000000005] user address but active_mm is swapper
[   11.650955] Internal error: Oops: 0000000096000004 [#1]  SMP
[   11.651460] Modules linked in:
[   11.651742] CPU: 1 UID: 0 PID: 144 Comm: kworker/1:2 Not tainted 7.2.0-rc6-g62a9297af2cd #1 PREEMPT
[   11.652553] Hardware name: Flipper One rev. F0B1C2 (DT)
[   11.653024] Workqueue: events power_supply_changed_work
[   11.653511] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   11.654135] pc : __power_supply_is_supplied_by+0x18/0x100
[   11.654624] lr : __power_supply_am_i_supplied+0x40/0xb8
[   11.655098] sp : ffff80008192bb30
[   11.655399] x29: ffff80008192bb30 x28: 0000000000000000 x27: 0000000000000000
[   11.656049] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
[   11.656695] x23: ffff0000c19f4200 x22: ffffdb2232ba4ea8 x21: ffff80008192bc28
[   11.657344] x20: ffff0000c1eef000 x19: ffff80008192bc18 x18: 00000000a0886e62
[   11.657991] x17: 000000040044ffff x16: 04500072b5503510 x15: 0000000000000000
[   11.658639] x14: 0000000000000000 x13: 0000000000000220 x12: 0000000000000000
[   11.659286] x11: 0000000000000000 x10: ffff0000c1fdb2b0 x9 : ffffdb2232ba5590
[   11.659934] x8 : 00000000e5b906e6 x7 : ffff0000c2502778 x6 : ffffdb22339793d0
[   11.660581] x5 : ffff80008192bc18 x4 : ffff0000c19cbca0 x3 : 0000000000000000
[   11.661228] x2 : ffff0000c1fdaf40 x1 : ffffffffffffffed x0 : ffff0000c1eef000
[   11.661878] Call trace:
[   11.662103]  __power_supply_is_supplied_by+0x18/0x100 (P)
[   11.662596]  __power_supply_am_i_supplied+0x40/0xb8
[   11.663040]  psy_for_each_psy_cb+0x20/0x40
[   11.663416]  class_for_each_device+0x110/0x150
[   11.663825]  power_supply_am_i_supplied+0x68/0x100
[   11.664262]  bq257xx_external_power_changed+0x58/0x140
[   11.664733]  __power_supply_changed_work+0x60/0x80
[   11.665170]  psy_for_each_psy_cb+0x20/0x40
[   11.665545]  class_for_each_device+0x110/0x150
[   11.665953]  power_supply_changed_work+0x98/0x1b8
[   11.666382]  process_one_work+0x164/0x4c0
[   11.666758]  worker_thread+0x19c/0x320
[   11.667104]  kthread+0x138/0x150
[   11.667408]  ret_from_fork+0x10/0x20
[   11.667744] Code: d503233f a9bd7bfd 910003fd a90153f3 (f9400c34)
[   11.668294] ---[ end trace 0000000000000000 ]---

Add a read-write semaphore between external_power_changed() and
power_supply_unregister() to prevent the latter from returning (and thus
the driver from freeing its data) while the callback is still running.

Fixes: bc1540561c9e ("power_supply: Add API for safe access of power supply function attrs")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Link: https://patch.msgid.link/20260910-bq257xx-init-v3-1-4e219a1a04a5@flipper.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 26 +++++++++++++++++++++++-
 include/linux/power_supply.h             | 10 +++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 2532e221b2e19..b83f0858afab3 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -1377,6 +1377,19 @@ void power_supply_external_power_changed(struct power_supply *psy)
 			!psy->desc->external_power_changed)
 		return;
 
+	/*
+	 * Keep power_supply_unregister() from returning, and thus from letting
+	 * the driver's data be freed, while the callback is running. The
+	 * ->removing check has to happen under the lock: on its own, just like
+	 * the use_cnt check above, it only tells us the supply was still there
+	 * when we looked, not that it still is by the time the callback
+	 * dereferences its driver data.
+	 */
+	guard(rwsem_read)(&psy->epc_sem);
+
+	if (psy->removing)
+		return;
+
 	psy->desc->external_power_changed(psy);
 }
 EXPORT_SYMBOL_GPL(power_supply_external_power_changed);
@@ -1621,6 +1634,7 @@ __power_supply_register(struct device *parent,
 	}
 
 	spin_lock_init(&psy->changed_lock);
+	init_rwsem(&psy->epc_sem);
 	init_rwsem(&psy->extensions_sem);
 	INIT_LIST_HEAD(&psy->extensions);
 
@@ -1753,7 +1767,17 @@ EXPORT_SYMBOL_GPL(devm_power_supply_register);
 void power_supply_unregister(struct power_supply *psy)
 {
 	WARN_ON(atomic_dec_return(&psy->use_cnt));
-	psy->removing = true;
+
+	/*
+	 * Publish ->removing so that no new ->external_power_changed() call can
+	 * start, and wait via semaphore for one that is already running: it may
+	 * be a supplier's changed_work, which cancel_work_sync() below does not
+	 * cover, and it may still dereference driver data that the caller is
+	 * about to free.
+	 */
+	scoped_guard(rwsem_write, &psy->epc_sem)
+		psy->removing = true;
+
 	cancel_work_sync(&psy->changed_work);
 	cancel_delayed_work_sync(&psy->deferred_register_work);
 	sysfs_remove_link(&psy->dev.kobj, "powers");
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index b85fd02409c67..433ac0923bda1 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -338,6 +338,16 @@ struct power_supply {
 	bool removing;
 	atomic_t use_cnt;
 	struct power_supply_battery_info *battery_info;
+	/*
+	 * Held for read while ->external_power_changed() runs, and for write by
+	 * power_supply_unregister() when it publishes @removing, so that it
+	 * waits for an in-flight callback to finish. Without this a driver's
+	 * data, typically devm-allocated on its own device, can be freed while
+	 * the callback is still using it.
+	 * Must not be shared with extensions_sem: callbacks may read their own
+	 * properties, which takes that one for read.
+	 */
+	struct rw_semaphore epc_sem;
 	struct rw_semaphore extensions_sem; /* protects "extensions" */
 	struct list_head extensions;
 #ifdef CONFIG_THERMAL
-- 
2.53.0



