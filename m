Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060A34E80B5;
	Tue, 13 Oct 2026 12:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893814; cv=none; b=YJLECz4GvlAKSr5Jp6Lzdk3oyp6PSBNGkVZDOSlqaRkqbXWXGC7MyIFIMl+HopICJBcGVPLx/GTH3Zz2NSXUAgwx8l9znWHyaL2ysrtu82BZsKBUDrXeqZ1yBAO6xgEGR2QBTmsjSMjEGPJDqzMGG20s6ji9V3HOx79DKteB6OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893814; c=relaxed/simple;
	bh=DqHUWaNj8/LLENHvzMR5KK8r+PGajMQjl0Bx0ulj9VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyQfMHlzruq6uoN92bZOAZzY/jTReu/VP2C+bXz/3RPdSoU0mtYjE2Pj1nwfPbODmKKBreDzyitkj5CdmIwoseZ+7cgfrOzKsGWRxErgK6PAkzQiXPwG4aHOCByechRqcVV3O2tzmoJ0DjSf24sc0lWB9s601K3HLTzVMoCovkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8IQznjH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8IQznjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF431F000FF;
	Tue, 13 Oct 2026 12:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893812;
	bh=r+zXQY4VQ9axGPxEvWolDL6YOFH0NCjNMEpoVcf93qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8IQznjHYO3NkEEjJ9GZbH7zG++bAN9FEXJuehpjyK4KXOL2PmIDXmh4+XRT5uaK0
	 0MvmwE/mGtPhgc98pN+wQsoeHS/QFnWWzeFhfV9uoA3Q9kF4Z7SKB6XOEnGOqDnaI/
	 wYfB278x62rViOFa97SmZvEGKYeFaEbG8senDbQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Qu Wenruo <wqu@suse.com>,
	Weiming Shi <bestswngs@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 352/621] btrfs: lzo: reject compressed segment that overflows the compressed input
Date: Tue, 13 Oct 2026 13:35:47 +0200
Message-ID: <20261013112929.204691173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit b0d27d43791b7a3057c3c4aedf9b4aa033d37c46 ]

lzo_decompress_bio() validates each on-disk segment length seg_len only
against the workspace cbuf size, not against the compressed input size
(compressed_len, the total folio bytes of the bio).  A crafted extent can
carry a segment whose seg_len passes the cbuf check but runs past the end
of the bio, so copy_compressed_segment() walks off the last folio:
get_current_folio() then returns the NULL folio from bio_next_folio(), and
with CONFIG_BTRFS_ASSERT disabled (default) folio_size(NULL) faults.

 BUG: KASAN: null-ptr-deref in lzo_decompress_bio (fs/btrfs/lzo.c:383)
 Read of size 8 at addr 0000000000000000 by task kworker/u8:1/29
 Workqueue: btrfs-endio simple_end_io_work
  kasan_report (mm/kasan/report.c:590)
  lzo_decompress_bio (fs/btrfs/lzo.c:383)
  end_bbio_compressed_read (fs/btrfs/compression.c:1065)
  btrfs_bio_end_io (fs/btrfs/bio.c:135)
  btrfs_check_read_bio (fs/btrfs/bio.c:180 fs/btrfs/bio.c:285)
  simple_end_io_work
  process_one_work
  worker_thread

Reject any segment whose payload would extend beyond compressed_len before
copying it, treating it as corruption like the other on-disk validation
failures in this function.

Reported-by: Xiang Mei <xmei5@asu.edu>
Fixes: a6e66e6f8c1b ("btrfs: rework lzo_decompress_bio() to make it subpage compatible")
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/lzo.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 6b1cf1e67be72..2f8a73999f946 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -409,6 +409,17 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 			return -EIO;
 		}
 
+		/* The segment must not extend beyond the compressed input. */
+		if (unlikely(cur_in + seg_len > cb->compressed_len)) {
+			struct btrfs_inode *inode = cb->bbio.inode;
+
+			btrfs_err(fs_info,
+			"lzo segment overflows compressed input, root %llu inode %llu offset %llu cur_in %u len %u compressed len %u",
+				  btrfs_root_id(inode->root), btrfs_ino(inode),
+				  cb->start, cur_in, seg_len, cb->compressed_len);
+			return -EUCLEAN;
+		}
+
 		/* Copy the compressed segment payload into workspace */
 		copy_compressed_segment(cb, workspace->cbuf, seg_len, &cur_in);
 
-- 
2.53.0



