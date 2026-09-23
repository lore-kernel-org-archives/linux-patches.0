Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AAE488233;
	Wed, 23 Sep 2026 14:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173067; cv=none; b=QY83mvqc2HBM/kRbNfCIiQDCFpfk41kLoy39DpMdIO6uSjQGCQPrrft5A0OKzjS/rs5qqZrRHKAr6QHB3vodFL6giD2+8Zc5tAwkuzOZk7Q9CLPka83e50pqOA6rqDvLsyNkOblHK4cn5cz5tOng4FWt7JOAeSRRFI1jXGfmfbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173067; c=relaxed/simple;
	bh=MZBzn/wmsm/pr82i+oX+3oXFhPXy7fnRPf/GAQScCR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMBG4EsKf3nzHjJqo8K/4dP6dn+UwEtmzC4ax58kMXW0tPTCIrkmAgZ9gp0IeC31NPm0mjIq718q1egWOICVIsHQagr55A2kri57McwaGhfmQwXPEDvFflC12LJIxAMWYiCgwllQTMZgjPoam2ON4/4pqIFfN8tunkHKXG+pUqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrUP8y95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrUP8y95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6A21F000FF;
	Wed, 23 Sep 2026 14:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173065;
	bh=Lid1G3slo33CNWgNLIS9xbpgbuTJOuzM5hHkp7Igejw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TrUP8y95C2a2S9ntt+igVoDqsUVHPwDGw2zpmsTlXl21ueU12uyPBLCP74VIVtsjb
	 AWylh+M3+HZT2Om81wzbPWQcOuNtmBalUzRdUgmfmPPPDpczugzOjeNPSWn0T1MLGu
	 eh3aFD+AGYUVfo1FYdu5c6lGAy8iUWrSvQ6E0lSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 140/438] ksmbd: fix malformed procfs status output
Date: Wed, 23 Sep 2026 16:02:41 +0200
Message-ID: <20260923140648.403730763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1f7dd03a88a8405143aab195f6fa9ed2243494b1 ]

The ksmbd procfs monitoring files produce misleading or malformed output.
The constant-name helper uses a bitwise test for enum values. This omits
zero-valued constants and can print multiple names for one lease state. It
also unconditionally emits a newline, splitting entries in the open-file
table across two lines. Session capabilities are printed as numeric flag
values even though a table of descriptive names is available.

Use exact matching for enum values. Print flag names as a comma-separated
list, preserving unknown bits as hexadecimal values. Let callers control
line termination so each open-file entry remains on one line. Print common
session properties once, and report signing and encryption independently.

Adjust client and open-file column widths for IPv6 addresses and 64-bit
file IDs, and fix the misspelled OPLOCK_EXCLUSIVE name. Also expose and
maintain the total request count alongside the per-command counters.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: d7fd1f98607f ("ksmbd: follow SMB2 session expiration semantics")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c        | 12 ++---
 fs/smb/server/mgmt/user_session.c | 75 +++++++++++++------------------
 fs/smb/server/misc.h              |  7 +--
 fs/smb/server/proc.c              | 38 ++++++++++++++++
 fs/smb/server/stats.h             |  4 +-
 fs/smb/server/vfs_cache.c         | 16 ++++---
 6 files changed, 89 insertions(+), 63 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 39ac777fd4527..cef279b8fd27e 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -35,9 +35,9 @@ static int proc_show_clients(struct seq_file *m, void *v)
 	struct timespec64 now, t;
 	int i;
 
-	seq_printf(m, "#%-20s %-10s %-10s %-10s %-10s %-10s\n",
-			"<name>", "<dialect>", "<credits>", "<open files>",
-			"<requests>", "<last active>");
+	seq_printf(m, "#%-40s %-10s %-10s %-12s %-10s %s\n",
+		   "<client>", "<dialect>", "<credits>", "<open files>",
+		   "<requests>", "<last active>");
 
 	down_read(&conn_list_lock);
 	hash_for_each(conn_list, i, conn, hlist) {
@@ -46,11 +46,11 @@ static int proc_show_clients(struct seq_file *m, void *v)
 		t = timespec64_sub(now, t);
 #if IS_ENABLED(CONFIG_IPV6)
 		if (!conn->inet_addr)
-			seq_printf(m, "%-20pI6c", &conn->inet6_addr);
+			seq_printf(m, " %-40pI6c", &conn->inet6_addr);
 		else
 #endif
-			seq_printf(m, "%-20pI4", &conn->inet_addr);
-		seq_printf(m, "   0x%-10x %-10u %-12d %-10d %ptT\n",
+			seq_printf(m, " %-40pI4", &conn->inet_addr);
+		seq_printf(m, " 0x%-8x %-10u %-12d %-10d %ptT\n",
 			   conn->dialect,
 			   conn->total_credits,
 			   atomic_read(&conn->stats.open_files_count),
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 10b31df185a60..37ebfc914b6d4 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -90,9 +90,15 @@ static int show_proc_session(struct seq_file *m, void *v)
 	sess = (struct ksmbd_session *)m->private;
 	ksmbd_user_session_get(sess);
 
+	seq_printf(m, "%-20s\t%s\n", "user", session_user_name(sess));
+	seq_printf(m, "%-20s\t%llu\n", "id", sess->id);
+	seq_printf(m, "%-20s\t%s\n", "state", session_state_string(sess));
+
 	i = 0;
 	down_read(&sess->chann_lock);
 	xa_for_each(&sess->ksmbd_chann_list, id, chan) {
+		const char *name;
+
 #if IS_ENABLED(CONFIG_IPV6)
 		if (chan->conn->inet_addr)
 			seq_printf(m, "%-20s\t%pI4\n", "client",
@@ -104,29 +110,37 @@ static int show_proc_session(struct seq_file *m, void *v)
 		seq_printf(m, "%-20s\t%pI4\n", "client",
 				&chan->conn->inet_addr);
 #endif
-		seq_printf(m, "%-20s\t%s\n", "user", session_user_name(sess));
-		seq_printf(m, "%-20s\t%llu\n", "id", sess->id);
-		seq_printf(m, "%-20s\t%s\n", "state",
-				session_state_string(sess));
-
 		seq_printf(m, "%-20s\t", "capabilities");
 		ksmbd_proc_show_flag_names(m,
 				ksmbd_sess_cap_const_names,
 				ARRAY_SIZE(ksmbd_sess_cap_const_names),
 				chan->conn->vals->req_capabilities);
+		seq_putc(m, '\n');
 
 		if (sess->sign) {
-			seq_printf(m, "%-20s\t", "signing");
-			ksmbd_proc_show_const_name(m, "%s\t",
-					ksmbd_signing_const_names,
-					ARRAY_SIZE(ksmbd_signing_const_names),
-					le16_to_cpu(chan->conn->signing_algorithm));
-		} else if (sess->enc) {
-			seq_printf(m, "%-20s\t", "encryption");
-			ksmbd_proc_show_const_name(m, "%s\t",
-					ksmbd_cipher_const_names,
-					ARRAY_SIZE(ksmbd_cipher_const_names),
-					le16_to_cpu(chan->conn->cipher_type));
+			unsigned int algorithm =
+				le16_to_cpu(chan->conn->signing_algorithm);
+
+			name = ksmbd_proc_const_name(ksmbd_signing_const_names,
+						     ARRAY_SIZE(ksmbd_signing_const_names),
+						     algorithm);
+			if (name)
+				seq_printf(m, "%-20s\t%s\n", "signing", name);
+			else
+				seq_printf(m, "%-20s\t0x%04x\n", "signing",
+					   algorithm);
+		}
+		if (sess->enc) {
+			unsigned int cipher = le16_to_cpu(chan->conn->cipher_type);
+
+			name = ksmbd_proc_const_name(ksmbd_cipher_const_names,
+						     ARRAY_SIZE(ksmbd_cipher_const_names),
+						     cipher);
+			if (name)
+				seq_printf(m, "%-20s\t%s\n", "encryption", name);
+			else
+				seq_printf(m, "%-20s\t0x%04x\n", "encryption",
+					   cipher);
 		}
 		i++;
 	}
@@ -152,35 +166,6 @@ static int show_proc_session(struct seq_file *m, void *v)
 	return 0;
 }
 
-void ksmbd_proc_show_flag_names(struct seq_file *m,
-				const struct ksmbd_const_name *table,
-				int count,
-				unsigned int flags)
-{
-	int i;
-
-	for (i = 0; i < count; i++) {
-		if (table[i].const_value & flags)
-			seq_printf(m, "0x%08x\t", table[i].const_value);
-	}
-	seq_putc(m, '\n');
-}
-
-void ksmbd_proc_show_const_name(struct seq_file *m,
-				const char *format,
-				const struct ksmbd_const_name *table,
-				int count,
-				unsigned int const_value)
-{
-	int i;
-
-	for (i = 0; i < count; i++) {
-		if (table[i].const_value & const_value)
-			seq_printf(m, format, table[i].name);
-	}
-	seq_putc(m, '\n');
-}
-
 static int create_proc_session(struct ksmbd_session *sess)
 {
 	char name[30];
diff --git a/fs/smb/server/misc.h b/fs/smb/server/misc.h
index c7b063f571a7a..1faaddd0f5f75 100644
--- a/fs/smb/server/misc.h
+++ b/fs/smb/server/misc.h
@@ -53,11 +53,8 @@ void ksmbd_proc_show_flag_names(struct seq_file *m,
 				const struct ksmbd_const_name *table,
 				int count,
 				unsigned int flags);
-void ksmbd_proc_show_const_name(struct seq_file *m,
-				const char *format,
-				const struct ksmbd_const_name *table,
-				int count,
-				unsigned int const_value);
+const char *ksmbd_proc_const_name(const struct ksmbd_const_name *table,
+				  int count, unsigned int const_value);
 #else
 static inline int ksmbd_proc_init(void) { return 0; }
 static inline void ksmbd_proc_cleanup(void) {}
diff --git a/fs/smb/server/proc.c b/fs/smb/server/proc.c
index 5c9f3f314dbe1..13742a2404a58 100644
--- a/fs/smb/server/proc.c
+++ b/fs/smb/server/proc.c
@@ -27,6 +27,42 @@ struct proc_dir_entry *ksmbd_proc_create(const char *name,
 			   show, v);
 }
 
+void ksmbd_proc_show_flag_names(struct seq_file *m,
+				const struct ksmbd_const_name *table,
+				int count, unsigned int flags)
+{
+	unsigned int remaining = flags;
+	bool separator = false;
+	int i;
+
+	for (i = 0; i < count; i++) {
+		unsigned int flag = table[i].const_value;
+
+		if (!flag || (remaining & flag) != flag)
+			continue;
+		seq_printf(m, "%s%s", separator ? "," : "", table[i].name);
+		separator = true;
+		remaining &= ~flag;
+	}
+
+	if (remaining)
+		seq_printf(m, "%s0x%08x", separator ? "," : "", remaining);
+	else if (!separator)
+		seq_puts(m, "none");
+}
+
+const char *ksmbd_proc_const_name(const struct ksmbd_const_name *table,
+				  int count, unsigned int const_value)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		if (table[i].const_value == const_value)
+			return table[i].name;
+	}
+	return NULL;
+}
+
 struct ksmbd_const_smb2_process_req {
 	unsigned int const_value;
 	const char *name;
@@ -71,6 +107,8 @@ static int proc_show_ksmbd_stats(struct seq_file *m, void *v)
 		   ksmbd_counter_sum(KSMBD_COUNTER_SESSIONS));
 	seq_printf(m, "tree connects: %lld\n",
 		   ksmbd_counter_sum(KSMBD_COUNTER_TREE_CONNS));
+	seq_printf(m, "requests: %lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_REQUESTS));
 	seq_printf(m, "read bytes: %lld\n",
 		   ksmbd_counter_sum(KSMBD_COUNTER_READ_BYTES));
 	seq_printf(m, "written bytes: %lld\n",
diff --git a/fs/smb/server/stats.h b/fs/smb/server/stats.h
index b60c30c690770..08ee66f91eaab 100644
--- a/fs/smb/server/stats.h
+++ b/fs/smb/server/stats.h
@@ -52,8 +52,10 @@ static inline void ksmbd_counter_sub(int type, s64 value)
 
 static inline void ksmbd_counter_inc_reqs(unsigned int cmd)
 {
-	if (cmd < KSMBD_COUNTER_MAX_REQS)
+	if (cmd < KSMBD_COUNTER_MAX_REQS) {
+		percpu_counter_inc(&ksmbd_counters.counters[KSMBD_COUNTER_REQUESTS]);
 		percpu_counter_inc(&ksmbd_counters.counters[KSMBD_COUNTER_FIRST_REQ + cmd]);
+	}
 }
 
 static inline s64 ksmbd_counter_sum(int type)
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index a23bd9b1a68bc..1b5f4efb6ae01 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -66,7 +66,7 @@ static const struct ksmbd_const_name ksmbd_lease_const_names[] = {
 static const struct ksmbd_const_name ksmbd_oplock_const_names[] = {
 	{SMB2_OPLOCK_LEVEL_NONE, "OPLOCK_NONE"},
 	{SMB2_OPLOCK_LEVEL_II, "OPLOCK_II"},
-	{SMB2_OPLOCK_LEVEL_EXCLUSIVE, "OPLOCK_EXECL"},
+	{SMB2_OPLOCK_LEVEL_EXCLUSIVE, "OPLOCK_EXCLUSIVE"},
 	{SMB2_OPLOCK_LEVEL_BATCH, "OPLOCK_BATCH"},
 };
 
@@ -76,14 +76,14 @@ static int proc_show_files(struct seq_file *m, void *v)
 	unsigned int id;
 	struct oplock_info *opinfo;
 
-	seq_printf(m, "#%-10s %-10s %-10s %-10s %-15s %-10s %-10s %s\n",
+	seq_printf(m, "#%-10s %-18s %-18s %-10s %-16s %-10s %-10s %s\n",
 		   "<tree id>", "<pid>", "<vid>", "<refcnt>",
 		   "<oplock>", "<daccess>", "<saccess>",
 		   "<name>");
 
 	read_lock(&global_ft.lock);
 	idr_for_each_entry(global_ft.idr, fp, id) {
-		seq_printf(m, "%#-10x %#-10llx %#-10llx %#-10x",
+		seq_printf(m, " %#-10x %#-18llx %#-18llx %#-10x",
 			   fp->tcon ? fp->tcon->id : 0,
 			   fp->persistent_id,
 			   fp->volatile_id,
@@ -93,6 +93,7 @@ static int proc_show_files(struct seq_file *m, void *v)
 		opinfo = rcu_dereference(fp->f_opinfo);
 		if (opinfo) {
 			const struct ksmbd_const_name *const_names;
+			const char *name;
 			int count;
 			unsigned int level;
 
@@ -106,11 +107,14 @@ static int proc_show_files(struct seq_file *m, void *v)
 				level = opinfo->level;
 			}
 			rcu_read_unlock();
-			ksmbd_proc_show_const_name(m, " %-15s",
-						   const_names, count, level);
+			name = ksmbd_proc_const_name(const_names, count, level);
+			if (name)
+				seq_printf(m, " %-16s", name);
+			else
+				seq_printf(m, " 0x%-14x", level);
 		} else {
 			rcu_read_unlock();
-			seq_printf(m, " %-15s", " ");
+			seq_printf(m, " %-16s", " ");
 		}
 
 		seq_printf(m, " %#010x %#010x %s\n",
-- 
2.53.0



