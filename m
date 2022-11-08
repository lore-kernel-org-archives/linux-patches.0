Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CBF15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F34C433D7;
	Tue,  8 Nov 2022 14:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916376;
	bh=ZRZ3H3FMXExOYhFxgtTexKmolXkmN4nhwL1GaZCP6VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4iyzRAkijYv15VVaEQPgW5OORBDLf9s8RocxjmBNnyg+S1wZAhKrq8dhhO6jUpaL
	 XCHowSfqrP+J5sSMxB6XajX5jk+6H8aTmwIDBX2YgRv63Kddgj2TaZCWsYOuCSUqbM
	 oKBBwOd2C0SxJQKdLyIGACs7gk+SS9DUP+0aS5NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jintao Yin <nicememory@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15 138/144] ext4,f2fs: fix readahead of verity data
Date: Tue,  8 Nov 2022 14:40:15 +0100
Message-Id: <20221108133351.144356297@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 4fa0e3ff217f775cb58d2d6d51820ec519243fb9 upstream.

The recent change of page_cache_ra_unbounded() arguments was buggy in the
two callers, causing us to readahead the wrong pages.  Move the definition
of ractl down to after the index is set correctly.  This affected
performance on configurations that use fs-verity.

Link: https://lkml.kernel.org/r/20221012193419.1453558-1-willy@infradead.org
Fixes: 73bb49da50cd ("mm/readahead: make page_cache_ra_unbounded take a readahead_control")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Jintao Yin <nicememory@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/verity.c |    3 ++-
 fs/f2fs/verity.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -364,13 +364,14 @@ static struct page *ext4_read_merkle_tre
 					       pgoff_t index,
 					       unsigned long num_ra_pages)
 {
-	DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, index);
 	struct page *page;
 
 	index += ext4_verity_metadata_pos(inode) >> PAGE_SHIFT;
 
 	page = find_get_page_flags(inode->i_mapping, index, FGP_ACCESSED);
 	if (!page || !PageUptodate(page)) {
+		DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, index);
+
 		if (page)
 			put_page(page);
 		else if (num_ra_pages > 1)
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -261,13 +261,14 @@ static struct page *f2fs_read_merkle_tre
 					       pgoff_t index,
 					       unsigned long num_ra_pages)
 {
-	DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, index);
 	struct page *page;
 
 	index += f2fs_verity_metadata_pos(inode) >> PAGE_SHIFT;
 
 	page = find_get_page_flags(inode->i_mapping, index, FGP_ACCESSED);
 	if (!page || !PageUptodate(page)) {
+		DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, index);
+
 		if (page)
 			put_page(page);
 		else if (num_ra_pages > 1)


