Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774651;
	b=V6374SOGOti5sVsbgKsA5+M/VKM+OE4xmQvShJfpwr+F6deiFFztb/DsZ8KLnS0gm2hO
	 UMLgDLZTkAhFQsq3RQCgRPfgG1RDXH0W2nyhIPN+kFI9b5jWx/ukswdqJK+sJKwdGtLof
	 j2wZaol5xQ9ecsaQea8zr//Ssa4MqA8fXgJn5urDCP6bt0iJlnzW7i3ts55loD2VdJyPm
	 cZeUbYxuCUeVhOrnJwZwY1IUVECrA3//FDZvDYYBX2lgPGkoY5B/PpsbXx9vmQljoTujR
	 XmiibTjH6KJJbdJBr9w7DLwWguPjucJ3wbmA1SnsrTxVwJl6bBxMuLoVGA8ghaPNILg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wdh6mo0M4GjgaRt38VU6VNEHMQDno+LjyFfWVdVWqUY=;
	b=zjUx4PcSFpFUG2awgnjtGuGrlHynkhOoq0rAhSJ2S8SnPVM7iw8164YmvkG0zYDqhRYP
	 yHFtjLIrghJfMILRObRRxzcykFve/5kQUAEh+TUPDZY+9CcsKVkYerJcwWze7Z9Wdtgli
	 4I3PGr8uDzizMqNoYk2ONcZ16xhmlgTmSFNuilnLJ4yxCf0bVKf9IEq69EqI/MC6VdMyE
	 l5rljI/3AvwrSHv4O+jfRTmQPdpfoLYwGL7vcD7U5pcquEebqeFFGvqv/H9fDIzv1LKAw
	 A2Io+XFSecSaILPV1t/FZyUBWuQBuVAosoaJlZpsA3hMg0T7O7qqYPvU7+u9mCFj0qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zb+9fkkt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3A6606A31E;
	Fri, 23 Oct 2026 16:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zb+9fkkt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DC11F01825;
	Fri, 23 Oct 2026 16:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774650;
	bh=Wdh6mo0M4GjgaRt38VU6VNEHMQDno+LjyFfWVdVWqUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zb+9fkktj45BDXWLOTFW0ososAXvElTRsUpECAVchtuhZ6tblw3AIhDLSwbJ+eqS1
	 AzaIjRFsgLA9eh8jpJvX83es9WfQd35Af8K6xvVj/hcIc9jjYHdkiI/2aWADx87TzL
	 axdIKjTRftxVToD+6tnzWBN3wP6o7wzBIu2oxGB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 112/242] fsnotify: prevent mark additions during connector teardown
Date: Fri, 23 Oct 2026 18:39:14 +0200
Message-ID: <20261023163716.428390128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit 36ebddca56b9d8993d6dc984fdecc748ee1f5e06 upstream.

fsnotify_destroy_marks() keeps a reference to its current mark while it
drops conn->lock to destroy the mark. This stabilizes the forward-walk
cursor, but does not prevent a new mark from being inserted before it.
For example, an inotify watch re-added after IN_IGNORED sorts before the
old, detached mark for the same group. The walk can miss the replacement
and then detach the entire connector from the object.

The replacement is still on its group's marks_list and, for inotify, in
the watch IDR. The group mutex no longer protects the connector's object
from disappearing. An unprivileged fdinfo read racing the final detach
can consequently call igrab(NULL):

  BUG: KASAN: null-ptr-deref in igrab+0x24/0x100
  Write of size 4 at addr 0000000000000148
  Call Trace:
   igrab+0x24/0x100
   inotify_show_fdinfo+0x1dc/0x5e0
   seq_show+0x397/0x690

Set a DESTROYING flag under conn->lock before starting the walk, and
reject new marks on that connector with -ENOENT. The existing add-mark
error paths undo the temporary group-list entry and the backend's watch
allocation. Do not wait for teardown while holding the group mutex,
which the destroyer needs. Once the old connector is detached, an add
can install a fresh connector as before.

This closes the insertion race for all object types using the common
connector teardown, without changing the mark reference or SRCU lifetime
rules.

Fixes: 6b3f05d24d35 ("fsnotify: Detach mark from object list when last reference is dropped")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/mark.c                 |   11 +++++++++++
 include/linux/fsnotify_backend.h |    1 +
 2 files changed, 12 insertions(+)

--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -925,6 +925,11 @@ restart:
 		goto restart;
 	}
 
+	if (conn->flags & FSNOTIFY_CONN_FLAG_DESTROYING) {
+		err = -ENOENT;
+		goto out_err;
+	}
+
 	/* is mark the first mark? */
 	if (hlist_empty(&conn->list)) {
 		hlist_add_head_rcu(&mark->obj_list, &conn->list);
@@ -1113,6 +1118,12 @@ void fsnotify_destroy_marks(fsnotify_con
 	if (!conn)
 		return;
 	/*
+	 * New marks could be inserted before our cursor and survive the final
+	 * detachment of the connector from the object. Prevent additions to
+	 * this connector before dropping its lock.
+	 */
+	conn->flags |= FSNOTIFY_CONN_FLAG_DESTROYING;
+	/*
 	 * We have to be careful since we can race with e.g.
 	 * fsnotify_clear_marks_by_group() and once we drop the conn->lock, the
 	 * list can get modified. However we are holding mark reference and
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -566,6 +566,7 @@ struct fsnotify_mark_connector {
 	unsigned char prio;	/* Highest priority group */
 #define FSNOTIFY_CONN_FLAG_IS_WATCHED	0x01
 #define FSNOTIFY_CONN_FLAG_HAS_IREF	0x02
+#define FSNOTIFY_CONN_FLAG_DESTROYING	0x04
 	unsigned short flags;	/* flags [lock] */
 	union {
 		/* Object pointer [lock] */


