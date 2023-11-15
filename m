Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDE83DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBQVqJTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8DBC433C7;
	Wed, 15 Nov 2023 20:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078698;
	bh=fSm2iHDpSPYKyKD2T7z8bjaGdLMsLH112r5hFcq01+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBQVqJTBkxRrdGiUZKjl53Pqc7rxCFvWgJFOI4HhTjte6+qaW1vICSatPdg5JSZiA
	 4hX/S8q8926DJ7srVg66DpM06vudNhVc1D7WLEqDLmdbFvXfQCfnk5rU7nYJJdFltc
	 piGohWuh4GDiZsQDnkEnrZXqN2MiKXBEPwupG1nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	GUO Zihua <guozihua@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 25/45] tty: tty_jobctrl: fix pid memleak in disassociate_ctty()
Date: Wed, 15 Nov 2023 14:33:02 -0500
Message-ID: <20231115191421.083206415@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191419.641552204@linuxfoundation.org>
References: <20231115191419.641552204@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit 11e7f27b79757b6586645d87b95d5b78375ecdfc ]

There is a pid leakage:
------------------------------
unreferenced object 0xffff88810c181940 (size 224):
  comm "sshd", pid 8191, jiffies 4294946950 (age 524.570s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 ad 4e ad de  .............N..
    ff ff ff ff 6b 6b 6b 6b ff ff ff ff ff ff ff ff  ....kkkk........
  backtrace:
    [<ffffffff814774e6>] kmem_cache_alloc+0x5c6/0x9b0
    [<ffffffff81177342>] alloc_pid+0x72/0x570
    [<ffffffff81140ac4>] copy_process+0x1374/0x2470
    [<ffffffff81141d77>] kernel_clone+0xb7/0x900
    [<ffffffff81142645>] __se_sys_clone+0x85/0xb0
    [<ffffffff8114269b>] __x64_sys_clone+0x2b/0x30
    [<ffffffff83965a72>] do_syscall_64+0x32/0x80
    [<ffffffff83a00085>] entry_SYSCALL_64_after_hwframe+0x61/0xc6

It turns out that there is a race condition between disassociate_ctty() and
tty_signal_session_leader(), which caused this leakage.

The pid memleak is triggered by the following race:
task[sshd]                     task[bash]
-----------------------        -----------------------
                               disassociate_ctty();
                               spin_lock_irq(&current->sighand->siglock);
                               put_pid(current->signal->tty_old_pgrp);
                               current->signal->tty_old_pgrp = NULL;
                               tty = tty_kref_get(current->signal->tty);
                               spin_unlock_irq(&current->sighand->siglock);
tty_vhangup();
tty_lock(tty);
...
tty_signal_session_leader();
spin_lock_irq(&p->sighand->siglock);
...
if (tty->ctrl.pgrp) //tty->ctrl.pgrp is not NULL
p->signal->tty_old_pgrp = get_pid(tty->ctrl.pgrp); //An extra get
spin_unlock_irq(&p->sighand->siglock);
...
tty_unlock(tty);
                               if (tty) {
                                   tty_lock(tty);
                                   ...
                                   put_pid(tty->ctrl.pgrp);
                                   tty->ctrl.pgrp = NULL; //It's too late
                                   ...
                                   tty_unlock(tty);
                               }

The issue is believed to be introduced by commit c8bcd9c5be24 ("tty:
Fix ->session locking") who moves the unlock of siglock in
disassociate_ctty() above "if (tty)", making a small window allowing
tty_signal_session_leader() to kick in. It can be easily reproduced by
adding a delay before "if (tty)" and at the entrance of
tty_signal_session_leader().

To fix this issue, we move "put_pid(current->signal->tty_old_pgrp)" after
"tty->ctrl.pgrp = NULL".

Fixes: c8bcd9c5be24 ("tty: Fix ->session locking")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Co-developed-by: GUO Zihua <guozihua@huawei.com>
Signed-off-by: GUO Zihua <guozihua@huawei.com>
Link: https://lore.kernel.org/r/20230831023329.165737-1-yiyang13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_jobctrl.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_jobctrl.c b/drivers/tty/tty_jobctrl.c
index b71e61e79c5a3..29b3957f329c6 100644
--- a/drivers/tty/tty_jobctrl.c
+++ b/drivers/tty/tty_jobctrl.c
@@ -289,12 +289,7 @@ void disassociate_ctty(int on_exit)
 		return;
 	}
 
-	spin_lock_irq(&current->sighand->siglock);
-	put_pid(current->signal->tty_old_pgrp);
-	current->signal->tty_old_pgrp = NULL;
-	tty = tty_kref_get(current->signal->tty);
-	spin_unlock_irq(&current->sighand->siglock);
-
+	tty = get_current_tty();
 	if (tty) {
 		unsigned long flags;
 
@@ -309,6 +304,16 @@ void disassociate_ctty(int on_exit)
 		tty_kref_put(tty);
 	}
 
+	/* If tty->ctrl.pgrp is not NULL, it may be assigned to
+	 * current->signal->tty_old_pgrp in a race condition, and
+	 * cause pid memleak. Release current->signal->tty_old_pgrp
+	 * after tty->ctrl.pgrp set to NULL.
+	 */
+	spin_lock_irq(&current->sighand->siglock);
+	put_pid(current->signal->tty_old_pgrp);
+	current->signal->tty_old_pgrp = NULL;
+	spin_unlock_irq(&current->sighand->siglock);
+
 	/* Now clear signal->tty under the lock */
 	read_lock(&tasklist_lock);
 	session_clear_tty(task_session(current));
-- 
2.42.0



