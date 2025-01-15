Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9510A156644;
	Wed, 15 Jan 2025 10:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938161; cv=none; b=rCzGOfyMCfWQM05gH4w2XT5b8yzvXwwkaqmkjb05ZtS3zwYLM3CJgCTJUf7kk0HNXaeBZ7auhIUlKzSSM7x5cVxoDN7YUh6PHHvtsxu8PnSWCMhcV8Yq9mMWJULrfRcuyg7q9B8Dyhd2HOh2TwnaL12Zfif9UsHQNOfIZLKdn3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938161; c=relaxed/simple;
	bh=zLYlPr1NsnrKp6QlFQrVUn1n0g4PW1TCRjA5V03uBUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btxWKHGaryx5Je1UOOW6ePgwGIfYEcrNw8btMLfMSET2HZqj272PTlQ/ZBdup9sS1/b96k+gb1G8S7P5uDSJudhPP0QGxwxku+oLewd2D7AQ/f3f27ixXJe3p7ZHKzYyakD7NxiYoknv3ea9Q7EV6D8zJbBMQVti5hQ8Uei9juI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuisjV+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuisjV+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C13EC4CEDF;
	Wed, 15 Jan 2025 10:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938161;
	bh=zLYlPr1NsnrKp6QlFQrVUn1n0g4PW1TCRjA5V03uBUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuisjV+eALzNqfH88peIQ/BK3no7OnBxsof8hEkGMWL9yMrOi8NGBfySxXnt2GRek
	 ionl/LI4FIkD05nc0IXn8AAa3F1nhNxdBH7wGOIixnWZA7Tn8zdzm9mWaNldtCwIv2
	 ABBuqLDV7GerZahIc8K//QcJBCF4c8vFPJjxlL4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Qu Wenruo <wqu@suse.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 102/189] btrfs: zlib: fix avail_in bytes for s390 zlib HW compression path
Date: Wed, 15 Jan 2025 11:36:38 +0100
Message-ID: <20250115103610.391886077@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Mikhail Zaslonko <zaslonko@linux.ibm.com>

commit 0ee4736c003daded513de0ff112d4a1e9c85bbab upstream.

Since the input data length passed to zlib_compress_folios() can be
arbitrary, always setting strm.avail_in to a multiple of PAGE_SIZE may
cause read-in bytes to exceed the input range. Currently this triggers
an assert in btrfs_compress_folios() on the debug kernel (see below).
Fix strm.avail_in calculation for S390 hardware acceleration path.

  assertion failed: *total_in <= orig_len, in fs/btrfs/compression.c:1041
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/compression.c:1041!
  monitor event: 0040 ilc:2 [#1] PREEMPT SMP
  CPU: 16 UID: 0 PID: 325 Comm: kworker/u273:3 Not tainted 6.13.0-20241204.rc1.git6.fae3b21430ca.300.fc41.s390x+debug #1
  Hardware name: IBM 3931 A01 703 (z/VM 7.4.0)
  Workqueue: btrfs-delalloc btrfs_work_helper
  Krnl PSW : 0704d00180000000 0000021761df6538 (btrfs_compress_folios+0x198/0x1a0)
             R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
  Krnl GPRS: 0000000080000000 0000000000000001 0000000000000047 0000000000000000
             0000000000000006 ffffff01757bb000 000001976232fcc0 000000000000130c
             000001976232fcd0 000001976232fcc8 00000118ff4a0e30 0000000000000001
             00000111821ab400 0000011100000000 0000021761df6534 000001976232fb58
  Krnl Code: 0000021761df6528: c020006f5ef4        larl    %r2,0000021762be2310
             0000021761df652e: c0e5ffbd09d5        brasl   %r14,00000217615978d8
            #0000021761df6534: af000000            mc      0,0
            >0000021761df6538: 0707                bcr     0,%r7
             0000021761df653a: 0707                bcr     0,%r7
             0000021761df653c: 0707                bcr     0,%r7
             0000021761df653e: 0707                bcr     0,%r7
             0000021761df6540: c004004bb7ec        brcl    0,000002176276d518
  Call Trace:
   [<0000021761df6538>] btrfs_compress_folios+0x198/0x1a0
  ([<0000021761df6534>] btrfs_compress_folios+0x194/0x1a0)
   [<0000021761d97788>] compress_file_range+0x3b8/0x6d0
   [<0000021761dcee7c>] btrfs_work_helper+0x10c/0x160
   [<0000021761645760>] process_one_work+0x2b0/0x5d0
   [<000002176164637e>] worker_thread+0x20e/0x3e0
   [<000002176165221a>] kthread+0x15a/0x170
   [<00000217615b859c>] __ret_from_fork+0x3c/0x60
   [<00000217626e72d2>] ret_from_fork+0xa/0x38
  INFO: lockdep is turned off.
  Last Breaking-Event-Address:
   [<0000021761597924>] _printk+0x4c/0x58
  Kernel panic - not syncing: Fatal exception: panic_on_oops

Fixes: fd1e75d0105d ("btrfs: make compression path to be subpage compatible")
CC: stable@vger.kernel.org # 6.12+
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zlib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index ddf0d5a448a7..c9e92c6941ec 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -174,10 +174,10 @@ int zlib_compress_folios(struct list_head *ws, struct address_space *mapping,
 					copy_page(workspace->buf + i * PAGE_SIZE,
 						  data_in);
 					start += PAGE_SIZE;
-					workspace->strm.avail_in =
-						(in_buf_folios << PAGE_SHIFT);
 				}
 				workspace->strm.next_in = workspace->buf;
+				workspace->strm.avail_in = min(bytes_left,
+							       in_buf_folios << PAGE_SHIFT);
 			} else {
 				unsigned int pg_off;
 				unsigned int cur_len;
-- 
2.48.0



