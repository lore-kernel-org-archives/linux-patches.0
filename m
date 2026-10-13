Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E38E4FDE40;
	Tue, 13 Oct 2026 12:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893781; cv=none; b=b0WAI1rPPoHnmMd1FNDauEpeyfqCJDMGjUzMkzA6wblQdRYVkysYN8AJRmFWRG9OhxFJXMZRHLOGB3grqjBixZswSvOdH7ywuYCwZfRC/NP+aOU3IN9ccXscx48HfaEBJxI3lcZPIIpHPaZJzgXQJJcSDHOS3fsUA+8L+8NWV8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893781; c=relaxed/simple;
	bh=bjFPzxsqJNNt3MzuUIRZ10BbUzqMq6b2elm7SS6Z218=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSat97r+kdV8sMcMziLNDmtZ7ia7HNAwyxm7WYLO8TUXUyLUrGhiTi9pVFzCAbmq5xsHwMh+AmESEb9rWSxGcN6fzmUFUKsRdyjs5XGA2QSDRlnz+lDksMHtLQYkU4TUOsImS8Ir0ZnTMqAgqCWbHp6WfTiADossDzALnWCll/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HcId0FjI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HcId0FjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804F21F000FF;
	Tue, 13 Oct 2026 12:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893780;
	bh=iBeDkwCIf8YGfp42fgVyjU47pGH0TVOa3k5D6xALxPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcId0FjILTuXZ6YP+3FPMXbXdzo3v2S4hrYTDHAuRYw9ajx0dLj0rD3RH8G8ach7/
	 EY6CWCqoz9CwKFKMvc/GCuEi1BRA0OYJTWsRoUY/NUkBQaMRZ7NyTlsbbyKkE5yHSW
	 wk1ss9qhMxRcvLU0RLHR1G57aqwn0rlDItkHFmYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 338/621] eventfs: Use children field for rcu head and add memory barriers
Date: Tue, 13 Oct 2026 13:35:33 +0200
Message-ID: <20261013112928.874900451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

[ Upstream commit f0ece16ffca7384787b692431961ce202907acf5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/event_inode.c | 24 ++++++++++++++++++++++++
 fs/tracefs/internal.h    |  4 ++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index a7b082a665bd1..abb0ea57601b6 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -124,7 +124,17 @@ static inline void put_ei(struct eventfs_inode *ei)
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
@@ -649,6 +659,20 @@ static int eventfs_iterate(struct file *file, struct dir_context *ctx)
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
diff --git a/fs/tracefs/internal.h b/fs/tracefs/internal.h
index a4a7f8431affb..c61481d04c8ee 100644
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
-- 
2.53.0



