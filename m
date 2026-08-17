Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4713420484;
	Mon, 17 Aug 2026 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975292; cv=none; b=QRg2uU27nFNm6VcN+7+K0PZ5vfOVnk6mXLNsTMqOMXnJYMRfbg1qo02Mv1QXhFoPDZE3K8syENl4wAtKk67JxGlTUT42YhDML03sdrnmbkVhBTbOeNVf8joSSewlE/Mn7lx+/7fgsD1GhoLb8M4wxRymzfzF8t9pr5DY6+VevQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975292; c=relaxed/simple;
	bh=LwBl+wLsNBbMYvD5WKpewJXce+JonaBDoAq+NtPJm3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaQT7Xp4wF76fHxzVuDOKtIGMqI5yifHNSxVR0RyoljL0LCyIzTSGeae7n9c5qwQ+9hUCwKZFTfqZkFNu4BPn5PWYO06/MILqlgKGthfFWmlW76d6zdDQ7oGXFP3tIXzEPAiwYFUZAs9I6VdD19dvQ6Hzq5MxWdQKU03hyXdSHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnuyRw6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnuyRw6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3511D1F000E9;
	Mon, 17 Aug 2026 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975290;
	bh=et6ZLnZ5PZaB+oMnriCQ/wncwKLB51v0zPCWazfrBnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnuyRw6Fz8BOdsfisqEF5js0bhnAecHspxHBqFAaW52r27etlziJKUmz+8SKPjLAf
	 BtUT2QD25+NenPjsFLKG02ZJGcCKwA5i52SNj/dZnhOKM8ajvg8rSR1zd7c/hWI5k6
	 9RH3O+kWndRLaeooSXxgPgXjadynIcqgwuV9Joxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 227/250] eventfs: Use children field for rcu head and add memory barriers
Date: Mon, 17 Aug 2026 15:33:08 +0200
Message-ID: <20260817132545.791907087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit f0ece16ffca7384787b692431961ce202907acf5 upstream.

When an eventfs inode is freed, it sets ei->is_freed and then uses its
ei->list to add it to the srcu link list as the list field is a union with
the rcu list head. As the ei->list is used to iterate over an SRCU
protected list without taking the eventfs_mutex, there's nothing stopping
the iteration over that list to see the ei->rcu instead of the ei->list
and it will read a corrupt target.

To fix this, change the union of the rcu list head with the children list.
On freeing the eventfs inode, set the is_free and execute a smp_wmb()
before adding the eventfs inode to the SRCU list.

On iteration of the ei->children list, at the start, execute a smp_rmb()
and then read the is_freed of the ei to see if the children list is still
valid. If is_freed is set, then the ei_child read is not valid and the
loop should exit immediately.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260808094215.4252430d@robin
Fixes: 704f960dbee2f ("eventfs: Read ei->entries before ei->children in eventfs_iterate()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260806022719.375354-1-shuangpeng.kernel%40gmail.com
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   24 ++++++++++++++++++++++++
 fs/tracefs/internal.h    |    4 ++--
 2 files changed, 26 insertions(+), 2 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -124,7 +124,17 @@ static inline void put_ei(struct eventfs
 static inline void free_ei(struct eventfs_inode *ei)
 {
 	if (ei) {
+		/* The ei should have no children if it is being freed. */
+		WARN_ON_ONCE(!list_empty(&ei->children));
 		ei->is_freed = 1;
+		/*
+		 * The SRCU iteration has a smp_rmb() to make sure it
+		 * sees a child (that may have already been freed)
+		 * before it reads is_free. If is_free is set, it must
+		 * not use the child it acquired from ei->children, as
+		 * the list may be used for SRCU.
+		 */
+		smp_wmb();
 		put_ei(ei);
 	}
 }
@@ -647,6 +657,20 @@ static int eventfs_iterate(struct file *
 	list_for_each_entry_srcu(ei_child, &ei->children, list,
 				 srcu_read_lock_held(&eventfs_srcu)) {
 
+		/*
+		 * If the ei is being freed, then the ei->children may be
+		 * being used as the rcu list, which means the next element
+		 * may be garbage. The ei->is_free is set before switching
+		 * the ei->children over to ei->rcu. The read memory barrier
+		 * here makes sure the ei_child is read before is_free is
+		 * updated.
+		 *
+		 * Matches the smp_wmb() in free_ei()
+		 */
+		smp_rmb();
+		if (ei->is_freed)
+			return -EINVAL;
+
 		if (c > 0) {
 			c--;
 			continue;
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -46,11 +46,11 @@ struct eventfs_attr {
  * @ino:	The saved inode number
  */
 struct eventfs_inode {
+	struct list_head	list;
 	union {
-		struct list_head	list;
+		struct list_head	children;
 		struct rcu_head		rcu;
 	};
-	struct list_head		children;
 	const struct eventfs_entry	*entries;
 	const char			*name;
 	struct eventfs_attr		*entry_attrs;


