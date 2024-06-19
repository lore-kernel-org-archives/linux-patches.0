Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9CC150984;
	Wed, 19 Jun 2024 13:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802078; cv=none; b=dKccbkry1g18kn8kWgiZf6f3BvtFBwzw/T/BYsKVhS6mK//FbBNmVINwTieroyAgcimsQfZPrrJ5yV+vkMD5GGpMK3rSJMpD4ne5BwvjUX2Ji5jWqpnWsHH9JyXuBhmfN4rLNU1uUncpRZnxDj+lhxRbsVUB3id1xO6KKCZqq7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802078; c=relaxed/simple;
	bh=yy/fN/SdemkzHsdQadSW1LyoqhQrvKlsXBB1GtKpkgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2YG8OcvFCBqHJxdvm7Hh3xHZKrJgoyH3esohidWVOa6KH5N48DoaqDi8CwtAsjcgEv+rw8h/kwviHVQByjqHilrGEhGfexAbdZLVIAHCF6PvFY9OX7ASmNoRfDU6ROPkfp6L47lwwvlhiveZjQ8/PWfQPOXWf8ySgnSN95dt5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxbRyRHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxbRyRHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C61C4AF1A;
	Wed, 19 Jun 2024 13:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802078;
	bh=yy/fN/SdemkzHsdQadSW1LyoqhQrvKlsXBB1GtKpkgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxbRyRHfwUlaE4K8FJC5z30YQ/IoBqnq9EeqJV3WHav+MdFRjpSGfCMKMDHu8s1PH
	 Y29eL4fQRiG5fbMbwzT178sYeY+tmPBDznFIjT0VkcLz3ULWjdYCByB1Okfaragxue
	 P8YN6vibgGUjGyX3YfiiJRA5zaQXiEA7xVhL/Tf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/267] eventfs: Update all the eventfs_inodes from the events descriptor
Date: Wed, 19 Jun 2024 14:53:45 +0200
Message-ID: <20240619125609.196149538@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 340f0c7067a95281ad13734f8225f49c6cf52067 ]

The change to update the permissions of the eventfs_inode had the
misconception that using the tracefs_inode would find all the
eventfs_inodes that have been updated and reset them on remount.
The problem with this approach is that the eventfs_inodes are freed when
they are no longer used (basically the reason the eventfs system exists).
When they are freed, the updated eventfs_inodes are not reset on a remount
because their tracefs_inodes have been freed.

Instead, since the events directory eventfs_inode always has a
tracefs_inode pointing to it (it is not freed when finished), and the
events directory has a link to all its children, have the
eventfs_remount() function only operate on the events eventfs_inode and
have it descend into its children updating their uid and gids.

Link: https://lore.kernel.org/all/CAK7LNARXgaWw3kH9JgrnH4vK6fr8LDkNKf3wq8NhMWJrVwJyVQ@mail.gmail.com/
Link: https://lore.kernel.org/linux-trace-kernel/20240523051539.754424703@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: baa23a8d4360d ("tracefs: Reset permissions on remount if permissions are options")
Reported-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/event_inode.c | 51 ++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index b521e904a7ce9..b406bb3430f3d 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -305,33 +305,60 @@ static const struct file_operations eventfs_file_operations = {
 	.llseek		= generic_file_llseek,
 };
 
-/*
- * On a remount of tracefs, if UID or GID options are set, then
- * the mount point inode permissions should be used.
- * Reset the saved permission flags appropriately.
- */
-void eventfs_remount(struct tracefs_inode *ti, bool update_uid, bool update_gid)
+static void eventfs_set_attrs(struct eventfs_inode *ei, bool update_uid, kuid_t uid,
+			      bool update_gid, kgid_t gid, int level)
 {
-	struct eventfs_inode *ei = ti->private;
+	struct eventfs_inode *ei_child;
 
-	if (!ei)
+	/* Update events/<system>/<event> */
+	if (WARN_ON_ONCE(level > 3))
 		return;
 
-	if (update_uid)
+	if (update_uid) {
 		ei->attr.mode &= ~EVENTFS_SAVE_UID;
+		ei->attr.uid = uid;
+	}
 
-	if (update_gid)
+	if (update_gid) {
 		ei->attr.mode &= ~EVENTFS_SAVE_GID;
+		ei->attr.gid = gid;
+	}
+
+	list_for_each_entry(ei_child, &ei->children, list) {
+		eventfs_set_attrs(ei_child, update_uid, uid, update_gid, gid, level + 1);
+	}
 
 	if (!ei->entry_attrs)
 		return;
 
 	for (int i = 0; i < ei->nr_entries; i++) {
-		if (update_uid)
+		if (update_uid) {
 			ei->entry_attrs[i].mode &= ~EVENTFS_SAVE_UID;
-		if (update_gid)
+			ei->entry_attrs[i].uid = uid;
+		}
+		if (update_gid) {
 			ei->entry_attrs[i].mode &= ~EVENTFS_SAVE_GID;
+			ei->entry_attrs[i].gid = gid;
+		}
 	}
+
+}
+
+/*
+ * On a remount of tracefs, if UID or GID options are set, then
+ * the mount point inode permissions should be used.
+ * Reset the saved permission flags appropriately.
+ */
+void eventfs_remount(struct tracefs_inode *ti, bool update_uid, bool update_gid)
+{
+	struct eventfs_inode *ei = ti->private;
+
+	/* Only the events directory does the updates */
+	if (!ei || !ei->is_events || ei->is_freed)
+		return;
+
+	eventfs_set_attrs(ei, update_uid, ti->vfs_inode.i_uid,
+			  update_gid, ti->vfs_inode.i_gid, 0);
 }
 
 /* Return the evenfs_inode of the "events" directory */
-- 
2.43.0



