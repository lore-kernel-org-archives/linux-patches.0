Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4974FDE60;
	Tue, 13 Oct 2026 12:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893152; cv=none; b=hjF98pPHqzL6tQUAGt7S+WL5L4Sk0fScdrVbjgHYlm5oHsqvkYHO+pNkhNKnb3bhu8Z6+KVEtYioeeOEHlx0MJCbmDBpDbOqurA+nM8eZ6JgdIZ723bvVdQG5riIjTHg8V3wHLIthIILmMDliVucLjO34YUxPbVvT33gX+S9qUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893152; c=relaxed/simple;
	bh=0hOIX6ta2fyupbWWboAs8sAOPO5VX12oso1U003mIw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAJ9vcuO+Dik0Lz2GN6qrmTnPJFJL68Rx2jeFCGbLCL6fA4XP5tdKjRCgbdP6u7Siwiffepk/Em3i6NA/KrKvYjk3H8ExU4wNN0eGC7m2Ii9deCQCm3qPPcck21U86BMKXjvZQ/FEVjA7+6IGvxzhAczSEW0pDf3ooNxA/AZZcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQMI5XWB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQMI5XWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31E01F000FF;
	Tue, 13 Oct 2026 12:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893151;
	bh=rMm2upzSVw7R5jyA2wQPwsKemANTDYTN2ckBqMEqN38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQMI5XWB4jJR+DtObg7Px6ppq+QscuNfQi8ZD4ITv43JLfZkggJ9ma6o4/tQQVS26
	 xSOdIxBJsHEhSdyvkHuF8BlixMUSreMeCFZR2snaj5dG4cB9NtUbPr3wtvMqZGcT/K
	 Jib/eGBRSLD9PldBl7bAHYvlGyhN9iKhBbt1wvzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 130/621] namespace: reset the old parents ->overmount in mnt_change_mountpoint()
Date: Tue, 13 Oct 2026 13:32:05 +0200
Message-ID: <20261013112923.944208755@linuxfoundation.org>
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

commit 476ef286a7a5db8bda51325dc0c45887b4d99d9a upstream.

__umount_mnt() resets ->overmount of the parent when it unmounts the
mount that overmounts it. mnt_change_mountpoint() doesn't. It moves the
mount to its new parent and leaves the old one pointing at it.

For a mount that is moved beneath in attach_recursive_mnt() that doesn't
matter. The new mount has already reset ->overmount of the old parent by
the time the old top mount is moved onto it.

It matters for reparent() though. propagate_umount() moves a surviving
overmount onto the first ancestor that isn't going to be unmounted. The
mount it was taken from is unmounted immediately afterwards. If a file
descriptor keeps that unmounted mount alive ->overmount points at the
moved mount. That's a dangling pointer and UAF as the moved mount is
unmounted and freed.

do_lock_mount() follows ->overmount from the target path under
mount_lock. With a file descriptor on such a mount as the target of a
mount beneath topmost_overmount() walks into the freed mount and
do_lock_mount() takes references on whatever it finds there.

So reset ->overmount of the old parent in mnt_change_mountpoint() the
same way __umount_mnt() does. A mount's ->overmount is then always a
mount that is attached to it.

Fixes: ffdc52fbbd58 ("prevent mount hash conflicts")
Cc: stable@vger.kernel.org # v6.17+
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-1-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1063,7 +1063,10 @@ static void attach_mnt(struct mount *mnt
 void mnt_change_mountpoint(struct mount *parent, struct mountpoint *mp, struct mount *mnt)
 {
 	struct mountpoint *old_mp = mnt->mnt_mp;
+	struct mount *old_parent = mnt->mnt_parent;
 
+	if (old_parent->overmount == mnt)
+		old_parent->overmount = NULL;
 	list_del_init(&mnt->mnt_child);
 	hlist_del_init(&mnt->mnt_mp_list);
 	hlist_del_init_rcu(&mnt->mnt_hash);


