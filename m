Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6FA1A0B13;
	Tue, 27 Aug 2024 14:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770356; cv=none; b=LscdK026RxkPMwtWPyQuHpRn29m+/jUcP117w9RHemL145qZuBkMRAQKj/rhbpU76B8BHv/yCiA4fCWhyeNv9BI6OgM64b239V5+6tmu1fKxMls5IhiiscXVorvl81paj7LNIkm1yyxJYpkwjSj+d6RbJngj617HXgLkMWlVe60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770356; c=relaxed/simple;
	bh=WT5Wt4xgOyyEnlL+z954iGYzO4q2PFfPkgDhy3YzjKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsXnVquLgI7TU+tySqrGdGHtAHrTJ7wtnyFoU34okS7n7EGgHKXQZn+Q3NEAwoVqtorEavm2sSmDnhCIUpacpd5fXe6MEKTQsTaxmwU+lTcDZziViECFty4J6rybSEsyME86EAnx1T+wdMLsoGGhshXFPh9Vi9+9mymgVIpuQBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjcLijKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjcLijKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5107DC61042;
	Tue, 27 Aug 2024 14:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770355;
	bh=WT5Wt4xgOyyEnlL+z954iGYzO4q2PFfPkgDhy3YzjKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjcLijKrB25e8z/ovMUDhdOmlRoO62/eQ4L5m+7gx1JT2wWTOqpLH2suw9PVZU5K0
	 28XEMIBtIg7gFEvSTCvowdNAKvvdJQmVAAAuqcujjS5auYqqWQy6rI0fbnamoEZvEv
	 afe8tp1zFF4yylxzTuKG/RSILlLRMjI7pfVzOaRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/341] btrfs: tests: allocate dummy fs_info and root in test_find_delalloc()
Date: Tue, 27 Aug 2024 16:36:58 +0200
Message-ID: <20240827143850.527345178@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit b2136cc288fce2f24a92f3d656531b2d50ebec5a ]

Allocate fs_info and root to have a valid fs_info pointer in case it's
dereferenced by a helper outside of tests, like find_lock_delalloc_range().

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tests/extent-io-tests.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 1cc86af97dc6e..f4fd3fb7c887b 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -11,6 +11,7 @@
 #include "btrfs-tests.h"
 #include "../ctree.h"
 #include "../extent_io.h"
+#include "../disk-io.h"
 #include "../btrfs_inode.h"
 
 #define PROCESS_UNLOCK		(1 << 0)
@@ -105,9 +106,11 @@ static void dump_extent_io_tree(const struct extent_io_tree *tree)
 	}
 }
 
-static int test_find_delalloc(u32 sectorsize)
+static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 {
-	struct inode *inode;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_root *root = NULL;
+	struct inode *inode = NULL;
 	struct extent_io_tree *tmp;
 	struct page *page;
 	struct page *locked_page = NULL;
@@ -121,12 +124,27 @@ static int test_find_delalloc(u32 sectorsize)
 
 	test_msg("running find delalloc tests");
 
+	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
+	if (!fs_info) {
+		test_std_err(TEST_ALLOC_FS_INFO);
+		return -ENOMEM;
+	}
+
+	root = btrfs_alloc_dummy_root(fs_info);
+	if (IS_ERR(root)) {
+		test_std_err(TEST_ALLOC_ROOT);
+		ret = PTR_ERR(root);
+		goto out;
+	}
+
 	inode = btrfs_new_test_inode();
 	if (!inode) {
 		test_std_err(TEST_ALLOC_INODE);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 	tmp = &BTRFS_I(inode)->io_tree;
+	BTRFS_I(inode)->root = root;
 
 	/*
 	 * Passing NULL as we don't have fs_info but tracepoints are not used
@@ -316,6 +334,8 @@ static int test_find_delalloc(u32 sectorsize)
 	process_page_range(inode, 0, total_dirty - 1,
 			   PROCESS_UNLOCK | PROCESS_RELEASE);
 	iput(inode);
+	btrfs_free_dummy_root(root);
+	btrfs_free_dummy_fs_info(fs_info);
 	return ret;
 }
 
@@ -794,7 +814,7 @@ int btrfs_test_extent_io(u32 sectorsize, u32 nodesize)
 
 	test_msg("running extent I/O tests");
 
-	ret = test_find_delalloc(sectorsize);
+	ret = test_find_delalloc(sectorsize, nodesize);
 	if (ret)
 		goto out;
 
-- 
2.43.0



