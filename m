Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223D5327BF3;
	Mon, 29 Dec 2025 16:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025563; cv=none; b=iW65eWI5DS1xaWw4gm2dGLt4jNKKnaD3VTUpVvnqNOPkIL2f5WheJALrWsRTN+D/jxvuwUXcjbO1VgO90o9mUAc8bkzNv9m+elHA7+BRojPLWtX8nkzIx6jXFfPabHXHh+8JNwM5PCuD3zk9pLQ9oOXDCkfZsLY48hBFYtf4cEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025563; c=relaxed/simple;
	bh=1fIjVxeUakk1TvKiylrtvMUC7Bp5bV1xbGQ9gPM8jZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hODwI3q8FOYNNweJ/o2uTzfV9nE9Cn7Rp3RKgQ4ssYCcyETtFnoTa9FCAsvXa6oKxj88i0828VAGE2jWuJQ+KyMXGyoUkwpAEMNRoAq1BeaC0KfWD4sbSkKgQQJGB6KGnunHtmLUh1RLYOw+KDWni7jEGq8XBaTZhwKjiWlMvRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAR98hjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAR98hjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2CAC16AAE;
	Mon, 29 Dec 2025 16:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025563;
	bh=1fIjVxeUakk1TvKiylrtvMUC7Bp5bV1xbGQ9gPM8jZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAR98hjkWYpldhQ1d+DpFY0p90Lqe6AdyI1+At/4acHjyhA0POht9f29gcM215KJp
	 AJ8uJz4rddXNTbRCZr82K8p0chuDtX2SimhB2z2QrbU5Ww5iLPWUajgn/Kg9hfdSfg
	 24InKlfSLvJ5QsHRkpnIi9v/8uz8Apli+8a7/AQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Sherry Sun <sherry.sun@nxp.com>
Subject: [PATCH 6.18 257/430] printk: Allow printk_trigger_flush() to flush all types
Date: Mon, 29 Dec 2025 17:10:59 +0100
Message-ID: <20251229160733.814070878@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

commit d01ff281bd9b1bfeac9ab98ec8a9ee41da900d5e upstream.

Currently printk_trigger_flush() only triggers legacy offloaded
flushing, even if that may not be the appropriate method to flush
for currently registered consoles. (The function predates the
NBCON consoles.)

Since commit 6690d6b52726 ("printk: Add helper for flush type
logic") there is printk_get_console_flush_type(), which also
considers NBCON consoles and reports all the methods of flushing
appropriate based on the system state and consoles available.

Update printk_trigger_flush() to use
printk_get_console_flush_type() to appropriately flush registered
consoles.

Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/stable/20251113160351.113031-2-john.ogness%40linutronix.de
Tested-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://patch.msgid.link/20251113160351.113031-2-john.ogness@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/printk/nbcon.c  |    2 +-
 kernel/printk/printk.c |   23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 2 deletions(-)

--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -1856,7 +1856,7 @@ void nbcon_device_release(struct console
 			if (console_trylock())
 				console_unlock();
 		} else if (ft.legacy_offload) {
-			printk_trigger_flush();
+			defer_console_output();
 		}
 	}
 	console_srcu_read_unlock(cookie);
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -4595,9 +4595,30 @@ void defer_console_output(void)
 	__wake_up_klogd(PRINTK_PENDING_WAKEUP | PRINTK_PENDING_OUTPUT);
 }
 
+/**
+ * printk_trigger_flush - Attempt to flush printk buffer to consoles.
+ *
+ * If possible, flush the printk buffer to all consoles in the caller's
+ * context. If offloading is available, trigger deferred printing.
+ *
+ * This is best effort. Depending on the system state, console states,
+ * and caller context, no actual flushing may result from this call.
+ */
 void printk_trigger_flush(void)
 {
-	defer_console_output();
+	struct console_flush_type ft;
+
+	printk_get_console_flush_type(&ft);
+	if (ft.nbcon_atomic)
+		nbcon_atomic_flush_pending();
+	if (ft.nbcon_offload)
+		nbcon_kthreads_wake();
+	if (ft.legacy_direct) {
+		if (console_trylock())
+			console_unlock();
+	}
+	if (ft.legacy_offload)
+		defer_console_output();
 }
 
 int vprintk_deferred(const char *fmt, va_list args)


