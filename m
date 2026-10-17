Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678BF381B0D;
	Sat, 17 Oct 2026 16:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254695; cv=none; b=hFD080yV8gmynpK3y2gsS2Y/4ZDxVQl/CG8Rlb2/pMStxy2gVNcPxF765Qk9TQlSrwSevPEtvzd4DQYuicWUQGZAQC7YLDI3ImbZjCUxiQkJk2TggaiBCK55aZ1i1JWgWd6Kox9yEj5UaFD1MmmaqzNQ1vntp7AhvMnL1jS75rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254695; c=relaxed/simple;
	bh=VTI+ml/RlznqkQxGTUAm8do+KCd+XOewWRDfmwSBnbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhUDzVjnt8CaNfgmie46j4nHYORlR0o4x5YUe0cLvgwDtYEijZPwAB7rsbYZb13uhzvhtWuR4USDxmTjILx39g2s4XQoQbAt08iQASDQhs41182irA+Ag9eYzRBg0X9aexE9aFaEYhvBt9LrCdLNY4jwJiMqt3FdLcM4jFE/uKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpBilvvG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpBilvvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2121F000C4;
	Sat, 17 Oct 2026 16:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254694;
	bh=HlIbuYbYjWlFNUyD3OaHZqaRKCVM8KNz79iu8Mc//M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpBilvvGqYCyOW44nwXh4354SbILMRliiCeIbCR6v5vNdDRwT9e5k1pDxvqIDxe5g
	 lPLgHNGpK0DY1FwZ8bC77/HztJ3sHaaHIFFIdmD8vUP40SAhXRDkF+0jW+wIPEK0eX
	 pJuK1w0sdH/SUn9zhttTqrEukLMNepfURoPVnf4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 514/869] btrfs: lzo: reject inline extents without valid headers
Date: Sat, 17 Oct 2026 17:55:55 +0200
Message-ID: <20261017160050.279299246@linuxfoundation.org>
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

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit 0fa78ef637deb5dbe341582f88553a4bce496de0 ]

[BUG]
For a crafted btrfs image, the following KASAN can be triggered when
reading an inline lzo compressed file extent:

  BUG: KASAN: slab-out-of-bounds in lzo_decompress+0x57d/0x700
  Read of size 4 at addr ffff888006f2e644 by task btrfs_lzo_inlin/77

  Call Trace:
   <TASK>
   dump_stack_lvl+0x5b/0x70
   print_report+0xd1/0x610
   kasan_report+0xe0/0x110
   __asan_report_load_n_noabort+0x13/0x20
   lzo_decompress+0x57d/0x700
   btrfs_decompress+0x140/0x1c0
   uncompress_inline+0x147/0x1b0
   btrfs_get_extent+0xb23/0x10a0
   btrfs_do_readpage.constprop.0+0x538/0x1ac0
   btrfs_readahead+0x32f/0x5f0
   read_pages+0x16f/0x850
   page_cache_ra_unbounded+0x296/0x490
   do_page_cache_ra+0xd9/0x130
   page_cache_sync_ra+0x3ee/0x6f0
   filemap_get_pages+0x306/0x15c0
   filemap_read+0x329/0xd00
   btrfs_file_read_iter+0x1f8/0x2b0
   vfs_read+0x4ef/0x720
   ksys_read+0xf8/0x1d0
   __x64_sys_read+0x71/0xb0
   x64_sys_call+0x1ab0/0x1b70
   do_syscall_64+0x61/0x470
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>

[CAUSE]
For an inline lzo compressed file extent, there should always be one lzo
header, recording the total length of the compressed data, followed by
one segment header, recording the compressed lzo payload.

But if a crafted inline lzo compressed file extent contains only an lzo
header, without the segment header or payload, lzo_decompress() will
still try to read the segment header, causing a read beyond the item
boundary.

Furthermore if the inline lzo compressed file extent is the first item
of the leaf, it will be at the extent buffer boundary. The above
out-of-boundary read will go beyond the extent buffer boundary,
triggering the above KASAN report.

[FIX]
Validate the total length of the inlined lzo compressed file extent, to
make sure there is at least one LZO header and one segment header, and a
non-zero payload.

Fixes: a6fa6fae40ec ("btrfs: Add lzo compression support")
Assisted-by: Codex:gpt-5.5
Signed-off-by: David Lee <david.lee@trailofbits.com>
[ Rework the commit message to remove slop ]
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/lzo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 72856f6775f7f..0d136da8b6be1 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -449,7 +449,7 @@ int lzo_decompress(struct list_head *ws, const u8 *data_in,
 	size_t max_segment_len = WORKSPACE_BUF_LENGTH;
 	int ret = 0;
 
-	if (srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2)
+	if (srclen <= LZO_LEN * 2 || srclen > max_segment_len + LZO_LEN * 2)
 		return -EUCLEAN;
 
 	in_len = read_compress_length(data_in);
-- 
2.53.0



