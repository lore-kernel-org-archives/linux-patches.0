Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C2C2F617C;
	Sat, 12 Sep 2026 19:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241390; cv=none; b=qGGmuYbf8nqiiGHc3QGr7A21XgnURpsdFygqpsaqPUYgQFL9guc6iAKwZrap49CbELWW5UjDvqu57ZnmrPS9SJceMXBUqldHjsdtoDwDElz7EplgUC3NnrQ0kuLL4Kng2VpIvj6dcQYbWh4QjH5JnIXWQnwCiR9rrlFvBB9aTho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241390; c=relaxed/simple;
	bh=4yR1PE9zr3iADmpnLgE05bgscNrklWjJOHF8N6oujJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiiRDxrEDirRvvAp5ZXlw/M70p5jxA+XuBTlAzjW/z660JAIgKMVtAGOSOCdpfo7tfZUvsbxSzdxOmsHEempgbjoD3vbrKUkdM1F4vL5dKUHsaAjt0YHAK7fUotiaMEJqGT3fymgoYZxioUy0GDDGXlKtJoiHoF0A6t5W19agxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZU7hcxft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZU7hcxft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BEE1F000FF;
	Sat, 12 Sep 2026 19:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241389;
	bh=AEncP21lcup2nq7IygJ49G322Hgu/0vDq3ZH4TqctOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZU7hcxftTeBdl1VEZosLip8eSN7j0mdQ4nBsimzJSJLZF2sQWlAUMmgLTpkFph4cA
	 VSNnqYW/Aq+eSI7VO2fQvzOZDRP9DqNmuEIOWnh++H/d44WfeVqnpI9VvgMdh7TJ+G
	 CIM3C41NZ4eqReS0w97/CWdAmf3/XA6+JJs1TNcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 126/798] lockd: pin next file across nlm_inspect_file lock-drop
Date: Sat, 12 Sep 2026 08:55:54 +0200
Message-ID: <20260912065519.862333454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 526c49cff3f72c3ec74752016380c7567040581b upstream.

nlm_traverse_files() pins the current file with f_count++ across
a mutex_unlock for nlm_inspect_file(), but nothing pins the saved
next pointer.  A concurrent nlm_release_file() can kfree the next
file during the unlock window, and the iterator dereferences freed
memory on the next loop step.

Pin both current and next before the lock-drop.  Advance by
swapping the pinned cursors at the end of each iteration so next
is always held alive across the unlock.

Always call nlm_file_release() after dropping the iteration pin,
regardless of whether the file matched the predicate.  Use
nlm_file_inuse(), which does a live walk of the inode lock list,
rather than the cached f_locks field, so skipped files that never
ran nlm_inspect_file() are evaluated correctly.

Because every file in a hash bucket is now pinned and released,
files skipped by the is_failover_file predicate that have no
locks, blocks, shares, or external references are deleted during
traversal.  The old code never evaluated skipped files for
cleanup.  The new behavior is intentional: such files are stale
and should not persist in the table.

Fixes: 01df9c5e918a ("LOCKD: Fix a deadlock in nlm_traverse_files()")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260524115527.1734251-1-michael.bommarito@gmail.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svcsubs.c |   53 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -286,12 +286,10 @@ nlm_file_inuse(struct nlm_file *file)
 	return 0;
 }
 
-static void nlm_close_files(struct nlm_file *file)
+static void nlm_file_release(struct nlm_file *file)
 {
-	if (file->f_file[O_RDONLY])
-		nlmsvc_ops->fclose(file->f_file[O_RDONLY]);
-	if (file->f_file[O_WRONLY])
-		nlmsvc_ops->fclose(file->f_file[O_WRONLY]);
+	if (!nlm_file_inuse(file))
+		nlm_delete_file(file);
 }
 
 /*
@@ -301,32 +299,41 @@ static int
 nlm_traverse_files(void *data, nlm_host_match_fn_t match,
 		int (*is_failover_file)(void *data, struct nlm_file *file))
 {
-	struct hlist_node *next;
-	struct nlm_file	*file;
+	struct nlm_file *file, *next;
 	int i, ret = 0;
 
 	mutex_lock(&nlm_file_mutex);
 	for (i = 0; i < FILE_NRHASH; i++) {
-		hlist_for_each_entry_safe(file, next, &nlm_files[i], f_list) {
-			if (is_failover_file && !is_failover_file(data, file))
-				continue;
+		file = hlist_entry_safe(nlm_files[i].first,
+					struct nlm_file, f_list);
+		if (file)
 			file->f_count++;
-			mutex_unlock(&nlm_file_mutex);
+		while (file) {
+			/*
+			 * Pin the next neighbour before we drop the mutex
+			 * for nlm_inspect_file(); a concurrent
+			 * nlm_release_file() under the same mutex would
+			 * otherwise be free to unlink and kfree it during
+			 * the unlock window, leaving us to dereference a
+			 * freed slab when we walked to next afterwards.
+			 */
+			next = hlist_entry_safe(file->f_list.next,
+						struct nlm_file, f_list);
+			if (next)
+				next->f_count++;
 
-			/* Traverse locks, blocks and shares of this file
-			 * and update file->f_locks count */
-			if (nlm_inspect_file(data, file, match))
-				ret = 1;
+			if (!is_failover_file || is_failover_file(data, file)) {
+				mutex_unlock(&nlm_file_mutex);
 
-			mutex_lock(&nlm_file_mutex);
-			file->f_count--;
-			/* No more references to this file. Let go of it. */
-			if (list_empty(&file->f_blocks) && !file->f_locks
-			 && !file->f_shares && !file->f_count) {
-				hlist_del(&file->f_list);
-				nlm_close_files(file);
-				kfree(file);
+				if (nlm_inspect_file(data, file, match))
+					ret = 1;
+
+				mutex_lock(&nlm_file_mutex);
 			}
+
+			file->f_count--;
+			nlm_file_release(file);
+			file = next;
 		}
 	}
 	mutex_unlock(&nlm_file_mutex);


