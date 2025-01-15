Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63EC248BD1;
	Wed, 15 Jan 2025 10:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938546; cv=none; b=YijxJQFY3L9v87+hkOmRtNRwqHFQU//NzG8FHrE0a9B6EpRJSYYWCR3FREmhY05ACOjOrnGmtKzmwvLxoJ/Y0TtGWQzt0X199vjgcZ5GKlZWuPdLhRW2+gXUFN0T/Y+GBEyLMjFdtsa2BtPv25mIJpESeI0hk22hMWId28qdEqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938546; c=relaxed/simple;
	bh=TLFJu78FcdHfQUK1pQI7pFiCkTIHht+BduRn2vJddoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cThT44Dqw0t4kz1OipyipDAiowB2FFYM8OV61W7gzAxTxBlaNXy17uCpUK1Dng8D9UwbbEaxZaNH2XcSvgl1aVT+Ro65TGWhLtSlSlL6nSkdGPSKiufN9xKrllkTHoSQUiuzGDRrGBtDFW3SAis88YFHwb9W4krXBZeu/jM9HA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aL95dJw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aL95dJw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C72C4CEDF;
	Wed, 15 Jan 2025 10:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938546;
	bh=TLFJu78FcdHfQUK1pQI7pFiCkTIHht+BduRn2vJddoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aL95dJw0TxVcWkqdio7f0T9ptANHiJlQiSwTL+zPIuNQODDSrxQupUMQmtTLhXb/+
	 YQEike0MHFpQ57HJId9StKzpH54HbssMUSsq1BloU+7fCm+nCNZitnU8w+VOoGcEyN
	 gEBJfQynKGJ/TTcar11eVgIGI9lBnuE81NXrqMi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+339e9dbe3a2ca419b85d@syzkaller.appspotmail.com,
	Anand Jain <anand.jain@oracle.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/129] btrfs: avoid NULL pointer dereference if no valid extent tree
Date: Wed, 15 Jan 2025 11:36:39 +0100
Message-ID: <20250115103555.332641616@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 6aecd91a5c5b68939cf4169e32bc49f3cd2dd329 ]

[BUG]
Syzbot reported a crash with the following call trace:

  BTRFS info (device loop0): scrub: started on devid 1
  BUG: kernel NULL pointer dereference, address: 0000000000000208
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 106e70067 P4D 106e70067 PUD 107143067 PMD 0
  Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 1 UID: 0 PID: 689 Comm: repro Kdump: loaded Tainted: G           O       6.13.0-rc4-custom+ #206
  Tainted: [O]=OOT_MODULE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
  RIP: 0010:find_first_extent_item+0x26/0x1f0 [btrfs]
  Call Trace:
   <TASK>
   scrub_find_fill_first_stripe+0x13d/0x3b0 [btrfs]
   scrub_simple_mirror+0x175/0x260 [btrfs]
   scrub_stripe+0x5d4/0x6c0 [btrfs]
   scrub_chunk+0xbb/0x170 [btrfs]
   scrub_enumerate_chunks+0x2f4/0x5f0 [btrfs]
   btrfs_scrub_dev+0x240/0x600 [btrfs]
   btrfs_ioctl+0x1dc8/0x2fa0 [btrfs]
   ? do_sys_openat2+0xa5/0xf0
   __x64_sys_ioctl+0x97/0xc0
   do_syscall_64+0x4f/0x120
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

[CAUSE]
The reproducer is using a corrupted image where extent tree root is
corrupted, thus forcing to use "rescue=all,ro" mount option to mount the
image.

Then it triggered a scrub, but since scrub relies on extent tree to find
where the data/metadata extents are, scrub_find_fill_first_stripe()
relies on an non-empty extent root.

But unfortunately scrub_find_fill_first_stripe() doesn't really expect
an NULL pointer for extent root, it use extent_root to grab fs_info and
triggered a NULL pointer dereference.

[FIX]
Add an extra check for a valid extent root at the beginning of
scrub_find_fill_first_stripe().

The new error path is introduced by 42437a6386ff ("btrfs: introduce
mount option rescue=ignorebadroots"), but that's pretty old, and later
commit b979547513ff ("btrfs: scrub: introduce helper to find and fill
sector info for a scrub_stripe") changed how we do scrub.

So for kernels older than 6.6, the fix will need manual backport.

Reported-by: syzbot+339e9dbe3a2ca419b85d@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/67756935.050a0220.25abdd.0a12.GAE@google.com/
Fixes: 42437a6386ff ("btrfs: introduce mount option rescue=ignorebadroots")
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a2d91d9f8a10..6be092bb814f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1538,6 +1538,10 @@ static int scrub_find_fill_first_stripe(struct btrfs_block_group *bg,
 	u64 extent_gen;
 	int ret;
 
+	if (unlikely(!extent_root)) {
+		btrfs_err(fs_info, "no valid extent root for scrub");
+		return -EUCLEAN;
+	}
 	memset(stripe->sectors, 0, sizeof(struct scrub_sector_verification) *
 				   stripe->nr_sectors);
 	scrub_stripe_reset_bitmaps(stripe);
-- 
2.39.5



