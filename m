Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6963FD955;
	Tue, 13 Oct 2026 12:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893182; cv=none; b=ICzEFmwSswEwx42tgQdxKjFFAMVvUCnlntFXz9u70NYXeatwCfS8zBsgB3DoAHTbd0M5yj0pNIA96aXPWtzXslmwIJQUWQCssM15lXeeh3Lrw3IfB8pv1V4G1AhQ2GMHja0T49KKLxzdvVX3htA75NlUPHz3jnJRqVK0jOqBn+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893182; c=relaxed/simple;
	bh=mVAOuX0aZ+YYHoVuXLZC2nsNyLCM9+F9cpVjNuOlqK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbRE0cFpqFBOr5RaRvafuy8mbyHWE1pIx1U+SwV4lcv+c94iulDHEMNZpNZiHN8NuYi10QRfpT4Ie2qN3sj2pUZbBqYGiNXN6zfmLhNVnoDhBQJlA02preLDNwnzGz1nWGnZv3BJr8RbIawU25Egnq1Uioc2VSGLCe5DbM25lYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0feKLBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0feKLBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184E51F000FF;
	Tue, 13 Oct 2026 12:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893180;
	bh=qGLqZd20dpEXtUIt3l63SDImP5cukLIElTfCrpI6PdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0feKLBWnIjNT73keZEhpHXyGqoj8EWr57QxZ7AV2z+IU3pGsRfzMvX6TKynbmKpE
	 gAL0k+CTKQRvhQeLznRiTdNHFLgeZRvlldRUUQ/lGrHBZgkTgB2Rc9fRHtzSqtuoFK
	 3Y8nREGW4vesd8Nb6l+OgRrXHcc31iBmpArKZCkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 139/621] namespace: remove the fsnotify marks of a mount namespace in process context
Date: Tue, 13 Oct 2026 13:32:14 +0200
Message-ID: <20261013112924.155394708@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 1a116222acdcc1bc1a8350727ae6f28907d44594 upstream.

mnt_ns_release() drops the last passive reference of a mount namespace
and removes its fanotify marks via fsnotify_mntns_delete(). That takes
the mutex of every group with a mark on the namespace and the spinlock
of the connector. Fine from process context. But mnt_ns_tree_remove()
hands the reference the namespace was allocated with to call_rcu() and
so the marks are removed from the RCU softirq:

  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:623
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/3
   __mutex_lock+0x113/0x24b0
   fsnotify_destroy_marks+0x11b/0x3d0
   mnt_ns_release_rcu+0x57/0xa0
   rcu_core+0x6b6/0x1e40

and lockdep complains about the connector lock being taken from softirq
context. A fanotify group with a FAN_MARK_MNTNS mark on the mount
namespace of another task is all that's needed. Root in a user
namespace can do that for a mount namespace it owns. The task exits and
the namespace is freed with the mark still on it.

Remove the marks in free_mnt_ns() before the namespace is handed to RCU.
That runs in process context once the last active reference is gone. A
mark is added through a file descriptor to the namespace which holds an
active reference so no mark can show up after that.

Fixes: bf630c401641 ("vfs: add notifications for mount attach and detach")
Cc: stable@vger.kernel.org # v6.15+
Link: https://patch.msgid.link/20260930-work-mount-fixes-3-v1-13-be34c83956ae@kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -136,7 +136,6 @@ static void mnt_ns_release(struct mnt_na
 {
 	/* keep alive for {list,stat}mount() */
 	if (ns && refcount_dec_and_test(&ns->passive)) {
-		fsnotify_mntns_delete(ns);
 		put_user_ns(ns->user_ns);
 		kfree(ns);
 	}
@@ -4112,6 +4111,8 @@ static void free_mnt_ns(struct mnt_names
 	if (!is_anon_ns(ns))
 		ns_common_free(ns);
 	dec_mnt_namespaces(ns->ucounts);
+	/* the last active reference is gone, no mark can show up anymore */
+	fsnotify_mntns_delete(ns);
 	mnt_ns_tree_remove(ns);
 }
 


