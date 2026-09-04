Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67083F23DB;
	Fri,  4 Sep 2026 05:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499051; cv=none; b=JWeiNaaTsT5Omzi73lIADpo6v5Jz2VhBHrgFMqHFbLocEhVmO9/sD0BNLvQVomOcLIRwobx806cW8S3OWUWaO1jzNSYsNleGfeHXtMYj3CdoDttm5Wq8/rGAAxd6QjF3hxkp8blsOfsrN3CJ0NZI/5xM3vjbFIcU9mTY0FXEITk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499051; c=relaxed/simple;
	bh=P0qcXxBECM7rKsW9OrBpBixVjOyaabkJoAD200THtDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJliDgmuROmorJhS0gb8ALzYJi/AXbK9vE/3Tdh8LEtQogUahowzGspGdGi9VeW+ie+FVRDK+wQSNxXn234o8H0g3MG4RPLJKA8k7eXt3X6Muy5BFWQsuBy/tXFg258NcxdhFech9cPk6f9qaCzteC6QAWjJYg6hUrUCx3sP5kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLYRDyS9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLYRDyS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EAC1F00A3D;
	Fri,  4 Sep 2026 05:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499049;
	bh=nZMwRvB2xc3g5ZCDPihGkHJDRLNg1QaKtbOMCDqxATk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLYRDyS91/GKiIvG5WfSBIfbZiDeR2PCHVlnfD7xslSHkCmq36S27S6r2nEyFtLDL
	 6YvSxKKjxf1KSiBcbLfvBIKHT5CNKdDWLn8bpL+5tgUfBXwMyNqfvt7bi7TLJjb9oA
	 7cZGlu1M/gXyL9AbWkNvJBbwvGEtpkgdYlWV2Hko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Chengfeng Ye <nicoyip.dev@gmail.com>
Subject: [PATCH 7.2 281/713] fanotify: fix use-after-free of file range info
Date: Fri,  4 Sep 2026 06:54:09 +0200
Message-ID: <20260904045810.140230674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit d7f1cf5be33ef0175a4e8ed8687aeb98fb00a851 upstream.

fsnotify_pre_content() builds its file_range on the triggering task's
stack. fanotify_alloc_perm_event() saves a pointer to range.pos in the
heap-allocated permission event so copy_range_info_to_user() can report
the offset later.

The event reader can set the event state to FAN_EVENT_REPORTED and then
sleep while preparing the file descriptor. If a signal interrupts the
triggering task at that point, fanotify_get_response() changes the state
to FAN_EVENT_CANCELED and returns. This unwinds the file_range stack
frame while the reader still owns the event. The reader then dereferences
pevent->ppos and copies the stale stack value to userspace.

KASAN reported:

  BUG: KASAN: use-after-free in fanotify_read+0x293e/0x2970
  Read of size 8 at addr ffff88811434fc50 by task fanotify_inotif/95
  Call Trace:
   fanotify_read+0x293e/0x2970
   vfs_read+0x177/0xa20
   ksys_read+0xf7/0x1c0
   do_syscall_64+0xf9/0x540
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Store the range position directly in the permission event and use
FANOTIFY_NO_RANGE when range information is unavailable. The event remains
alive until the reader finishes, so the reported offset no longer depends
on the triggering task's stack.

Fixes: 870499bc1d4d ("fanotify: report file range info with pre-content events")
Cc: stable@vger.kernel.org
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Link: https://patch.msgid.link/20260730134316.2085087-1-nicoyip.dev@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fanotify/fanotify.c      |    3 +--
 fs/notify/fanotify/fanotify.h      |    6 ++++--
 fs/notify/fanotify/fanotify_user.c |    5 +----
 3 files changed, 6 insertions(+), 8 deletions(-)

--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -600,8 +600,7 @@ static struct fanotify_event *fanotify_a
 	pevent->hdr.len = 0;
 	pevent->state = FAN_EVENT_INIT;
 	pevent->path = *path;
-	/* NULL ppos means no range info */
-	pevent->ppos = range ? &range->pos : NULL;
+	pevent->pos = range ? range->pos : FANOTIFY_NO_RANGE;
 	pevent->count = range ? range->count : 0;
 	path_get(path);
 
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -428,6 +428,8 @@ FANOTIFY_ME(struct fanotify_event *event
 	return container_of(event, struct fanotify_mnt_event, fae);
 }
 
+#define FANOTIFY_NO_RANGE	((loff_t)-1)
+
 /*
  * Structure for permission fanotify events. It gets allocated and freed in
  * fanotify_handle_event() since we wait there for user response. When the
@@ -438,7 +440,7 @@ FANOTIFY_ME(struct fanotify_event *event
 struct fanotify_perm_event {
 	struct fanotify_event fae;
 	struct path path;
-	const loff_t *ppos;		/* optional file range info */
+	loff_t pos;			/* FANOTIFY_NO_RANGE if unavailable */
 	size_t count;
 	u32 response;			/* userspace answer to the event */
 	unsigned short state;		/* state of the event */
@@ -468,7 +470,7 @@ static inline bool fanotify_event_has_ac
 	if (!(event->mask & FANOTIFY_PRE_CONTENT_EVENTS))
 		return false;
 
-	return FANOTIFY_PERM(event)->ppos;
+	return FANOTIFY_PERM(event)->pos != FANOTIFY_NO_RANGE;
 }
 
 static inline struct fanotify_event *FANOTIFY_E(struct fsnotify_event *fse)
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -675,12 +675,9 @@ static size_t copy_range_info_to_user(st
 	if (WARN_ON_ONCE(info_len > count))
 		return -EFAULT;
 
-	if (WARN_ON_ONCE(!pevent->ppos))
-		return -EINVAL;
-
 	info.hdr.info_type = FAN_EVENT_INFO_TYPE_RANGE;
 	info.hdr.len = info_len;
-	info.offset = *(pevent->ppos);
+	info.offset = pevent->pos;
 	info.count = pevent->count;
 
 	if (copy_to_user(buf, &info, info_len))


