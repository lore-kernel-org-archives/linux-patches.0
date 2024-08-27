Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAE01C5788;
	Tue, 27 Aug 2024 15:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771241; cv=none; b=H4ts/FGCGKPFIo4s+aX+2eetqZvNE6NyhxTFoFPFpv7u+UHiMLIV3lmpYvLFZ4CDhBwGXv3xHmmmlmr/ILKcDntxPJhKS4F5+zrQ+G3j5gQQ9fGz8Z0PAIG0SUFIOp6EVa6w2XkkzS5qz3w/TZlT1DGvnkMrieXo+IwRZL9Eahc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771241; c=relaxed/simple;
	bh=UqkTVO9gN7t60I0Er88heCdBO17coSu9lm5I/tnNj/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OegZTnVSgE7z0mPQKoy4/VbGisSkrHE5YFosl2YKCODAnc1fZkI76ozm8YMXyHpft1vX7I9hwZiKiZq53O9bEx+35Wl2WHKh+ClxLap/mMQx5ylrUPCxbah4xRb2gsCJrMTeyoYDbQjtSwLMcKYBDe8azfKe+0wvA8EUKWo4264=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJh6odc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJh6odc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6F0C4DDF5;
	Tue, 27 Aug 2024 15:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771241;
	bh=UqkTVO9gN7t60I0Er88heCdBO17coSu9lm5I/tnNj/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJh6odc5jZQidQgHN1Pw0N61smVykshgPABuaj1L9gwFEsB8QFiumBF/Ks93fcQyP
	 bU5Js2byhW2QG3msG4J1cf6Owvy4bFciiFtXe3MSlzKeycfs1YH9HI0dRlb5oQIY3s
	 /tsl5A3Z/wMXRBbQjBph0Do7R/m7H0obACTLIcA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Haberland <sth@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 128/273] s390/dasd: Remove DMA alignment
Date: Tue, 27 Aug 2024 16:37:32 +0200
Message-ID: <20240827143838.276224577@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 2a07bb64d80152701d507b1498237ed1b8d83866 ]

This reverts commit bc792884b76f ("s390/dasd: Establish DMA alignment").

Quoting the original commit:
    linux-next commit bf8d08532bc1 ("iomap: add support for dma aligned
    direct-io") changes the alignment requirement to come from the block
    device rather than the block size, and the default alignment
    requirement is 512-byte boundaries. Since DASD I/O has page
    alignments for IDAW/TIDAW requests, let's override this value to
    restore the expected behavior.

I mentioned TIDAW, but that was wrong. TIDAWs have no distinct alignment
requirement (per p. 15-70 of POPS SA22-7832-13):

   Unless otherwise specified, TIDAWs may designate
   a block of main storage on any boundary and length
   up to 4K bytes, provided the specified block does not
   cross a 4 K-byte boundary.

IDAWs do, but the original commit neglected that while ECKD DASD are
typically formatted in 4096-byte blocks, they don't HAVE to be. Formatting
an ECKD volume with smaller blocks is permitted (dasdfmt -b xxx), and the
problematic commit enforces alignment properties to such a device that
will result in errors, such as:

   [test@host ~]# lsdasd -l a367 | grep blksz
     blksz:				512
   [test@host ~]# mkfs.xfs -f /dev/disk/by-path/ccw-0.0.a367-part1
   meta-data=/dev/dasdc1            isize=512    agcount=4, agsize=230075 blks
            =                       sectsz=512   attr=2, projid32bit=1
            =                       crc=1        finobt=1, sparse=1, rmapbt=1
            =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
   data     =                       bsize=4096   blocks=920299, imaxpct=25
            =                       sunit=0      swidth=0 blks
   naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
   log      =internal log           bsize=4096   blocks=16384, version=2
            =                       sectsz=512   sunit=0 blks, lazy-count=1
   realtime =none                   extsz=4096   blocks=0, rtextents=0
   error reading existing superblock: Invalid argument
   mkfs.xfs: pwrite failed: Invalid argument
   libxfs_bwrite: write failed on (unknown) bno 0x70565c/0x100, err=22
   mkfs.xfs: Releasing dirty buffer to free list!
   found dirty buffer (bulk) on free list!
   mkfs.xfs: pwrite failed: Invalid argument
   ...snipped...

The original commit omitted the FBA discipline for just this reason,
but the formatted block size of the other disciplines was overlooked.
The solution to all of this is to revert to the original behavior,
such that the block size can be respected. There were two commits [1]
that moved this code in the interim, so a straight git-revert is not
possible, but the change is straightforward.

But what of the original problem? That was manifested with a direct-io
QEMU guest, where QEMU itself was changed a month or two later with
commit 25474d90aa ("block: use the request length for iov alignment")
such that the blamed kernel commit is unnecessary.

[1] commit 0127a47f58c6 ("dasd: move queue setup to common code")
    commit fde07a4d74e3 ("dasd: use the atomic queue limits API")

Fixes: bc792884b76f ("s390/dasd: Establish DMA alignment")
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://lore.kernel.org/r/20240812125733.126431-2-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_genhd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index 4533dd055ca8e..23d6e638f381d 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -41,7 +41,6 @@ int dasd_gendisk_alloc(struct dasd_block *block)
 		 */
 		.max_segment_size = PAGE_SIZE,
 		.seg_boundary_mask = PAGE_SIZE - 1,
-		.dma_alignment = PAGE_SIZE - 1,
 		.max_segments = USHRT_MAX,
 	};
 	struct gendisk *gdp;
-- 
2.43.0



