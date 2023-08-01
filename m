Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D261FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EC9C433C9;
	Tue,  1 Aug 2023 09:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882716;
	bh=/XxyUVd3LdGuIXfN5xmcDxUdMWkLrA2PWRWuDlzDEaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ye8xikWmoiAwsyfHkAK+fWWlX20F45K7wLZyqgglVqhN+OiP/OsPwMk128YOmSGXp
	 6XknkVzpZnKonjTcttJOo5HrerX5y6spenc84DTRg+qLG4G0AHVWLowvfA0UmM4kg3
	 jFhZnMocLpOnsWtP+6661FJZ4fsAPRVwM3Nf2Z2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaoyuan Peng <hedonistsmith@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 177/228] tty: n_gsm: fix UAF in gsm_cleanup_mux
Date: Tue,  1 Aug 2023 11:20:35 +0200
Message-ID: <20230801091929.264728950@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chaoyuan Peng <hedonistsmith@gmail.com>

commit 9b9c8195f3f0d74a826077fc1c01b9ee74907239 upstream.

In gsm_cleanup_mux() the 'gsm->dlci' pointer was not cleaned properly,
leaving it a dangling pointer after gsm_dlci_release.
This leads to use-after-free where 'gsm->dlci[0]' are freed and accessed
by the subsequent gsm_cleanup_mux().

Such is the case in the following call trace:

 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
 print_address_description+0x63/0x3b0 mm/kasan/report.c:248
 __kasan_report mm/kasan/report.c:434 [inline]
 kasan_report+0x16b/0x1c0 mm/kasan/report.c:451
 gsm_cleanup_mux+0x76a/0x850 drivers/tty/n_gsm.c:2397
 gsm_config drivers/tty/n_gsm.c:2653 [inline]
 gsmld_ioctl+0xaae/0x15b0 drivers/tty/n_gsm.c:2986
 tty_ioctl+0x8ff/0xc50 drivers/tty/tty_io.c:2816
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl+0xf1/0x160 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x61/0xcb
 </TASK>

Allocated by task 3501:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc+0xba/0xf0 mm/kasan/common.c:513
 kasan_kmalloc include/linux/kasan.h:264 [inline]
 kmem_cache_alloc_trace+0x143/0x290 mm/slub.c:3247
 kmalloc include/linux/slab.h:591 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 gsm_dlci_alloc+0x53/0x3a0 drivers/tty/n_gsm.c:1932
 gsm_activate_mux+0x1c/0x330 drivers/tty/n_gsm.c:2438
 gsm_config drivers/tty/n_gsm.c:2677 [inline]
 gsmld_ioctl+0xd46/0x15b0 drivers/tty/n_gsm.c:2986
 tty_ioctl+0x8ff/0xc50 drivers/tty/tty_io.c:2816
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl+0xf1/0x160 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x61/0xcb

Freed by task 3501:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x4b/0x80 mm/kasan/common.c:46
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:360
 ____kasan_slab_free+0xd8/0x120 mm/kasan/common.c:366
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1705 [inline]
 slab_free_freelist_hook+0xdd/0x160 mm/slub.c:1731
 slab_free mm/slub.c:3499 [inline]
 kfree+0xf1/0x270 mm/slub.c:4559
 dlci_put drivers/tty/n_gsm.c:1988 [inline]
 gsm_dlci_release drivers/tty/n_gsm.c:2021 [inline]
 gsm_cleanup_mux+0x574/0x850 drivers/tty/n_gsm.c:2415
 gsm_config drivers/tty/n_gsm.c:2653 [inline]
 gsmld_ioctl+0xaae/0x15b0 drivers/tty/n_gsm.c:2986
 tty_ioctl+0x8ff/0xc50 drivers/tty/tty_io.c:2816
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl+0xf1/0x160 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x61/0xcb

Fixes: aa371e96f05d ("tty: n_gsm: fix restart handling via CLD command")
Signed-off-by: Chaoyuan Peng <hedonistsmith@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2508,8 +2508,10 @@ static void gsm_cleanup_mux(struct gsm_m
 		gsm->has_devices = false;
 	}
 	for (i = NUM_DLCI - 1; i >= 0; i--)
-		if (gsm->dlci[i])
+		if (gsm->dlci[i]) {
 			gsm_dlci_release(gsm->dlci[i]);
+			gsm->dlci[i] = NULL;
+		}
 	mutex_unlock(&gsm->mutex);
 	/* Now wipe the queues */
 	tty_ldisc_flush(gsm->tty);


