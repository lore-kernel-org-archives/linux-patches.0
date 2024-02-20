Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174B3151CCC;
	Tue, 20 Feb 2024 21:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464226; cv=none; b=l2RjRxxCb1V4Nw6OUeyQZCkLMHumP5XSAr1W7CPLsVu+nuAf5SGmKp0XCWrUOgYvYMNscAtV/y5CkJz4SJ9ybdUGUTjQV+7X6stdeDEVaQ/53scFJgD8n6ZB72mEg1IxPtM1XxM7n/jd+m6pex1mhjSiDX45jH0QOB1XCWWXU88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464226; c=relaxed/simple;
	bh=w5FEBq31rPmf4f/4v/eZgcAIijib+aUnU7Ra8I80AuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xo4+YFmA3oJH2A1rYbtBobZ/fF4uIzURUfexJbPhOLQeg+k7g+eI2njXSy+rAfS1n/SURzWwDNAmQUBPL587KwC+jTJkoF3jxkuGpeG3G6uEyNhVNN43ta3vUSRRwiCcHsBsHp0xRL+ZM2iUoMZZIB29imEGlFwbycpypa+X67M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1s88Y/tL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1s88Y/tL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A1EC43390;
	Tue, 20 Feb 2024 21:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464226;
	bh=w5FEBq31rPmf4f/4v/eZgcAIijib+aUnU7Ra8I80AuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1s88Y/tLh+99Pfmk9ztuU9Xe5wa23A+3enXQhd/707/QNIORbyIMlTxEsWgdl+zB3
	 YYHAyj1YfSQd0gT7ecRvLX1xjr4pd0inlxCuvwbIYjpFQkroyqH9eknClNeeqcWlb8
	 re3yWxIPWZgym0yivIes7dydKmzvG3FeSkxXUGzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ajay Kaher <akaher@vmware.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 273/331] eventfs: Remove "is_freed" union with rcu head
Date: Tue, 20 Feb 2024 21:56:29 +0100
Message-ID: <20240220205646.464262659@linuxfoundation.org>
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

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit f2f496370afcbc5227d7002da28c74b91fed12ff upstream.

The eventfs_inode->is_freed was a union with the rcu_head with the
assumption that when it was on the srcu list the head would contain a
pointer which would make "is_freed" true. But that was a wrong assumption
as the rcu head is a single link list where the last element is NULL.

Instead, split the nr_entries integer so that "is_freed" is one bit and
the nr_entries is the next 31 bits. As there shouldn't be more than 10
(currently there's at most 5 to 7 depending on the config), this should
not be a problem.

Link: https://lkml.kernel.org/r/20231101172649.049758712@goodmis.org

Cc: stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ajay Kaher <akaher@vmware.com>
Fixes: 63940449555e7 ("eventfs: Implement eventfs lookup, read, open functions")
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    2 ++
 fs/tracefs/internal.h    |    6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -824,6 +824,8 @@ static void eventfs_remove_rec(struct ev
 		eventfs_remove_rec(ei_child, head, level + 1);
 	}
 
+	ei->is_freed = 1;
+
 	list_del_rcu(&ei->list);
 	list_add_tail(&ei->del_list, head);
 }
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -23,6 +23,7 @@ struct tracefs_inode {
  * @d_parent:   pointer to the parent's dentry
  * @d_children: The array of dentries to represent the files when created
  * @data:	The private data to pass to the callbacks
+ * @is_freed:	Flag set if the eventfs is on its way to be freed
  * @nr_entries: The number of items in @entries
  */
 struct eventfs_inode {
@@ -38,14 +39,13 @@ struct eventfs_inode {
 	 * Union - used for deletion
 	 * @del_list:	list of eventfs_inode to delete
 	 * @rcu:	eventfs_inode to delete in RCU
-	 * @is_freed:	node is freed if one of the above is set
 	 */
 	union {
 		struct list_head	del_list;
 		struct rcu_head		rcu;
-		unsigned long		is_freed;
 	};
-	int				nr_entries;
+	unsigned int			is_freed:1;
+	unsigned int			nr_entries:31;
 };
 
 static inline struct tracefs_inode *get_tracefs(const struct inode *inode)


