Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ACD368276;
	Fri,  7 Aug 2026 15:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115691; cv=none; b=Mkls6+uJ7OFD4uhrXUVdAmBdTo0SST/CCCu+m+30kq0RoNAKXB8E41A69DxTaoO2joxTeyyI9TN0liG0ecdLcXHtQacN53SJj4tq6bcjJsyYxcEhCcNMlVrI40GnDJjzINl50lV9TgkNGsAxiQczd4lGo1pYqKeg3X3PVHof4qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115691; c=relaxed/simple;
	bh=ORLwihstGqAVtHU7Jtby/ZiYjfutwjncwyc9hLCJ7Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHvlq2IwiMNDndFCeOaSjZmavonI4vHhfRHFVNH6m597/16j9kRx6nTjMBvL3lQ7BTQhsr0sXk5i5VjeGWa5dlYWTjyTPzG3YTETjZ7MCurUeh0QaMV1fsO2m6/84PJSHwm3yU8uDRC+CmnBWLLuKrZspdn0ijg+YKWtiV9T91k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1OO0zAg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1OO0zAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8A91F000E9;
	Fri,  7 Aug 2026 15:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115690;
	bh=vYK60Yt9VJefXQl9NF7zSOBg7DiTQatBqv0XfjOmGos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1OO0zAgYNv31n+Itzp0kasXOVSIQcja3wzcUK+mLdNTvLovtL2PHIziycSLossbc
	 MW1L32zcnI/j8R130G5zmLu4HgB/ZFU9giL8bHlfbDy/JohIekFP6S9mYrr8aTtfwI
	 fCx9cIFMwXUeKbxyiNZAAgibDFNFrtHHN83yDv5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 364/396] usb: typec: ucsi: split connector lock classes
Date: Fri,  7 Aug 2026 16:38:44 +0200
Message-ID: <20260807143432.134481149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 8c22256bbafad3dc5fdbe9f684d045b67ff06a68 ]

Lockdep detects a possible recursive locking scenario during
ucsi init:

[    5.418616] ============================================
[    5.418634] WARNING: possible recursive locking detected
[    5.418706] --------------------------------------------
[    5.418725] kworker/4:1/82 is trying to acquire lock:
[    5.418759] ffff888119a34648 (&con->lock){+.+.}-{3:3}, at: ucsi_init_work+0x1a78/0x2eb0 [typec_ucsi]
[    5.418801]
               but task is already holding lock:
[    5.418835] ffff888119a34080 (&con->lock){+.+.}-{3:3}, at: ucsi_init_work+0x1a78/0x2eb0 [typec_ucsi]
[    5.418884]
               other info that might help us debug this:
[    5.418904]  Possible unsafe locking scenario:

[    5.418937]        CPU0
[    5.418956]        ----
[    5.418991]   lock(&con->lock);
[    5.419013]   lock(&con->lock);
[    5.419033]
                *** DEADLOCK ***

[    5.419387] Call Trace:
[    5.419406]  <TASK>
[    5.419425]  dump_stack_lvl+0x61/0xa0
[    5.419448]  print_deadlock_bug+0x4a6/0x650
[    5.419483]  __lock_acquire+0x62b6/0x7f50
[    5.419507]  lock_acquire+0x11b/0x390
[    5.419654]  __mutex_lock+0xbc/0xcd0
[    5.419741]  ucsi_init_work+0x1a78/0x2eb0
[    5.419785]  ? worker_thread+0xf53/0x2bc0
[    5.419819]  worker_thread+0xff4/0x2bc0
[    5.419842]  kthread+0x2a7/0x330
[    5.419863]  ? __pfx_worker_thread+0x10/0x10
[    5.419896]  ? __pfx_kthread+0x10/0x10
[    5.419916]  ret_from_fork+0x38/0x70
[    5.419936]  ? __pfx_kthread+0x10/0x10
[    5.419969]  ret_from_fork_asm+0x1b/0x30
[    5.419991]  </TASK>
[    5.420009] ---[ end trace 0000000000000000 ]---

The problem is that all connector locks belong to the same
lockdep lock class, so the following loop:

	for (i = 0; i < ucsi->cap.num_connectors; i++)
		ucsi_register_port(connector[i])
			mutex_lock(&connector[i]->lock)

looks like a recursive acquire of the same mutex.  Put each connector
lock into a dedicated lock class so that lockdep doesn't see it as a
possible recursion.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260515060042.136083-1-senozhatsky@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 7aa7d4bf9d3f ("usb: typec: ucsi: Fix race condition and ordering in port unregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    8 ++++++++
 drivers/usb/typec/ucsi/ucsi.h |    1 +
 2 files changed, 9 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1741,6 +1741,7 @@ static int ucsi_register_port(struct ucs
 	INIT_WORK(&con->work, ucsi_handle_connector_change);
 	init_completion(&con->complete);
 	mutex_init(&con->lock);
+	lockdep_set_class(&con->lock, &con->lock_key);
 	INIT_LIST_HEAD(&con->partner_tasks);
 	con->ucsi = ucsi;
 
@@ -1981,6 +1982,9 @@ static int ucsi_init(struct ucsi *ucsi)
 		goto err_reset;
 	}
 
+	for (i = 0; i < ucsi->cap.num_connectors; i++)
+		lockdep_register_key(&connector[i].lock_key);
+
 	/* Register all connectors */
 	for (i = 0; i < ucsi->cap.num_connectors; i++) {
 		connector[i].num = i + 1;
@@ -2010,6 +2014,9 @@ static int ucsi_init(struct ucsi *ucsi)
 	return 0;
 
 err_unregister:
+	for (i = 0; i < ucsi->cap.num_connectors; i++)
+		lockdep_unregister_key(&connector[i].lock_key);
+
 	for (con = connector; con->port; con++) {
 		if (con->wq)
 			destroy_workqueue(con->wq);
@@ -2280,6 +2287,7 @@ void ucsi_unregister(struct ucsi *ucsi)
 		usb_power_delivery_unregister(ucsi->connector[i].pd);
 		ucsi->connector[i].pd = NULL;
 		typec_unregister_port(ucsi->connector[i].port);
+		lockdep_unregister_key(&ucsi->connector[i].lock_key);
 	}
 
 	kfree(ucsi->connector);
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -502,6 +502,7 @@ struct ucsi_connector {
 
 	struct ucsi *ucsi;
 	struct mutex lock; /* port lock */
+	struct lock_class_key lock_key;
 	struct work_struct work;
 	struct completion complete;
 	struct workqueue_struct *wq;


