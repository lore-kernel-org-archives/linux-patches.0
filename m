Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215703;
	b=LqZCCDYxWRMpnm5YvzqVLORpwStOzqgTi8rwlkq7EKtPPtxZlLWovFbPrl/Pl3tZaW+F
	 ZW/tPbzfAeg/+tkYbT2ARQI8L+QG9+sWET5as1OnHUjS2dmKsJWcWcKAn0GmJNmxKUAOB
	 l6OkYLCpWMugEgrdzcJAij3167pkO7FSIWvjkExZfOVyDEwSJPyaqxoh/iypIOWJckH0n
	 flPo6fsyXZ6TfwTarAtecMiXy/TnfLbxQTlkWcgKmr0PE5zkC6eOK/AlKuQZMSA9jpNUF
	 q/5Y3MDBdZQqi9lqrxRn52lQ+x1f9EjNOiuR1neflWQzUO0IK+wJYpvGJlTofaVdqtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5F6z1Rwg0A39aTJQU/Et9D63t6A5zkkz6exXNNnPQ3U=;
	b=5tyMaT0dSzcOvPnGC8Yy/KPttxzLoH8/zbRhMmUw+0AoGnpvYZkbaOaiRuUsW+zigqU5
	 bQiJUY9RWzocAaudZKh/daNid2Z6wDiyQ/Gav9CpqcQO3oM+j+ugFoBuTW8x+PqWIuAvf
	 ZiiviWjRSrlNhCQ1QcQvJTzEocqM+oBxX8yoJlwAMhhn4Ew4+iKw4oQlKlA1CUR7rG8e8
	 OPxuQaM7v832HBT4dUZfW9n1I8l+sQ5JnK9oRU3gXKzU7vH3Uqk4uBt+fy2xx3g/6Fe3K
	 vv29/FfyEk09QtQisBCl7JpH9fQJSqMAKMl6vqQGunaKB+s8r/eyH2zM4bq5pnGl+Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GoB7ntId;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F353606A31A;
	Wed, 28 Oct 2026 19:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GoB7ntId
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD991F01825;
	Wed, 28 Oct 2026 19:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215702;
	bh=5F6z1Rwg0A39aTJQU/Et9D63t6A5zkkz6exXNNnPQ3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GoB7ntIdOdFOGP/tXLahmodlAfta5S9PQJrXRUcbbcmqOGdWFNLdt1QdMf4toXdq9
	 v3F5ahZOxajcFia1JKWr4njVbS0ngJPMbX5zA/i8z0/8sMbuPJiQTrJCc0QUcrMasv
	 ux3IsKv1D7EreoOzvrroIGZnfnOU8GqGNZ2qOWsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1302/1887] btrfs: lzo: reject inline extents without valid headers
Date: Wed, 28 Oct 2026 17:56:38 +0100
Message-ID: <20261028170529.057582925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 89bc5f825e0a6..79875e9e1cfa3 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -437,7 +437,7 @@ int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	char *kaddr;
 	unsigned long bytes;
 
-	if (srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2)
+	if (srclen <= LZO_LEN * 2 || srclen > max_segment_len + LZO_LEN * 2)
 		return -EUCLEAN;
 
 	in_len = read_compress_length(data_in);
-- 
2.53.0



