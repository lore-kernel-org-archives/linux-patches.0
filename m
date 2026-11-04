Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827091;
	b=H0AHrE4V8cffqAOGbn1f21ycnWkxEQ47gLXCboATH4QKIt7uITOE7/SRpIixEzDSBZmL
	 5kYZVEF9rURp4Vbt+5U/+YpQwfIWO91KHQK7f4PCIpPub5PKhC5hF7pSDCc0JC3/Kjx9T
	 lJscxX2cKx0+u4MnThJul7dziEm8it0Ds0nx7boXWh7F4OOYNUYsTKYatJ/XazesjUSuJ
	 CalkivjywXpC5yI5sz7IIEswtKsof6YAB49q6TYP8SEPY+la+okRLV45UrC6I7fDURT2I
	 xc+L+NXSOY951rKSXJPUwxOOzmhTKd/nmn8QLvBI9o/RG7+f9YXZPkrBh5EY57S3Kqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d3ksCbw1D/10W/kNEJQLFkxH4W04D5uKnJaGkSwOybI=;
	b=bU86jAJfrUmKVwzLHeEgkeQl6byGlmpYR34JNU5dq4ir2A71DUEAO27mhKHy4gQIohEh
	 Qg1r0yTwVpO4rrCm/wgOgVJqwzikQI4rzVqjsBq4N+s5tQDu5dHqsnU5DVR2AHyt6q/QI
	 sG4aVwNe5HaWXwpk84964rnRO04L+Net4M3i0177FSUdGKPPSWVY9X7xI1zqe/VXsvNUZ
	 D0Nqi6m/CQS/cAWDvj3JI6wiA+p2opTZSZJ5kUI/4M7Ue8neYTw2ZjK70kN2aUQl7LvtS
	 OUMvhvnvLcrHYFEKmxqUUyW3OaqV2FkMHqNvUNrrqVf59Ad0IcPNXo//aMOrOhEeZ8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDQhoOqK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105D860841A4;
	Wed,  4 Nov 2026 21:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDQhoOqK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4E31F000C1;
	Wed,  4 Nov 2026 21:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827090;
	bh=d3ksCbw1D/10W/kNEJQLFkxH4W04D5uKnJaGkSwOybI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDQhoOqKYIJO02VPvvZDhKQsFd47KJcjyabbMuu02JjqUlVzj3W+vYWEskWAQCNU9
	 tm0Ew/yBEns/xHP0OvFDafHFUVCMmNmgtRrLRRYwVjZ/z3ke8U+XLZdDsQYb6fohit
	 pXD8PZ0nk72YOKRdFEkeiK3tQXzwH+lx07xmden8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>
Subject: [PATCH 7.3 190/547] klist: avoid accesses after waking klist_remove()
Date: Wed,  4 Nov 2026 16:06:14 -0500
Message-ID: <20261104211043.535872548@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 732e3e10234cbe302d0dcbaa98c91c66628209cb upstream.

klist_remove() waits until a node is unreferenced so that its caller can
free the containing object.  klist_release() currently publishes
waiter->woken and wakes the waiter before its final accesses to the waiter
and node.  klist_remove() can then return, allowing its stack waiter and
the containing object to be freed or reused while klist_release() is still
running.  In particular, bus_remove_driver() can free drv->p while
__device_attach() walks the same bus klist with bus_for_each_drv().

On an arm64 Cortex-A72 system, an unpatched 7.2.0-rc3 kernel with
CONFIG_PREEMPT_RT=y and CONFIG_KASAN=y reproduced the bug through the
in-tree I2C/at24 path.  KASAN reported a use-after-free in
klist_dec_and_del() reached from klist_next()/bus_for_each_drv() while
at24 was being unregistered.

Clear n_klist and take a task reference before publishing woken.  Use
release/acquire accesses for that publication and wake the referenced
task.  The task reference keeps the waiter task alive if it returns and
exits before wake_up_process().

Link: https://lore.kernel.org/20260827041708.31682-1-kmehltretter@gmail.com
Fixes: 8b0c250be489 ("[PATCH] add klist_node_attached() to determine if a node is on a list or not.")
Fixes: 210272a28465 ("driver core: Remove completion from struct klist_node")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/klist.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/lib/klist.c
+++ b/lib/klist.c
@@ -36,6 +36,7 @@
 #include <linux/klist.h>
 #include <linux/export.h>
 #include <linux/sched.h>
+#include <linux/sched/task.h>
 
 /*
  * Use the lowest bit of n_klist to mark deleted nodes and exclude
@@ -187,18 +188,24 @@ static void klist_release(struct kref *k
 
 	WARN_ON(!knode_dead(n));
 	list_del(&n->n_node);
+	knode_set_klist(n, NULL);
 	spin_lock(&klist_remove_lock);
 	list_for_each_entry_safe(waiter, tmp, &klist_remove_waiters, list) {
+		struct task_struct *p;
+
 		if (waiter->node != n)
 			continue;
 
+		p = waiter->process;
+		get_task_struct(p);
 		list_del(&waiter->list);
-		waiter->woken = 1;
+		/* Publish only after the final waiter and n accesses */
+		smp_store_release(&waiter->woken, 1);
 		mb();
-		wake_up_process(waiter->process);
+		wake_up_process(p);
+		put_task_struct(p);
 	}
 	spin_unlock(&klist_remove_lock);
-	knode_set_klist(n, NULL);
 }
 
 static int klist_dec_and_del(struct klist_node *n)
@@ -250,7 +257,8 @@ void klist_remove(struct klist_node *n)
 
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (waiter.woken)
+		/* Pairs with the release store in klist_release() */
+		if (smp_load_acquire(&waiter.woken))
 			break;
 		schedule();
 	}


