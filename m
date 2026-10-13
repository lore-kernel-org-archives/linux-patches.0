Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E19150E5AA;
	Tue, 13 Oct 2026 12:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893146; cv=none; b=UglD7THTn40f+N+ZrMnj39IqsjvL2BkO4Mf/GSdP6Q/WtYglxYLPadztlLDpOGtcrhfLLXY9k3mgqkB6Zz9iUJOnxjZ8TibRmoilRwmRdqIDt7P8aDxNI5subrrgjZZ7NRxfphc/JG9MgSOjYiJ+yKzI5RJ67ak5XZRqJeDYwJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893146; c=relaxed/simple;
	bh=tVSDBB5Y60w0TxzxU4fvJ7xlsAxpOeV0WAweY8FMqrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpL/WSZliioqNPoE8OrBLmQvW2jRjilTPiz4DbJZ7ykaG+7KzD4X+dZwkezDjQxjLpgOU1bbN/9aUPpWBUDqQjwO8LWBhcpzuExhoS+SmLpEcX1Q1tRsySULJ1cAdOIS8GrZ/O9X+3nPlLHZyU+4Dg2uF0yvwWnp2EBxMz/dEs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2t9Eo7I9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2t9Eo7I9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48D21F000FF;
	Tue, 13 Oct 2026 12:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893145;
	bh=PrkzIo3vBUE8FtxWAc7GpTVvBjlt6pImzE+NZnt4O88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2t9Eo7I9QO8NrfO/p7/UvpJDA+Oj6aqHNEGMl6Gf0RiEw49UnSzXdU8FrRfDsortB
	 nK3SgPENbpWA5tEenckVPSGnCDzOUrj97EfTqp/UJBLLiXfLjj9P/0UK1MjFMzXN9k
	 RSLhjjKvqPa2Rc4WpegkuXHEbh612ZNDCPstzoXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 128/621] mount: keep a copied mount unbindable
Date: Tue, 13 Oct 2026 13:32:03 +0200
Message-ID: <20261013112923.896558288@linuxfoundation.org>
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

commit 1ab8904ae61b076d1242e1f48537698c77074b5c upstream.

It's groundhog day.

MNT_UNBINDABLE used to be set in in mnt->mnt.mnt_flags and was not part
of MNT_INTERNAL_FLAGS. clone_mnt() copied it with all the other flags to
the new mount. This guaranteed that the copy of an unbindable mount
became unbindable as well. Unbindable copies that ended up as shared
lost the unbindable property.

But then commit 406fea799925 ("mount: separate the flags accessed only
under namespace_sem") moved MNT_UNBINDABLE from mnt->mnt.mnt_flags into
mnt->mnt_t_flags as T_UNBINDABLE.

clone_mnt() doesn't copy from mnt_t_flags and specifically doesn't copy
T_UNBINDABLE. The only place a mount gets marked unbindable is in
change_mnt_propagation() for MS_UNBINDABLE.

This reintroduced an earlier bug we had already fixed. It resurfaces in
copy_mnt_ns() which clones unbindable mounts via CL_COPY_UNBINDABLE. So
since v6.17 a mount namespace created via clone(CLONE_NEWNS) or
unshare(CLONE_NEWNS) contain private and bindable copies of every
unbindable mount. The following snippet:

  mount --make-unbindable /mnt
  unshare -m --propagation unchanged
  mount --bind /mnt /tmp/x

succeeds. This used to fail with EINVAL. This also applies to
recursively binding a tree that contains an unbindable the mount. Such
subtrees used to be pruned when they were moved onto a shared mount.

And Documentation/filesystems/sharedsubtree.rst still says that the copy
of an unbindable mount is unbindable.

So once again let's fix this. Copy T_UNBINDABLE in clone_mnt(). Let
set_mnt_shared() mask it off whenever a mount is made shared.
This restores what the old MNT_INTERNAL_FLAGS mask did.

Link: https://patch.msgid.link/20260923-work-mount-fixes-v1-1-f424cf8d3242@kernel.org
Fixes: 406fea799925 ("mount: separate the flags accessed only under namespace_sem")
Cc: stable@vger.kernel.org # v6.17+
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1255,6 +1255,7 @@ static struct mount *clone_mnt(struct mo
 
 	mnt->mnt.mnt_flags = READ_ONCE(old->mnt.mnt_flags) &
 			     ~MNT_INTERNAL_FLAGS;
+	mnt->mnt_t_flags = old->mnt_t_flags & T_UNBINDABLE;
 
 	if (flag & (CL_SLAVE | CL_PRIVATE))
 		mnt->mnt_group_id = 0; /* not a peer of original */


