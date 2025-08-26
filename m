Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B90D21D3C0;
	Tue, 26 Aug 2025 11:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208241; cv=none; b=CGwvoZw1yQs3wVOmXkwI/unTJSjNAn5SqfgiYJjLWpUBrsSMWPiLgbkxZhACfuwKH7bef3ayBIZHK0j9j8o2j23p6uAh0gvr5bZjZimVvY55gooblCa4omovR/sAYCbGVNIcBY589qV8OU83ZXk58dpg158FlMckjOqHmhy5v1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208241; c=relaxed/simple;
	bh=yPbU3q8WpwAx30iasOB8BhuWx+3QctOBf0FIOes9S6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJ7/a8A8nR8V70e9fyb0QJ9fyC4MaddsRhimY7JfitrvZ7nXrn1r0dfh2y4Sl8cu4xLh0coYBgRvT96M8Yg+4FxnvL65a6QnOLkEPEZ5yfk2nph3f0g9ogr8u3FaEl7nd4jsYPs/xQfpr5sg9vU0KLNxJ5dM0T6wItzwana17iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7K+xozu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7K+xozu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC54C4CEF1;
	Tue, 26 Aug 2025 11:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208241;
	bh=yPbU3q8WpwAx30iasOB8BhuWx+3QctOBf0FIOes9S6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7K+xozuQxQXeEvCQXyPyXc8sR0Yoe7tOW3no4aWUDFLKLDIKgB6JouoY+9zvoq8U
	 hNYHfQOhqxHjI9QQx6ByLrjdcVMBrFVQbvCiLdmIyOLdpeaTsfOPzmlN2g6VbwkdBP
	 B8VcXZCB59tCRkVvx9wXCZ2VsKBSBWw7GGXBjVts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 034/322] ext4: fix hole length calculation overflow in non-extent inodes
Date: Tue, 26 Aug 2025 13:07:29 +0200
Message-ID: <20250826110916.187853119@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

commit 02c7f7219ac0e2277b3379a3a0e9841ef464b6d4 upstream.

In a filesystem with a block size larger than 4KB, the hole length
calculation for a non-extent inode in ext4_ind_map_blocks() can easily
exceed INT_MAX. Then it could return a zero length hole and trigger the
following waring and infinite in the iomap infrastructure.

  ------------[ cut here ]------------
  WARNING: CPU: 3 PID: 434101 at fs/iomap/iter.c:34 iomap_iter_done+0x148/0x190
  CPU: 3 UID: 0 PID: 434101 Comm: fsstress Not tainted 6.16.0-rc7+ #128 PREEMPT(voluntary)
  Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
  pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : iomap_iter_done+0x148/0x190
  lr : iomap_iter+0x174/0x230
  sp : ffff8000880af740
  x29: ffff8000880af740 x28: ffff0000db8e6840 x27: 0000000000000000
  x26: 0000000000000000 x25: ffff8000880af830 x24: 0000004000000000
  x23: 0000000000000002 x22: 000001bfdbfa8000 x21: ffffa6a41c002e48
  x20: 0000000000000001 x19: ffff8000880af808 x18: 0000000000000000
  x17: 0000000000000000 x16: ffffa6a495ee6cd0 x15: 0000000000000000
  x14: 00000000000003d4 x13: 00000000fa83b2da x12: 0000b236fc95f18c
  x11: ffffa6a4978b9c08 x10: 0000000000001da0 x9 : ffffa6a41c1a2a44
  x8 : ffff8000880af5c8 x7 : 0000000001000000 x6 : 0000000000000000
  x5 : 0000000000000004 x4 : 000001bfdbfa8000 x3 : 0000000000000000
  x2 : 0000000000000000 x1 : 0000004004030000 x0 : 0000000000000000
  Call trace:
   iomap_iter_done+0x148/0x190 (P)
   iomap_iter+0x174/0x230
   iomap_fiemap+0x154/0x1d8
   ext4_fiemap+0x110/0x140 [ext4]
   do_vfs_ioctl+0x4b8/0xbc0
   __arm64_sys_ioctl+0x8c/0x120
   invoke_syscall+0x6c/0x100
   el0_svc_common.constprop.0+0x48/0xf0
   do_el0_svc+0x24/0x38
   el0_svc+0x38/0x120
   el0t_64_sync_handler+0x10c/0x138
   el0t_64_sync+0x198/0x1a0
  ---[ end trace 0000000000000000 ]---

Cc: stable@kernel.org
Fixes: facab4d9711e ("ext4: return hole from ext4_map_blocks()")
Reported-by: Qu Wenruo <wqu@suse.com>
Closes: https://lore.kernel.org/linux-ext4/9b650a52-9672-4604-a765-bb6be55d1e4a@gmx.com/
Tested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250811064532.1788289-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/indirect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -539,7 +539,7 @@ int ext4_ind_map_blocks(handle_t *handle
 	int indirect_blks;
 	int blocks_to_boundary = 0;
 	int depth;
-	int count = 0;
+	u64 count = 0;
 	ext4_fsblk_t first_block = 0;
 
 	trace_ext4_ind_map_blocks_enter(inode, map->m_lblk, map->m_len, flags);
@@ -588,7 +588,7 @@ int ext4_ind_map_blocks(handle_t *handle
 		count++;
 		/* Fill in size of a hole we found */
 		map->m_pblk = 0;
-		map->m_len = min_t(unsigned int, map->m_len, count);
+		map->m_len = umin(map->m_len, count);
 		goto cleanup;
 	}
 


