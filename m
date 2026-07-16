Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263423D953E;
	Thu, 16 Jul 2026 13:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210265; cv=none; b=lS4ws0esex63mSmHeJsAJybLe/exUITB3Bw6O+axetw9vHIS9pcvtpRQ4nu91DQNEDKFqoClcSblGF7QdHt/JB0mIBIs4zbvkQpuGU4mu1MVIbrZz+JXut+X2+5aARl3Hx1XG5qD/bMfLVsJ8PsJpsUT2n3+0RAmKd+Q9AEW9EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210265; c=relaxed/simple;
	bh=p2q8hejajuJbcTG/OE0RE7aNAx7l9XqFi0mDqu3K0Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CSfiuCDyHKCbZlfV5Qf90WVXHdyTW8be7U+VgMG/GAnPOv7h00On6laDkIRvK/5u+a/t0hEuH2dyMCYsT7mhn8uoz0IoajwB3wn7WkQr2NVn5bMe7ayLeVL6R6eTiO9MJ38NyPDZ3hyvqviHhapQshFhr2S1QenXRDcCcn7KYbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ut+8p9Jv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ut+8p9Jv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6F31F000E9;
	Thu, 16 Jul 2026 13:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210264;
	bh=um1alQsJDvvHscmLhKKRsLVGh4WBKFzro8IKCvD/2ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ut+8p9JvFGqDHjASnXusMNmyZ3B4jRLnIdRE0Q7sgRPaS9MCzIcb2dZJV+VzmDI2B
	 JFpCzHdTwDwrlXMiub2W4l9cWkz6ThpPkAqXl80GspBLRx1Luu/53F9scDtzb7f6Eo
	 AZcel5jyoB+q/7hTUyhlzK54HSDC0P3tIZXefz4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=D0=90=D1=80=D1=82=D0=B5=D0=BC=20=D0=9B=D0=B0=D0=B1=D0=B0=D0=B7=D0=BE=D0=B2?= <123321artyom@gmail.com>,
	NeilBrown <neilb@ownmail.net>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.1 501/518] Revert "fuse: fix conversion of fuse_reverse_inval_entry() to start_removing()"
Date: Thu, 16 Jul 2026 15:32:49 +0200
Message-ID: <20260716133058.803990632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit c12bbaf7c2d19325913ffd7002e580e63952d9e2 upstream.

This reverts commit cab012375122304a6343c1ed09404e5143b9dc01.

Commit c9ba789dad15 ("VFS: introduce start_creating_noperm() and
start_removing_noperm()") caused a regression in FUSE_NOTIFY_INVAL_ENTRY,
which failed to invalidate negative dentries.

This manifests in the filesystem returning -ENOENT for operations on an
existing file.

Fixing it properly while still keeping the start_removing* infrastructure
would add much additional complexity.

Instead revert to the original simple implementation.

The start_removing* infrastructure is needed in VFS to abstract the
filesystem locking.  However filesystem code can still safely use the raw
locking primitives without affacting other filesystems.

This is part one of the revert.

Reported-by: Артем Лабазов <123321artyom@gmail.com>
Closes: https://lore.kernel.org/all/CAFbF8N7++zopZuEcsKRxBV_sgOGCbzCY0hOyMw1SiGAtuzGhyQ@mail.gmail.com/
Fixes: c9ba789dad15 ("VFS: introduce start_creating_noperm() and start_removing_noperm()")
Cc: stable@vger.kernel.org # 6.19
Cc: NeilBrown <neilb@ownmail.net>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b658b6baf72f..6b05846c9bed 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1587,8 +1587,8 @@ int fuse_reverse_inval_entry(struct fuse_conn *fc, u64 parent_nodeid,
 {
 	int err = -ENOTDIR;
 	struct inode *parent;
-	struct dentry *dir = NULL;
-	struct dentry *entry = NULL;
+	struct dentry *dir;
+	struct dentry *entry;
 
 	parent = fuse_ilookup(fc, parent_nodeid, NULL);
 	if (!parent)
@@ -1601,19 +1601,11 @@ int fuse_reverse_inval_entry(struct fuse_conn *fc, u64 parent_nodeid,
 	dir = d_find_alias(parent);
 	if (!dir)
 		goto put_parent;
-	while (!entry) {
-		struct dentry *child = try_lookup_noperm(name, dir);
-		if (!child || IS_ERR(child))
-			goto put_parent;
-		entry = start_removing_dentry(dir, child);
-		dput(child);
-		if (IS_ERR(entry))
-			goto put_parent;
-		if (!d_same_name(entry, dir, name)) {
-			end_removing(entry);
-			entry = NULL;
-		}
-	}
+
+	entry = start_removing_noperm(dir, name);
+	dput(dir);
+	if (IS_ERR(entry))
+		goto put_parent;
 
 	fuse_dir_changed(parent);
 	if (!(flags & FUSE_EXPIRE_ONLY))
@@ -1651,7 +1643,6 @@ int fuse_reverse_inval_entry(struct fuse_conn *fc, u64 parent_nodeid,
 
 	end_removing(entry);
  put_parent:
-	dput(dir);
 	iput(parent);
 	return err;
 }
-- 
2.55.0



