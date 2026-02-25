Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E9F2D1F44;
	Wed, 25 Feb 2026 06:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002609; cv=none; b=nU+y0nFmm8DbgT1CaKRQRn4/sKNEItwTFOoUbNosUeMA1gQDj2bxLFtBXl0Caubk259HegPl+mncgVYUXHP+O+t/9Cb51DyOjbXqAYrKst1B41N3SQbtWjSml79rerTHpcfUB8T7vBW+kryn8lCeIEkro1VlheBU6etx94wsMa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002609; c=relaxed/simple;
	bh=bKVcJfrFEDsHJJHhEVFWYEF+Kzz564gI0KNXxjOI0Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rESCxqX8/iW764E68miUxClV/16lAtSZ21Mi+JQBM5aXFnDSZ4ppEK46FIev5mo1kdjXgQBt9DcdH/I3Oss1gGmeK5OWF0I/rRpg3QCYa75Q5B6uqaqtkQaCv2Rvr83tYFz348Q7wr5P2W7rtJpOsa2gnoI4FekP5UCLjPNof08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sX7mAdhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sX7mAdhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8030C116D0;
	Wed, 25 Feb 2026 06:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002608;
	bh=bKVcJfrFEDsHJJHhEVFWYEF+Kzz564gI0KNXxjOI0Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sX7mAdhM0DaCD2JN2bjCKBqIAN2MKLfv53OgriS3VsVxr+VOHDWUNVJ1tARfTm4e6
	 aqSyaAbnM2deEAvi6CHglZhczcc35fWzswqG56Iu7/zNomzcbNvSLKxOnj1udK65ZU
	 VYuihL+ovq+9JScM/h1QyGjDOOoJufhbLe02eXWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 359/641] RDMA/iwcm: Fix workqueue list corruption by removing work_list
Date: Tue, 24 Feb 2026 17:21:25 -0800
Message-ID: <20260225012357.323197791@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 7874eeacfa42177565c01d5198726671acf7adf2 ]

The commit e1168f0 ("RDMA/iwcm: Simplify cm_event_handler()")
changed the work submission logic to unconditionally call
queue_work() with the expectation that queue_work() would
have no effect if work was already pending. The problem is
that a free list of struct iwcm_work is used (for which
struct work_struct is embedded), so each call to queue_work()
is basically unique and therefore does indeed queue the work.

This causes a problem in the work handler which walks the work_list
until it's empty to process entries. This means that a single
run of the work handler could process item N+1 and release it
back to the free list while the actual workqueue entry is still
queued. It could then get reused (INIT_WORK...) and lead to
list corruption in the workqueue logic.

Fix this by just removing the work_list. The workqueue already
does this for us.

This fixes the following error that was observed when stress
testing with ucmatose on an Intel E830 in iWARP mode:

[  151.465780] list_del corruption. next->prev should be ffff9f0915c69c08, but was ffff9f0a1116be08. (next=ffff9f0a15b11c08)
[  151.466639] ------------[ cut here ]------------
[  151.466986] kernel BUG at lib/list_debug.c:67!
[  151.467349] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[  151.467753] CPU: 14 UID: 0 PID: 2306 Comm: kworker/u64:18 Not tainted 6.19.0-rc4+ #1 PREEMPT(voluntary)
[  151.468466] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  151.469192] Workqueue:  0x0 (iw_cm_wq)
[  151.469478] RIP: 0010:__list_del_entry_valid_or_report+0xf0/0x100
[  151.469942] Code: c7 58 5f 4c b2 e8 10 50 aa ff 0f 0b 48 89 ef e8 36 57 cb ff 48 8b 55 08 48 89 e9 48 89 de 48 c7 c7 a8 5f 4c b2 e8 f0 4f aa ff <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 90 90 90 90 90 90
[  151.471323] RSP: 0000:ffffb15644e7bd68 EFLAGS: 00010046
[  151.471712] RAX: 000000000000006d RBX: ffff9f0915c69c08 RCX: 0000000000000027
[  151.472243] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9f0a37d9c600
[  151.472768] RBP: ffff9f0a15b11c08 R08: 0000000000000000 R09: c0000000ffff7fff
[  151.473294] R10: 0000000000000001 R11: ffffb15644e7bba8 R12: ffff9f092339ee68
[  151.473817] R13: ffff9f0900059c28 R14: ffff9f092339ee78 R15: 0000000000000000
[  151.474344] FS:  0000000000000000(0000) GS:ffff9f0a847b5000(0000) knlGS:0000000000000000
[  151.474934] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  151.475362] CR2: 0000559e233a9088 CR3: 000000020296b004 CR4: 0000000000770ef0
[  151.475895] PKRU: 55555554
[  151.476118] Call Trace:
[  151.476331]  <TASK>
[  151.476497]  move_linked_works+0x49/0xa0
[  151.476792]  __pwq_activate_work.isra.46+0x2f/0xa0
[  151.477151]  pwq_dec_nr_in_flight+0x1e0/0x2f0
[  151.477479]  process_scheduled_works+0x1c8/0x410
[  151.477823]  worker_thread+0x125/0x260
[  151.478108]  ? __pfx_worker_thread+0x10/0x10
[  151.478430]  kthread+0xfe/0x240
[  151.478671]  ? __pfx_kthread+0x10/0x10
[  151.478955]  ? __pfx_kthread+0x10/0x10
[  151.479240]  ret_from_fork+0x208/0x270
[  151.479523]  ? __pfx_kthread+0x10/0x10
[  151.479806]  ret_from_fork_asm+0x1a/0x30
[  151.480103]  </TASK>

Fixes: e1168f09b331 ("RDMA/iwcm: Simplify cm_event_handler()")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260112020006.1352438-1-jmoroni@google.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/iwcm.c | 56 +++++++++++++---------------------
 drivers/infiniband/core/iwcm.h |  1 -
 2 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 62410578dec37..eb942ab9c4055 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -95,7 +95,6 @@ static struct workqueue_struct *iwcm_wq;
 struct iwcm_work {
 	struct work_struct work;
 	struct iwcm_id_private *cm_id;
-	struct list_head list;
 	struct iw_cm_event event;
 	struct list_head free_list;
 };
@@ -178,7 +177,6 @@ static int alloc_work_entries(struct iwcm_id_private *cm_id_priv, int count)
 			return -ENOMEM;
 		}
 		work->cm_id = cm_id_priv;
-		INIT_LIST_HEAD(&work->list);
 		put_work(work);
 	}
 	return 0;
@@ -213,7 +211,6 @@ static void free_cm_id(struct iwcm_id_private *cm_id_priv)
 static bool iwcm_deref_id(struct iwcm_id_private *cm_id_priv)
 {
 	if (refcount_dec_and_test(&cm_id_priv->refcount)) {
-		BUG_ON(!list_empty(&cm_id_priv->work_list));
 		free_cm_id(cm_id_priv);
 		return true;
 	}
@@ -260,7 +257,6 @@ struct iw_cm_id *iw_create_cm_id(struct ib_device *device,
 	refcount_set(&cm_id_priv->refcount, 1);
 	init_waitqueue_head(&cm_id_priv->connect_wait);
 	init_completion(&cm_id_priv->destroy_comp);
-	INIT_LIST_HEAD(&cm_id_priv->work_list);
 	INIT_LIST_HEAD(&cm_id_priv->work_free_list);
 
 	return &cm_id_priv->id;
@@ -1007,13 +1003,13 @@ static int process_event(struct iwcm_id_private *cm_id_priv,
 }
 
 /*
- * Process events on the work_list for the cm_id. If the callback
- * function requests that the cm_id be deleted, a flag is set in the
- * cm_id flags to indicate that when the last reference is
- * removed, the cm_id is to be destroyed. This is necessary to
- * distinguish between an object that will be destroyed by the app
- * thread asleep on the destroy_comp list vs. an object destroyed
- * here synchronously when the last reference is removed.
+ * Process events for the cm_id. If the callback function requests
+ * that the cm_id be deleted, a flag is set in the cm_id flags to
+ * indicate that when the last reference is removed, the cm_id is
+ * to be destroyed. This is necessary to distinguish between an
+ * object that will be destroyed by the app thread asleep on the
+ * destroy_comp list vs. an object destroyed here synchronously
+ * when the last reference is removed.
  */
 static void cm_work_handler(struct work_struct *_work)
 {
@@ -1024,35 +1020,26 @@ static void cm_work_handler(struct work_struct *_work)
 	int ret = 0;
 
 	spin_lock_irqsave(&cm_id_priv->lock, flags);
-	while (!list_empty(&cm_id_priv->work_list)) {
-		work = list_first_entry(&cm_id_priv->work_list,
-					struct iwcm_work, list);
-		list_del_init(&work->list);
-		levent = work->event;
-		put_work(work);
-		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
-
-		if (!test_bit(IWCM_F_DROP_EVENTS, &cm_id_priv->flags)) {
-			ret = process_event(cm_id_priv, &levent);
-			if (ret) {
-				destroy_cm_id(&cm_id_priv->id);
-				WARN_ON_ONCE(iwcm_deref_id(cm_id_priv));
-			}
-		} else
-			pr_debug("dropping event %d\n", levent.event);
-		if (iwcm_deref_id(cm_id_priv))
-			return;
-		spin_lock_irqsave(&cm_id_priv->lock, flags);
-	}
+	levent = work->event;
+	put_work(work);
 	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
+
+	if (!test_bit(IWCM_F_DROP_EVENTS, &cm_id_priv->flags)) {
+		ret = process_event(cm_id_priv, &levent);
+		if (ret) {
+			destroy_cm_id(&cm_id_priv->id);
+			WARN_ON_ONCE(iwcm_deref_id(cm_id_priv));
+		}
+	} else
+		pr_debug("dropping event %d\n", levent.event);
+	if (iwcm_deref_id(cm_id_priv))
+		return;
 }
 
 /*
  * This function is called on interrupt context. Schedule events on
  * the iwcm_wq thread to allow callback functions to downcall into
- * the CM and/or block.  Events are queued to a per-CM_ID
- * work_list. If this is the first event on the work_list, the work
- * element is also queued on the iwcm_wq thread.
+ * the CM and/or block.
  *
  * Each event holds a reference on the cm_id. Until the last posted
  * event has been delivered and processed, the cm_id cannot be
@@ -1094,7 +1081,6 @@ static int cm_event_handler(struct iw_cm_id *cm_id,
 	}
 
 	refcount_inc(&cm_id_priv->refcount);
-	list_add_tail(&work->list, &cm_id_priv->work_list);
 	queue_work(iwcm_wq, &work->work);
 out:
 	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
diff --git a/drivers/infiniband/core/iwcm.h b/drivers/infiniband/core/iwcm.h
index bf74639be1287..b56fb12edece4 100644
--- a/drivers/infiniband/core/iwcm.h
+++ b/drivers/infiniband/core/iwcm.h
@@ -50,7 +50,6 @@ struct iwcm_id_private {
 	struct ib_qp *qp;
 	struct completion destroy_comp;
 	wait_queue_head_t connect_wait;
-	struct list_head work_list;
 	spinlock_t lock;
 	refcount_t refcount;
 	struct list_head work_free_list;
-- 
2.51.0



