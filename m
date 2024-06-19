Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE674AD58;
	Wed, 19 Jun 2024 13:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802986; cv=none; b=scEL2vQ0Nnr9FEf4mx+NaQQyto54yGKvR7k8ZD0Yvd5jtrOqeHOOqhbaPC7TFNVzfJvXkcs+axRYiEsuMpw9/OcjwgrgTm9htYNQnRPTBy/8udQq2dja3jr3WyOgoEKNO6/WIZriMjFNi9mghEN0eHqqW/12/9vzn5TVjqxjTNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802986; c=relaxed/simple;
	bh=j2PEMCtIsb1kLLwrQTT98eamhv/g9VLB/CiWMGO7aSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iM+MpunaXxtcl0ggf/WqBx3qxh2JC+d99WdgWIoO7cSuzm700DeYwhpSBQkuzVyjVRUMzC5PxdIZpxoQutKhloQPXlE9pmyXcGh5b+3W9EKqFUz2t8txlKOe3/nF9EUWc5BfgOfoavz5SVmtcPj6X7v5VCZPtFv2ukZCpdgOBvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROTq7yx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROTq7yx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45243C2BBFC;
	Wed, 19 Jun 2024 13:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802986;
	bh=j2PEMCtIsb1kLLwrQTT98eamhv/g9VLB/CiWMGO7aSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROTq7yx3RF30RWgdU6Hs8pPkrSQPNpZzXbH/sbWb4kppsXPKLBCUYBRWcLY0jnwvB
	 JUBHq656qgGqGXIOvDjfiU+KyCPEjV227ZPVlQk1tY/hjMOrJ3Rq50kwksGuws78g9
	 bCwDyRHsO/QPmJyvl7XH6TBIHXCkesZq2PEouKTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Alan Stern <stern@rowland.harvard.edu>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>
Subject: [PATCH 6.9 083/281] kcov, usb: disable interrupts in kcov_remote_start_usb_softirq
Date: Wed, 19 Jun 2024 14:54:02 +0200
Message-ID: <20240619125613.035421293@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Konovalov <andreyknvl@gmail.com>

commit f85d39dd7ed89ffdd622bc1de247ffba8d961504 upstream.

After commit 8fea0c8fda30 ("usb: core: hcd: Convert from tasklet to BH
workqueue"), usb_giveback_urb_bh() runs in the BH workqueue with
interrupts enabled.

Thus, the remote coverage collection section in usb_giveback_urb_bh()->
__usb_hcd_giveback_urb() might be interrupted, and the interrupt handler
might invoke __usb_hcd_giveback_urb() again.

This breaks KCOV, as it does not support nested remote coverage collection
sections within the same context (neither in task nor in softirq).

Update kcov_remote_start/stop_usb_softirq() to disable interrupts for the
duration of the coverage collection section to avoid nested sections in
the softirq context (in addition to such in the task context, which are
already handled).

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Closes: https://lore.kernel.org/linux-usb/0f4d1964-7397-485b-bc48-11c01e2fcbca@I-love.SAKURA.ne.jp/
Closes: https://syzkaller.appspot.com/bug?extid=0438378d6f157baae1a2
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 8fea0c8fda30 ("usb: core: hcd: Convert from tasklet to BH workqueue")
Cc: stable@vger.kernel.org
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://lore.kernel.org/r/20240527173538.4989-1-andrey.konovalov@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hcd.c |   12 +++++++-----
 include/linux/kcov.h   |   47 ++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 45 insertions(+), 14 deletions(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1623,6 +1623,7 @@ static void __usb_hcd_giveback_urb(struc
 	struct usb_hcd *hcd = bus_to_hcd(urb->dev->bus);
 	struct usb_anchor *anchor = urb->anchor;
 	int status = urb->unlinked;
+	unsigned long flags;
 
 	urb->hcpriv = NULL;
 	if (unlikely((urb->transfer_flags & URB_SHORT_NOT_OK) &&
@@ -1640,13 +1641,14 @@ static void __usb_hcd_giveback_urb(struc
 	/* pass ownership to the completion handler */
 	urb->status = status;
 	/*
-	 * This function can be called in task context inside another remote
-	 * coverage collection section, but kcov doesn't support that kind of
-	 * recursion yet. Only collect coverage in softirq context for now.
+	 * Only collect coverage in the softirq context and disable interrupts
+	 * to avoid scenarios with nested remote coverage collection sections
+	 * that KCOV does not support.
+	 * See the comment next to kcov_remote_start_usb_softirq() for details.
 	 */
-	kcov_remote_start_usb_softirq((u64)urb->dev->bus->busnum);
+	flags = kcov_remote_start_usb_softirq((u64)urb->dev->bus->busnum);
 	urb->complete(urb);
-	kcov_remote_stop_softirq();
+	kcov_remote_stop_softirq(flags);
 
 	usb_anchor_resume_wakeups(anchor);
 	atomic_dec(&urb->use_count);
--- a/include/linux/kcov.h
+++ b/include/linux/kcov.h
@@ -55,21 +55,47 @@ static inline void kcov_remote_start_usb
 
 /*
  * The softirq flavor of kcov_remote_*() functions is introduced as a temporary
- * work around for kcov's lack of nested remote coverage sections support in
- * task context. Adding support for nested sections is tracked in:
- * https://bugzilla.kernel.org/show_bug.cgi?id=210337
+ * workaround for KCOV's lack of nested remote coverage sections support.
+ *
+ * Adding support is tracked in https://bugzilla.kernel.org/show_bug.cgi?id=210337.
+ *
+ * kcov_remote_start_usb_softirq():
+ *
+ * 1. Only collects coverage when called in the softirq context. This allows
+ *    avoiding nested remote coverage collection sections in the task context.
+ *    For example, USB/IP calls usb_hcd_giveback_urb() in the task context
+ *    within an existing remote coverage collection section. Thus, KCOV should
+ *    not attempt to start collecting coverage within the coverage collection
+ *    section in __usb_hcd_giveback_urb() in this case.
+ *
+ * 2. Disables interrupts for the duration of the coverage collection section.
+ *    This allows avoiding nested remote coverage collection sections in the
+ *    softirq context (a softirq might occur during the execution of a work in
+ *    the BH workqueue, which runs with in_serving_softirq() > 0).
+ *    For example, usb_giveback_urb_bh() runs in the BH workqueue with
+ *    interrupts enabled, so __usb_hcd_giveback_urb() might be interrupted in
+ *    the middle of its remote coverage collection section, and the interrupt
+ *    handler might invoke __usb_hcd_giveback_urb() again.
  */
 
-static inline void kcov_remote_start_usb_softirq(u64 id)
+static inline unsigned long kcov_remote_start_usb_softirq(u64 id)
 {
-	if (in_serving_softirq())
+	unsigned long flags = 0;
+
+	if (in_serving_softirq()) {
+		local_irq_save(flags);
 		kcov_remote_start_usb(id);
+	}
+
+	return flags;
 }
 
-static inline void kcov_remote_stop_softirq(void)
+static inline void kcov_remote_stop_softirq(unsigned long flags)
 {
-	if (in_serving_softirq())
+	if (in_serving_softirq()) {
 		kcov_remote_stop();
+		local_irq_restore(flags);
+	}
 }
 
 #ifdef CONFIG_64BIT
@@ -103,8 +129,11 @@ static inline u64 kcov_common_handle(voi
 }
 static inline void kcov_remote_start_common(u64 id) {}
 static inline void kcov_remote_start_usb(u64 id) {}
-static inline void kcov_remote_start_usb_softirq(u64 id) {}
-static inline void kcov_remote_stop_softirq(void) {}
+static inline unsigned long kcov_remote_start_usb_softirq(u64 id)
+{
+	return 0;
+}
+static inline void kcov_remote_stop_softirq(unsigned long flags) {}
 
 #endif /* CONFIG_KCOV */
 #endif /* _LINUX_KCOV_H */


