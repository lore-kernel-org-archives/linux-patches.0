Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211772;
	b=kqiXZYSn20+GumPlGduDC10VRodqfF1/hfKiuHfLZtVwxCRoA9M0doK8zc/JILOTADav
	 JDkIEb7hRciU0VRlIzAW1IOansb80skkRPLNLPJASIMqtu1EhYBPS9lZII3gxQwQ1Pn1u
	 mLYcuqsL/fcwFQr60cAkEi7XwqUXkXgfriJhSzqoxN5BtHcmDrvrT4xMGZRovK88rv9eP
	 tu8uExpqFVhgNtNFlewuuj9FLOihZrn7mi+0ElaCzycy+O0ayUG8diOk96LCvzA8HX5UN
	 Lk0evgOq6qIc7mzVScdttY9vS5Pd4ACM0wo+FgE9Z3D9xdEh16ThJRjtz/mRqBjJ08w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DmzJx+hzlfYTxdIGO9LVDkute8t0rL4ZoPbFVnsVhXk=;
	b=hUvF08hNdw+4RavK+7L5nJMzhdvzhK1PHNsFDYvlZWQamyM1ZesAtCI15/vAOTiMyMLX
	 fOWBV/ko1etQ8k/YNVxXAZDGkPyu6EJcqzInnjoZ5P0yiRT+n2vNpOj1c5aue+B0oQ7na
	 EC2CpSr1Yu2iefcIPQy5DN+lGHnFXew+2wG2CZXUVFG+MHpX9RGmFVJPQ4siyyTqRMPdC
	 8xgS5n6u1zV3grFo/1zG2Gav8Ggl0f+5967ByDUqoKumma9TVfs5NebBVqecA89qaQMzr
	 P8DgLQJHT0y5Hj9lC9CZ8Lt44GiZRPwG74ktvsWzVMedBFLUn68ZmWJZyr5uj7bOBcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2oOF8OwY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1B060A262C;
	Wed, 28 Oct 2026 18:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2oOF8OwY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3D61F01825;
	Wed, 28 Oct 2026 18:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211772;
	bh=DmzJx+hzlfYTxdIGO9LVDkute8t0rL4ZoPbFVnsVhXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2oOF8OwY/rJogtNtTK2ZWM109ib/zJ+TpOP+GXWeET1LSjFEjWoVTF88pwJDqxYVE
	 TkRYF8LBbivpPrm0i3YgJqrLkwGs4L0aK5/KH0BK9SLay4ZJ1BfTJWMJ6KKZl0NLsD
	 k82fdRZsHYLUiM+VIm5aHXhTxQrAY5ZhTgjgFv2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.15 494/571] fsnotify: prevent mark additions during connector teardown
Date: Wed, 28 Oct 2026 18:00:41 +0100
Message-ID: <20261028170019.749570017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


