Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC81388E43;
	Fri,  7 Aug 2026 14:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114524; cv=none; b=J45dahqG1XTWUB8qbVxGjeWnBnxNoJFkxxeu6l4ri5+sJYsNMttmhajXfS40plXFkHaWYG0F+0duIk6kbqoXjZNbon3cL6fJ4hUGVLOn1XQyMqYowcFgzrNRvx2jRTeUInPTKNJLVywbznHAv0D1Brj4w//EGnVvM4BivVX3Kko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114524; c=relaxed/simple;
	bh=+1Y6pKf16WP5TOetfI0NGLUcjPzsscq9DZ5RMWLe6Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2+cAO3KZ+vaajY9e5MnF95wTigV2W7To9J2dl7wjEXBXYwVZcvtwtDkF2RWM2Hpk68Tgl4qEcHTD9IJ8TdtIhmT3raKe6AWnnrfgPGDaZ2nr+9YhcjMYLb1ihzFbMukq6J5PAwKphxFImvbJFpE5UGxMCPXjHKbxd1qIoNHlqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIwRWl7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIwRWl7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C891F00A3A;
	Fri,  7 Aug 2026 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114519;
	bh=zBVmPgt4bc73k5ZVlA75I/xy/US3BTGUYIFSoAk6AGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIwRWl7F2tKY3RzSb4I59je1r6A+P5eH0rvnndCNi7vnqvLdYjuMmZAnc40J3hA6t
	 J6ECeF6s7W1KjRAeed0YvVi7Dmde+jRlUUi/XPDunU+uR2pcFRZPJeaK1RLv0irfy+
	 qzC6ko6Tn/moN4ov6AKpFSbY3fRwo1fd9WvgBSSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/337] usb: typec: ucsi: split connector lock classes
Date: Fri,  7 Aug 2026 16:38:15 +0200
Message-ID: <20260807143424.859113804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1569,6 +1569,7 @@ static int ucsi_register_port(struct ucs
 	INIT_WORK(&con->work, ucsi_handle_connector_change);
 	init_completion(&con->complete);
 	mutex_init(&con->lock);
+	lockdep_set_class(&con->lock, &con->lock_key);
 	INIT_LIST_HEAD(&con->partner_tasks);
 	con->ucsi = ucsi;
 
@@ -1808,6 +1809,9 @@ static int ucsi_init(struct ucsi *ucsi)
 		goto err_reset;
 	}
 
+	for (i = 0; i < ucsi->cap.num_connectors; i++)
+		lockdep_register_key(&connector[i].lock_key);
+
 	/* Register all connectors */
 	for (i = 0; i < ucsi->cap.num_connectors; i++) {
 		connector[i].num = i + 1;
@@ -1837,6 +1841,9 @@ static int ucsi_init(struct ucsi *ucsi)
 	return 0;
 
 err_unregister:
+	for (i = 0; i < ucsi->cap.num_connectors; i++)
+		lockdep_unregister_key(&connector[i].lock_key);
+
 	for (con = connector; con->port; con++) {
 		if (con->wq)
 			destroy_workqueue(con->wq);
@@ -2107,6 +2114,7 @@ void ucsi_unregister(struct ucsi *ucsi)
 		usb_power_delivery_unregister(ucsi->connector[i].pd);
 		ucsi->connector[i].pd = NULL;
 		typec_unregister_port(ucsi->connector[i].port);
+		lockdep_unregister_key(&ucsi->connector[i].lock_key);
 	}
 
 	kfree(ucsi->connector);
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -422,6 +422,7 @@ struct ucsi_connector {
 
 	struct ucsi *ucsi;
 	struct mutex lock; /* port lock */
+	struct lock_class_key lock_key;
 	struct work_struct work;
 	struct completion complete;
 	struct workqueue_struct *wq;


