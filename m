Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624543;
	b=4pwSoTon+445EoPfzY5Yu0mJSm3M+U9YwWaJOED3VE0bG887Fg0E6STIfkiTjDgpkPgq
	 1gQJyB0Y921MRYA816XGR+8BPqImTeijClzbkfbAMP80sDZEJMxjgCoP1HXodb1GWNFrv
	 ert64dAWKZ3lUCCZrXlVEDr+rsDHycYnRrH5ouvadkPSaHzBlhVOWhWsEWyDWsVS0LEEP
	 q/7vb57HHe0SwUbKoiXjw1lmLh4bp+TFywOuGqdmUkb3yTfjSoA8HPZaAAYOoTOBvkq10
	 LaukkOwpMqmokLaCyL3ARD/Pj4QEYUwvF7RDrz/VE3jybMRD+vrkp9PNyM0drHmS+8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bJO7tYeUjW+UsgOA8Bxg4ENpBc4DZpcSvGjb5eFsInA=;
	b=p0XAIxfvtw7xDPWmPbU+uIAR1Clm6w01IbC+dozn5AWneMq9Nz/dO7gkeK9iMNxnv8t5
	 p2plyHSVhPPaIOJj2Poye1pNJXQ7DhkZVhpyDnM4/P2oVBSCMy6tsKBi0LHwZziISZoHT
	 7VnP6r9TAnS+F+SXAjwl4FZ8hgIobropyeyKrGCyyWB4OXCTCOoAuvJ0xHbAcJUD73VKq
	 LM7PIrCMzznCzPOYKAbyn7fy4VKNNGKSWXOtcKT7eExUXdJh7eCgE3+axjkg1aVt7WM2R
	 xBWDGDQ3nW86D+Ds1qWRj4Vf0CFU9GHJQQ5xVm2Ugp7y9EQkCzeDoeGHc4EmXEBGF3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eeBt/Tmf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D62606A339;
	Wed, 25 Nov 2026 16:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eeBt/Tmf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AA21F000C0;
	Wed, 25 Nov 2026 16:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624543;
	bh=bJO7tYeUjW+UsgOA8Bxg4ENpBc4DZpcSvGjb5eFsInA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eeBt/TmftNwLquBHfoedISx8D/oUTedZBG+SrbdjrDJ8bnwqSyKralGpfXhYH4JzS
	 uEzM9QOSVvFjHcci+57kkaVRD3vrIqIAIBYTKvisX/lqKxfCnbg6+tUj0fo62mHl3i
	 eC6cGMOMgJx6l5rpm5u8sYFDvIUCmDXzP+aWhWoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Derek Barbosa <debarbos@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/816] printk: Avoid multiple unregistration in unregister_console_locked()
Date: Wed, 25 Nov 2026 15:28:50 +0100
Message-ID: <20261125143853.404879298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 8a7f26aa072a4e63bc3b1adfe649546709db722e ]

unregister_console_locked() is called from within
hlist_for_each_entry_safe(console_list) loops. This would be safe if
unregister_console_locked() only unregistered the specified console. After
all, that is what the _safe variant is for.

However, unregister_console_locked() calls printk_kthreads_check_locked(),
which can unregister _multiple_ consoles if kthreads fail to start. This
could lead to hlist_for_each_entry_safe() use-after-free scenarios because
not only was the list entry removed, but possibly the following entry as
well (the @n temporary storage of the next entry).

Move the call to printk_kthreads_check_locked() outside of
unregister_console_locked(). Add comments to both functions to clarify
if they are safe to be used in hlist_for_each_entry_safe(console_list)
loops.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/lkml/87ik31iz4x.fsf@jogness.linutronix.de
Fixes: 76f258bf3f2a ("printk: nbcon: Introduce printer kthreads")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Derek Barbosa <debarbos@redhat.com>
Link: https://patch.msgid.link/20261030135802.663893-1-john.ogness@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index def877601a867..f3d897ca6d615 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3696,6 +3696,13 @@ static struct syscore printk_syscore = {
  * If appropriate, start nbcon kthreads and set @printk_kthreads_running.
  * If any kthreads fail to start, those consoles are unregistered.
  *
+ * Called after consoles are registered or unregistered.
+ *
+ * This MUST NOT be called within an hlist_for_each_entry_safe(console_list)
+ * loop because it can unregister multiple consoles if any kthreads fail to
+ * start. That would lead to use-after-free scenarios within the
+ * hlist_for_each_entry_safe(console_list) loop of the caller.
+ *
  * Must be called under console_list_lock().
  */
 static void printk_kthreads_check_locked(void)
@@ -4137,7 +4144,20 @@ void register_console(struct console *newcon)
 }
 EXPORT_SYMBOL(register_console);
 
-/* Must be called under console_list_lock(). */
+/*
+ * Unregister the specified console.
+ *
+ * This can be called safely from within an
+ * hlist_for_each_entry_safe(console_list) loop because it unregisters
+ * _only_ the specified console.
+ *
+ * Afterwards the caller should call printk_kthreads_check_locked() since
+ * unregistering a console may require printer threads to start/stop. Note
+ * that printk_kthreads_check_locked() cannot be called safely from within
+ * an hlist_for_each_entry_safe(console_list) loop.
+ *
+ * Must be called under console_list_lock().
+ */
 static int unregister_console_locked(struct console *console)
 {
 	bool use_device_lock = (console->flags & CON_NBCON) && console->write_atomic;
@@ -4229,9 +4249,6 @@ static int unregister_console_locked(struct console *console)
 	if (console->exit)
 		res = console->exit(console);
 
-	/* Changed console list, may require printer threads to start/stop. */
-	printk_kthreads_check_locked();
-
 	return res;
 }
 
@@ -4240,7 +4257,12 @@ int unregister_console(struct console *console)
 	int res;
 
 	console_list_lock();
+
 	res = unregister_console_locked(console);
+
+	/* Changed console list, may require printer threads to start/stop. */
+	printk_kthreads_check_locked();
+
 	console_list_unlock();
 	return res;
 }
@@ -4359,6 +4381,10 @@ static int __init printk_late_init(void)
 			unregister_console_locked(con);
 		}
 	}
+
+	/* Changed console list, may require printer threads to start/stop. */
+	printk_kthreads_check_locked();
+
 	console_list_unlock();
 
 	ret = cpuhp_setup_state_nocalls(CPUHP_PRINTK_DEAD, "printk:dead", NULL,
-- 
2.53.0



