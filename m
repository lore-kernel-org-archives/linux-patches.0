Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D6933C18B;
	Sat, 12 Sep 2026 15:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227349; cv=none; b=V7S+ClS1zyfItn7uWtDV6z9oiSZap/r2Is4xh6pxqCrVSgxk5wJFM5Txy+wrwRYBZUXXr7CJ+OkN03gkV2avJkQeBe7LidthqrGy16vJgMTczFGajlSw/sEBf5dZypTg0WdDZlunTus4yfCKnc1UL9u4AkfwNs7A+Ud4Cwu/CME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227349; c=relaxed/simple;
	bh=fUZRsHeyQJoViNCgGQHTveg95xA9TdDU3WvZ3MLtlus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZOCpnXDh5MlTZbCqiArPwwqWHP3NWyenn+CDbaxcjB647owZMw/9IR9eiyUhN5MzocLVpX52H+yfPgViLNSPAKiX69izcZXo1GERbn+WIv1w0W9lhQ2xEvLxbBpKSMbf8ltg1UjmhK5ib029XjAS21husnFGY/kuavjaSqJkLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhwXhKou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhwXhKou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61A91F000FF;
	Sat, 12 Sep 2026 15:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227347;
	bh=L0fWbY6CK47N+zMAZDJUC3ocupja37zQ6Qa0jh6d0k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhwXhKouiGMS9GujiZMS55Fmjiz5MKvhIHXNDhULagSAAyiWrIREX+Fh745Snk5Mx
	 hTX1DetZBIk86XgVRpXlmtLIWXHSyTgI23QgdLaIRKTBHHhQknbY2X8MtWD8l6fto3
	 zH+zqBenUXsn0SIamIBRTKXGIDm0eDANCo6TjfEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 0163/1191] lockd: pin next file across nlm_inspect_file lock-drop
Date: Sat, 12 Sep 2026 08:48:11 +0200
Message-ID: <20260912065551.874553900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


