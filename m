Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59794392829;
	Sat, 17 Oct 2026 17:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257840; cv=none; b=grcnLOBcjsl+qInL4SoeR8suqzaN6gWIRn7/BteIw8TWUg6hWrwDM9yY5ir4lktq+rgQYWem0UJeqcsIF9CUwwANXPMrDqlZvV4RMdBLNgbrmGRxYap7xPokMs3kq+9WPgvJclftVLcceXoFRHGpBTzc3YTgB18hU9ycIDgRG/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257840; c=relaxed/simple;
	bh=sekkYMJbIJtehnSC1/m8wPu2oJkWrwFdZKwNmE/bg8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unhulHcbop9qKc8D82uXEgoOooEknAUfXKwmhEh7rBxKin2tT3vTX79cNghmwS9fJ8+wjm0p319RSmLL4Z+1YEW0a65G84XxJfVagt/z4RmnL3OdAstqnfZeTfF8MGTQVMCvW7B+yTxV2+OY1Ztn6BiFc/GOR5fp/WFmMW0Edrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxKr2Lz8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxKr2Lz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B111F000C4;
	Sat, 17 Oct 2026 17:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257839;
	bh=vPgR4cX+wQQIuB5WxVX/1jzeFjKrNIJEFEyvMOquPhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxKr2Lz8fxbIvtK+9GCVTPFVfxtUpxiuOPLZoYX4lexuVjjOg4JfGNUsvsgtjbqGD
	 VxTfFdJZS/LI/6lpvbTKgh7i1RtR3TfJ/pn7NhFRyc3AUWLMx1Rpe7Wk5PUOcjgt1O
	 Xjvnf09ikFsG8y0TqKwUXNZHPHOD1NqAfsuFiTxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <lei.huang@linux.intel.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0660/1674] fuse: Fix missing FOLL_PIN for direct-io
Date: Sat, 17 Oct 2026 17:48:52 +0200
Message-ID: <20261017160448.053894742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei Huang <lei.huang@linux.intel.com>

[ Upstream commit 738adade96b2ec414a44f3b1ed891fec3e0c03dd ]

Our user space filesystem relies on fuse to provide POSIX interface.
In our test, a known string is written into a file and the content
is read back later to verify correct data returned. We observed wrong
data returned in read buffer in rare cases although correct data are
stored in our filesystem.

Fuse kernel module calls iov_iter_get_pages2() to get the physical
pages of the user-space read buffer passed in read(). The pages are
not pinned to avoid page migration. When page migration occurs, the
consequence are two-folds.

1) Applications do not receive correct data in read buffer.
2) fuse kernel writes data into a wrong place.

Using iov_iter_extract_pages() to pin pages fixes the issue in our
test.

An auxiliary variable "struct page **pt_pages" is used in the patch
to prepare the 2nd parameter for iov_iter_extract_pages() since
iov_iter_get_pages2() uses a different type for the 2nd parameter.

[SzM] add iov_iter_extract_will_pin(ii) and unpin only if true.

Signed-off-by: Lei Huang <lei.huang@linux.intel.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 41748675c0bf ("virtiofs: use pages instead of pointer for kernel direct IO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c   | 15 ++++++++++-----
 fs/fuse/fuse_i.h |  1 +
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 553c163afbc2d..8a8c0aa82b866 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -666,7 +666,8 @@ static void fuse_release_user_pages(struct fuse_args_pages *ap,
 	for (i = 0; i < ap->num_pages; i++) {
 		if (should_dirty)
 			set_page_dirty_lock(ap->pages[i]);
-		put_page(ap->pages[i]);
+		if (ap->args.is_pinned)
+			unpin_user_page(ap->pages[i]);
 	}
 }
 
@@ -1424,10 +1425,13 @@ static int fuse_get_user_pages(struct fuse_args_pages *ap, struct iov_iter *ii,
 	while (nbytes < *nbytesp && ap->num_pages < max_pages) {
 		unsigned npages;
 		size_t start;
-		ret = iov_iter_get_pages2(ii, &ap->pages[ap->num_pages],
-					*nbytesp - nbytes,
-					max_pages - ap->num_pages,
-					&start);
+		struct page **pt_pages;
+
+		pt_pages = &ap->pages[ap->num_pages];
+		ret = iov_iter_extract_pages(ii, &pt_pages,
+					     *nbytesp - nbytes,
+					     max_pages - ap->num_pages,
+					     0, &start);
 		if (ret < 0)
 			break;
 
@@ -1444,6 +1448,7 @@ static int fuse_get_user_pages(struct fuse_args_pages *ap, struct iov_iter *ii,
 			(PAGE_SIZE - ret) & (PAGE_SIZE - 1);
 	}
 
+	ap->args.is_pinned = iov_iter_extract_will_pin(ii);
 	ap->args.user_pages = true;
 	if (write)
 		ap->args.in_pages = true;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 8751217aaafa7..83dc806d72056 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -289,6 +289,7 @@ struct fuse_args {
 	bool page_replace:1;
 	bool may_block:1;
 	bool is_ext:1;
+	bool is_pinned:1;
 	struct fuse_in_arg in_args[3];
 	struct fuse_arg out_args[2];
 	void (*end)(struct fuse_mount *fm, struct fuse_args *args, int error);
-- 
2.53.0



