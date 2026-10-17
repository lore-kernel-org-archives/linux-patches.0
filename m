Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713113822B7;
	Sat, 17 Oct 2026 16:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254701; cv=none; b=AD7uVNcuxjO7STHp/0GKYmb4sAmZjiMBR+PQDO7u5+a+4uyS2bwB7K+lwCxRbkQKhy0J2qLVU6iHBeS7Gdo8BMfNu8i8GV4FN7tFI84Wtk0d+z+LFTZk7yON9xwiFZMCf66d7Z56qcOiQcXHj1Gq6758iQb+gAdJ0dzTnCQbuEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254701; c=relaxed/simple;
	bh=KeK3cT4kSB+XZiwsOogx1et2L6P8EJJGx5F2nAQe/vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4EOdcxjq9mbqXb54GpeoLJ9cAtY/Oc5unHq58T8Oe04nirBZn7pBWgRtJWXNE5nZBKo4R0bbHvWUnposPVJ9oE+UZOMNYf1RqBYFCcS8PLL1zu+KAvTpRoJW3tUnh44Yj+NQ1EZ4nLH4El1hG6RQo86IWkGo+JB/2puhc9vWfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmyXhgHi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmyXhgHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C676F1F000C4;
	Sat, 17 Oct 2026 16:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254700;
	bh=vxalMwLRbNnz8NcIpPOu6sSinBAMo6BCe/ktEt0at/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmyXhgHiv3F5JQtdFRsQu7Xx9RXIORhdyIv618Ta9QiiXZ1cjmtBNd4eEbaGXKWi3
	 aeTWzyYaG7ee+qqMU0HycOkL+rEFB/FJUi9DGTNCcISNPdgKJcZqoov8ihEUvAl7HP
	 21/hHn/iD+NoXPBG3B3xMQmbBW6wUYhRu062LRCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Qu Wenruo <wqu@suse.com>,
	Weiming Shi <bestswngs@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 533/869] btrfs: lzo: reject compressed segment that overflows the compressed input
Date: Sat, 17 Oct 2026 17:56:14 +0200
Message-ID: <20261017160050.769362913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0d136da8b6be1..f2097e7cab435 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -400,6 +400,17 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
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



