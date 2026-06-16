Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C736A35201E;
	Tue, 16 Jun 2026 15:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623061; cv=none; b=rh6g03nuRcOAfjT+1k/sykO07JLMTu0n4qgcLuQqPr99Jzv6NXqBzTuayU94isO44TJ2zIDuqK37anJ53VGtCbYtZk6Khi+KPhPaplMzEPph2mmuQxPCFEwxaV/DhVKTfS1NFajM463bn6UsidyWJH2dlmSEQzwTFukpuT0g/Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623061; c=relaxed/simple;
	bh=BgG1REilJP2lL+/41Rokd777JubccItw4yr4irKsWkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVhh7Acygjgloj74eO0BdNe73XF3+vpwwygfrg0lXCj1Tnm1w/nqf1/Sqt0Qf+xDDSRG87Eb7yd9rX9WFXooG3zXf+rkBjesbcZR1J8L8uNkIQmxupViWRzOHmlnauO9EXGp2yqWZtOb8EPoR83cGnoXY6J0ZszK8teyccOMQwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJEaoX6n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJEaoX6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775D41F000E9;
	Tue, 16 Jun 2026 15:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623060;
	bh=F1H7jxVqGtbYQMRG6Nh6FhB9ZKrrHCy7FOouLwNkNmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vJEaoX6nJHavHD1KZc9SNV5Czdl9MxGKKZ4fBb/qsC7nh3jDN1AvKyhuZ6tniZnt7
	 b+E/T1MEAREWuSHFBnKGGDqkNkL6RAMlPzKYxZqUJbfE+NuzQmKpS2thwZvCS1zG3L
	 0A8WHwfafqhFk9tOeiNthOxtXd5IwOFVIFnjs3cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 081/378] VFS: fix possible failure to unlock in nfsd4_create_file()
Date: Tue, 16 Jun 2026 20:25:12 +0530
Message-ID: <20260616145114.474240217@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@ownmail.net>

[ Upstream commit e824bbd4d224cce4b5fb59cc9dcd3447fe0b7e44 ]

atomic_create() in fs/namei.c drops the reference to the dentry
when it returns an error.
This behaviour was imported into dentry_create() so that it
will drop the reference if an error is returned from atomic_create(),
though not if vfs_create() returns an error (in the case where
->atomic_create is not supported).

The caller - nfsd4_create_file() - is made aware of this by checking
path->dentry, which will either be a counted reference to a dentry, or
an error pointer.

However the change to use start_creating()/end_creating() (which landed
shortly before the dentry_create() change landed, though was likely
developed around the same time) means that nfsd4_create_file() *needs* a
valid dentry so that it can unlock the parent.

The net result is that if NFSD exports a filesystem which uses
->atomic_create, and if a call to ->atomic_create returns an error, then
nfsd4_create_file() will pass an error pointer to end_creating()
and the parent will not be unlocked.

Fix this by changing dentry_create() to make sure path->dentry is always
a valid dentry, never an error-pointer.  The actual error is already
returned a different way.

Note that if ->atomic_create() returns a different dentry (which may not
be possible in practice) we are guaranteed (because it is only ever
provided by d_spliace_alias()) that it will have the same d_parent and
so it will have the same effect when passed to end_creating().

Fixes: 64a989dbd144 ("VFS/knfsd: Teach dentry_create() to use atomic_open()")
Signed-off-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/177969022571.3379282.16448744624428323496@noble.neil.brown.name
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@hammerspace.com>
Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namei.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 9e5500dad14f59..d615cd62885198 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -5002,6 +5002,7 @@ struct file *dentry_create(struct path *path, int flags, umode_t mode,
 {
 	struct file *file __free(fput) = NULL;
 	struct dentry *dentry = path->dentry;
+	struct dentry *orig_dentry = dentry;
 	struct dentry *dir = dentry->d_parent;
 	struct inode *dir_inode = d_inode(dir);
 	struct mnt_idmap *idmap;
@@ -5021,9 +5022,18 @@ struct file *dentry_create(struct path *path, int flags, umode_t mode,
 		if (create_error)
 			flags &= ~O_CREAT;
 
+		/* atomic_open will dput(dentry) on error */
+		dget(orig_dentry);
 		dentry = atomic_open(path, dentry, file, flags, mode);
 		error = PTR_ERR_OR_ZERO(dentry);
 
+		if (IS_ERR(dentry))
+			/* keep the original */
+			dentry = orig_dentry;
+		else
+			/* Drop the extra reference */
+			dput(orig_dentry);
+
 		if (unlikely(create_error) && error == -ENOENT)
 			error = create_error;
 
-- 
2.53.0



