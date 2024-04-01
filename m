Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030F0487A7;
	Mon,  1 Apr 2024 16:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989433; cv=none; b=QNXmTwxXBejyRkBNt7rkuabjLnpyRwy/oUqCUT4nugME//KQSEdll0/sPF+z/GytV7+gXTV60RTY8E1Ib8VgTvXOfuLJA2Dd3HrrxBHto2rPfm6y4Komn9W7WAYGL2qJerAlkglVzDaN4S/OmyisRSAXG5nx+4U+gJgVycxyFrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989433; c=relaxed/simple;
	bh=0LxFDLGjneBgT9QEeJ+SjXptT2o1x8WzywR4dTAn1Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXuFSFy4FjuPnHF8Wph51VKOqFN0hRAYw7NzNVUpWMpUEajuS4eLm5Xh63tnkN/ZuPEyPdWIIdE4ZLgYGx2ehSMzINhSmYbf4tafqvhAIaFfu1Z0LZMXQcZzkQ/PrrrLZL6pVXMJcTFcLWwyKxEaqWEIFqXRaP+52fbQKyP9jYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atZ2erkg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atZ2erkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77576C433C7;
	Mon,  1 Apr 2024 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989432;
	bh=0LxFDLGjneBgT9QEeJ+SjXptT2o1x8WzywR4dTAn1Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atZ2erkgyHaXuPIwGPOdlLdr0eCvX51nzRyqadTXQwrpv6k3Qof37OhII5WhMajWS
	 LlHUfPZAOoRDx8S3B00tFRtRrbJOGrgxBG1gPSdDf39Ydj5juCxxy+RNBcxtGu0oPN
	 B9vVNbGAB6BAtpgm0zJl7MPnjOyhx9C2sBZiXBhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Xu <howeyxu@tencent.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/396] fuse: fix VM_MAYSHARE and direct_io_allow_mmap
Date: Mon,  1 Apr 2024 17:41:35 +0200
Message-ID: <20240401152549.302091195@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



