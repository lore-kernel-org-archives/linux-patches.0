Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B17610E0;
	Fri,  6 Dec 2024 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496444; cv=none; b=uVeEp6LXQQIr98qkfDmMwCdrR8IGxwjVkUUVT+qINArRDAiA7Kdtq2XPZyJ14P9hMI97vo72HkpGGnY7oMhYGH/vufkgLjMra9xeFa9blge3sPxVEtTPcQH8f09pvoihmcuMCFn7G6B/Fo8WsST8ghDfQi2Atb+s6VA0BkCr7kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496444; c=relaxed/simple;
	bh=KnnIH37WcE8hRIxbUTNJCESqvVfnTzxbId3UeCRQw5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ew4hSQohg6M48r9Wmbuh181EtejGl+a0jXp9fwWLwLDIEQxQVF9bqkV172ectIV0ccdbGOYOG6s9W2KC7zw4nkR4bFZafbNnoCq5J8LBTm91cc4GJhPCRm9JKyFWrLdMBtu4QrRH4xA4bBXUzcaH1vUjJ2WCrvRuXg7lWYiJgN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPpzcPQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPpzcPQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BF7C4CED1;
	Fri,  6 Dec 2024 14:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496444;
	bh=KnnIH37WcE8hRIxbUTNJCESqvVfnTzxbId3UeCRQw5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPpzcPQ5XAII5YE4uPrIOTFBCYb9C+y12hoETwfUb7e2lFIy1dRzribe6f+5vGLuV
	 +cSwG6g+0uksD50WcqAI0N4Zu6S52Y0P5XcIij96jKWrx3lNBADlIYHpdMBkSWFEx4
	 amK/FAtgoikU4xhIHNYBZVsxCN+7uDCX0E9h12Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Todd Kjos <tkjos@google.com>
Subject: [PATCH 6.12 114/146] binder: fix memleak of proc->delivered_freeze
Date: Fri,  6 Dec 2024 15:37:25 +0100
Message-ID: <20241206143532.043717126@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 1db76ec2b4b206ff943e292a0b55e68ff3443598 upstream.

If a freeze notification is cleared with BC_CLEAR_FREEZE_NOTIFICATION
before calling binder_freeze_notification_done(), then it is detached
from its reference (e.g. ref->freeze) but the work remains queued in
proc->delivered_freeze. This leads to a memory leak when the process
exits as any pending entries in proc->delivered_freeze are not freed:

  unreferenced object 0xffff38e8cfa36180 (size 64):
    comm "binder-util", pid 655, jiffies 4294936641
    hex dump (first 32 bytes):
      b8 e9 9e c8 e8 38 ff ff b8 e9 9e c8 e8 38 ff ff  .....8.......8..
      0b 00 00 00 00 00 00 00 3c 1f 4b 00 00 00 00 00  ........<.K.....
    backtrace (crc 95983b32):
      [<000000000d0582cf>] kmemleak_alloc+0x34/0x40
      [<000000009c99a513>] __kmalloc_cache_noprof+0x208/0x280
      [<00000000313b1704>] binder_thread_write+0xdec/0x439c
      [<000000000cbd33bb>] binder_ioctl+0x1b68/0x22cc
      [<000000002bbedeeb>] __arm64_sys_ioctl+0x124/0x190
      [<00000000b439adee>] invoke_syscall+0x6c/0x254
      [<00000000173558fc>] el0_svc_common.constprop.0+0xac/0x230
      [<0000000084f72311>] do_el0_svc+0x40/0x58
      [<000000008b872457>] el0_svc+0x38/0x78
      [<00000000ee778653>] el0t_64_sync_handler+0x120/0x12c
      [<00000000a8ec61bf>] el0t_64_sync+0x190/0x194

This patch fixes the leak by ensuring that any pending entries in
proc->delivered_freeze are freed during binder_deferred_release().

Fixes: d579b04a52a1 ("binder: frozen notification")
Cc: stable@vger.kernel.org
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20240926233632.821189-8-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 415fc9759249..7c09b5e38e32 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -5155,6 +5155,16 @@ static void binder_release_work(struct binder_proc *proc,
 		} break;
 		case BINDER_WORK_NODE:
 			break;
+		case BINDER_WORK_CLEAR_FREEZE_NOTIFICATION: {
+			struct binder_ref_freeze *freeze;
+
+			freeze = container_of(w, struct binder_ref_freeze, work);
+			binder_debug(BINDER_DEBUG_DEAD_TRANSACTION,
+				     "undelivered freeze notification, %016llx\n",
+				     (u64)freeze->cookie);
+			kfree(freeze);
+			binder_stats_deleted(BINDER_STAT_FREEZE);
+		} break;
 		default:
 			pr_err("unexpected work type, %d, not freed\n",
 			       wtype);
@@ -6273,6 +6283,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 
 	binder_release_work(proc, &proc->todo);
 	binder_release_work(proc, &proc->delivered_death);
+	binder_release_work(proc, &proc->delivered_freeze);
 
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
 		     "%s: %d threads %d, nodes %d (ref %d), refs %d, active transactions %d\n",
-- 
2.47.1



