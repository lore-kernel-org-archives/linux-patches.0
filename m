Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A4C3C1F45;
	Sat, 17 Oct 2026 17:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259650; cv=none; b=duUUw2RVmJTEchwoj94Hxyoy7M7mw6d8kd1TsilQZIdnzNbnU4bwsCBVYpuvLljVaK6EjMM4gn4KG1UbUQl4LERFViKwucX34G+uMXnOhAH6z3wAS1uRN6TBlxGTgT66oGidhyVKeu66+Eg7oSTaNiJLZHUI7nADsJ2EmwGw69Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259650; c=relaxed/simple;
	bh=RT9imLmJqDG8M6r45VRuXSzxnP9rPF1Vm9hGJazPa6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7wa7/TOM/YcPaAKAB0XAqIWXbelgzxWM/DXA51lmtaEOSpHZ4w7qScTqXGCnBM5zOWfg27t40ibyATSemLWmMhXicvcit6qiE/LG1FLwNoT0JROb/vYN63HSWlm8iuPWcT2c5X0Y823DBBdT0r28GcbFLgCFpVZr/YX1TjwzA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ep99tbEc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ep99tbEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD21B1F000C4;
	Sat, 17 Oct 2026 17:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259649;
	bh=HmJ5hXSAhVzo5jwKy40zvTHAyU1dewrvt/QxoMGP7ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ep99tbEcYZjnk7I+axvOjJ53h7/hRu/tpwUiHjnP0XT3k4BMyfLYHZgXPNSZ7tNCd
	 zSUUfdw1Kz3790I9/qoRhBp73xBNn/bk1Li8Nq6rK9C9pXVukyGUbYIiOjUfcN+5no
	 dL3ZRRSyVXP/iNANGVbzvtw6wPOrNuaH2ye9i/3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1277/1674] filelock: split common fields into struct file_lock_core
Date: Sat, 17 Oct 2026 17:59:09 +0200
Message-ID: <20261017160503.919978295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit a69ce85ec9af6bdc0b3511959a7dc1a324e5e16a ]

In a future patch, we're going to split file leases into their own
structure. Since a lot of the underlying machinery uses the same fields
move those into a new file_lock_core, and embed that inside struct
file_lock.

For now, add some macros to ensure that we can continue to build while
the conversion is in progress.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20240131-flsplit-v3-17-c6129007ee8d@kernel.org
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>

[ Instead of the temporary field macros and the tree-wide conversion,
  alias the old field names in an anonymous struct overlaying
  struct file_lock_core, so existing users keep building. Convert the
  lockd client owner lookup to the new field name. ]

Stable-dep-of: 4c7fc129db06 ("lockd: fix NULL dereference on lockowner allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/clntproc.c      |  3 ++-
 include/linux/filelock.h | 46 ++++++++++++++++++++++++++++------------
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index fba6c7fa74747..98894f69680d0 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -485,7 +485,8 @@ static const struct file_lock_operations nlmclnt_lock_ops = {
 static void nlmclnt_locks_init_private(struct file_lock *fl, struct nlm_host *host)
 {
 	fl->fl_u.nfs_fl.state = 0;
-	fl->fl_u.nfs_fl.owner = nlmclnt_find_lockowner(host, fl->fl_owner);
+	fl->fl_u.nfs_fl.owner = nlmclnt_find_lockowner(host,
+						       fl->c.flc_owner);
 	INIT_LIST_HEAD(&fl->fl_u.nfs_fl.list);
 	fl->fl_ops = &nlmclnt_lock_ops;
 }
diff --git a/include/linux/filelock.h b/include/linux/filelock.h
index 95e868e09e298..03fdaae58de42 100644
--- a/include/linux/filelock.h
+++ b/include/linux/filelock.h
@@ -85,23 +85,43 @@ bool opens_in_grace(struct net *);
  *
  * Obviously, the last two criteria only matter for POSIX locks.
  */
-struct file_lock {
-	struct file_lock *fl_blocker;	/* The lock, that is blocking us */
-	struct list_head fl_list;	/* link into file_lock_context */
-	struct hlist_node fl_link;	/* node in global lists */
-	struct list_head fl_blocked_requests;	/* list of requests with
+struct file_lock_core {
+	struct file_lock *flc_blocker;	/* The lock that is blocking us */
+	struct list_head flc_list;	/* link into file_lock_context */
+	struct hlist_node flc_link;	/* node in global lists */
+	struct list_head flc_blocked_requests;	/* list of requests with
 						 * ->fl_blocker pointing here
 						 */
-	struct list_head fl_blocked_member;	/* node in
+	struct list_head flc_blocked_member;	/* node in
 						 * ->fl_blocker->fl_blocked_requests
 						 */
-	fl_owner_t fl_owner;
-	unsigned int fl_flags;
-	unsigned char fl_type;
-	unsigned int fl_pid;
-	int fl_link_cpu;		/* what cpu's list is this on? */
-	wait_queue_head_t fl_wait;
-	struct file *fl_file;
+	fl_owner_t flc_owner;
+	unsigned int flc_flags;
+	unsigned char flc_type;
+	unsigned int flc_pid;
+	int flc_link_cpu;		/* what cpu's list is this on? */
+	wait_queue_head_t flc_wait;
+	struct file *flc_file;
+};
+
+struct file_lock {
+	union {
+		struct file_lock_core c;
+		struct {
+			struct file_lock *fl_blocker;
+			struct list_head fl_list;
+			struct hlist_node fl_link;
+			struct list_head fl_blocked_requests;
+			struct list_head fl_blocked_member;
+			fl_owner_t fl_owner;
+			unsigned int fl_flags;
+			unsigned char fl_type;
+			unsigned int fl_pid;
+			int fl_link_cpu;
+			wait_queue_head_t fl_wait;
+			struct file *fl_file;
+		};
+	};
 	loff_t fl_start;
 	loff_t fl_end;
 
-- 
2.53.0



