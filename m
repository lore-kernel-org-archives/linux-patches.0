Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12162D839A;
	Tue, 15 Jul 2025 13:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587044; cv=none; b=mjnmdN7BeLUOP+wN3L40bHSzIKB9geDKy7LZhugqmA4aywtiDHx1OJfjeRUb5F/Z7G4sbIabdMpcZ+VedhTXa0/mJZ9cGcMF4vdFcnhhPJH9t/l8+pSIz5QGszRgJ/XzijUlVfT62tT81iZue9wDG6CKWXorL43fdiY1sCn9fvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587044; c=relaxed/simple;
	bh=O4aSsNWmalTWpYh6DjTTp/ATlEHmXHyUxDNM5YqiJf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1fHHFD6QK9NvrT0hcCGjrkwQQddDte0S3/3YmOqxTht4cjLED9HGyxzZyo23DW73CWOcCqmOOyVxLN3/l44hW+YE8RJLoEKUJ+JTz81spwmWCOHZr/Ho0/yl/BwIt0jXEo6Y8+HIaVgJeRrJO147AlUo3nwajm9RJxpitOONG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoglWtg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoglWtg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E954C4CEE3;
	Tue, 15 Jul 2025 13:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587044;
	bh=O4aSsNWmalTWpYh6DjTTp/ATlEHmXHyUxDNM5YqiJf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoglWtg3oC6kHf6InQ3A64mBOwJsKg/i/FxOQMPimrhNYrlmxHK4rke4JbtRsGPkZ
	 pVzlz+/od2RZpd13Ysla3TqjhPBnJ8X4gqJznfxepTDZ9mmoqMpfXOj7kTqEkBciQq
	 9XKXilSMj4sIRSRYJAL1KB7sjNWQCzRdEq7FQOdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+48240bab47e705c53126@syzkaller.appspotmail.com,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 145/192] nbd: fix uaf in nbd_genl_connect() error path
Date: Tue, 15 Jul 2025 15:14:00 +0200
Message-ID: <20250715130820.727828914@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit aa9552438ebf015fc5f9f890dbfe39f0c53cf37e ]

There is a use-after-free issue in nbd:

block nbd6: Receive control failed (result -104)
block nbd6: shutting down sockets
==================================================================
BUG: KASAN: slab-use-after-free in recv_work+0x694/0xa80 drivers/block/nbd.c:1022
Write of size 4 at addr ffff8880295de478 by task kworker/u33:0/67

CPU: 2 UID: 0 PID: 67 Comm: kworker/u33:0 Not tainted 6.15.0-rc5-syzkaller-00123-g2c89c1b655c0 #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: nbd6-recv recv_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xc3/0x670 mm/kasan/report.c:521
 kasan_report+0xe0/0x110 mm/kasan/report.c:634
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0xef/0x1a0 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
 atomic_dec include/linux/atomic/atomic-instrumented.h:592 [inline]
 recv_work+0x694/0xa80 drivers/block/nbd.c:1022
 process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3238
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
 kthread+0x3c2/0x780 kernel/kthread.c:464
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

nbd_genl_connect() does not properly stop the device on certain
error paths after nbd_start_device() has been called. This causes
the error path to put nbd->config while recv_work continue to use
the config after putting it, leading to use-after-free in recv_work.

This patch moves nbd_start_device() after the backend file creation.

Reported-by: syzbot+48240bab47e705c53126@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68227a04.050a0220.f2294.00b5.GAE@google.com/T/
Fixes: 6497ef8df568 ("nbd: provide a way for userspace processes to identify device backends")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250612132405.364904-1-zhengqixing@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 7bdc7eb808ea9..2592bd19ebc15 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -2198,9 +2198,7 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 				goto out;
 		}
 	}
-	ret = nbd_start_device(nbd);
-	if (ret)
-		goto out;
+
 	if (info->attrs[NBD_ATTR_BACKEND_IDENTIFIER]) {
 		nbd->backend = nla_strdup(info->attrs[NBD_ATTR_BACKEND_IDENTIFIER],
 					  GFP_KERNEL);
@@ -2216,6 +2214,8 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 	set_bit(NBD_RT_HAS_BACKEND_FILE, &config->runtime_flags);
+
+	ret = nbd_start_device(nbd);
 out:
 	mutex_unlock(&nbd->config_lock);
 	if (!ret) {
-- 
2.39.5



