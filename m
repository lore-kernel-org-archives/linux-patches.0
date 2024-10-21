Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17791E1C11;
	Mon, 21 Oct 2024 10:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507156; cv=none; b=UrQbvG7v7qqaIb2wUpldb6Zu8gn7uEFwYJ9aLjQBnrazgGEN8Nr+Z5teayIvuEMdS6zS1mZrjRWK5phO1Qg1Uu8moym5JqqeyCcJ3Jla8606VmbrOwZDMKPljkQn09JuppZz/sLb0Fu3b6PIeKg/9hmFXOqjsJ1uP6U6R7onkP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507156; c=relaxed/simple;
	bh=TR9DP5TjvzmAybysqRrhANIdfmIZkyeZ3+z1Z0/knuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhKdfYlSaI1VTwXboYCgVUNb5/JRrqPByF/zGwns2jWFNwWh7XzefwvIqlc5sNwMIFdxayiPE2+MO9U0LA7vz6rqg6vpumKxXrkHXJBNHDPFe7j0DegvAPdZoRVYmb16dHkyk9e4Y7ALyue3nRz4esDPe0ycBy9yHbCx+FyDzn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjUx2r2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjUx2r2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E71C4CEC3;
	Mon, 21 Oct 2024 10:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507156;
	bh=TR9DP5TjvzmAybysqRrhANIdfmIZkyeZ3+z1Z0/knuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjUx2r2mrTi0cx1K9VrpFSqOTqXzqjpiBaaBMnORKfZD8hIPDy2oHqqTwPP/LwEqj
	 f56ybJa0B76G8OzTTT0TldeGkwmFkRbTvogw0R0mb6ijnOv1OAOF/8sEkhWZpH7B80
	 kznRIGWiTo3s9y7isEcUDFp9g0wa1a78p0xK6ajk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.6 108/124] tty: n_gsm: Fix use-after-free in gsm_cleanup_mux
Date: Mon, 21 Oct 2024 12:25:12 +0200
Message-ID: <20241021102300.894920260@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longlong Xia <xialonglong@kylinos.cn>

commit 9462f4ca56e7d2430fdb6dcc8498244acbfc4489 upstream.

BUG: KASAN: slab-use-after-free in gsm_cleanup_mux+0x77b/0x7b0
drivers/tty/n_gsm.c:3160 [n_gsm]
Read of size 8 at addr ffff88815fe99c00 by task poc/3379
CPU: 0 UID: 0 PID: 3379 Comm: poc Not tainted 6.11.0+ #56
Hardware name: VMware, Inc. VMware Virtual Platform/440BX
Desktop Reference Platform, BIOS 6.00 11/12/2020
Call Trace:
 <TASK>
 gsm_cleanup_mux+0x77b/0x7b0 drivers/tty/n_gsm.c:3160 [n_gsm]
 __pfx_gsm_cleanup_mux+0x10/0x10 drivers/tty/n_gsm.c:3124 [n_gsm]
 __pfx_sched_clock_cpu+0x10/0x10 kernel/sched/clock.c:389
 update_load_avg+0x1c1/0x27b0 kernel/sched/fair.c:4500
 __pfx_min_vruntime_cb_rotate+0x10/0x10 kernel/sched/fair.c:846
 __rb_insert_augmented+0x492/0xbf0 lib/rbtree.c:161
 gsmld_ioctl+0x395/0x1450 drivers/tty/n_gsm.c:3408 [n_gsm]
 _raw_spin_lock_irqsave+0x92/0xf0 arch/x86/include/asm/atomic.h:107
 __pfx_gsmld_ioctl+0x10/0x10 drivers/tty/n_gsm.c:3822 [n_gsm]
 ktime_get+0x5e/0x140 kernel/time/timekeeping.c:195
 ldsem_down_read+0x94/0x4e0 arch/x86/include/asm/atomic64_64.h:79
 __pfx_ldsem_down_read+0x10/0x10 drivers/tty/tty_ldsem.c:338
 __pfx_do_vfs_ioctl+0x10/0x10 fs/ioctl.c:805
 tty_ioctl+0x643/0x1100 drivers/tty/tty_io.c:2818

Allocated by task 65:
 gsm_data_alloc.constprop.0+0x27/0x190 drivers/tty/n_gsm.c:926 [n_gsm]
 gsm_send+0x2c/0x580 drivers/tty/n_gsm.c:819 [n_gsm]
 gsm1_receive+0x547/0xad0 drivers/tty/n_gsm.c:3038 [n_gsm]
 gsmld_receive_buf+0x176/0x280 drivers/tty/n_gsm.c:3609 [n_gsm]
 tty_ldisc_receive_buf+0x101/0x1e0 drivers/tty/tty_buffer.c:391
 tty_port_default_receive_buf+0x61/0xa0 drivers/tty/tty_port.c:39
 flush_to_ldisc+0x1b0/0x750 drivers/tty/tty_buffer.c:445
 process_scheduled_works+0x2b0/0x10d0 kernel/workqueue.c:3229
 worker_thread+0x3dc/0x950 kernel/workqueue.c:3391
 kthread+0x2a3/0x370 kernel/kthread.c:389
 ret_from_fork+0x2d/0x70 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:257

Freed by task 3367:
 kfree+0x126/0x420 mm/slub.c:4580
 gsm_cleanup_mux+0x36c/0x7b0 drivers/tty/n_gsm.c:3160 [n_gsm]
 gsmld_ioctl+0x395/0x1450 drivers/tty/n_gsm.c:3408 [n_gsm]
 tty_ioctl+0x643/0x1100 drivers/tty/tty_io.c:2818

[Analysis]
gsm_msg on the tx_ctrl_list or tx_data_list of gsm_mux
can be freed by multi threads through ioctl,which leads
to the occurrence of uaf. Protect it by gsm tx lock.

Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Cc: stable <stable@kernel.org>
Suggested-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20240926130213.531959-1-xialonglong@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -3156,6 +3156,8 @@ static void gsm_cleanup_mux(struct gsm_m
 	mutex_unlock(&gsm->mutex);
 	/* Now wipe the queues */
 	tty_ldisc_flush(gsm->tty);
+
+	guard(spinlock_irqsave)(&gsm->tx_lock);
 	list_for_each_entry_safe(txq, ntxq, &gsm->tx_ctrl_list, list)
 		kfree(txq);
 	INIT_LIST_HEAD(&gsm->tx_ctrl_list);


