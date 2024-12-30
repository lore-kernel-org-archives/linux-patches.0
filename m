Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295C215E8B;
	Mon, 30 Dec 2024 15:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574342; cv=none; b=p0Q2/AGqGBu6+2JcOv/WE4ueg/8ovBzjDav0Lnszt/ypD0jScmMoVOVysbNzDZxZfRrq+cQq6byIik7z/LUDH1Kt9f3H8kO22QK8eYMA3fzy0w8HUPvVwLo2uRSVgG4+nZOwPYaq/symkkkv3J7gFarahJ6aQ5/OpYjIWGXNK5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574342; c=relaxed/simple;
	bh=RReZSPyU4hnEgpMhSQ4NA/FAzXM2ZQmrgSj+y7HDHDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3DipbsPls/hC0qog3TG957kQXQ5LAJOVsVD5LaJzDhWkSF/HfpxQsBAT1OJvBhjeTLjqq2/1F7mV7V/xh4v3SKo8uZ/BzfXLZMaxDTJ2zvxmz8dDg4hnmzirdcKVAFlWWGOw0Du4r4uEuTxDVX2tdFag7RoXf/ITMalX0li/TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgUHG8KV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgUHG8KV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFAFC4CED0;
	Mon, 30 Dec 2024 15:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574342;
	bh=RReZSPyU4hnEgpMhSQ4NA/FAzXM2ZQmrgSj+y7HDHDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NgUHG8KVnUwp5nkCiwvSgEpUAu5WRWaURd/qZVJIE3RRCySYaT/XpehRC1Z24RciX
	 P19rjz6JEq/YVlXRajugl0jojfIufiSLapOQmGlQ+iHnLEeHHlHV3PxqUmZYgUipWW
	 h4eA6S1c1ELuoKIm09HrtciKH/YBNwYTI2PnNGRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 108/114] btrfs: check folio mapping after unlock in relocate_one_folio()
Date: Mon, 30 Dec 2024 16:43:45 +0100
Message-ID: <20241230154222.289487935@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Boris Burkov <boris@bur.io>

commit 3e74859ee35edc33a022c3f3971df066ea0ca6b9 upstream.

When we call btrfs_read_folio() to bring a folio uptodate, we unlock the
folio. The result of that is that a different thread can modify the
mapping (like remove it with invalidate) before we call folio_lock().
This results in an invalid page and we need to try again.

In particular, if we are relocating concurrently with aborting a
transaction, this can result in a crash like the following:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP
  CPU: 76 PID: 1411631 Comm: kworker/u322:5
  Workqueue: events_unbound btrfs_reclaim_bgs_work
  RIP: 0010:set_page_extent_mapped+0x20/0xb0
  RSP: 0018:ffffc900516a7be8 EFLAGS: 00010246
  RAX: ffffea009e851d08 RBX: ffffea009e0b1880 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: ffffc900516a7b90 RDI: ffffea009e0b1880
  RBP: 0000000003573000 R08: 0000000000000001 R09: ffff88c07fd2f3f0
  R10: 0000000000000000 R11: 0000194754b575be R12: 0000000003572000
  R13: 0000000003572fff R14: 0000000000100cca R15: 0000000005582fff
  FS:  0000000000000000(0000) GS:ffff88c07fd00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 000000407d00f002 CR4: 00000000007706f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  PKRU: 55555554
  Call Trace:
  <TASK>
  ? __die+0x78/0xc0
  ? page_fault_oops+0x2a8/0x3a0
  ? __switch_to+0x133/0x530
  ? wq_worker_running+0xa/0x40
  ? exc_page_fault+0x63/0x130
  ? asm_exc_page_fault+0x22/0x30
  ? set_page_extent_mapped+0x20/0xb0
  relocate_file_extent_cluster+0x1a7/0x940
  relocate_data_extent+0xaf/0x120
  relocate_block_group+0x20f/0x480
  btrfs_relocate_block_group+0x152/0x320
  btrfs_relocate_chunk+0x3d/0x120
  btrfs_reclaim_bgs_work+0x2ae/0x4e0
  process_scheduled_works+0x184/0x370
  worker_thread+0xc6/0x3e0
  ? blk_add_timer+0xb0/0xb0
  kthread+0xae/0xe0
  ? flush_tlb_kernel_range+0x90/0x90
  ret_from_fork+0x2f/0x40
  ? flush_tlb_kernel_range+0x90/0x90
  ret_from_fork_asm+0x11/0x20
  </TASK>

This occurs because cleanup_one_transaction() calls
destroy_delalloc_inodes() which calls invalidate_inode_pages2() which
takes the folio_lock before setting mapping to NULL. We fail to check
this, and subsequently call set_extent_mapping(), which assumes that
mapping != NULL (in fact it asserts that in debug mode)

Note that the "fixes" patch here is not the one that introduced the
race (the very first iteration of this code from 2009) but a more recent
change that made this particular crash happen in practice.

Fixes: e7f1326cc24e ("btrfs: set page extent mapped after read_folio in relocate_one_page")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/relocation.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2902,6 +2902,7 @@ static int relocate_one_folio(struct rel
 	const bool use_rst = btrfs_need_stripe_tree_update(fs_info, rc->block_group->flags);
 
 	ASSERT(index <= last_index);
+again:
 	folio = filemap_lock_folio(inode->i_mapping, index);
 	if (IS_ERR(folio)) {
 
@@ -2937,6 +2938,11 @@ static int relocate_one_folio(struct rel
 			ret = -EIO;
 			goto release_folio;
 		}
+		if (folio->mapping != inode->i_mapping) {
+			folio_unlock(folio);
+			folio_put(folio);
+			goto again;
+		}
 	}
 
 	/*


