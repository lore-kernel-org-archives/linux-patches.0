Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D4434CD3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4701CC433EF;
	Wed,  7 Jun 2023 20:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170388;
	bh=pqzdTNgUwHqgceYCq0XJCIoUPvNv3LVkJxE36qND4w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoMsDFImpdUN9gJGyXE3189dHyqlHG2NKwJm0Abi93DolYavjhA3SRc6tuRVTKxUG
	 vghSH3a7AbT/uP6rzNAHrKnJXHnpPZ4jiitlgnsp93gV24YeofIDuC1piSVKEpjMtA
	 Vh/TcQe2nCxfMD8fvQ+hjV63wxVOLzURF86TbSOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jassi Brar <jaswinder.singh@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/225] mailbox: mailbox-test: Fix potential double-free in mbox_test_message_write()
Date: Wed,  7 Jun 2023 22:14:19 +0200
Message-ID: <20230607200916.520729975@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lee Jones <lee@kernel.org>

[ Upstream commit 2d1e952a2b8e5e92d8d55ac88a7cf7ca5ea591ad ]

If a user can make copy_from_user() fail, there is a potential for
UAF/DF due to a lack of locking around the allocation, use and freeing
of the data buffers.

This issue is not theoretical.  I managed to author a POC for it:

    BUG: KASAN: double-free in kfree+0x5c/0xac
    Free of addr ffff29280be5de00 by task poc/356
    CPU: 1 PID: 356 Comm: poc Not tainted 6.1.0-00001-g961aa6552c04-dirty #20
    Hardware name: linux,dummy-virt (DT)
    Call trace:
     dump_backtrace.part.0+0xe0/0xf0
     show_stack+0x18/0x40
     dump_stack_lvl+0x64/0x80
     print_report+0x188/0x48c
     kasan_report_invalid_free+0xa0/0xc0
     ____kasan_slab_free+0x174/0x1b0
     __kasan_slab_free+0x18/0x24
     __kmem_cache_free+0x130/0x2e0
     kfree+0x5c/0xac
     mbox_test_message_write+0x208/0x29c
     full_proxy_write+0x90/0xf0
     vfs_write+0x154/0x440
     ksys_write+0xcc/0x180
     __arm64_sys_write+0x44/0x60
     invoke_syscall+0x60/0x190
     el0_svc_common.constprop.0+0x7c/0x160
     do_el0_svc+0x40/0xf0
     el0_svc+0x2c/0x6c
     el0t_64_sync_handler+0xf4/0x120
     el0t_64_sync+0x18c/0x190

    Allocated by task 356:
     kasan_save_stack+0x3c/0x70
     kasan_set_track+0x2c/0x40
     kasan_save_alloc_info+0x24/0x34
     __kasan_kmalloc+0xb8/0xc0
     kmalloc_trace+0x58/0x70
     mbox_test_message_write+0x6c/0x29c
     full_proxy_write+0x90/0xf0
     vfs_write+0x154/0x440
     ksys_write+0xcc/0x180
     __arm64_sys_write+0x44/0x60
     invoke_syscall+0x60/0x190
     el0_svc_common.constprop.0+0x7c/0x160
     do_el0_svc+0x40/0xf0
     el0_svc+0x2c/0x6c
     el0t_64_sync_handler+0xf4/0x120
     el0t_64_sync+0x18c/0x190

    Freed by task 357:
     kasan_save_stack+0x3c/0x70
     kasan_set_track+0x2c/0x40
     kasan_save_free_info+0x38/0x5c
     ____kasan_slab_free+0x13c/0x1b0
     __kasan_slab_free+0x18/0x24
     __kmem_cache_free+0x130/0x2e0
     kfree+0x5c/0xac
     mbox_test_message_write+0x208/0x29c
     full_proxy_write+0x90/0xf0
     vfs_write+0x154/0x440
     ksys_write+0xcc/0x180
     __arm64_sys_write+0x44/0x60
     invoke_syscall+0x60/0x190
     el0_svc_common.constprop.0+0x7c/0x160
     do_el0_svc+0x40/0xf0
     el0_svc+0x2c/0x6c
     el0t_64_sync_handler+0xf4/0x120
     el0t_64_sync+0x18c/0x190

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-test.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mailbox/mailbox-test.c b/drivers/mailbox/mailbox-test.c
index 4555d678fadda..6dd5b9614452b 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/mailbox_client.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/poll.h>
@@ -38,6 +39,7 @@ struct mbox_test_device {
 	char			*signal;
 	char			*message;
 	spinlock_t		lock;
+	struct mutex		mutex;
 	wait_queue_head_t	waitq;
 	struct fasync_struct	*async_queue;
 	struct dentry		*root_debugfs_dir;
@@ -110,6 +112,8 @@ static ssize_t mbox_test_message_write(struct file *filp,
 		return -EINVAL;
 	}
 
+	mutex_lock(&tdev->mutex);
+
 	tdev->message = kzalloc(MBOX_MAX_MSG_LEN, GFP_KERNEL);
 	if (!tdev->message)
 		return -ENOMEM;
@@ -144,6 +148,8 @@ static ssize_t mbox_test_message_write(struct file *filp,
 	kfree(tdev->message);
 	tdev->signal = NULL;
 
+	mutex_unlock(&tdev->mutex);
+
 	return ret < 0 ? ret : count;
 }
 
@@ -392,6 +398,7 @@ static int mbox_test_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, tdev);
 
 	spin_lock_init(&tdev->lock);
+	mutex_init(&tdev->mutex);
 
 	if (tdev->rx_channel) {
 		tdev->rx_buffer = devm_kzalloc(&pdev->dev,
-- 
2.39.2



