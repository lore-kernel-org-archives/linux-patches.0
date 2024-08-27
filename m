Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52B019F485;
	Tue, 27 Aug 2024 15:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772327; cv=none; b=ZFZIGYYXAB8TWdc7r2Ome7/tiEB7L9VDspS/xO1vEf3qdce50Z8gCWJxfssCsLZ435RK16GXnPuOLt0euf8J9JlexQJikMADafff8n4eFQ2I63lcLWwHkXFUarWIUAbCh53UakAf0CVgIyzMTxEOF792sBCfBn3NSvHztoTnJqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772327; c=relaxed/simple;
	bh=oltVRjQcTu4XyXyQYbckKW+n+an05iMYvzFDvwoaRiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jn5sOsLpF8WQX/to8O03VqxmVsLEFm9vRl9cqgUFCrkv+1PKImJlBlc0COZTwKsx4hGe2/JSOSFy8oMMnUeeiNmOkNGYpvmwNAopywM38AUDxses+V5kk4DWkwbffFKEDV9qqcDJfV3c7cAY/oyzkAX70cg4WwIX4uNuYD45bsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxkRFMiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxkRFMiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42493C61071;
	Tue, 27 Aug 2024 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772327;
	bh=oltVRjQcTu4XyXyQYbckKW+n+an05iMYvzFDvwoaRiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxkRFMiY49vHQ+BbGIeX5o6DLXCsJl3ZdfdgejyXC3dPy6eDHe1kBbESsdz+ef7dd
	 SX7b+xmdbklLthp4lBuaWdSBqQX5Suu4i16PmwIKkI3qqmaT+x7PsPzKTXNdAF1RC/
	 VbkruuAnZCz6UkXeBM0CM5x7PTK/TvtlUG8YKesU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 182/321] btrfs: tests: allocate dummy fs_info and root in test_find_delalloc()
Date: Tue, 27 Aug 2024 16:38:10 +0200
Message-ID: <20240827143845.157556793@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 350da449db084..d6a5e6afd5dc0 100644
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
 
@@ -598,7 +618,7 @@ int btrfs_test_extent_io(u32 sectorsize, u32 nodesize)
 
 	test_msg("running extent I/O tests");
 
-	ret = test_find_delalloc(sectorsize);
+	ret = test_find_delalloc(sectorsize, nodesize);
 	if (ret)
 		goto out;
 
-- 
2.43.0



