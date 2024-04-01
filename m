Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CAA4D9F2;
	Mon,  1 Apr 2024 15:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986670; cv=none; b=hInGR7jQdvRMwk7PQFUjArhoQIA9cYO4PVGmqsnCxVSrpoo5Sv/qkloumFXxFpgLd86mflSetM9CopUImYftmbl00I+I/lwvRU+7Q3Hv1+Si6fRqLyWOe65f9bhnS6PcJrnsCq06pGXZfPGQ7gH/k8BqUdHIsaYFqvyfeOZCQoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986670; c=relaxed/simple;
	bh=rZqi4tWckU5FEZbzhtMoKSIINj1JTRgKOI/pvnlzwB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNnQH/w0NHiqvGhd+TXpO7ytBif4sg3b01GASy1F4BKCLS8eo/Qsx/AyLFDq4Jj1d7l+VM6Zx2CGeBXsf1upWNiajINRmfbbOyWihw3g31SpVD/Hh4EkSndbKPtmHzZfY+orwDSXS5MGrXnj+7R8bgeLnVpYt2rcReVtADIJwEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ls6c318j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ls6c318j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD1CC43394;
	Mon,  1 Apr 2024 15:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986669;
	bh=rZqi4tWckU5FEZbzhtMoKSIINj1JTRgKOI/pvnlzwB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ls6c318jTsFm1v5fLcZ4ubvjrzbhMnJiM95neOQrlEopv/Tz5NUvI20bxcGJD+ooD
	 VCMRIP+VHTD3X0x0A3TTVUp8BUzjIJt1UiUMB9bS+Ut5qNlm2MqoyR18eR/ddrhnoS
	 6KfPvaitTkzAqgB0L00Vm5/54w5RY5TjdoSwJaO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Xu <howeyxu@tencent.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 048/399] fuse: fix VM_MAYSHARE and direct_io_allow_mmap
Date: Mon,  1 Apr 2024 17:40:14 +0200
Message-ID: <20240401152550.619421383@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 148a71b8b4d0e..b9cff9b6ca1b8 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2468,7 +2468,8 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 		return fuse_dax_mmap(file, vma);
 
 	if (ff->open_flags & FOPEN_DIRECT_IO) {
-		/* Can't provide the coherency needed for MAP_SHARED
+		/*
+		 * Can't provide the coherency needed for MAP_SHARED
 		 * if FUSE_DIRECT_IO_ALLOW_MMAP isn't set.
 		 */
 		if ((vma->vm_flags & VM_MAYSHARE) && !fc->direct_io_allow_mmap)
@@ -2476,7 +2477,10 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 
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



