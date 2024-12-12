Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9651E211493;
	Thu, 12 Dec 2024 17:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024354; cv=none; b=OQO4F1FhCBm5j+52v66lU5NmNvwSk+/OPQjyOOhmTo9ACL5ZQBcrTxCu9Pjgun6VkD8nyvzMyYiUrl/FK1cWBBTvXL40/X4KYrpOeNzxIxChlsx40x0V0/VDTBI18npYhxc7oYWiY7PJ31BRwvoFo01HLKTj3uqZRzA/+qpJFuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024354; c=relaxed/simple;
	bh=P6bnw46EBaKR+nzb0bmb40QmuruxPY85nJmyyVRV0SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bINyatYcNzAZWqxG19JCObigcWSxA3Xa13TTut6QivId8yOO3TkIZ01BTTGe1GL/d54Tz4Bc5e98MOlcC+i8mKXDQjOlLNJ2YgjbZmDXu4wsTWBvTCzAloM8ucED614wfMq9SF0blg5wUQZaklZ+DQpJiEN7jxNsW4ixkLmMx30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IfSyhPVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IfSyhPVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177BAC4CED3;
	Thu, 12 Dec 2024 17:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024354;
	bh=P6bnw46EBaKR+nzb0bmb40QmuruxPY85nJmyyVRV0SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfSyhPVH/kM5oW0Sp6YOhSFJWuMhUTR9q77v+SRzODPaYWWHL40+5aAPr7ZOn80ak
	 FD2HZX5BMRLELnjMco6+Lsi0r3wcFBYTMDo6pS91hYhFQlMLma9K6Z8CRzpI9h/Ums
	 h1sKPKH1VIwREqtI9VKzTCezroj3hjULqgw5O7HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 268/459] um: ubd: Do not use drvdata in release
Date: Thu, 12 Dec 2024 16:00:06 +0100
Message-ID: <20241212144304.191439077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

commit 5bee35e5389f450a7eea7318deb9073e9414d3b1 upstream.

The drvdata is not available in release. Let's just use container_of()
to get the ubd instance. Otherwise, removing a ubd device will result
in a crash:

RIP: 0033:blk_mq_free_tag_set+0x1f/0xba
RSP: 00000000e2083bf0  EFLAGS: 00010246
RAX: 000000006021463a RBX: 0000000000000348 RCX: 0000000062604d00
RDX: 0000000004208060 RSI: 00000000605241a0 RDI: 0000000000000348
RBP: 00000000e2083c10 R08: 0000000062414010 R09: 00000000601603f7
R10: 000000000000133a R11: 000000006038c4bd R12: 0000000000000000
R13: 0000000060213a5c R14: 0000000062405d20 R15: 00000000604f7aa0
Kernel panic - not syncing: Segfault with no mm
CPU: 0 PID: 17 Comm: kworker/0:1 Not tainted 6.8.0-rc3-00107-gba3f67c11638 #1
Workqueue: events mc_work_proc
Stack:
 00000000 604f7ef0 62c5d000 62405d20
 e2083c30 6002c776 6002c755 600e47ff
 e2083c60 6025ffe3 04208060 603d36e0
Call Trace:
 [<6002c776>] ubd_device_release+0x21/0x55
 [<6002c755>] ? ubd_device_release+0x0/0x55
 [<600e47ff>] ? kfree+0x0/0x100
 [<6025ffe3>] device_release+0x70/0xba
 [<60381d6a>] kobject_put+0xb5/0xe2
 [<6026027b>] put_device+0x19/0x1c
 [<6026a036>] platform_device_put+0x26/0x29
 [<6026ac5a>] platform_device_unregister+0x2c/0x2e
 [<6002c52e>] ubd_remove+0xb8/0xd6
 [<6002bb74>] ? mconsole_reply+0x0/0x50
 [<6002b926>] mconsole_remove+0x160/0x1cc
 [<6002bbbc>] ? mconsole_reply+0x48/0x50
 [<6003379c>] ? um_set_signals+0x3b/0x43
 [<60061c55>] ? update_min_vruntime+0x14/0x70
 [<6006251f>] ? dequeue_task_fair+0x164/0x235
 [<600620aa>] ? update_cfs_group+0x0/0x40
 [<603a0e77>] ? __schedule+0x0/0x3ed
 [<60033761>] ? um_set_signals+0x0/0x43
 [<6002af6a>] mc_work_proc+0x77/0x91
 [<600520b4>] process_scheduled_works+0x1af/0x2c3
 [<6004ede3>] ? assign_work+0x0/0x58
 [<600527a1>] worker_thread+0x2f7/0x37a
 [<6004ee3b>] ? set_pf_worker+0x0/0x64
 [<6005765d>] ? arch_local_irq_save+0x0/0x2d
 [<60058e07>] ? kthread_exit+0x0/0x3a
 [<600524aa>] ? worker_thread+0x0/0x37a
 [<60058f9f>] kthread+0x130/0x135
 [<6002068e>] new_thread_handler+0x85/0xb6

Cc: stable@vger.kernel.org
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Link: https://patch.msgid.link/20241104163203.435515-3-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -861,7 +861,7 @@ static int ubd_open_dev(struct ubd *ubd_
 
 static void ubd_device_release(struct device *dev)
 {
-	struct ubd *ubd_dev = dev_get_drvdata(dev);
+	struct ubd *ubd_dev = container_of(dev, struct ubd, pdev.dev);
 
 	blk_cleanup_queue(ubd_dev->queue);
 	blk_mq_free_tag_set(&ubd_dev->tag_set);


