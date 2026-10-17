Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6B7E555;
	Sat, 17 Oct 2026 17:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259457; cv=none; b=kxeoabYa2RVAYbxbN3bkM+MaVgKzeqTb+FlDrPr4q0RgLUzohA4EhOAwd/rpGrRejOKDmcoZAk4KE0UBP3Mv5M6ldY8/1KmmEpIyO0OgxqKcQ/EHpbQ5geKRBnYZpXEypQ8trkyYQ7BY314aPcvic35uRFx9sCNiKpv5Hx3QXgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259457; c=relaxed/simple;
	bh=6ggvZ16D3fUwd9ggdhiSRIfhXyC07W4/tvbm/ANcdZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BM1VRBsmZeUDu0S5I7J1Qz7BLpcxHDflgQdvDlHIVNY6AIPrx5M3BLTWUxgC7XneTD5bOgj0ElfTf8JLTCQjV7XNBLDnVRVIMRwo8318qZUXF+iIi3rRBsb68GzQkQray8XPqmA2/o40zzCOUb9tN5lCeHf+3UrVOQjidllT/LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJx9l25P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJx9l25P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F881F000C4;
	Sat, 17 Oct 2026 17:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259455;
	bh=UrwnU8e+ZnlJzWQubYRNdPYRp5F1trGBL8yxNf8k3CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJx9l25Px1K/XAuRFc8QregEdzLIVhzseHwHTxlB/Pk7QlgT/tvagdDGFIj5uzaQL
	 84d5YtGvob2XL9VT69MQx+znumjVY/Uiy9Vi7bYXXg9JYV7Em/xbKXIxDlGnWQQ8Kr
	 RdDR5yewBwNLKpi5NIjlug/BonOpyVFHHiow0avU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Qu Wenruo <wqu@suse.com>,
	Weiming Shi <bestswngs@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1219/1674] btrfs: lzo: reject compressed segment that overflows the compressed input
Date: Sat, 17 Oct 2026 17:58:11 +0200
Message-ID: <20261017160502.433773652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 70b3a3e035a89..222aeb40b26d5 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -392,6 +392,17 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
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



