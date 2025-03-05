Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE06253F12;
	Wed,  5 Mar 2025 18:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198662; cv=none; b=S9ytc9f+bdaMiXeFby+/OBZjsBdydGgIOl5esOE+NFbnN8GNI/cKdvqDMqNs+OOxro2jSi5LMTVMYaPhB8zlE6glbSmYWbshHgKmYXeGsKeSd8dEYCUNhdLQ4eOQGg6Vt2KRAwZb2ppC/IdG7bRU/5E3oeUajqDm8irve8u8AKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198662; c=relaxed/simple;
	bh=7KztxqK7J6UETmzs+QlnyaKaYZlU7zeBFb0VitGu8Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaOCpCfoUPQ94nkOyMsVM9h/RJTbxXwucUgkFfqh8k8uuMS4ICtApuZkvF7YF630Q9bPJoS6xpbJa+bpUDIPn5Qo2PEN4lflFDF+kbu28xEzVuldbNtsd0Ad+cfGMSrtztkNoFxtA10Ib9EJNVbKM06HnptoJq6yPdmgLA6BB2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3t5jGYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3t5jGYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E6AC4CED1;
	Wed,  5 Mar 2025 18:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198662;
	bh=7KztxqK7J6UETmzs+QlnyaKaYZlU7zeBFb0VitGu8Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3t5jGYBZ8GwJV3dnheNHWU+4R2GGdelndbWafGtBa7T+z1/S2b597mIcEuKlmrlP
	 EIZXb4XwA/yzTw5gwQ3NRqnBqnJFdqSNmIc2oEXZJOKzQV1k4/Qgp/h7yL7RuwnHug
	 eU6v6U4h5N5UVwjDpvwOTGiuInzs9QcSmH36++uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.13 106/157] btrfs: fix data overwriting bug during buffered write when block size < page size
Date: Wed,  5 Mar 2025 18:49:02 +0100
Message-ID: <20250305174509.567776965@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit efa11fd269c139e29b71ec21bc9c9c0063fde40d upstream.

[BUG]
When running generic/418 with a btrfs whose block size < page size
(subpage cases), it always fails.

And the following minimal reproducer is more than enough to trigger it
reliably:

workload()
{
        mkfs.btrfs -s 4k -f $dev > /dev/null
        dmesg -C
        mount $dev $mnt
        $fsstree_dir/src/dio-invalidate-cache -r -b 4096 -n 3 -i 1 -f $mnt/diotest
        ret=$?
        umount $mnt
        stop_trace
        if [ $ret -ne 0 ]; then
                fail
        fi
}

for (( i = 0; i < 1024; i++)); do
        echo "=== $i/$runtime ==="
        workload
done

[CAUSE]
With extra trace printk added to the following functions:
- btrfs_buffered_write()
  * Which folio is touched
  * The file offset (start) where the buffered write is at
  * How many bytes are copied
  * The content of the write (the first 2 bytes)

- submit_one_sector()
  * Which folio is touched
  * The position inside the folio
  * The content of the page cache (the first 2 bytes)

- pagecache_isize_extended()
  * The parameters of the function itself
  * The parameters of the folio_zero_range()

Which are enough to show the problem:

  22.158114: btrfs_buffered_write: folio pos=0 start=0 copied=4096 content=0x0101
  22.158161: submit_one_sector: r/i=5/257 folio=0 pos=0 content=0x0101
  22.158609: btrfs_buffered_write: folio pos=0 start=4096 copied=4096 content=0x0101
  22.158634: btrfs_buffered_write: folio pos=0 start=8192 copied=4096 content=0x0101
  22.158650: pagecache_isize_extended: folio=0 from=4096 to=8192 bsize=4096 zero off=4096 len=8192
  22.158682: submit_one_sector: r/i=5/257 folio=0 pos=4096 content=0x0000
  22.158686: submit_one_sector: r/i=5/257 folio=0 pos=8192 content=0x0101

The tool dio-invalidate-cache will start 3 threads, each doing a buffered
write with 0x01 at offset 0, 4096 and 8192, do a fsync, then do a direct read,
and compare the read buffer with the write buffer.

Note that all 3 btrfs_buffered_write() are writing the correct 0x01 into
the page cache.

But at submit_one_sector(), at file offset 4096, the content is zeroed
out, by pagecache_isize_extended().

The race happens like this:
 Thread A is writing into range [4K, 8K).
 Thread B is writing into range [8K, 12k).

               Thread A              |         Thread B
-------------------------------------+------------------------------------
btrfs_buffered_write()               | btrfs_buffered_write()
|- old_isize = 4K;                   | |- old_isize = 4096;
|- btrfs_inode_lock()                | |
|- write into folio range [4K, 8K)   | |
|- pagecache_isize_extended()        | |
|  extend isize from 4096 to 8192    | |
|  no folio_zero_range() called      | |
|- btrfs_inode_lock()                | |
                                     | |- btrfs_inode_lock()
				     | |- write into folio range [8K, 12K)
				     | |- pagecache_isize_extended()
				     | |  calling folio_zero_range(4K, 8K)
				     | |  This is caused by the old_isize is
				     | |  grabbed too early, without any
				     | |  inode lock.
				     | |- btrfs_inode_unlock()

The @old_isize is grabbed without inode lock, causing race between two
buffered write threads and making pagecache_isize_extended() to zero
range which is still containing cached data.

And this is only affecting subpage btrfs, because for regular blocksize
== page size case, the function pagecache_isize_extended() will do
nothing if the block size >= page size.

[FIX]
Grab the old i_size while holding the inode lock.
This means each buffered write thread will have a stable view of the
old inode size, thus avoid the above race.

CC: stable@vger.kernel.org # 5.15+
Fixes: 5e8b9ef30392 ("btrfs: move pos increment and pagecache extension to btrfs_buffered_write")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1127,7 +1127,7 @@ ssize_t btrfs_buffered_write(struct kioc
 	u64 lockend;
 	size_t num_written = 0;
 	ssize_t ret;
-	loff_t old_isize = i_size_read(inode);
+	loff_t old_isize;
 	unsigned int ilock_flags = 0;
 	const bool nowait = (iocb->ki_flags & IOCB_NOWAIT);
 	unsigned int bdp_flags = (nowait ? BDP_ASYNC : 0);
@@ -1140,6 +1140,13 @@ ssize_t btrfs_buffered_write(struct kioc
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * We can only trust the isize with inode lock held, or it can race with
+	 * other buffered writes and cause incorrect call of
+	 * pagecache_isize_extended() to overwrite existing data.
+	 */
+	old_isize = i_size_read(inode);
+
 	ret = generic_write_checks(iocb, i);
 	if (ret <= 0)
 		goto out;


