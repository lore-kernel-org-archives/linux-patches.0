Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026188;
	b=E/6QuYgkQI4oJrn9Jc+VXQZ8O9654sPJpD81fIXLMZV8PE7bVKPqRwU065NQVZP42dHY
	 8FYiHA6A6aeBwtFOE+a6VlnS91CxF7Y4fZktC5fFFWWLYabUPYVcTw/GMBNdGn1eTTzBF
	 psmrQo+5TDn+Iv8MPe0SbDkykrBdZvmoQShb/ng45rO3RwbaBRIElF/qg7+oYQKLptgrw
	 RowZWvkTZUZWukWCnCLklyieTVBV7mj31qJ5a74quab/Gw2qt+8tRPbLEn8XF+F8mu4p1
	 wx5O0uk+JqGvcV734YPYv2bsV7jvnhkET62dT8yKKCXL01G7f9gavqIsi3PYQ6BAxrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a35X6Hhc2nik8iLGkxCA1RvyoR0OHYKKVlHooi/3FNk=;
	b=A21af6XPdUkEenFAEyvrVOe7rB0xCSHnvRQu8u+wKqrZWs5/mtkAVG04IjAyxLHmuCb5
	 3Zw9FB8ADKFF6NNC286ZRN8Re8CuW/Flr6GNn1DPuIp6k5tCfMhO6u9+VlxTcAill1rnL
	 ssIKYXc+QZ0RxxqpEu8PTp3SSK8kKe4GGg4ZvU5QnL0FNTdoSK+NdoqLU6/KimvRv2ct8
	 fOat4mEs5DXnyHHnbbISbNE48WjevbnkBDyNz+EoM/cX9yf5b7h+Z7P4YAYVI1DaVOSMZ
	 N1l6S2szCrGpHrJOBzb6fJZ/SXiS2VO2VXWlJlIEOZ+K5b9zPlen5XifU8uQpISescg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iu4HtsMA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E43760A261A;
	Wed, 18 Nov 2026 18:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iu4HtsMA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1B51F000C6;
	Wed, 18 Nov 2026 18:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026188;
	bh=a35X6Hhc2nik8iLGkxCA1RvyoR0OHYKKVlHooi/3FNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iu4HtsMAk83FK6kr2tWl9xDHPL1GizM6CCx5PgKCfNOye6QXY0Imx91CJD7zIuBft
	 RnfsdlmwNf6f1fDcU8/CKsCp9iFXg7a5Ecu4pQS48/n/FSE18dkiEoa4gSt9jZztQv
	 lpUGTmwf6fAqYYGCrXDII49oxlZaHcWh+7wuHli4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1347/2151] block: take i_rwsem for the direct I/O write fallback
Date: Wed, 18 Nov 2026 15:51:22 +0100
Message-ID: <20261118150211.113283426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 2fec4fd97cc3ce32283aac03b6882d3d36cbd4bb ]

Commit c0e473a0d226 ("block: fix race between set_blocksize and read
paths") closed a race between set_blocksize() and block device I/O: with
large sector size support, set_blocksize() can change i_blkbits and the
mapping's minimum folio order while a concurrent reader still holds a
folio of the old, smaller order, leading to crashes. In particular, it
made blkdev_write_iter() wrap buffered writes in inode_lock_shared().

However, the direct I/O fallback path was missed in that conversion.
blkdev_write_iter() passes blkdev_buffered_write() as an argument to
direct_write_fallback() with no lock held. A direct write that completes
only partially then finishes as a buffered write with no protection.

This can cause a BUG by racing partial direct writes against
ioctl(BLKBSZSET). Writer threads issue O_DIRECT pwritev() with a
two-segment iovec whose second segment is an unreadable PROT_NONE
mapping. The direct path then writes the first segment, fails to pin the
second, and returns short, entering the fallback. A second thread keeps
toggling the second segment's protection so that some fallbacks get past
fault_in_iov_iter_readable() and reach the page cache, a third thread
populates the page cache with folios of the current block size via
pread() and readahead(), and a fourth thread toggles the block size
between 512 bytes and 64K with BLKBSZSET. The minimum folio order only
moves with block sizes above PAGE_SIZE, i.e. with
CONFIG_TRANSPARENT_HUGEPAGE raising BLK_MAX_BLOCK_SIZE to 64K.

On a CONFIG_DEBUG_VM kernel this yields the following BUG:

  page dumped because: VM_BUG_ON_FOLIO(folio_order(folio) < mapping_min_folio_order(mapping))
  kernel BUG at mm/filemap.c:858!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:__filemap_add_folio+0x860/0x8d0
  Call Trace:
   filemap_add_folio+0xc9/0x1f0
   __filemap_get_folio_mpol+0x240/0x660
   iomap_write_begin+0xa87/0xd70
   iomap_file_buffered_write+0x304/0x6a0
   blkdev_write_iter+0x255/0x510
   do_iter_readv_writev+0x23d/0x3c0
   vfs_writev+0x211/0x7d0
   do_pwritev+0x121/0x190
   do_syscall_64+0x121/0x630
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

The same workload also trips WARN_ON_ONCE(pos >= folio_pos(folio) +
fsize) in iomap_trim_folio_range().

Fix this by calling blkdev_buffered_write() in the fallback path under
inode_lock_shared(), matching the plain buffered-write branch. With the
fix the same workload runs clean.

A short IOCB_NOWAIT direct write reaches the same fallback. Taking
i_rwsem there can now block behind set_blocksize(), and the fallback
already blocks on writeback of the data it copied in
direct_write_fallback(). blkdev_write_iter() already rejects a purely
buffered IOCB_NOWAIT write with -EOPNOTSUPP, so do not enter the
fallback for IOCB_NOWAIT at all: return the bytes the direct path
already wrote, or -EAGAIN if none, and let the caller retry.

The reproducer used was written by an LLM, and is available at [1].

[1] https://gist.github.com/tzussman/69d06bc57d42a42989eb038b1b5aeb74

Fixes: 3c20917120ce ("block/bdev: enable large folio support for large logical block sizes")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260730-blk-dontcache-v7-0-3e8e6850068d%40columbia.edu?part=5
Assisted-by: Claude:claude-fable-5
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Link: https://patch.msgid.link/20261009-blkdev-fixes-v6-2-307939c387df@columbia.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index e94ad38f0a426..4b058996fe086 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -815,9 +815,28 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = blkdev_direct_write(iocb, from);
 		if (ret >= 0 && iov_iter_count(from)) {
-			ret = direct_write_fallback(iocb, from, ret,
-					blkdev_buffered_write(iocb, from));
-			need_sync = true;
+			if (iocb->ki_flags & IOCB_NOWAIT) {
+				/*
+				 * The buffered fallback blocks on i_rwsem and
+				 * on writeback of the data it copied: return
+				 * the short direct write instead and let the
+				 * caller retry. The bytes already written
+				 * still need a flush if REQ_FUA was not set.
+				 */
+				if (!ret)
+					ret = -EAGAIN;
+				else if (!blkdev_dio_fua(iocb, bdev))
+					need_sync = true;
+			} else {
+				ssize_t ret2;
+
+				inode_lock_shared(bd_inode);
+				ret2 = blkdev_buffered_write(iocb, from);
+				inode_unlock_shared(bd_inode);
+				ret = direct_write_fallback(iocb, from, ret,
+							    ret2);
+				need_sync = true;
+			}
 		} else if (ret > 0 && !blkdev_dio_fua(iocb, bdev)) {
 			/*
 			 * The device does not support FUA, so REQ_FUA was not
-- 
2.53.0



