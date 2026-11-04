Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827177;
	b=Jfjut9vgjNO8FJWr3WKmMCquFonAe38HAljqVePcEpGHsgA7rwjBiGZfOhSZpkxYZFfP
	 lKEboh1W3g7STMgxL7CdiMHDVj5Eq3tMqYse3UxbMSM6dNmDxOkCsiJE42KUEBvpEL1vz
	 NJVCsJ+hTMvizIow3sTmKxCkJv691HyAbyJYBBI45amL9u29bAfLtuqlvMYcIpgqJSDg8
	 msBmXoMDaOTPew4K9IJPfzu4+X4FR94vEg30/wsW7M5Cq82TyHlT/TK2zEQ7H9qm7JQwa
	 LTgg5ufoDKKfXKHunRYJxP6a2BUjX36dT843AVY8K1Kc2DJ/bgRDXT2fD9+fp5r0YuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k0HIrwd7e1jFCeh2lZCjNAC6q11sl8kRyWCOxm0CVls=;
	b=YMLhoR40rLSES1SXlUF8gq3WtawzIp9nwhnhDvovTdYZSyrCe2sdhfvzoBzRJ2JFsp80
	 o86PD6n/JJRD/i1gRsGnajyZWz+JREbv/9p4H2L2mJiRNkQq/kQOKXlaskS7ryrPPry2E
	 iaFDExuTBTBV+nHUmfMoA93svD6wjJ5SqJg7LP6mqy+RRmufroIm8iq7mqgsLQ8p52WIp
	 UvTcMlczYvbAB2djQsd60vADihbM4alnIzotRjUq/IagRcF+pwNpIRUrLVhzhK6NcsCsc
	 79h9KUt5qHcZHaJvBNz633em0yO67O/HwAGW6+sZVasqJ7ZuTPb8Ri3g+HbY45i0wKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qvIfErJt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632E56075272;
	Wed,  4 Nov 2026 21:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qvIfErJt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6B01F000C1;
	Wed,  4 Nov 2026 21:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827177;
	bh=k0HIrwd7e1jFCeh2lZCjNAC6q11sl8kRyWCOxm0CVls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvIfErJtrW+onjbVv767V69tAWEodTSKiwZCyDwnLG+9a8r/ccuy/0CD9cvDs5r8H
	 MUfrTDZjViodUkUhJjsgGE2KZRTciVhjEdgZLUHkiy2QPc8wSH9rHzJ53RGUr6/oK9
	 Bo9IGDGDw/yHB/J1rbaxNKFD9gL+LeiKxjRzBozY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 7.3 240/547] mshv_vtl: detach poll waiter on POLLFREE
Date: Wed,  4 Nov 2026 16:07:04 -0500
Message-ID: <20261104211044.986389499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit efc5dc4c15713fdd6e87882686a26ed1deb22dab upstream.

MSHV_SET_POLL_FILE keeps a poll wait entry after the ioctl returns. A
file reference does not always pin the registered waitqueue:
signalfd_poll() uses current->sighand->signalfd_wqh, whose lifetime is
tied to the task.

signalfd_cleanup() sends POLLFREE before the sighand is freed. The MSHV
callback currently leaves its entry linked, so __wake_up_pollfree()
warns and a later replacement calls remove_wait_queue() through a stale
wqh pointer. A source-equivalent KASAN run reproduced:

  BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave
  _raw_spin_lock_irqsave
  remove_wait_queue
  harness_ioctl [mshv_pollfree_harness]

The object belonged to sighand_cache and had been released through
slab_free_after_rcu_debug() after __cleanup_sighand().

On POLLFREE, unlink the entry under the provider waitqueue lock. Preserve
the existing CPU cancellation before publishing a NULL wqh, since a NULL
load lets a racing replacement reuse the persistent poll state. Use a
matching acquire load under RCU when removing a normal registration.

The callback takes no mutex and does not sleep, so the existing
mutex-to-waitqueue-lock order is unchanged.

An LLM assisted the source audit, fix development, and validation of this
issue.

Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/mshv_vtl_main.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/drivers/hv/mshv_vtl_main.c
+++ b/drivers/hv/mshv_vtl_main.c
@@ -17,6 +17,7 @@
 #include <linux/entry-virt.h>
 #include <linux/eventfd.h>
 #include <linux/poll.h>
+#include <linux/rcupdate.h>
 #include <linux/file.h>
 #include <linux/vmalloc.h>
 #include <asm/debugreg.h>
@@ -448,12 +449,35 @@ static void mshv_vtl_cancel(int cpu)
 static int mshv_vtl_poll_file_wake(wait_queue_entry_t *wait, unsigned int mode, int sync, void *key)
 {
 	struct mshv_vtl_poll_file *poll_file = container_of(wait, struct mshv_vtl_poll_file, wait);
+	__poll_t pollflags = key_to_poll(key);
+
+	if (pollflags & POLLFREE)
+		list_del_init(&wait->entry);
 
 	mshv_vtl_cancel(poll_file->cpu);
 
+	if (pollflags & POLLFREE) {
+		/* Publish teardown last; pair with acquire in the removal path. */
+		smp_store_release(&poll_file->wqh, NULL);
+	}
+
 	return 0;
 }
 
+static void mshv_vtl_poll_file_remove_wait_queue(struct mshv_vtl_poll_file *poll_file)
+{
+	wait_queue_head_t *wqh;
+
+	/* POLLFREE providers RCU-delay the waitqueue free. */
+	rcu_read_lock();
+	/* Pair with the release store in the POLLFREE callback. */
+	wqh = smp_load_acquire(&poll_file->wqh);
+	if (wqh)
+		remove_wait_queue(wqh, &poll_file->wait);
+	rcu_read_unlock();
+	WRITE_ONCE(poll_file->wqh, NULL);
+}
+
 static void mshv_vtl_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh, poll_table *pt)
 {
 	struct mshv_vtl_poll_file *poll_file = container_of(pt, struct mshv_vtl_poll_file, pt);
@@ -490,9 +514,7 @@ static int mshv_vtl_ioctl_set_poll_file(
 
 	mutex_lock(&mshv_vtl_poll_file_lock);
 
-	if (poll_file->wqh)
-		remove_wait_queue(poll_file->wqh, &poll_file->wait);
-	poll_file->wqh = NULL;
+	mshv_vtl_poll_file_remove_wait_queue(poll_file);
 
 	old_file = poll_file->file;
 	poll_file->file = file;


