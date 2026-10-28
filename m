Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210014;
	b=KEkDW08RAVVSlJMYJIIw705tZBph5I0LzBNsa2lCywG4VyomPNDu0/ZGhVDVk18nyHZd
	 86GAQ2IrNCI4jAvyxLkNWLWDYiER1WxquMBvtIxm8BZInpwrvIDhnf1no5IcfMjdNcEwO
	 zubb3dS8JZujxc3qASlAtRCSH7rG3q8cojzxfGoloEhEZfcUfIKIiQs4+RpjbuESXUK3z
	 PdNTVt96HBNm/3ZfF1gie8O93E+XPjoI6+Yvk0/dp11rOME58/F804dqdrBZ7N9ruiWVr
	 dHq3XPrmQiuwjWBr1udMmnipJqlrTSQjqxRJkJ4uV9RNjiL+fpeeEV8mlQEWum33Q/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xBzpR++IAGtaub1I7r9KX2aDbTtEamrmq5zwVirMej8=;
	b=vPckn/Cj40MWMNmObiDhiivRk3Yk+ZLkjK7i+W6dVwOKRb4X1dSXrqXL2Nq7ep66hPCy
	 MYUp9a6l9/l802YxAbs4ZC8+KPATTs8+zRqy1hfrgRdTUr/g7iZOz9o4VPmMv1nEd0Dn8
	 nUxJd/YEu7fB8i6oGfg1y714lDoLbYmMkLDe3VGvgcpeilFWxel1dvTuVj/WVpHIGyrPm
	 2ZKcnOy3Tl0L+1pH94F5eGl7F1VIfj4oqakhJbgr5gArk2DMCdExtfyglvtwV72PhUFm6
	 h+CkbFHQfelpXAvB2+0Mzs4jIlQmhxGPuuVUvW9ygVBCgAcxUfPc5HKl5P1hb0nW48g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TMznh/lD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35B3606A31F;
	Wed, 28 Oct 2026 17:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TMznh/lD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEAD1F01825;
	Wed, 28 Oct 2026 17:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210013;
	bh=xBzpR++IAGtaub1I7r9KX2aDbTtEamrmq5zwVirMej8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMznh/lDhGHF/sJPrPGaK/rmdMhQKyJuVM+hdyuueZ3sg0/DA7iasTNX6bw1c/dAi
	 GZerFpVIj6JSvhmiN1BpEuVDxU7WKDRnNEqBM2bC7ms0P+OsScgLx6YGnfHtS45/bz
	 qVuzrI9XghboMU/22yWrl/FBgwiFkCT4fAft6T9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.6 044/168] fsnotify: prevent mark additions during connector teardown
Date: Wed, 28 Oct 2026 17:59:40 +0100
Message-ID: <20261028165944.132562040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -719,6 +719,11 @@ restart:
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
@@ -902,6 +907,12 @@ void fsnotify_destroy_marks(fsnotify_con
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


