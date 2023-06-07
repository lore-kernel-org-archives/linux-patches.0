Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674BD34CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 21:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF432C433EF;
	Wed,  7 Jun 2023 21:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171723;
	bh=tSCjI4XQM/4vHCpNuejJ4incqltF/vB8C9iqnvjUhLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXXH523eEUKVwjx0ifrqDsK/YCCV8xzruQawPBEVOfgvFX8mzMLh9+F+mdDEhIPTz
	 cSuhiHy9s158839x+71jVmwugWEw67WQY7hQQePvFto1e0xQMKcr3DX8qdhL/LSpeM
	 TsXh4bNHBDclyVgaNVZPmofQpjdgaF89v5D9vQlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pengfuyuan <pengfuyuan@kylinos.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 125/159] btrfs: fix csum_tree_block page iteration to avoid tripping on -Werror=array-bounds
Date: Wed,  7 Jun 2023 22:17:08 +0200
Message-ID: <20230607200907.770215102@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: pengfuyuan <pengfuyuan@kylinos.cn>

commit 5ad9b4719fc9bc4715c7e19875a962095b0577e7 upstream.

When compiling on a MIPS 64-bit machine we get these warnings:

    In file included from ./arch/mips/include/asm/cacheflush.h:13,
	             from ./include/linux/cacheflush.h:5,
	             from ./include/linux/highmem.h:8,
		     from ./include/linux/bvec.h:10,
		     from ./include/linux/blk_types.h:10,
                     from ./include/linux/blkdev.h:9,
	             from fs/btrfs/disk-io.c:7:
    fs/btrfs/disk-io.c: In function ‘csum_tree_block’:
    fs/btrfs/disk-io.c:100:34: error: array subscript 1 is above array bounds of ‘struct page *[1]’ [-Werror=array-bounds]
      100 |   kaddr = page_address(buf->pages[i]);
          |                        ~~~~~~~~~~^~~
    ./include/linux/mm.h:2135:48: note: in definition of macro ‘page_address’
     2135 | #define page_address(page) lowmem_page_address(page)
          |                                                ^~~~
    cc1: all warnings being treated as errors

We can check if i overflows to solve the problem. However, this doesn't make
much sense, since i == 1 and num_pages == 1 doesn't execute the body of the loop.
In addition, i < num_pages can also ensure that buf->pages[i] will not cross
the boundary. Unfortunately, this doesn't help with the problem observed here:
gcc still complains.

To fix this add a compile-time condition for the extent buffer page
array size limit, which would eventually lead to eliminating the whole
for loop.

CC: stable@vger.kernel.org # 5.10+
Signed-off-by: pengfuyuan <pengfuyuan@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -139,7 +139,7 @@ static void csum_tree_block(struct exten
 	crypto_shash_update(shash, kaddr + BTRFS_CSUM_SIZE,
 			    first_page_part - BTRFS_CSUM_SIZE);
 
-	for (i = 1; i < num_pages; i++) {
+	for (i = 1; i < num_pages && INLINE_EXTENT_BUFFER_PAGES > 1; i++) {
 		kaddr = page_address(buf->pages[i]);
 		crypto_shash_update(shash, kaddr, PAGE_SIZE);
 	}


