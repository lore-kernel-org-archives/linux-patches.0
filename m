Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CD8350A0A;
	Wed,  3 Dec 2025 16:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778546; cv=none; b=ViFzbsnBEFtWef82fRXBmidwGnum6LTxuh4rgzTKRS0rnryWqgwrvfNYe74rmXtUJRvbZoSg40eH2XR6a0Exhz+ypPZGn2fce064j3rceOI+v69iO2KhCfmAcd76yhFPdijfuOQrKOBFpkE06vRjjSDO4229aedZwCkpHihjdgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778546; c=relaxed/simple;
	bh=wrhpFJTDlrp6SopfGPbws9akhxByGkFeIokjyDujLzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFC/eKZ/AZo4CH8awhaHATfHgkm1by37XZi9aaf72YDfoP2Ke4N63O8De1yoFv5PiwUVWsck52P87jKeGTAPXhvC2KEN/9Dt5VINoBL9/L8WMdskpY0dye2PhSbeFSLo5SVqFHWJx65fiq2p7AWClzfJAfkUotdWNYQ6J/JbLA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWXKNCrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWXKNCrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AA3C4CEF5;
	Wed,  3 Dec 2025 16:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778546;
	bh=wrhpFJTDlrp6SopfGPbws9akhxByGkFeIokjyDujLzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWXKNCrTjboBNHZ00GQVwnQ9ZsSVOK6suPWU7L0CWo9UeOv+RLkI3U76ocdcXCjWQ
	 KhT1axSpKfI5fsDAwcQFusGV2ldB0/8Gd7RuX3SuoCN/ZIYI9nWtSpTO1MVwEMj0PN
	 mQvk2Bm7rJF+cffTonAhtcc8LuROu+qt8TRJvOz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 5.15 377/392] libceph: fix potential use-after-free in have_mon_and_osd_map()
Date: Wed,  3 Dec 2025 16:28:47 +0100
Message-ID: <20251203152428.027803168@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit 076381c261374c587700b3accf410bdd2dba334e upstream.

The wait loop in __ceph_open_session() can race with the client
receiving a new monmap or osdmap shortly after the initial map is
received.  Both ceph_monc_handle_map() and handle_one_map() install
a new map immediately after freeing the old one

    kfree(monc->monmap);
    monc->monmap = monmap;

    ceph_osdmap_destroy(osdc->osdmap);
    osdc->osdmap = newmap;

under client->monc.mutex and client->osdc.lock respectively, but
because neither is taken in have_mon_and_osd_map() it's possible for
client->monc.monmap->epoch and client->osdc.osdmap->epoch arms in

    client->monc.monmap && client->monc.monmap->epoch &&
        client->osdc.osdmap && client->osdc.osdmap->epoch;

condition to dereference an already freed map.  This happens to be
reproducible with generic/395 and generic/397 with KASAN enabled:

    BUG: KASAN: slab-use-after-free in have_mon_and_osd_map+0x56/0x70
    Read of size 4 at addr ffff88811012d810 by task mount.ceph/13305
    CPU: 2 UID: 0 PID: 13305 Comm: mount.ceph Not tainted 6.14.0-rc2-build2+ #1266
    ...
    Call Trace:
    <TASK>
    have_mon_and_osd_map+0x56/0x70
    ceph_open_session+0x182/0x290
    ceph_get_tree+0x333/0x680
    vfs_get_tree+0x49/0x180
    do_new_mount+0x1a3/0x2d0
    path_mount+0x6dd/0x730
    do_mount+0x99/0xe0
    __do_sys_mount+0x141/0x180
    do_syscall_64+0x9f/0x100
    entry_SYSCALL_64_after_hwframe+0x76/0x7e
    </TASK>

    Allocated by task 13305:
    ceph_osdmap_alloc+0x16/0x130
    ceph_osdc_init+0x27a/0x4c0
    ceph_create_client+0x153/0x190
    create_fs_client+0x50/0x2a0
    ceph_get_tree+0xff/0x680
    vfs_get_tree+0x49/0x180
    do_new_mount+0x1a3/0x2d0
    path_mount+0x6dd/0x730
    do_mount+0x99/0xe0
    __do_sys_mount+0x141/0x180
    do_syscall_64+0x9f/0x100
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

    Freed by task 9475:
    kfree+0x212/0x290
    handle_one_map+0x23c/0x3b0
    ceph_osdc_handle_map+0x3c9/0x590
    mon_dispatch+0x655/0x6f0
    ceph_con_process_message+0xc3/0xe0
    ceph_con_v1_try_read+0x614/0x760
    ceph_con_workfn+0x2de/0x650
    process_one_work+0x486/0x7c0
    process_scheduled_works+0x73/0x90
    worker_thread+0x1c8/0x2a0
    kthread+0x2ec/0x300
    ret_from_fork+0x24/0x40
    ret_from_fork_asm+0x1a/0x30

Rewrite the wait loop to check the above condition directly with
client->monc.mutex and client->osdc.lock taken as appropriate.  While
at it, improve the timeout handling (previously mount_timeout could be
exceeded in case wait_event_interruptible_timeout() slept more than
once) and access client->auth_err under client->monc.mutex to match
how it's set in finish_auth().

monmap_show() and osdmap_show() now take the respective lock before
accessing the map as well.

Cc: stable@vger.kernel.org
Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/ceph_common.c |   53 +++++++++++++++++++++++++++++--------------------
 net/ceph/debugfs.c     |   14 +++++++++---
 2 files changed, 42 insertions(+), 25 deletions(-)

--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -806,41 +806,52 @@ void ceph_reset_client_addr(struct ceph_
 EXPORT_SYMBOL(ceph_reset_client_addr);
 
 /*
- * true if we have the mon map (and have thus joined the cluster)
- */
-static bool have_mon_and_osd_map(struct ceph_client *client)
-{
-	return client->monc.monmap && client->monc.monmap->epoch &&
-	       client->osdc.osdmap && client->osdc.osdmap->epoch;
-}
-
-/*
  * mount: join the ceph cluster, and open root directory.
  */
 int __ceph_open_session(struct ceph_client *client, unsigned long started)
 {
-	unsigned long timeout = client->options->mount_timeout;
-	long err;
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	long timeout = ceph_timeout_jiffies(client->options->mount_timeout);
+	bool have_monmap, have_osdmap;
+	int err;
 
 	/* open session, and wait for mon and osd maps */
 	err = ceph_monc_open_session(&client->monc);
 	if (err < 0)
 		return err;
 
-	while (!have_mon_and_osd_map(client)) {
-		if (timeout && time_after_eq(jiffies, started + timeout))
-			return -ETIMEDOUT;
+	add_wait_queue(&client->auth_wq, &wait);
+	for (;;) {
+		mutex_lock(&client->monc.mutex);
+		err = client->auth_err;
+		have_monmap = client->monc.monmap && client->monc.monmap->epoch;
+		mutex_unlock(&client->monc.mutex);
+
+		down_read(&client->osdc.lock);
+		have_osdmap = client->osdc.osdmap && client->osdc.osdmap->epoch;
+		up_read(&client->osdc.lock);
+
+		if (err || (have_monmap && have_osdmap))
+			break;
+
+		if (signal_pending(current)) {
+			err = -ERESTARTSYS;
+			break;
+		}
+
+		if (!timeout) {
+			err = -ETIMEDOUT;
+			break;
+		}
 
 		/* wait */
 		dout("mount waiting for mon_map\n");
-		err = wait_event_interruptible_timeout(client->auth_wq,
-			have_mon_and_osd_map(client) || (client->auth_err < 0),
-			ceph_timeout_jiffies(timeout));
-		if (err < 0)
-			return err;
-		if (client->auth_err < 0)
-			return client->auth_err;
+		timeout = wait_woken(&wait, TASK_INTERRUPTIBLE, timeout);
 	}
+	remove_wait_queue(&client->auth_wq, &wait);
+
+	if (err)
+		return err;
 
 	pr_info("client%llu fsid %pU\n", ceph_client_gid(client),
 		&client->fsid);
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -36,8 +36,9 @@ static int monmap_show(struct seq_file *
 	int i;
 	struct ceph_client *client = s->private;
 
+	mutex_lock(&client->monc.mutex);
 	if (client->monc.monmap == NULL)
-		return 0;
+		goto out_unlock;
 
 	seq_printf(s, "epoch %d\n", client->monc.monmap->epoch);
 	for (i = 0; i < client->monc.monmap->num_mon; i++) {
@@ -48,6 +49,9 @@ static int monmap_show(struct seq_file *
 			   ENTITY_NAME(inst->name),
 			   ceph_pr_addr(&inst->addr));
 	}
+
+out_unlock:
+	mutex_unlock(&client->monc.mutex);
 	return 0;
 }
 
@@ -56,13 +60,14 @@ static int osdmap_show(struct seq_file *
 	int i;
 	struct ceph_client *client = s->private;
 	struct ceph_osd_client *osdc = &client->osdc;
-	struct ceph_osdmap *map = osdc->osdmap;
+	struct ceph_osdmap *map;
 	struct rb_node *n;
 
+	down_read(&osdc->lock);
+	map = osdc->osdmap;
 	if (map == NULL)
-		return 0;
+		goto out_unlock;
 
-	down_read(&osdc->lock);
 	seq_printf(s, "epoch %u barrier %u flags 0x%x\n", map->epoch,
 			osdc->epoch_barrier, map->flags);
 
@@ -131,6 +136,7 @@ static int osdmap_show(struct seq_file *
 		seq_printf(s, "]\n");
 	}
 
+out_unlock:
 	up_read(&osdc->lock);
 	return 0;
 }


