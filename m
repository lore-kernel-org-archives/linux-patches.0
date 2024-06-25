Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8F913D62A;
	Tue, 25 Jun 2024 09:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308398; cv=none; b=J8ek4FRVIzjDOkvmf4P/LlttmTmyYYwJw+E/PE1a5QSe6jLVbrIt85hZhxPIkduISMiKPsBynzzIn9BLAhQrCrQLViK/pCUGf4K38MyJS5XpWubO9vIQrrhFf5yVm0BDW0bt4XgZ106EVRvB1q6rzAz2iche6jpdsnrBMrfTw1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308398; c=relaxed/simple;
	bh=0ZayWFmo4iGlLFeYzqRoheLkaJhp4GNvMuNPIojG/R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtmcZ9HOhHpBRqZURWHPA9/gwa2XSrHhA4R+DHDsIJ7uOG44tJhIEcQvKdPHX+08eerge/gGiXjSqO+VlkpRhswhH3vnbG3UPAnE3KvXKgs22YonM+7zpEm/stQAKHlPBOZpC2IX/oWEBS41WikI1j+IbMHOd4ATv71XFIBPNIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhn+/Qhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhn+/Qhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D40BC32781;
	Tue, 25 Jun 2024 09:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308397;
	bh=0ZayWFmo4iGlLFeYzqRoheLkaJhp4GNvMuNPIojG/R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dhn+/QhlpS/klO3fvfssDzcSQMZVnkyW9jJzHrcm5bPKh2Jq9W/+uEwKB1vIFAzYj
	 67Cz0cFyx9OonfQ68l57sOf8Avs/03A2j9zpbnnS+CVKB9YSBcINDnlH6/Dmpf+4B1
	 YskUR5x8uuc+287hcQeEwrx0A7zDg851U7pL4tnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: [PATCH 6.9 108/250] btrfs: zoned: allocate dummy checksums for zoned NODATASUM writes
Date: Tue, 25 Jun 2024 11:31:06 +0200
Message-ID: <20240625085552.218452706@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit cebae292e0c32a228e8f2219c270a7237be24a6a ]

Shin'ichiro reported that when he's running fstests' test-case
btrfs/167 on emulated zoned devices, he's seeing the following NULL
pointer dereference in 'btrfs_zone_finish_endio()':

  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000011: 0000 [#1] PREEMPT SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000088-0x000000000000008f]
  CPU: 4 PID: 2332440 Comm: kworker/u80:15 Tainted: G        W          6.10.0-rc2-kts+ #4
  Hardware name: Supermicro Super Server/X11SPi-TF, BIOS 3.3 02/21/2020
  Workqueue: btrfs-endio-write btrfs_work_helper [btrfs]
  RIP: 0010:btrfs_zone_finish_endio.part.0+0x34/0x160 [btrfs]

  RSP: 0018:ffff88867f107a90 EFLAGS: 00010206
  RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff893e5534
  RDX: 0000000000000011 RSI: 0000000000000004 RDI: 0000000000000088
  RBP: 0000000000000002 R08: 0000000000000001 R09: ffffed1081696028
  R10: ffff88840b4b0143 R11: ffff88834dfff600 R12: ffff88840b4b0000
  R13: 0000000000020000 R14: 0000000000000000 R15: ffff888530ad5210
  FS:  0000000000000000(0000) GS:ffff888e3f800000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f87223fff38 CR3: 00000007a7c6a002 CR4: 00000000007706f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  PKRU: 55555554
  Call Trace:
   <TASK>
   ? __die_body.cold+0x19/0x27
   ? die_addr+0x46/0x70
   ? exc_general_protection+0x14f/0x250
   ? asm_exc_general_protection+0x26/0x30
   ? do_raw_read_unlock+0x44/0x70
   ? btrfs_zone_finish_endio.part.0+0x34/0x160 [btrfs]
   btrfs_finish_one_ordered+0x5d9/0x19a0 [btrfs]
   ? __pfx_lock_release+0x10/0x10
   ? do_raw_write_lock+0x90/0x260
   ? __pfx_do_raw_write_lock+0x10/0x10
   ? __pfx_btrfs_finish_one_ordered+0x10/0x10 [btrfs]
   ? _raw_write_unlock+0x23/0x40
   ? btrfs_finish_ordered_zoned+0x5a9/0x850 [btrfs]
   ? lock_acquire+0x435/0x500
   btrfs_work_helper+0x1b1/0xa70 [btrfs]
   ? __schedule+0x10a8/0x60b0
   ? __pfx___might_resched+0x10/0x10
   process_one_work+0x862/0x1410
   ? __pfx_lock_acquire+0x10/0x10
   ? __pfx_process_one_work+0x10/0x10
   ? assign_work+0x16c/0x240
   worker_thread+0x5e6/0x1010
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x2c3/0x3a0
   ? trace_irq_enable.constprop.0+0xce/0x110
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x31/0x70
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>

Enabling CONFIG_BTRFS_ASSERT revealed the following assertion to
trigger:

  assertion failed: !list_empty(&ordered->list), in fs/btrfs/zoned.c:1815

This indicates, that we're missing the checksums list on the
ordered_extent. As btrfs/167 is doing a NOCOW write this is to be
expected.

Further analysis with drgn confirmed the assumption:

  >>> inode = prog.crashed_thread().stack_trace()[11]['ordered'].inode
  >>> btrfs_inode = drgn.container_of(inode, "struct btrfs_inode", \
         				"vfs_inode")
  >>> print(btrfs_inode.flags)
  (u32)1

As zoned emulation mode simulates conventional zones on regular devices,
we cannot use zone-append for writing. But we're only attaching dummy
checksums if we're doing a zone-append write.

So for NOCOW zoned data writes on conventional zones, also attach a
dummy checksum.

Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Fixes: cbfce4c7fbde ("btrfs: optimize the logical to physical mapping for zoned writes")
CC: Naohiro Aota <Naohiro.Aota@wdc.com> # 6.6+
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/bio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 477f350a8bd09..e3a57196b0ee0 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -741,7 +741,9 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 			ret = btrfs_bio_csum(bbio);
 			if (ret)
 				goto fail_put_bio;
-		} else if (use_append) {
+		} else if (use_append ||
+			   (btrfs_is_zoned(fs_info) && inode &&
+			    inode->flags & BTRFS_INODE_NODATASUM)) {
 			ret = btrfs_alloc_dummy_sum(bbio);
 			if (ret)
 				goto fail_put_bio;
-- 
2.43.0



