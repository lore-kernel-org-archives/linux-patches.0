Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBC615C127;
	Mon, 12 Aug 2024 16:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480536; cv=none; b=H/WRFPVK5EVvhTYquqs0WdPnZUe4Cm2ixIqmi3fZDwFto5X6rJ5vg3GHEdbW3LouoSdNh9pvz+dq+JuXlXhlOZUTqCRd10Vx97fUy+ZcYfC5FYv7UYiTOapA3iO21QtZ9a2U7IIJWQRj87JeA0NFCOgs2Yzulf7wm+IGMWenbbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480536; c=relaxed/simple;
	bh=L53xQqI+LINu5kqJRvSOv7rFxwfOh5Ikj4B0qMvdy4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcRhX4JKpvOzZPjROuy+yb4ZDI0btXPbCYRQ7BxnxCa5JQ0X3amUVYEBH7U+WrwpKeQzcStFkcKR2VxBjiPfpy8u4hL0MZYXa7KvYSKvamX9ygSbYphzPUX3N8NE/u5U0om7CZ6+ht8FeNdMBQTS38qICZZ1VxKbb8JeuINzOQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fU4jFDNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fU4jFDNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0A6C32782;
	Mon, 12 Aug 2024 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480536;
	bh=L53xQqI+LINu5kqJRvSOv7rFxwfOh5Ikj4B0qMvdy4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fU4jFDNP21Z9av2bH72ccOldssnv50TCccpcm+5Er/pEk0FOE6i/vam+S4b7joASu
	 5/CbTE7ehSPQR2GNeKLrrJkpYZ1KvCGcYUMX9JgX1wLa2sbeqltohHpLzzdIG8s/qN
	 4lniJKuyjFTo8IzlMRxZec8cPTzIA2x/VKrem5tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	syzbot+2388cdaeb6b10f0c13ac@syzkaller.appspotmail.com,
	Marco Elver <elver@google.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Aleksandr Nogikh <nogikh@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Marcello Sylvester Bauer <sylv@sylv.io>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 218/263] kcov: properly check for softirq context
Date: Mon, 12 Aug 2024 18:03:39 +0200
Message-ID: <20240812160154.888135199@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Konovalov <andreyknvl@gmail.com>

commit 7d4df2dad312f270d62fecb0e5c8b086c6d7dcfc upstream.

When collecting coverage from softirqs, KCOV uses in_serving_softirq() to
check whether the code is running in the softirq context.  Unfortunately,
in_serving_softirq() is > 0 even when the code is running in the hardirq
or NMI context for hardirqs and NMIs that happened during a softirq.

As a result, if a softirq handler contains a remote coverage collection
section and a hardirq with another remote coverage collection section
happens during handling the softirq, KCOV incorrectly detects a nested
softirq coverate collection section and prints a WARNING, as reported by
syzbot.

This issue was exposed by commit a7f3813e589f ("usb: gadget: dummy_hcd:
Switch to hrtimer transfer scheduler"), which switched dummy_hcd to using
hrtimer and made the timer's callback be executed in the hardirq context.

Change the related checks in KCOV to account for this behavior of
in_serving_softirq() and make KCOV ignore remote coverage collection
sections in the hardirq and NMI contexts.

This prevents the WARNING printed by syzbot but does not fix the inability
of KCOV to collect coverage from the __usb_hcd_giveback_urb when dummy_hcd
is in use (caused by a7f3813e589f); a separate patch is required for that.

Link: https://lkml.kernel.org/r/20240729022158.92059-1-andrey.konovalov@linux.dev
Fixes: 5ff3b30ab57d ("kcov: collect coverage from interrupts")
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reported-by: syzbot+2388cdaeb6b10f0c13ac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2388cdaeb6b10f0c13ac
Acked-by: Marco Elver <elver@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marcello Sylvester Bauer <sylv@sylv.io>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kcov.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -161,6 +161,15 @@ static void kcov_remote_area_put(struct
 	kmsan_unpoison_memory(&area->list, sizeof(area->list));
 }
 
+/*
+ * Unlike in_serving_softirq(), this function returns false when called during
+ * a hardirq or an NMI that happened in the softirq context.
+ */
+static inline bool in_softirq_really(void)
+{
+	return in_serving_softirq() && !in_hardirq() && !in_nmi();
+}
+
 static notrace bool check_kcov_mode(enum kcov_mode needed_mode, struct task_struct *t)
 {
 	unsigned int mode;
@@ -170,7 +179,7 @@ static notrace bool check_kcov_mode(enum
 	 * so we ignore code executed in interrupts, unless we are in a remote
 	 * coverage collection section in a softirq.
 	 */
-	if (!in_task() && !(in_serving_softirq() && t->kcov_softirq))
+	if (!in_task() && !(in_softirq_really() && t->kcov_softirq))
 		return false;
 	mode = READ_ONCE(t->kcov_mode);
 	/*
@@ -849,7 +858,7 @@ void kcov_remote_start(u64 handle)
 
 	if (WARN_ON(!kcov_check_handle(handle, true, true, true)))
 		return;
-	if (!in_task() && !in_serving_softirq())
+	if (!in_task() && !in_softirq_really())
 		return;
 
 	local_lock_irqsave(&kcov_percpu_data.lock, flags);
@@ -991,7 +1000,7 @@ void kcov_remote_stop(void)
 	int sequence;
 	unsigned long flags;
 
-	if (!in_task() && !in_serving_softirq())
+	if (!in_task() && !in_softirq_really())
 		return;
 
 	local_lock_irqsave(&kcov_percpu_data.lock, flags);


