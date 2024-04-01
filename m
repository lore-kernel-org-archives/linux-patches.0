Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B6243AD6;
	Mon,  1 Apr 2024 16:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987976; cv=none; b=WGc7vWm63ozJM1ANzw9ZsovmfgMO4UxLVvJTAjxSO/rV6FX0jKqu3foGp2UGzr2VA0wbFVwKG4XmQ3qhw4y9LLYf0abmvCWSV1i5hJ/TIogzUogRfGERx5JW6C14o8muoVInlIdRG4i/4pkL0nkx+C0CMWpBNbQyCsAS7HBezyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987976; c=relaxed/simple;
	bh=Ntd+RP2PKLlijgrkMNux02JYJQAPn2SpHVzNst4hsm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xk8MBaBlLx2qPX+3B/M6DAwU9kgZVLxQz95IUCecfpLlsDxEscegQ/gjA4acQoh95aWATNiG4GNbDy8twoErb4YNJavtJYdrxM0jJNEV+RVPfDPAe6BglIaqHb0TgOYV6oau3bhoQtSGRixYOTGUVGNzC7oKR0nM+a3Z0a6fE6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CcEBLXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CcEBLXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D901C433F1;
	Mon,  1 Apr 2024 16:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987976;
	bh=Ntd+RP2PKLlijgrkMNux02JYJQAPn2SpHVzNst4hsm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CcEBLXntTtibr2jdCQ8fr06tGdjBjuizStoaBIQQdYmIu26MWYmQ3LhMvUsa9tGs
	 PhxySiubgYSm5DycotqpAmmBtYBiuHpOpXxLuUHvFGyxhqeThYCZ9uCq+HG4EJZ89M
	 tTLybnomev5XCxBWriuuYpQLqEP4V0/zYpLoqILk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Xu <howeyxu@tencent.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 048/432] fuse: fix VM_MAYSHARE and direct_io_allow_mmap
Date: Mon,  1 Apr 2024 17:40:35 +0200
Message-ID: <20240401152554.562261504@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bschubert@ddn.com>

[ Upstream commit 9511176bbaee0ac60ecc84e7b01cf5972a59ea17 ]

There were multiple issues with direct_io_allow_mmap:

 - fuse_link_write_file() was missing, resulting in warnings in
   fuse_write_file_get() and EIO from msync()

 - "vma->vm_ops = &fuse_file_vm_ops" was not set, but especially
   fuse_page_mkwrite is needed.

The semantics of invalidate_inode_pages2() is so far not clearly defined in
fuse_file_mmap.  It dates back to commit 3121bfe76311 ("fuse: fix
"direct_io" private mmap") Though, as direct_io_allow_mmap is a new
feature, that was for MAP_PRIVATE only.  As invalidate_inode_pages2() is
calling into fuse_launder_folio() and writes out dirty pages, it should be
safe to call invalidate_inode_pages2 for MAP_PRIVATE and MAP_SHARED as
well.

Cc: Hao Xu <howeyxu@tencent.com>
Cc: stable@vger.kernel.org
Fixes: e78662e818f9 ("fuse: add a new fuse init flag to relax restrictions in no cache mode")
Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index a660f1f21540a..cc9651a01351c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2467,7 +2467,8 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 		return fuse_dax_mmap(file, vma);
 
 	if (ff->open_flags & FOPEN_DIRECT_IO) {
-		/* Can't provide the coherency needed for MAP_SHARED
+		/*
+		 * Can't provide the coherency needed for MAP_SHARED
 		 * if FUSE_DIRECT_IO_ALLOW_MMAP isn't set.
 		 */
 		if ((vma->vm_flags & VM_MAYSHARE) && !fc->direct_io_allow_mmap)
@@ -2475,7 +2476,10 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 		invalidate_inode_pages2(file->f_mapping);
 
-		return generic_file_mmap(file, vma);
+		if (!(vma->vm_flags & VM_MAYSHARE)) {
+			/* MAP_PRIVATE */
+			return generic_file_mmap(file, vma);
+		}
 	}
 
 	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
-- 
2.43.0



