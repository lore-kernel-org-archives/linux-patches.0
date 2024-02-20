Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE0E14A4D2;
	Tue, 20 Feb 2024 21:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464372; cv=none; b=AzLfIvPp66Ys7Bkd6+kLYMv/E0z4p0J/RPPjw7s/hRXD6pmPufLb9Rd4rJeUZhDcseuuc2TBFM70UJI2gxDVIj+CHX5/nlxqaLwKGse/JCUVV2dSd4Ni+GADMW8rvNmczFWQbXNQd8DS9C/r+LUQRLZovtQTSh7ZVfUnb/gecWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464372; c=relaxed/simple;
	bh=gxyjZVeYgtpAB0XwhAHMsno/zJMA1F2D4iAGd8q/j7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPQQqL8CLtrVH/6GQhDR5GXxY9fD68rUKE97IllJP56Yjj0vfq5uDMDbKom/LmX5q715VPiRrr+ZWeDPOpgFYHAPZi7ytVM3C048/MN9g/1icSA4BkLxZMWcvJ87tSkbncf+LNU3YG62rSkp9ifAX64fzGHB5I6IphhM4WVv+ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1fCde9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1fCde9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5355FC433F1;
	Tue, 20 Feb 2024 21:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464372;
	bh=gxyjZVeYgtpAB0XwhAHMsno/zJMA1F2D4iAGd8q/j7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1fCde9tUM/o87pzj3PakoW2f9PuaYsg9YdZ37mWljZfh1p9XWC2tU7wMYxpfsfnl
	 lmZkglpwH/+iDsELc7MSw+V49Q3Hz7Xi7K6LBetxI675OucCTR4rXWRn168gGxUgYB
	 5WZ/XvTURJx0GcWPftQ1a4Usz0nsxapSLPQYpFzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 309/331] eventfs: Clean up dentry ops and add revalidate function
Date: Tue, 20 Feb 2024 21:57:05 +0100
Message-ID: <20240220205647.891842256@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 8dce06e98c70a7fcbb4bca7d90faf40522e65c58 upstream.

In order for the dentries to stay up-to-date with the eventfs changes,
just add a 'd_revalidate' function that checks the 'is_freed' bit.

Also, clean up the dentry release to actually use d_release() rather
than the slightly odd d_iput() function.  We don't care about the inode,
all we want to do is to get rid of the refcount to the eventfs data
added by dentry->d_fsdata.

It would probably be cleaner to make eventfs its own filesystem, or at
least set its own dentry ops when looking up eventfs files.  But as it
is, only eventfs dentries use d_fsdata, so we don't really need to split
these things up by use.

Another thing that might be worth doing is to make all eventfs lookups
mark their dentries as not worth caching.  We could do that with
d_delete(), but the DCACHE_DONTCACHE flag would likely be even better.

As it is, the dentries are all freeable, but they only tend to get freed
at memory pressure rather than more proactively.  But that's a separate
issue.

Link: https://lore.kernel.org/linux-trace-kernel/202401291043.e62e89dc-oliver.sang@intel.com/
Link: https://lore.kernel.org/linux-trace-kernel/20240131185513.124644253@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: c1504e510238 ("eventfs: Implement eventfs dir creation functions")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    5 ++---
 fs/tracefs/inode.c       |   27 ++++++++++++++++++---------
 fs/tracefs/internal.h    |    3 ++-
 3 files changed, 22 insertions(+), 13 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -378,13 +378,12 @@ static void free_ei(struct eventfs_inode
 }
 
 /**
- * eventfs_set_ei_status_free - remove the dentry reference from an eventfs_inode
- * @ti: the tracefs_inode of the dentry
+ * eventfs_d_release - dentry is going away
  * @dentry: dentry which has the reference to remove.
  *
  * Remove the association between a dentry from an eventfs_inode.
  */
-void eventfs_set_ei_status_free(struct tracefs_inode *ti, struct dentry *dentry)
+void eventfs_d_release(struct dentry *dentry)
 {
 	struct eventfs_inode *ei;
 	int i;
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -377,21 +377,30 @@ static const struct super_operations tra
 	.show_options	= tracefs_show_options,
 };
 
-static void tracefs_dentry_iput(struct dentry *dentry, struct inode *inode)
+/*
+ * It would be cleaner if eventfs had its own dentry ops.
+ *
+ * Note that d_revalidate is called potentially under RCU,
+ * so it can't take the eventfs mutex etc. It's fine - if
+ * we open a file just as it's marked dead, things will
+ * still work just fine, and just see the old stale case.
+ */
+static void tracefs_d_release(struct dentry *dentry)
 {
-	struct tracefs_inode *ti;
+	if (dentry->d_fsdata)
+		eventfs_d_release(dentry);
+}
 
-	if (!dentry || !inode)
-		return;
+static int tracefs_d_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	struct eventfs_inode *ei = dentry->d_fsdata;
 
-	ti = get_tracefs(inode);
-	if (ti && ti->flags & TRACEFS_EVENT_INODE)
-		eventfs_set_ei_status_free(ti, dentry);
-	iput(inode);
+	return !(ei && ei->is_freed);
 }
 
 static const struct dentry_operations tracefs_dentry_operations = {
-	.d_iput = tracefs_dentry_iput,
+	.d_revalidate = tracefs_d_revalidate,
+	.d_release = tracefs_d_release,
 };
 
 static int trace_fill_super(struct super_block *sb, void *data, int silent)
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -78,6 +78,7 @@ struct dentry *tracefs_start_creating(co
 struct dentry *tracefs_end_creating(struct dentry *dentry);
 struct dentry *tracefs_failed_creating(struct dentry *dentry);
 struct inode *tracefs_get_inode(struct super_block *sb);
-void eventfs_set_ei_status_free(struct tracefs_inode *ti, struct dentry *dentry);
+
+void eventfs_d_release(struct dentry *dentry);
 
 #endif /* _TRACEFS_INTERNAL_H */


