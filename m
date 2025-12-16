Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1410359F8F;
	Tue, 16 Dec 2025 12:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886701; cv=none; b=nMH7zbAFJw1HeriENXQl1VC10gr7eq1b0BEoDz3vqfAMftoYhfRBYYX1DfloAxRSfMsi9Hw4rgJqieEgNw9zur5fr6D/IAyv+UJ14RGqbGUnUL9KPWafWQ0xqF2QGg8i4ag7dJsmaF2qYe69K7zAOt7mCfJ3ylTVpFD7s6KwGjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886701; c=relaxed/simple;
	bh=YD6NdBc5QxiiHOYOH1zfRDhW4j+TTM8NNmIZT3EVEJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ig9JdG+YfuwYwQwc/42ijCWXt2qGqptCH/eSZxTqWSSDtjKOwR1ziyQ11kuPmOfvmxfzrUq1PREs4xLzodco8JF4Y9u3Y83kChho+ZHU+T7TT3R/pqNT1dcyQc+fp6ojYVucHwfRSveW0Hep+AmZeVOHFZIvZtJ/HdLvnrTxMRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWKICSBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWKICSBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDACC4CEF1;
	Tue, 16 Dec 2025 12:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886700;
	bh=YD6NdBc5QxiiHOYOH1zfRDhW4j+TTM8NNmIZT3EVEJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWKICSBFrVSkLHlnwrFrF4xu4GopJFRz67WxdJB3WpLc9JZ4NsEHmOJOiGTJzd41U
	 MIEmoip7ONZ9rlc6Xtuy+wVjDFmqkB5wJBfMjWsxPVTOcl2V6NoWV1N7UVge3j7i5T
	 TqdoegrhL/GjZIPN7Z4Mgk5zlRMrivopdreJTjU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.17 501/507] usb: typec: ucsi: fix use-after-free caused by uec->work
Date: Tue, 16 Dec 2025 12:15:42 +0100
Message-ID: <20251216111403.589020753@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

commit 2b7a0f47aaf2439d517ba0a6b29c66a535302154 upstream.

The delayed work uec->work is scheduled in gaokun_ucsi_probe()
but never properly canceled in gaokun_ucsi_remove(). This creates
use-after-free scenarios where the ucsi and gaokun_ucsi structure
are freed after ucsi_destroy() completes execution, while the
gaokun_ucsi_register_worker() might be either currently executing
or still pending in the work queue. The already-freed gaokun_ucsi
or ucsi structure may then be accessed.

Furthermore, the race window is 3 seconds, which is sufficiently
long to make this bug easily reproducible. The following is the
trace captured by KASAN:

==================================================================
BUG: KASAN: slab-use-after-free in __run_timers+0x5ec/0x630
Write of size 8 at addr ffff00000ec28cc8 by task swapper/0/0
...
Call trace:
 show_stack+0x18/0x24 (C)
 dump_stack_lvl+0x78/0x90
 print_report+0x114/0x580
 kasan_report+0xa4/0xf0
 __asan_report_store8_noabort+0x20/0x2c
 __run_timers+0x5ec/0x630
 run_timer_softirq+0xe8/0x1cc
 handle_softirqs+0x294/0x720
 __do_softirq+0x14/0x20
 ____do_softirq+0x10/0x1c
 call_on_irq_stack+0x30/0x48
 do_softirq_own_stack+0x1c/0x28
 __irq_exit_rcu+0x27c/0x364
 irq_exit_rcu+0x10/0x1c
 el1_interrupt+0x40/0x60
 el1h_64_irq_handler+0x18/0x24
 el1h_64_irq+0x6c/0x70
 arch_local_irq_enable+0x4/0x8 (P)
 do_idle+0x334/0x458
 cpu_startup_entry+0x60/0x70
 rest_init+0x158/0x174
 start_kernel+0x2f8/0x394
 __primary_switched+0x8c/0x94

Allocated by task 72 on cpu 0 at 27.510341s:
 kasan_save_stack+0x2c/0x54
 kasan_save_track+0x24/0x5c
 kasan_save_alloc_info+0x40/0x54
 __kasan_kmalloc+0xa0/0xb8
 __kmalloc_node_track_caller_noprof+0x1c0/0x588
 devm_kmalloc+0x7c/0x1c8
 gaokun_ucsi_probe+0xa0/0x840  auxiliary_bus_probe+0x94/0xf8
 really_probe+0x17c/0x5b8
 __driver_probe_device+0x158/0x2c4
 driver_probe_device+0x10c/0x264
 __device_attach_driver+0x168/0x2d0
 bus_for_each_drv+0x100/0x188
 __device_attach+0x174/0x368
 device_initial_probe+0x14/0x20
 bus_probe_device+0x120/0x150
 device_add+0xb3c/0x10fc
 __auxiliary_device_add+0x88/0x130
...

Freed by task 73 on cpu 1 at 28.910627s:
 kasan_save_stack+0x2c/0x54
 kasan_save_track+0x24/0x5c
 __kasan_save_free_info+0x4c/0x74
 __kasan_slab_free+0x60/0x8c
 kfree+0xd4/0x410
 devres_release_all+0x140/0x1f0
 device_unbind_cleanup+0x20/0x190
 device_release_driver_internal+0x344/0x460
 device_release_driver+0x18/0x24
 bus_remove_device+0x198/0x274
 device_del+0x310/0xa84
...

The buggy address belongs to the object at ffff00000ec28c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 200 bytes inside of
 freed 512-byte region
The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4ec28
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x3fffe0000000040(head|node=0|zone=0|lastcpupid=0x1ffff)
page_type: f5(slab)
raw: 03fffe0000000040 ffff000008801c80 dead000000000122 0000000000000000
raw: 0000000000000000 0000000080100010 00000000f5000000 0000000000000000
head: 03fffe0000000040 ffff000008801c80 dead000000000122 0000000000000000
head: 0000000000000000 0000000080100010 00000000f5000000 0000000000000000
head: 03fffe0000000002 fffffdffc03b0a01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff00000ec28b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff00000ec28c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff00000ec28c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                              ^
 ffff00000ec28d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff00000ec28d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Add disable_delayed_work_sync() in gaokun_ucsi_remove() to ensure
that uec->work is properly canceled and prevented from executing
after the ucsi and gaokun_ucsi structure have been deallocated.

Fixes: 00327d7f2c8c ("usb: typec: ucsi: add Huawei Matebook E Go ucsi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/cc31e12ef9ffbf86676585b02233165fd33f0d8e.1764065838.git.duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
+++ b/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
@@ -503,6 +503,7 @@ static void gaokun_ucsi_remove(struct au
 {
 	struct gaokun_ucsi *uec = auxiliary_get_drvdata(adev);
 
+	disable_delayed_work_sync(&uec->work);
 	gaokun_ec_unregister_notify(uec->ec, &uec->nb);
 	ucsi_unregister(uec->ucsi);
 	ucsi_destroy(uec->ucsi);


