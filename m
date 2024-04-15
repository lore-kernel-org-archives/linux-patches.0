Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C6178281;
	Mon, 15 Apr 2024 14:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191058; cv=none; b=E/NIp9V/GbP0qmXHpPzUVUuUZudGvwtzL3YfHN9YKPlc+EVNR1iHi1Zvl+tvSn/6aRAvE8I5Nu7y0zlQhnIeB6GnhqKY5om5zsaqBkOWo6QjEFZA8oHBhDs7Y56k04q1HXWSAz7ANjIczGz2ZgW+XwJ4Dun6KkGfFx7bC5KVfng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191058; c=relaxed/simple;
	bh=ZwswROdKL0w+fGfpQJeoHV0ZX1BbIhOh5z2ajPZhZks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNXJ5+8IoABuhLEHG4ePUpGsg7vwMjPVYDrmh6ArN0Vnq1/w783Av4bQGnPsIcYzqOr7Z1o/ZXjDmye5YaDpzh9Cf0qxAE8L9gSqvBkiz1QjiBEL9KgN9rgED7wOCdjxEz3kXfune8DQ3w9XuJBO15MzQEK4vePwItY15LrubOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wp02qohA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wp02qohA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD688C2BD10;
	Mon, 15 Apr 2024 14:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191058;
	bh=ZwswROdKL0w+fGfpQJeoHV0ZX1BbIhOh5z2ajPZhZks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wp02qohA4BTdrMAULoZ+LgdI1GMqUewTCrUj4IXY1tYsjir8cEbkgONj7XWQEOB8L
	 nxKQ5H18dI0KmCqPskA6CEFsXQwK2cDRXBlCBE2tNPnXgMC1MMP4F4+qW5lOefVrqE
	 US8WwhdsoxTiXv0I5sqamHm44e75xpChFZNt9RrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 019/172] btrfs: tests: allocate dummy fs_info and root in test_find_delalloc()
Date: Mon, 15 Apr 2024 16:18:38 +0200
Message-ID: <20240415142000.936741169@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

commit b2136cc288fce2f24a92f3d656531b2d50ebec5a upstream.

Allocate fs_info and root to have a valid fs_info pointer in case it's
dereferenced by a helper outside of tests, like find_lock_delalloc_range().

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tests/extent-io-tests.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -11,6 +11,7 @@
 #include "btrfs-tests.h"
 #include "../ctree.h"
 #include "../extent_io.h"
+#include "../disk-io.h"
 #include "../btrfs_inode.h"
 
 #define PROCESS_UNLOCK		(1 << 0)
@@ -105,9 +106,11 @@ static void dump_extent_io_tree(const st
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
@@ -121,12 +124,27 @@ static int test_find_delalloc(u32 sector
 
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
@@ -316,6 +334,8 @@ out:
 	process_page_range(inode, 0, total_dirty - 1,
 			   PROCESS_UNLOCK | PROCESS_RELEASE);
 	iput(inode);
+	btrfs_free_dummy_root(root);
+	btrfs_free_dummy_fs_info(fs_info);
 	return ret;
 }
 
@@ -794,7 +814,7 @@ int btrfs_test_extent_io(u32 sectorsize,
 
 	test_msg("running extent I/O tests");
 
-	ret = test_find_delalloc(sectorsize);
+	ret = test_find_delalloc(sectorsize, nodesize);
 	if (ret)
 		goto out;
 


