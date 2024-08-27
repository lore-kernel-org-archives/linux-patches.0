Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BA71CDA3F;
	Tue, 27 Aug 2024 15:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772725; cv=none; b=iCxgJN+NxIwaIvdDLxZAZiGd7Zpym/FcS5p2OXGSkp0u3xZOvEl46c8pRYlmJb0X2bH1/xog+uFlJnpKrA8JXZycBLppvqZcIPppYvNWVUz6HteC6g2jigeY+uo/XhqkFtPfZIUc1w4OPzvfrHTIh8PqHoKTWF6Pi/ajmFx+Fjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772725; c=relaxed/simple;
	bh=9Ivl/EiSP39sZsGE4pTm3p+A1ZuLTYGOkwy+SPFWhlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UHIeBaOIlGXeB+hL09Gn0y80/1zGMAuo/mf0qGTMHkZyh6dDqpi5Uz+QgeGyFxZ3ZxTQgjCUvSPUxJ1Tnt0ER1jMLIjgOA+sTlOZyU3mrhsZ9czot6mBogt2fqTKzD24zluyiQwbvUqyfs1iUgKAzO2V7VDAUPO9M/qn4ZO8fes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvCdjZfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvCdjZfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2FAC4DE04;
	Tue, 27 Aug 2024 15:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772724;
	bh=9Ivl/EiSP39sZsGE4pTm3p+A1ZuLTYGOkwy+SPFWhlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvCdjZfk+zoT95woMin8dbJDYkCxFRrzK5VyRBy1cIBMHwq8GeD9/wUpNp4x9ENSj
	 8Zk2iEYifV5IlbwoeWQwJjGj4E4LtZsAZVhDPLUkR3DPYYjph1t1EZJry1KvusRwWV
	 poyzGSEMY6kH1FRhWfXhSZyj7jq0WE09bFR9Um8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>
Subject: [PATCH 6.1 299/321] Revert "s390/dasd: Establish DMA alignment"
Date: Tue, 27 Aug 2024 16:40:07 +0200
Message-ID: <20240827143849.637877947@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Jan Höppner" <hoeppner@linux.ibm.com>

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
such that the block size can be respected.

But what of the original problem? That was manifested with a direct-io
QEMU guest, where QEMU itself was changed a month or two later with
commit 25474d90aa ("block: use the request length for iov alignment")
such that the blamed kernel commit is unnecessary.

Note: This is an adapted version of the original upstream commit
2a07bb64d801 ("s390/dasd: Remove DMA alignment").

Cc: stable@vger.kernel.org # 6.0+
Signed-off-by: Jan HÃ¶ppner <hoeppner@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_diag.c |    1 -
 drivers/s390/block/dasd_eckd.c |    1 -
 2 files changed, 2 deletions(-)

--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -639,7 +639,6 @@ static void dasd_diag_setup_blk_queue(st
 	/* With page sized segments each segment can be translated into one idaw/tidaw */
 	blk_queue_max_segment_size(q, PAGE_SIZE);
 	blk_queue_segment_boundary(q, PAGE_SIZE - 1);
-	blk_queue_dma_alignment(q, PAGE_SIZE - 1);
 }
 
 static int dasd_diag_pe_handler(struct dasd_device *device,
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -6889,7 +6889,6 @@ static void dasd_eckd_setup_blk_queue(st
 	/* With page sized segments each segment can be translated into one idaw/tidaw */
 	blk_queue_max_segment_size(q, PAGE_SIZE);
 	blk_queue_segment_boundary(q, PAGE_SIZE - 1);
-	blk_queue_dma_alignment(q, PAGE_SIZE - 1);
 }
 
 static struct ccw_driver dasd_eckd_driver = {


