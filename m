Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621539;
	b=icckkssmOGRBNwxLJRSLMEnVKjgDkHbg1hGX9btemzReUofMlOuu3Ih2BoEzuNhlpxyk
	 2emWhEW2ZUFWMhmL1Wl3oN59ewLxa+xBr9ZsfiEF1GNcNft6JXnsbA7nRTbsZ1MNgrZXp
	 65GnbWVvzAYZwM0soPS+N7po+qn59caVBxIrt8RcIAJfqH/cqIesVuGpXBFXN2IkFcpl9
	 8xq4E0z4DDuuJ4gdoHaIWPgrO9qZlI6VCFjLpZvpCuAVudDC/1hhxQKpchyQDHUAP2lUe
	 uL47bhha3Pv6a15b0VqBsHoVImXStW/BrGFFLY3MSv6hmWaGVL+wRYpFK0bsz+8V/wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SpTMBISIq5ZrwH37jmBdQCSJ7WKJKBD+931rfiIiJ/I=;
	b=jOBwkArMJr5bijcdJVzaLiWaRp7IYy4Db9c/+d2d1nDwiFUIS3CrcUjkG5Eq/mtC3LPI
	 HVa39QAH+yb6+5b0ok38P2plhfFZl87G89J+Cf+oh3kr/+c3R0Wj/+3numPHHmKeUIZyn
	 bXiPWDuYxV++WOx5efR38FSakWWWXjtL70lTZYpkRo4IyqKAdZPjWaZwZWcaH6hvP8K8y
	 vIYfePeQdQXyPxmK8ZrNv/A0279/xTIEtYduJCTTQme+9h537OV85PBcNM0EkXslRSem2
	 e92ggHZUY9pc9go+LjzrORdID+DQ14Ylp7KNSzNu02pz9wy6TF2gf+GyPQqcRDGErkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wd1FrD18;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C9B606A31E;
	Wed, 25 Nov 2026 15:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wd1FrD18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A6A1F000C4;
	Wed, 25 Nov 2026 15:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621538;
	bh=SpTMBISIq5ZrwH37jmBdQCSJ7WKJKBD+931rfiIiJ/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wd1FrD18rym+gTzaCmKoepP4ln9e5u4Lf2QZxmwa6PXUVcsff9WHLijRtpcniCAIF
	 zmIykJ/JuESdfUWGUUQBQzfnH0jbpM4zJ9GG8l/cSDw9pJcCeP+LWrtqMRW47NAAjz
	 Par1cx+Tm2otYIgCPVN1FJHWgZNsgZKz80urL8p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Derek Barbosa <debarbos@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 211/990] printk: Avoid multiple unregistration in unregister_console_locked()
Date: Wed, 25 Nov 2026 15:26:18 +0100
Message-ID: <20261125143827.033458800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d555d05ffa8d4..124e7790f8447 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3747,6 +3747,13 @@ static struct syscore printk_syscore = {
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
@@ -4188,7 +4195,20 @@ void register_console(struct console *newcon)
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
@@ -4280,9 +4300,6 @@ static int unregister_console_locked(struct console *console)
 	if (console->exit)
 		res = console->exit(console);
 
-	/* Changed console list, may require printer threads to start/stop. */
-	printk_kthreads_check_locked();
-
 	return res;
 }
 
@@ -4291,7 +4308,12 @@ int unregister_console(struct console *console)
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
@@ -4415,6 +4437,10 @@ static int __init printk_late_init(void)
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



