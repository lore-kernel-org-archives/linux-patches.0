Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3AA28DBA
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8d1TC30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15C8C433C7;
	Mon, 16 Oct 2023 14:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468010;
	bh=yArO/kI3/HCPbXzsF/YO6m0L9y7S5YD9KMG3/r5pCKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8d1TC30JTj7vYBpllkLaF1Jybihj2hDdDWRCV7Z8FAni1ob4XIhC4lLewvQq1V8J
	 3cdvIOSOzjjq2J3sMLRzcq7N7RAqXutdU6OpcLN3BkKlbCIrM1cl1LVLJXevkqdAnB
	 U1wNvwwjSpf4jk87uNjDIMdP50NgNGHifSneW9QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7f10c1653e35933c0f1e@syzkaller.appspotmail.com,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Todd Kjos <tkjos@google.com>
Subject: [PATCH 6.5 134/191] binder: fix memory leaks of spam and pending work
Date: Mon, 16 Oct 2023 10:41:59 +0200
Message-ID: <20231016084018.518631112@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 1aa3aaf8953c84bad398adf6c3cabc9d6685bf7d upstream.

A transaction complete work is allocated and queued for each
transaction. Under certain conditions the work->type might be marked as
BINDER_WORK_TRANSACTION_ONEWAY_SPAM_SUSPECT to notify userspace about
potential spamming threads or as BINDER_WORK_TRANSACTION_PENDING when
the target is currently frozen.

However, these work types are not being handled in binder_release_work()
so they will leak during a cleanup. This was reported by syzkaller with
the following kmemleak dump:

BUG: memory leak
unreferenced object 0xffff88810e2d6de0 (size 32):
  comm "syz-executor338", pid 5046, jiffies 4294968230 (age 13.590s)
  hex dump (first 32 bytes):
    e0 6d 2d 0e 81 88 ff ff e0 6d 2d 0e 81 88 ff ff  .m-......m-.....
    04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81573b75>] kmalloc_trace+0x25/0x90 mm/slab_common.c:1114
    [<ffffffff83d41873>] kmalloc include/linux/slab.h:599 [inline]
    [<ffffffff83d41873>] kzalloc include/linux/slab.h:720 [inline]
    [<ffffffff83d41873>] binder_transaction+0x573/0x4050 drivers/android/binder.c:3152
    [<ffffffff83d45a05>] binder_thread_write+0x6b5/0x1860 drivers/android/binder.c:4010
    [<ffffffff83d486dc>] binder_ioctl_write_read drivers/android/binder.c:5066 [inline]
    [<ffffffff83d486dc>] binder_ioctl+0x1b2c/0x3cf0 drivers/android/binder.c:5352
    [<ffffffff816b25f2>] vfs_ioctl fs/ioctl.c:51 [inline]
    [<ffffffff816b25f2>] __do_sys_ioctl fs/ioctl.c:871 [inline]
    [<ffffffff816b25f2>] __se_sys_ioctl fs/ioctl.c:857 [inline]
    [<ffffffff816b25f2>] __x64_sys_ioctl+0xf2/0x140 fs/ioctl.c:857
    [<ffffffff84b30008>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff84b30008>] do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84c0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fix the leaks by kfreeing these work types in binder_release_work() and
handle them as a BINDER_WORK_TRANSACTION_COMPLETE cleanup.

Cc: stable@vger.kernel.org
Fixes: 0567461a7a6e ("binder: return pending info for frozen async txns")
Fixes: a7dc1e6f99df ("binder: tell userspace to dump current backtrace when detected oneway spamming")
Reported-by: syzbot+7f10c1653e35933c0f1e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7f10c1653e35933c0f1e
Suggested-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20230922175138.230331-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -4812,6 +4812,8 @@ static void binder_release_work(struct b
 				"undelivered TRANSACTION_ERROR: %u\n",
 				e->cmd);
 		} break;
+		case BINDER_WORK_TRANSACTION_PENDING:
+		case BINDER_WORK_TRANSACTION_ONEWAY_SPAM_SUSPECT:
 		case BINDER_WORK_TRANSACTION_COMPLETE: {
 			binder_debug(BINDER_DEBUG_DEAD_TRANSACTION,
 				"undelivered TRANSACTION_COMPLETE\n");


