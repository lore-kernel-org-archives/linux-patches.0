Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE85230988;
	Mon, 10 Mar 2025 17:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627139; cv=none; b=fqHhx3CVOEApeGYpiXp4kUrZFX9qjTRipjg9QD5Yt6lb4oA3GFYXJ96m5S832RvJpme55K55zwb8oAQ4oPi1b4raRzAxKhzvQLNykkJ1dEYcEoGmR3SNddvL7tT1U0tYzTbDfU2j9yWlQsKmuQIfwMWWRrAJb/PSMgpqR3lQJMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627139; c=relaxed/simple;
	bh=xF+VORUlVuibP7c/P3JuoOG6VqUO1TfhjQfNiIUpKo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdRc1LDxpzkqNe/t31jOwH8AE0Sa1WzES+YN/p5eo6oIb5gNA7Z/SsXZbSSfGUNngmGi3X8YzU+57Xt3yDOYKiURNX0NoP+HCBFkJM0QrFfQuq1XMJPl64Rt8ZviFxt/eANFOt8nGna+RwBrnBrjnEu1o5li3W5+eTF+jcvHaEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=buM+2MLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="buM+2MLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD98CC4CEEC;
	Mon, 10 Mar 2025 17:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627139;
	bh=xF+VORUlVuibP7c/P3JuoOG6VqUO1TfhjQfNiIUpKo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buM+2MLGDHNR9A5eQ0QhkIHPrKyVwYdmRhPiARc2ieT7Y3Y+b5fl6ZF6sWs9aN0nB
	 MOij5vlxVXrFt4H83bzlMxljoQ9ffwxSsMJNdMwRdgR5aJJGz8z1QegO6lZbkk8/Ym
	 9v0ayv5Awde52B5wWWTH9QC397uwbiP5edRccyCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/269] btrfs: fix data overwriting bug during buffered write when block size < page size
Date: Mon, 10 Mar 2025 18:02:42 +0100
Message-ID: <20250310170458.075551838@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit efa11fd269c139e29b71ec21bc9c9c0063fde40d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 848cb2c3d9dde..78c4a3765002e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1200,7 +1200,7 @@ ssize_t btrfs_buffered_write(struct kiocb *iocb, struct iov_iter *i)
 	ssize_t ret;
 	bool only_release_metadata = false;
 	bool force_page_uptodate = false;
-	loff_t old_isize = i_size_read(inode);
+	loff_t old_isize;
 	unsigned int ilock_flags = 0;
 	const bool nowait = (iocb->ki_flags & IOCB_NOWAIT);
 	unsigned int bdp_flags = (nowait ? BDP_ASYNC : 0);
@@ -1212,6 +1212,13 @@ ssize_t btrfs_buffered_write(struct kiocb *iocb, struct iov_iter *i)
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
-- 
2.39.5



