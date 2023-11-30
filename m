Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BB051002;
	Thu, 30 Nov 2023 16:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8l69Tfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987FEC433C8;
	Thu, 30 Nov 2023 16:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361910;
	bh=KyHefMf/c3aymI1DoDR75PrqTAPXalbposaawP8Ez18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8l69TfxJaw72Y5Bw0fWhFDfSyArMsDffYpLB/PPAehkfSSehjds41fUmaYS/URG7
	 Eo1eu9gimqIpltU7xkPdNhVFWqymulshFQiHnE7C4l88x4OwxZx1AA4eUlW0vWC625
	 5niajcJvSSWqAY4ohiWnWFOZzJBBOqRlqWn/QFRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Yi <be286@163.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/69] HID: fix HID device resource race between HID core and debugging support
Date: Thu, 30 Nov 2023 16:22:09 +0000
Message-ID: <20231130162133.479040007@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Charles Yi <be286@163.com>

[ Upstream commit fc43e9c857b7aa55efba9398419b14d9e35dcc7d ]

hid_debug_events_release releases resources bound to the HID device instance.
hid_device_release releases the underlying HID device instance potentially
before hid_debug_events_release has completed releasing debug resources bound
to the same HID device instance.

Reference count to prevent the HID device instance from being torn down
preemptively when HID debugging support is used. When count reaches zero,
release core resources of HID device instance using hiddev_free.

The crash:

[  120.728477][ T4396] kernel BUG at lib/list_debug.c:53!
[  120.728505][ T4396] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[  120.739806][ T4396] Modules linked in: bcmdhd dhd_static_buf 8822cu pcie_mhi r8168
[  120.747386][ T4396] CPU: 1 PID: 4396 Comm: hidt_bridge Not tainted 5.10.110 #257
[  120.754771][ T4396] Hardware name: Rockchip RK3588 EVB4 LP4 V10 Board (DT)
[  120.761643][ T4396] pstate: 60400089 (nZCv daIf +PAN -UAO -TCO BTYPE=--)
[  120.768338][ T4396] pc : __list_del_entry_valid+0x98/0xac
[  120.773730][ T4396] lr : __list_del_entry_valid+0x98/0xac
[  120.779120][ T4396] sp : ffffffc01e62bb60
[  120.783126][ T4396] x29: ffffffc01e62bb60 x28: ffffff818ce3a200
[  120.789126][ T4396] x27: 0000000000000009 x26: 0000000000980000
[  120.795126][ T4396] x25: ffffffc012431000 x24: ffffff802c6d4e00
[  120.801125][ T4396] x23: ffffff8005c66f00 x22: ffffffc01183b5b8
[  120.807125][ T4396] x21: ffffff819df2f100 x20: 0000000000000000
[  120.813124][ T4396] x19: ffffff802c3f0700 x18: ffffffc01d2cd058
[  120.819124][ T4396] x17: 0000000000000000 x16: 0000000000000000
[  120.825124][ T4396] x15: 0000000000000004 x14: 0000000000003fff
[  120.831123][ T4396] x13: ffffffc012085588 x12: 0000000000000003
[  120.837123][ T4396] x11: 00000000ffffbfff x10: 0000000000000003
[  120.843123][ T4396] x9 : 455103d46b329300 x8 : 455103d46b329300
[  120.849124][ T4396] x7 : 74707572726f6320 x6 : ffffffc0124b8cb5
[  120.855124][ T4396] x5 : ffffffffffffffff x4 : 0000000000000000
[  120.861123][ T4396] x3 : ffffffc011cf4f90 x2 : ffffff81fee7b948
[  120.867122][ T4396] x1 : ffffffc011cf4f90 x0 : 0000000000000054
[  120.873122][ T4396] Call trace:
[  120.876259][ T4396]  __list_del_entry_valid+0x98/0xac
[  120.881304][ T4396]  hid_debug_events_release+0x48/0x12c
[  120.886617][ T4396]  full_proxy_release+0x50/0xbc
[  120.891323][ T4396]  __fput+0xdc/0x238
[  120.895075][ T4396]  ____fput+0x14/0x24
[  120.898911][ T4396]  task_work_run+0x90/0x148
[  120.903268][ T4396]  do_exit+0x1bc/0x8a4
[  120.907193][ T4396]  do_group_exit+0x8c/0xa4
[  120.911458][ T4396]  get_signal+0x468/0x744
[  120.915643][ T4396]  do_signal+0x84/0x280
[  120.919650][ T4396]  do_notify_resume+0xd0/0x218
[  120.924262][ T4396]  work_pending+0xc/0x3f0

[ Rahul Rameshbabu <sergeantsagara@protonmail.com>: rework changelog ]
Fixes: cd667ce24796 ("HID: use debugfs for events/reports dumping")
Signed-off-by: Charles Yi <be286@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c  | 12 ++++++++++--
 drivers/hid/hid-debug.c |  3 +++
 include/linux/hid.h     |  3 +++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 35046adf1294e..7b76405df8c47 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -702,15 +702,22 @@ static void hid_close_report(struct hid_device *device)
  * Free a device structure, all reports, and all fields.
  */
 
-static void hid_device_release(struct device *dev)
+void hiddev_free(struct kref *ref)
 {
-	struct hid_device *hid = to_hid_device(dev);
+	struct hid_device *hid = container_of(ref, struct hid_device, ref);
 
 	hid_close_report(hid);
 	kfree(hid->dev_rdesc);
 	kfree(hid);
 }
 
+static void hid_device_release(struct device *dev)
+{
+	struct hid_device *hid = to_hid_device(dev);
+
+	kref_put(&hid->ref, hiddev_free);
+}
+
 /*
  * Fetch a report description item from the data stream. We support long
  * items, though they are not used yet.
@@ -2490,6 +2497,7 @@ struct hid_device *hid_allocate_device(void)
 	spin_lock_init(&hdev->debug_list_lock);
 	sema_init(&hdev->driver_input_lock, 1);
 	mutex_init(&hdev->ll_open_lock);
+	kref_init(&hdev->ref);
 
 	return hdev;
 }
diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 03da865e423c7..b8274bdd7d27f 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -1096,6 +1096,7 @@ static int hid_debug_events_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 	list->hdev = (struct hid_device *) inode->i_private;
+	kref_get(&list->hdev->ref);
 	file->private_data = list;
 	mutex_init(&list->read_mutex);
 
@@ -1188,6 +1189,8 @@ static int hid_debug_events_release(struct inode *inode, struct file *file)
 	list_del(&list->node);
 	spin_unlock_irqrestore(&list->hdev->debug_list_lock, flags);
 	kfifo_free(&list->hid_debug_fifo);
+
+	kref_put(&list->hdev->ref, hiddev_free);
 	kfree(list);
 
 	return 0;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 4fa40d2e821f2..ad97435d8e01d 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -630,10 +630,13 @@ struct hid_device {							/* device report descriptor */
 	struct list_head debug_list;
 	spinlock_t  debug_list_lock;
 	wait_queue_head_t debug_wait;
+	struct kref			ref;
 
 	unsigned int id;						/* system unique id */
 };
 
+void hiddev_free(struct kref *ref);
+
 #define to_hid_device(pdev) \
 	container_of(pdev, struct hid_device, dev)
 
-- 
2.42.0



