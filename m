Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE07B6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FE0C433C7;
	Sun, 17 Sep 2023 20:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981691;
	bh=I8afsS/pROh/H5mCsYYnSTpOg1pn90Q3A5sq6f4rXF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2JasBnnIUWRaJ2+BvY6m2K26KE3IqfXwioa1i73rkPX3eaaKadAVKHIKOYZD1Jbs
	 /fkOrXGu+3sanqQ7T/z6cM9M6gPIqhKh3blTx+eIAVn1Wu33/2mbGrDFhvgh23p9Yg
	 e0WOVU35DWX9a/OCVzxRl1vMa8Kh4h2gA8XqyWpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 159/219] btrfs: set page extent mapped after read_folio in relocate_one_page
Date: Sun, 17 Sep 2023 21:14:46 +0200
Message-ID: <20230917191046.798232302@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit e7f1326cc24e22b38afc3acd328480a1183f9e79 upstream.

One of the CI runs triggered the following panic

  assertion failed: PagePrivate(page) && page->private, in fs/btrfs/subpage.c:229
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/subpage.c:229!
  Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
  CPU: 0 PID: 923660 Comm: btrfs Not tainted 6.5.0-rc3+ #1
  pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
  pc : btrfs_subpage_assert+0xbc/0xf0
  lr : btrfs_subpage_assert+0xbc/0xf0
  sp : ffff800093213720
  x29: ffff800093213720 x28: ffff8000932138b4 x27: 000000000c280000
  x26: 00000001b5d00000 x25: 000000000c281000 x24: 000000000c281fff
  x23: 0000000000001000 x22: 0000000000000000 x21: ffffff42b95bf880
  x20: ffff42b9528e0000 x19: 0000000000001000 x18: ffffffffffffffff
  x17: 667274622f736620 x16: 6e69202c65746176 x15: 0000000000000028
  x14: 0000000000000003 x13: 00000000002672d7 x12: 0000000000000000
  x11: ffffcd3f0ccd9204 x10: ffffcd3f0554ae50 x9 : ffffcd3f0379528c
  x8 : ffff800093213428 x7 : 0000000000000000 x6 : ffffcd3f091771e8
  x5 : ffff42b97f333948 x4 : 0000000000000000 x3 : 0000000000000000
  x2 : 0000000000000000 x1 : ffff42b9556cde80 x0 : 000000000000004f
  Call trace:
   btrfs_subpage_assert+0xbc/0xf0
   btrfs_subpage_set_dirty+0x38/0xa0
   btrfs_page_set_dirty+0x58/0x88
   relocate_one_page+0x204/0x5f0
   relocate_file_extent_cluster+0x11c/0x180
   relocate_data_extent+0xd0/0xf8
   relocate_block_group+0x3d0/0x4e8
   btrfs_relocate_block_group+0x2d8/0x490
   btrfs_relocate_chunk+0x54/0x1a8
   btrfs_balance+0x7f4/0x1150
   btrfs_ioctl+0x10f0/0x20b8
   __arm64_sys_ioctl+0x120/0x11d8
   invoke_syscall.constprop.0+0x80/0xd8
   do_el0_svc+0x6c/0x158
   el0_svc+0x50/0x1b0
   el0t_64_sync_handler+0x120/0x130
   el0t_64_sync+0x194/0x198
  Code: 91098021 b0007fa0 91346000 97e9c6d2 (d4210000)

This is the same problem outlined in 17b17fcd6d44 ("btrfs:
set_page_extent_mapped after read_folio in btrfs_cont_expand") , and the
fix is the same.  I originally looked for the same pattern elsewhere in
our code, but mistakenly skipped over this code because I saw the page
cache readahead before we set_page_extent_mapped, not realizing that
this was only in the !page case, that we can still end up with a
!uptodate page and then do the btrfs_read_folio further down.

The fix here is the same as the above mentioned patch, move the
set_page_extent_mapped call to after the btrfs_read_folio() block to
make sure that we have the subpage blocksize stuff setup properly before
using the page.

CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/relocation.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2985,9 +2985,6 @@ static int relocate_one_page(struct inod
 		if (!page)
 			return -ENOMEM;
 	}
-	ret = set_page_extent_mapped(page);
-	if (ret < 0)
-		goto release_page;
 
 	if (PageReadahead(page))
 		page_cache_async_readahead(inode->i_mapping, ra, NULL,
@@ -3003,6 +3000,15 @@ static int relocate_one_page(struct inod
 		}
 	}
 
+	/*
+	 * We could have lost page private when we dropped the lock to read the
+	 * page above, make sure we set_page_extent_mapped here so we have any
+	 * of the subpage blocksize stuff we need in place.
+	 */
+	ret = set_page_extent_mapped(page);
+	if (ret < 0)
+		goto release_page;
+
 	page_start = page_offset(page);
 	page_end = page_start + PAGE_SIZE - 1;
 


