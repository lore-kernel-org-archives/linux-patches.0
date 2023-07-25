Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A1A1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6B1C433C8;
	Tue, 25 Jul 2023 10:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282745;
	bh=+Lrr2QBCzXLYzHCb6BsVRVYjkB81rtr0uy5TsCVFiQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5RPBsNnBBARLUw36LG1HCICO0QG/ETK7jP2S5kMbwyTjEtNqWPIafqB+GbjVRsyK
	 HLA3JQ2j9KtlibhTWJSunq+prAx4nDCSLJ+5SV0OZmnTkfq6GrQlStp9YA/sVTHFrx
	 MVGmRxCq+x/CxK+gK41wJdhAIstu3A8y6DzC3W3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 012/183] btrfs: set_page_extent_mapped after read_folio in btrfs_cont_expand
Date: Tue, 25 Jul 2023 12:44:00 +0200
Message-ID: <20230725104508.266706795@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josef Bacik <josef@toxicpanda.com>

commit 17b17fcd6d446b95904a6929c40012ee7f0afc0c upstream.

While trying to get the subpage blocksize tests running, I hit the
following panic on generic/476

  assertion failed: PagePrivate(page) && page->private, in fs/btrfs/subpage.c:229
  kernel BUG at fs/btrfs/subpage.c:229!
  Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
  CPU: 1 PID: 1453 Comm: fsstress Not tainted 6.4.0-rc7+ #12
  Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20230301gitf80f052277c8-26.fc38 03/01/2023
  pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
  pc : btrfs_subpage_assert+0xbc/0xf0
  lr : btrfs_subpage_assert+0xbc/0xf0
  Call trace:
   btrfs_subpage_assert+0xbc/0xf0
   btrfs_subpage_clear_checked+0x38/0xc0
   btrfs_page_clear_checked+0x48/0x98
   btrfs_truncate_block+0x5d0/0x6a8
   btrfs_cont_expand+0x5c/0x528
   btrfs_write_check.isra.0+0xf8/0x150
   btrfs_buffered_write+0xb4/0x760
   btrfs_do_write_iter+0x2f8/0x4b0
   btrfs_file_write_iter+0x1c/0x30
   do_iter_readv_writev+0xc8/0x158
   do_iter_write+0x9c/0x210
   vfs_iter_write+0x24/0x40
   iter_file_splice_write+0x224/0x390
   direct_splice_actor+0x38/0x68
   splice_direct_to_actor+0x12c/0x260
   do_splice_direct+0x90/0xe8
   generic_copy_file_range+0x50/0x90
   vfs_copy_file_range+0x29c/0x470
   __arm64_sys_copy_file_range+0xcc/0x498
   invoke_syscall.constprop.0+0x80/0xd8
   do_el0_svc+0x6c/0x168
   el0_svc+0x50/0x1b0
   el0t_64_sync_handler+0x114/0x120
   el0t_64_sync+0x194/0x198

This happens because during btrfs_cont_expand we'll get a page, set it
as mapped, and if it's not Uptodate we'll read it.  However between the
read and re-locking the page we could have called release_folio() on the
page, but left the page in the file mapping.  release_folio() can clear
the page private, and thus further down we blow up when we go to modify
the subpage bits.

Fix this by putting the set_page_extent_mapped() after the read.  This
is safe because read_folio() will call set_page_extent_mapped() before
it does the read, and then if we clear page private but leave it on the
mapping we're completely safe re-setting set_page_extent_mapped().  With
this patch I can now run generic/476 without panicing.

CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4913,9 +4913,6 @@ again:
 		ret = -ENOMEM;
 		goto out;
 	}
-	ret = set_page_extent_mapped(page);
-	if (ret < 0)
-		goto out_unlock;
 
 	if (!PageUptodate(page)) {
 		ret = btrfs_read_folio(NULL, page_folio(page));
@@ -4930,6 +4927,17 @@ again:
 			goto out_unlock;
 		}
 	}
+
+	/*
+	 * We unlock the page after the io is completed and then re-lock it
+	 * above.  release_folio() could have come in between that and cleared
+	 * PagePrivate(), but left the page in the mapping.  Set the page mapped
+	 * here to make sure it's properly set for the subpage stuff.
+	 */
+	ret = set_page_extent_mapped(page);
+	if (ret < 0)
+		goto out_unlock;
+
 	wait_on_page_writeback(page);
 
 	lock_extent(io_tree, block_start, block_end, &cached_state);


