Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A830330FF1D;
	Sat, 12 Sep 2026 09:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206853; cv=none; b=Wg4Lfgnyi68xgHQ40Ml2L50PCm1ske3cTNCM5rBdpy3bAUMbVqEmi8ylWII7j90EOTdIKO/gmgMaxz+6h/Ipmdz6riT5dq3HYGPKfW2z05ThkeVe7qNn2IJtatnN/78fSOQmSKhVy8ZrV6KPSnYCKWWJmHhN6+yArxhId7suTsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206853; c=relaxed/simple;
	bh=s+l4KM30P8iXJNiNjiHvt3YNypK8X/F1GNVHmEoCRBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/QW1BFcTPXmgdh/aDNlwGu+4DS4pHbnQ11rGMLPhztn5Xz+2SRBt+uxim6mpf+M0wy2Z0XM8ksWXtvCQ4YaJiqITcY9YzlGjz/JVYHovA0NQ4H79Vw2RuRz0kwmVoQifmcYdWS852LXBx8/GIC09SDlbcGzZKIFVhSlQnx5K0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFnyVLyh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFnyVLyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F571F000FF;
	Sat, 12 Sep 2026 09:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206852;
	bh=epSkzWBkO0G2QNZxhQMskfOr7/SG8fEL7w0nOkElBGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFnyVLyhZHVZKFrQNHQ2V0/hsROvp3Fi/67GfhxrlXOotn2kGSTSpHMemK07BXv6T
	 RV+b2Kx2Mkdawqdo0aZ4kGOnalZuBSWd2ajY5Y0X17omnae6ML27mzZSu/Wa42SoNe
	 QYJnizUarwmLwB2KaDgMwy7UeawhB5QUGNtaJ2uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Andrew Murray <amurray@thegoodpenguin.co.uk>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0293/1518] printk: Introduce console_flush_one_record
Date: Sat, 12 Sep 2026 08:41:02 +0200
Message-ID: <20260912065630.109972746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Andrew Murray <amurray@thegoodpenguin.co.uk>

[ Upstream commit 741ea7aa95dd9ac77f861e7d0961d8d231ac8448 ]

console_flush_all prints all remaining records to all usable consoles
whilst its caller holds console_lock. This can result in large waiting
times for those waiting for console_lock especially where there is a
large volume of records or where the console is slow (e.g. serial).

Let's extract the parts of this function which print a single record
into a new function named console_flush_one_record. This can later
be used for functions that will release and reacquire console_lock
between records.

This commit should not change existing functionality.

Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Murray <amurray@thegoodpenguin.co.uk>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Link: https://patch.msgid.link/20251020-printk_legacy_thread_console_lock-v3-1-00f1f0ac055a@thegoodpenguin.co.uk
Signed-off-by: Petr Mladek <pmladek@suse.com>
Stable-dep-of: 36630cafbeed ("printk: Fix possible console use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 158 ++++++++++++++++++++++++++---------------
 1 file changed, 99 insertions(+), 59 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index c27fc7fc64eb5..8f3097664622d 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3155,6 +3155,99 @@ static inline void printk_kthreads_check_locked(void) { }
 
 #endif /* CONFIG_PRINTK */
 
+
+/*
+ * Print out one record for each console.
+ *
+ * @do_cond_resched is set by the caller. It can be true only in schedulable
+ * context.
+ *
+ * @next_seq is set to the sequence number after the last available record.
+ * The value is valid only when there is at least one usable console and all
+ * usable consoles were flushed.
+ *
+ * @handover will be set to true if a printk waiter has taken over the
+ * console_lock, in which case the caller is no longer holding the
+ * console_lock. Otherwise it is set to false.
+ *
+ * @any_usable will be set to true if there are any usable consoles.
+ *
+ * Returns true when there was at least one usable console and a record was
+ * flushed. A returned false indicates there were no records to flush for any
+ * of the consoles. It may also indicate that there were no usable consoles,
+ * the context has been lost or there is a panic suitation. Regardless the
+ * reason, the caller should assume it is not useful to immediately try again.
+ *
+ * Requires the console_lock.
+ */
+static bool console_flush_one_record(bool do_cond_resched, u64 *next_seq, bool *handover,
+				     bool *any_usable)
+{
+	struct console_flush_type ft;
+	bool any_progress = false;
+	struct console *con;
+	int cookie;
+
+	printk_get_console_flush_type(&ft);
+
+	cookie = console_srcu_read_lock();
+	for_each_console_srcu(con) {
+		short flags = console_srcu_read_flags(con);
+		u64 printk_seq;
+		bool progress;
+
+		/*
+		 * console_flush_one_record() is only responsible for
+		 * nbcon consoles when the nbcon consoles cannot print via
+		 * their atomic or threaded flushing.
+		 */
+		if ((flags & CON_NBCON) && (ft.nbcon_atomic || ft.nbcon_offload))
+			continue;
+
+		if (!console_is_usable(con, flags, !do_cond_resched))
+			continue;
+		*any_usable = true;
+
+		if (flags & CON_NBCON) {
+			progress = nbcon_legacy_emit_next_record(con, handover, cookie,
+								 !do_cond_resched);
+			printk_seq = nbcon_seq_read(con);
+		} else {
+			progress = console_emit_next_record(con, handover, cookie);
+			printk_seq = con->seq;
+		}
+
+		/*
+		 * If a handover has occurred, the SRCU read lock
+		 * is already released.
+		 */
+		if (*handover)
+			return false;
+
+		/* Track the next of the highest seq flushed. */
+		if (printk_seq > *next_seq)
+			*next_seq = printk_seq;
+
+		if (!progress)
+			continue;
+		any_progress = true;
+
+		/* Allow panic_cpu to take over the consoles safely. */
+		if (panic_on_other_cpu())
+			goto abandon;
+
+		if (do_cond_resched)
+			cond_resched();
+	}
+	console_srcu_read_unlock(cookie);
+
+	return any_progress;
+
+abandon:
+	console_srcu_read_unlock(cookie);
+	return false;
+}
+
 /*
  * Print out all remaining records to all consoles.
  *
@@ -3180,77 +3273,24 @@ static inline void printk_kthreads_check_locked(void) { }
  */
 static bool console_flush_all(bool do_cond_resched, u64 *next_seq, bool *handover)
 {
-	struct console_flush_type ft;
 	bool any_usable = false;
-	struct console *con;
 	bool any_progress;
-	int cookie;
 
 	*next_seq = 0;
 	*handover = false;
 
 	do {
-		any_progress = false;
+		any_progress = console_flush_one_record(do_cond_resched, next_seq, handover,
+							&any_usable);
 
-		printk_get_console_flush_type(&ft);
-
-		cookie = console_srcu_read_lock();
-		for_each_console_srcu(con) {
-			short flags = console_srcu_read_flags(con);
-			u64 printk_seq;
-			bool progress;
+		if (*handover)
+			return false;
 
-			/*
-			 * console_flush_all() is only responsible for nbcon
-			 * consoles when the nbcon consoles cannot print via
-			 * their atomic or threaded flushing.
-			 */
-			if ((flags & CON_NBCON) && (ft.nbcon_atomic || ft.nbcon_offload))
-				continue;
-
-			if (!console_is_usable(con, flags, !do_cond_resched))
-				continue;
-			any_usable = true;
-
-			if (flags & CON_NBCON) {
-				progress = nbcon_legacy_emit_next_record(con, handover, cookie,
-									 !do_cond_resched);
-				printk_seq = nbcon_seq_read(con);
-			} else {
-				progress = console_emit_next_record(con, handover, cookie);
-				printk_seq = con->seq;
-			}
-
-			/*
-			 * If a handover has occurred, the SRCU read lock
-			 * is already released.
-			 */
-			if (*handover)
-				return false;
-
-			/* Track the next of the highest seq flushed. */
-			if (printk_seq > *next_seq)
-				*next_seq = printk_seq;
-
-			if (!progress)
-				continue;
-			any_progress = true;
-
-			/* Allow panic_cpu to take over the consoles safely. */
-			if (panic_on_other_cpu())
-				goto abandon;
-
-			if (do_cond_resched)
-				cond_resched();
-		}
-		console_srcu_read_unlock(cookie);
+		if (panic_on_other_cpu())
+			return false;
 	} while (any_progress);
 
 	return any_usable;
-
-abandon:
-	console_srcu_read_unlock(cookie);
-	return false;
 }
 
 static void __console_flush_and_unlock(void)
-- 
2.53.0



