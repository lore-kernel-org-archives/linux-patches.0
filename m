Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752E819DF5F;
	Thu, 15 Aug 2024 14:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730635; cv=none; b=j3oqMh/p8mGPlxwnN8OVN3bf3WTiW3aub6rYhd4BOy4mX3toNncMMRA+0SPmYDn4Nty1IigeCtnzTo4crQJpVeu19oUY/Be+qyrBquy+2Z1pa/mexgzFl80CidQDhEFIqmT7+9qdEyasTuQLpC69OjtK5k4o67Md4HXxDPPcsDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730635; c=relaxed/simple;
	bh=KaOeRqYTxdVTLb3PhAP5c9vm2F4CxIkX/Sh5iMpQq6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knNSZOMAKhjbULH9jzrMrNn+vT/dAibVAwVk8TsdOqH569+wHsTVvD4INiKW3b4VR+65GPiP3Bf8T2xInQq7S0DqbT6yGs49NvXax985p/vrVNcXS7Khuws5i+VFFj0APyYw3bphOLWaLTumjVtFlW1vtdK5fnOKZw1d0njEUSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ne5qEFCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ne5qEFCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C88C32786;
	Thu, 15 Aug 2024 14:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730635;
	bh=KaOeRqYTxdVTLb3PhAP5c9vm2F4CxIkX/Sh5iMpQq6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ne5qEFCZI16OSVaHoAfIVwHQv1v69vEReybj5VyzqR6wPHyPhDT5AqXKL/Y6Lbhf7
	 fJNLie9jldN9N70Men1dxw/o8vnHqU+G/+rqurEWeBmLGLUAuqEFDnREmIsqjgYBdT
	 marMT7A35kwMHb0BFS7DUS7KoGVFCwyE/inGmg8k=
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
Subject: [PATCH 5.15 439/484] kcov: properly check for softirq context
Date: Thu, 15 Aug 2024 15:24:57 +0200
Message-ID: <20240815131958.414267677@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -151,6 +151,15 @@ static void kcov_remote_area_put(struct
 	list_add(&area->list, &kcov_remote_areas);
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
@@ -160,7 +169,7 @@ static notrace bool check_kcov_mode(enum
 	 * so we ignore code executed in interrupts, unless we are in a remote
 	 * coverage collection section in a softirq.
 	 */
-	if (!in_task() && !(in_serving_softirq() && t->kcov_softirq))
+	if (!in_task() && !(in_softirq_really() && t->kcov_softirq))
 		return false;
 	mode = READ_ONCE(t->kcov_mode);
 	/*
@@ -822,7 +831,7 @@ void kcov_remote_start(u64 handle)
 
 	if (WARN_ON(!kcov_check_handle(handle, true, true, true)))
 		return;
-	if (!in_task() && !in_serving_softirq())
+	if (!in_task() && !in_softirq_really())
 		return;
 
 	local_irq_save(flags);
@@ -963,7 +972,7 @@ void kcov_remote_stop(void)
 	int sequence;
 	unsigned long flags;
 
-	if (!in_task() && !in_serving_softirq())
+	if (!in_task() && !in_softirq_really())
 		return;
 
 	local_irq_save(flags);


