Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDC723B604;
	Mon,  9 Feb 2026 14:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647463; cv=none; b=nMx2RPE9CUkBLP5dcmMgKUjPCdJadS41TSTvvbNpdhImqn3Xnk9guxuZClWnpP+sKy3MVowy0lD8QOdUDDrRPQqRaLtS+sINEOvW/hI4iBnLER8uLWw4RV6CK39tXdtHW4O8zOwQriVnG9FFekcuxh0xvtOp0dkQ+pAnMWlfiyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647463; c=relaxed/simple;
	bh=GTzgn0wvH6nElVwADZlotCtQR4wWo/DvUC0jPC8FJVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bix/1nug+s2+QKMinutvtYH2cLk9kT8+j3NlX00DLwEN50JMxOUzDiKxkeCAlhVb0qm/sI8FPqMMUrNeF1tQAoMAR1Vlw8F0ZcOtEKPVukO0gFDC7naZErosWf6YxMlZaBav+TUbIdKh2/yQSEMyBgCXEV4xwfIHve6LPuhq8Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPFMYwTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPFMYwTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221D4C116C6;
	Mon,  9 Feb 2026 14:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647463;
	bh=GTzgn0wvH6nElVwADZlotCtQR4wWo/DvUC0jPC8FJVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPFMYwTshi6EoyxhfLnIjCqSXrmyKeqsQzJEpLIFscawh/SVG/p56IjlHuwb7WWS0
	 KkbeRDzvTv7eZUEoE/+VUZ9Rnubiqx0SELWTKBCmswRekIKk7d5PI7gAtim9z42gbm
	 CrCMrTZ5EY3wbJFtb1ORYSPTvBJ1CXlPpUqzuUB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b4a2af3000eaa84d95d5@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/175] btrfs: sync read disk super and set block size
Date: Mon,  9 Feb 2026 15:23:00 +0100
Message-ID: <20260209142324.271437324@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 3f29d661e5686f3aa14e6f11537ff5c49846f2e2 ]

When the user performs a btrfs mount, the block device is not set
correctly. The user sets the block size of the block device to 0x4000
by executing the BLKBSZSET command.
Since the block size change also changes the mapping->flags value, this
further affects the result of the mapping_min_folio_order() calculation.

Let's analyze the following two scenarios:

Scenario 1: Without executing the BLKBSZSET command, the block size is
0x1000, and mapping_min_folio_order() returns 0;

Scenario 2: After executing the BLKBSZSET command, the block size is
0x4000, and mapping_min_folio_order() returns 2.

do_read_cache_folio() allocates a folio before the BLKBSZSET command
is executed. This results in the allocated folio having an order value
of 0. Later, after BLKBSZSET is executed, the block size increases to
0x4000, and the mapping_min_folio_order() calculation result becomes 2.

This leads to two undesirable consequences:

1. filemap_add_folio() triggers a VM_BUG_ON_FOLIO(folio_order(folio) <
mapping_min_folio_order(mapping)) assertion.

2. The syzbot report [1] shows a null pointer dereference in
create_empty_buffers() due to a buffer head allocation failure.

Synchronization should be established based on the inode between the
BLKBSZSET command and read cache page to prevent inconsistencies in
block size or mapping flags before and after folio allocation.

[1]
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:create_empty_buffers+0x4d/0x480 fs/buffer.c:1694
Call Trace:
 folio_create_buffers+0x109/0x150 fs/buffer.c:1802
 block_read_full_folio+0x14c/0x850 fs/buffer.c:2403
 filemap_read_folio+0xc8/0x2a0 mm/filemap.c:2496
 do_read_cache_folio+0x266/0x5c0 mm/filemap.c:4096
 do_read_cache_page mm/filemap.c:4162 [inline]
 read_cache_page_gfp+0x29/0x120 mm/filemap.c:4195
 btrfs_read_disk_super+0x192/0x500 fs/btrfs/volumes.c:1367

Reported-by: syzbot+b4a2af3000eaa84d95d5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b4a2af3000eaa84d95d5
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 48e717c105c35..8e7dcb12af4c4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1365,7 +1365,9 @@ struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev,
 				      (bytenr + BTRFS_SUPER_INFO_SIZE) >> PAGE_SHIFT);
 	}
 
+	filemap_invalidate_lock(mapping);
 	page = read_cache_page_gfp(mapping, bytenr >> PAGE_SHIFT, GFP_NOFS);
+	filemap_invalidate_unlock(mapping);
 	if (IS_ERR(page))
 		return ERR_CAST(page);
 
-- 
2.51.0



