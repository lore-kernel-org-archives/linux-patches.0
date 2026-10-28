Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209384;
	b=fmpFkxkpNSiBVbHFu1Rf9dwH8YNqq42QSmTpsjYJ3WjUmViwygQUmR8r7dJW/hvSbMpi
	 bKaptSYmUycMnTkxANozuQEcguX+cv6nRGOYjWn2ioq/8+cpRg7ImibQ9atsYVvq0BRvo
	 rzOngM8aTxNg3iW8/WzJar5N1HFA0WsSz9TsmMBPM3rYLuksC9Mbe1TN3O8k7ZB7uhy8u
	 al/DclPM8OAFVacZKH+O2zbvVC3YT1jB/FkxfrhFJ2hhkES3R+DyRveLAYWo8JPh/m4AS
	 3D+YQytDEXofQYv1PAJd/HcqsGPfE/vefnGOwJNlZPKzEZ09JaKvLeY5VcUeUClqDrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oR0xS26gSioei7wRKO8EVYGyYldf8W/K3JPyTUdK3P0=;
	b=pGq0/EnRhdBah8ewHzu2FJf7dMb3V6SSYCMqxENFyQN77IB51n5W2fOvyfmwMVcAEEhr
	 NTgOgidQKbtE1XYYKTUx/JplIUwdfN7fiUgH+kZA0I8h3P4TqxQelWPvLetiDgHDwlEXW
	 5h+dVtLHrZnR4uu70iiy15bsyURUZlTgiAiNzQ6h1kiLY9TrOfi6vXxuzaxMSY1mMQBim
	 q+Wv5fGpmzUzFDfN+Du1iTp8EbUHAVI9MCiQrCuhh+5nbOZi0Kulpc55HatcghEvqXnN2
	 8kgOmWSj7Dx257RXVQ8RwbRXP9WTaUCqs3UXg8iC8W8C3bGGRP0rZjgHGdcNgPhzAgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlsFCLgl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55D2606A31D;
	Wed, 28 Oct 2026 17:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlsFCLgl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C411F01825;
	Wed, 28 Oct 2026 17:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209383;
	bh=oR0xS26gSioei7wRKO8EVYGyYldf8W/K3JPyTUdK3P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PlsFCLglswv+9VS8BAbBzrSGhbzuanikNu/dNDjXUW/1cDPCDBG0P30thzohdOeQS
	 4eI7OPt5Uxa48Pay+Q9GYpdh/yg5FejDV1Q+GGmKcKfDz3Js3tn3Ukzs439yclk6UA
	 yCrl96gXEMcb9Q26voYPh0/flSSt5sgdUAM0I3NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 451/516] fsnotify: prevent mark additions during connector teardown
Date: Wed, 28 Oct 2026 18:00:03 +0100
Message-ID: <20261028170014.166473498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -686,6 +686,11 @@ restart:
 		goto out_err;
 	}
 
+	if (conn->flags & FSNOTIFY_CONN_FLAG_DESTROYING) {
+		err = -ENOENT;
+		goto out_err;
+	}
+
 	/* is mark the first mark? */
 	if (hlist_empty(&conn->list)) {
 		hlist_add_head_rcu(&mark->obj_list, &conn->list);
@@ -869,6 +874,12 @@ void fsnotify_destroy_marks(fsnotify_con
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
@@ -474,6 +474,7 @@ struct fsnotify_mark_connector {
 	unsigned short type;	/* Type of object [lock] */
 #define FSNOTIFY_CONN_FLAG_HAS_FSID	0x01
 #define FSNOTIFY_CONN_FLAG_HAS_IREF	0x02
+#define FSNOTIFY_CONN_FLAG_DESTROYING	0x04
 	unsigned short flags;	/* flags [lock] */
 	__kernel_fsid_t fsid;	/* fsid of filesystem containing object */
 	union {


