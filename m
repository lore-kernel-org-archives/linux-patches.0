Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8E8423E99;
	Thu, 16 Jul 2026 14:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212406; cv=none; b=IUQhdRYrfmnbdDYeae5dswjVAh/9H8uQ9zwhsbFy4XAJ0DzOJdUYEYeJF2mXDfQ4jIE68RHOK71Rga6ZXSoSU84u3TcKqku2IJdTuC0lSIfog0b2aMHN5RXidNV6nZDvGgHOCqOnxXzU4WoRTHgqjFwgcsFG3GFCnE7LRmVpnsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212406; c=relaxed/simple;
	bh=lHjgRGCMLVig/J8adh18HWya2bJsmX3R4OzfMKHc1Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1J1mqTt9iQ7+JWyPbRWiXMGW3ybIATn56yi6Mvq2iVKl4vScCf966PbaTQwtY0tN6GE33M8UUZxOL/Fn7dQirGLvBoGgw40A/O6/NACiQbFYFSlXKv+1DgeGed+PxUD2NJHECTPs/8oHMEhEO71rC9xOlhrHHAP5g0QcXYFNdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3hhJeV/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3hhJeV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218531F000E9;
	Thu, 16 Jul 2026 14:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212405;
	bh=sOfqYRXGZzEBqC70O3EOdtg167qER13DdxfxhKElmrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r3hhJeV/RSJYFIozCLzoNWYe5PyZze8E4XxOKyh6eSnYSGkah6v7Bp+gm2flG65cv
	 2iX2P8P8BzO73JXhSHE2ANFl2KnG0sLBGMhht9kUDe0gS3SpQePOxwO8zsmHOxq8Sk
	 TGwJprKAb+AH6GGjpbDLvEKoYRlvPrA+ZyEsKqJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 314/349] mm: do file ownership checks with the proper mount idmap
Date: Thu, 16 Jul 2026 15:34:08 +0200
Message-ID: <20260716133040.345796952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Falcato <pfalcato@suse.de>

commit e187bc02f8fa4226d62814592cf064ee4557c470 upstream.

Ever since idmapped mounts were introduced, inode ownership checks (for
side-channel protection) in mincore() and madvise(MADV_PAGEOUT) were done
against the nop_mnt_idmap, which completely ignores the file's mount's
idmap.  This results in odd edgecases like:

1) mount/bind-mount with an idmap userA:userB:1
2) userB runs an owner_or_capable() check on file that is owned by userA
on-disk/in-memory, but owned by userB after idmap translation
3) owner_or_capable() mysteriously fails as the correct idmap wasn't supplied

In the case of mincore/madvise MADV_PAGEOUT, this is usually benign,
because file_permission(file, MAY_WRITE) will probably succeed, as it uses
the proper idmap internally, but it does not need to be the case on e.g a
0444 file where even the owner itself doesn't have permissions to write to
it.

Since this is clearly not trivial to get right, introduce a
file_owner_or_capable() that can carry the correct semantics, and switch
the various users in mm to it.

The issue was found by manual code inspection & an off-list discussion
with Jan Kara.

Link: https://lore.kernel.org/20260625153853.913949-1-pfalcato@suse.de
Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h |    5 +++++
 mm/filemap.c       |    2 +-
 mm/madvise.c       |    3 +--
 mm/mincore.c       |    3 +--
 4 files changed, 8 insertions(+), 5 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2704,6 +2704,11 @@ static inline struct mnt_idmap *file_mnt
 	return mnt_idmap(file->f_path.mnt);
 }
 
+static inline bool file_owner_or_capable(const struct file *file)
+{
+	return inode_owner_or_capable(file_mnt_idmap(file), file_inode(file));
+}
+
 /**
  * is_idmapped_mnt - check whether a mount is mapped
  * @mnt: the mount to check
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4420,7 +4420,7 @@ static inline bool can_do_cachestat(stru
 {
 	if (f->f_mode & FMODE_WRITE)
 		return true;
-	if (inode_owner_or_capable(file_mnt_idmap(f), file_inode(f)))
+	if (file_owner_or_capable(f))
 		return true;
 	return file_permission(f, MAY_WRITE) == 0;
 }
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -316,8 +316,7 @@ static inline bool can_do_file_pageout(s
 	 * otherwise we'd be including shared non-exclusive mappings, which
 	 * opens a side channel.
 	 */
-	return inode_owner_or_capable(&nop_mnt_idmap,
-				      file_inode(vma->vm_file)) ||
+	return file_owner_or_capable(vma->vm_file) ||
 	       file_permission(vma->vm_file, MAY_WRITE) == 0;
 }
 
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -167,8 +167,7 @@ static inline bool can_do_mincore(struct
 	 * for writing; otherwise we'd be including shared non-exclusive
 	 * mappings, which opens a side channel.
 	 */
-	return inode_owner_or_capable(&nop_mnt_idmap,
-				      file_inode(vma->vm_file)) ||
+	return file_owner_or_capable(vma->vm_file) ||
 	       file_permission(vma->vm_file, MAY_WRITE) == 0;
 }
 


