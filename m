Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3471779C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF93C433EF;
	Thu, 12 Jan 2023 14:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534053;
	bh=KnugLaj1eRa51WEKI9K7xdP440JVqkc2aW6BMb8l9LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zs7GFjWZpxra0OEpzzZwasp2EyN08twXoSYngiq8+9ge1tsm5UVBIwlUU1ReDMSZ8
	 FnSdtMiQHFsMtlZfrK52s8RUq5ieD0TPYTnm4QkRtJ7zqQ2j3qbpOk1UM2BBweUS4g
	 EeY3/G/2vCftZK/oMhKr3YfFDqDhmPFHsCaJlV3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Whitney <enwlinux@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.10 680/783] ext4: fix delayed allocation bug in ext4_clu_mapped for bigalloc + inline
Date: Thu, 12 Jan 2023 14:56:36 +0100
Message-Id: <20230112135555.846816278@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Whitney <enwlinux@gmail.com>

commit 131294c35ed6f777bd4e79d42af13b5c41bf2775 upstream.

When converting files with inline data to extents, delayed allocations
made on a file system created with both the bigalloc and inline options
can result in invalid extent status cache content, incorrect reserved
cluster counts, kernel memory leaks, and potential kernel panics.

With bigalloc, the code that determines whether a block must be
delayed allocated searches the extent tree to see if that block maps
to a previously allocated cluster.  If not, the block is delayed
allocated, and otherwise, it isn't.  However, if the inline option is
also used, and if the file containing the block is marked as able to
store data inline, there isn't a valid extent tree associated with
the file.  The current code in ext4_clu_mapped() calls
ext4_find_extent() to search the non-existent tree for a previously
allocated cluster anyway, which typically finds nothing, as desired.
However, a side effect of the search can be to cache invalid content
from the non-existent tree (garbage) in the extent status tree,
including bogus entries in the pending reservation tree.

To fix this, avoid searching the extent tree when allocating blocks
for bigalloc + inline files that are being converted from inline to
extent mapped.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Link: https://lore.kernel.org/r/20221117152207.2424-1-enwlinux@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5802,6 +5802,14 @@ int ext4_clu_mapped(struct inode *inode,
 	struct ext4_extent *extent;
 	ext4_lblk_t first_lblk, first_lclu, last_lclu;
 
+	/*
+	 * if data can be stored inline, the logical cluster isn't
+	 * mapped - no physical clusters have been allocated, and the
+	 * file has no extents
+	 */
+	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+		return 0;
+
 	/* search for the extent closest to the first block in the cluster */
 	path = ext4_find_extent(inode, EXT4_C2B(sbi, lclu), NULL, 0);
 	if (IS_ERR(path)) {


