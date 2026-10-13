Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A874F7CBB;
	Tue, 13 Oct 2026 12:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893164; cv=none; b=Skyl12A4FN2xECNfojIAbMkZTgcp6w58Je/obWw3a0KehJc/YoLf2tZk9mZbFau+d8B07yhu7XLyEnhP/bvwnAcgMwBas4jndMiukrx83rUxGXhhspXva1YhNoKjI8miOOEVEABH5y2Twb17a7Tu1UXWcMspPmuhj/qx6oWGCks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893164; c=relaxed/simple;
	bh=/b85BWjhcZ3lZ0j/2p+PUEo+ePWRTU9kWbnRrahEMIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VniNqtAxSH4ztUrzKQfQSd2Hsduj4kU7Ta/Xp9tJg6+NT1d0kxU0eYe9zKg9zNTcmfoJ+1AghbjKcsaJR9cdeHcuxxHuwWNoX4bP+r24vNori/p9XvtVOraMAG7mQy7F7nZzyUp7peM3ADlxr5WuxVgIfyBs6j1mJDI39a5EJaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ia8AbOX7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ia8AbOX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF49A1F000FF;
	Tue, 13 Oct 2026 12:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893163;
	bh=CCr3VmTOgFXOtXk6t+EPScmCrr/TvNtp8qfGTeQoWhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ia8AbOX7Qb9dkz3jQYX23jOjzAvEcKp7dZQ5tppGw+he+6FB8x6BF+IbTTvLoUVQU
	 eSp3myCUueoXXKBgTxgRqGOnXyxgw67F0ykGhjM2n8XXBQC4hMjuuf7/W8uCp1Cf6n
	 5+y6SYqlNXrFdz2TxQzWOKclozXax00tO2pFMu9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 134/621] namespace: check the target before walking it in do_mount_setattr()
Date: Tue, 13 Oct 2026 13:32:09 +0200
Message-ID: <20261013112924.038352312@linuxfoundation.org>
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

commit 08f4288a37ef4b3d19b4a9599ec3048219cac828 upstream.

When mount_setattr() changes the propagation type to MS_SHARED
do_mount_setattr() takes namespace_sem and calls invent_group_ids()
which walks the whole target tree with next_mnt() and allocates a peer
group id for every mount that doesn't have one.

Whether the caller may touch the target at all is only checked
afterwards under mount_lock. If it may not, cleanup_group_ids() walks
the tree a second time on the way out to free the ids again.

A detached tree that a file descriptor keeps alive, a mount in another
mount namespace or a mount below the root of an anonymous mount
namespace does a bunch of allocation work that is completely useless
because it will fail and revert right after.

Do the right thing and check the target right after taking namespace_sem
instead. A mount leaves its namespace only under namespace_sem so the
mount stays stable. The check under mount_lock stays for the case where
no propagation change is requested and namespace_sem isn't taken.
Callers get the same EINVAL as before.

Fixes: 2a1867219c7b ("fs: add mount_setattr()")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-5-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4810,6 +4810,11 @@ static int do_mount_setattr(const struct
 		 * propagation.
 		 */
 		namespace_lock();
+		/* invent_group_ids() walks the tree, only walk a mounted one */
+		if (!anon_ns_root(mnt) && !check_mnt(mnt)) {
+			namespace_unlock();
+			return -EINVAL;
+		}
 		if (kattr->propagation == MS_SHARED) {
 			err = invent_group_ids(mnt, kattr->kflags & MOUNT_KATTR_RECURSE);
 			if (err) {
@@ -4822,6 +4827,7 @@ static int do_mount_setattr(const struct
 	err = -EINVAL;
 	lock_mount_hash();
 
+	/* Checked under namespace_sem already if the propagation changes. */
 	if (!anon_ns_root(mnt) && !check_mnt(mnt))
 		goto out;
 


