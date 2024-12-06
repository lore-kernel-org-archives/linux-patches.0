Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C169145A05;
	Fri,  6 Dec 2024 14:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496299; cv=none; b=qUq/5zqZb4yWt6XUeFxR+mzL+I/iC2Vfl9Kg9RvFCxOhH4zumxT3ZgLsl8JYQcNKP49COldaPR3sMoWSRbwlsQdUEIXxyRaiF8yxilv5G7+v8ccGhVMSFfQGH/E80KaTSmEdN0kQJ1t7DQVHA/3tlA+wjuIIghzNQGGaCBx+KwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496299; c=relaxed/simple;
	bh=PyUQZu60jJgX3eTXrZiGqeNjJr3DxVz8D7EaU2XmUI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQ+jWS4rNRvyu9RBoR4wg5RD1lXVVEdHoKTO+pPHhlDc1adqTMnx6/2NrqB+cG4IxPq9QwPVS0tlC9YzCLFvDNmUsGJkHduZjicLUr/CRPMNrXZjzJvJgWro0Rgm9sr+vv4h8xm+uG6dhpwym/8XNzG6P/NDxLzHAHl4zsb6IxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/WBF7jj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/WBF7jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB66C4CED1;
	Fri,  6 Dec 2024 14:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496298;
	bh=PyUQZu60jJgX3eTXrZiGqeNjJr3DxVz8D7EaU2XmUI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/WBF7jjMcu3IPfkM1IjYEINXPdNMF0LxI0abnffX8Ms+1/MjGi8SJTlVzrnuAG+s
	 ldjQzDQi6a9kKImyUSbiJw9c6SVMx0RwlxaL1Gxar4865/LaxLWnkOoXCD+plDjygL
	 WjpDM4lzNmgvtMnZhgJO8XrNa6Bq8TQrYAv9yupw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Kjos <tkjos@android.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.12 110/146] binder: fix freeze UAF in binder_release_work()
Date: Fri,  6 Dec 2024 15:37:21 +0100
Message-ID: <20241206143531.892140569@linuxfoundation.org>
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

commit 7e20434cbca814cb91a0a261ca0106815ef48e5f upstream.

When a binder reference is cleaned up, any freeze work queued in the
associated process should also be removed. Otherwise, the reference is
freed while its ref->freeze.work is still queued in proc->work leading
to a use-after-free issue as shown by the following KASAN report:

  ==================================================================
  BUG: KASAN: slab-use-after-free in binder_release_work+0x398/0x3d0
  Read of size 8 at addr ffff31600ee91488 by task kworker/5:1/211

  CPU: 5 UID: 0 PID: 211 Comm: kworker/5:1 Not tainted 6.11.0-rc7-00382-gfc6c92196396 #22
  Hardware name: linux,dummy-virt (DT)
  Workqueue: events binder_deferred_func
  Call trace:
   binder_release_work+0x398/0x3d0
   binder_deferred_func+0xb60/0x109c
   process_one_work+0x51c/0xbd4
   worker_thread+0x608/0xee8

  Allocated by task 703:
   __kmalloc_cache_noprof+0x130/0x280
   binder_thread_write+0xdb4/0x42a0
   binder_ioctl+0x18f0/0x25ac
   __arm64_sys_ioctl+0x124/0x190
   invoke_syscall+0x6c/0x254

  Freed by task 211:
   kfree+0xc4/0x230
   binder_deferred_func+0xae8/0x109c
   process_one_work+0x51c/0xbd4
   worker_thread+0x608/0xee8
  ==================================================================

This commit fixes the issue by ensuring any queued freeze work is removed
when cleaning up a binder reference.

Fixes: d579b04a52a1 ("binder: frozen notification")
Cc: stable@vger.kernel.org
Acked-by: Todd Kjos <tkjos@android.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20240926233632.821189-4-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 8bca2de6fa24..d955135ee37a 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1225,6 +1225,12 @@ static void binder_cleanup_ref_olocked(struct binder_ref *ref)
 		binder_dequeue_work(ref->proc, &ref->death->work);
 		binder_stats_deleted(BINDER_STAT_DEATH);
 	}
+
+	if (ref->freeze) {
+		binder_dequeue_work(ref->proc, &ref->freeze->work);
+		binder_stats_deleted(BINDER_STAT_FREEZE);
+	}
+
 	binder_stats_deleted(BINDER_STAT_REF);
 }
 
-- 
2.47.1



