Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA93813D896;
	Tue, 23 Jul 2024 18:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759542; cv=none; b=EDaGtYOFlrJ0HzY4q17+xenjLTHEq4MZC94icD5J3DoPqLAlzSarojP7KVi7sqCFdWlp4ZQfkFv3nwv+A5xS2BCEPi62AgUZVJj6njGA/lIjX/M/eKwCQopOVFq7tcCO+dEf/9aeDq0A7pX8oHAbi1WtnACCgiCgNic+zXm+SWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759542; c=relaxed/simple;
	bh=vQKwhpGc0RFCe7fsMJOLRUFWTPzB7/W96JDgVqcZWjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQ0IWRP7sUIM+yPd1leWdxdTIepYmTY2YgTTC+FDxZxoSHnb4y42wctipkSKyTpDOkWmdYaCUS7IuWHEdJ3i/c7mwDSPTIBxAPJnkB6jFVc2v0abMpbg92kXKzcYG+Hw8Nb9coaLF63pxG1MdzOUDqQhlx0vBH6NJS7dAY70ZJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmXoXFZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmXoXFZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B81EC4AF0A;
	Tue, 23 Jul 2024 18:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759542;
	bh=vQKwhpGc0RFCe7fsMJOLRUFWTPzB7/W96JDgVqcZWjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmXoXFZXlniua7ddkQ13vOMj0UdhM5LIdTgUrtbDR2wAbIxZiWJEBqY8025Fwuk93
	 O/nouITrZwx+6Hc+eATIuzJTXz3hNx5Mv+Z+fYjJ9ZG89BkD0d4Hb0SI8chSwVvmX/
	 6uRkRrNU5cd6Rg3+DXuAl3aW9HkQTUoBeRM6obOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/129] iomap: Fix iomap_adjust_read_range for plen calculation
Date: Tue, 23 Jul 2024 20:23:13 +0200
Message-ID: <20240723180406.529898226@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

[ Upstream commit f5ceb1bbc98c69536d4673a97315e8427e67de1b ]

If the extent spans the block that contains i_size, we need to handle
both halves separately so that we properly zero data in the page cache
for blocks that are entirely outside of i_size. But this is needed only
when i_size is within the current folio under processing.
"orig_pos + length > isize" can be true for all folios if the mapped
extent length is greater than the folio size. That is making plen to
break for every folio instead of only the last folio.

So use orig_plen for checking if "orig_pos + orig_plen > isize".

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/a32e5f9a4fcfdb99077300c4020ed7ae61d6e0f9.1715067055.git.ritesh.list@gmail.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 129a85633797a..975fd88c1f0f4 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -201,6 +201,7 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 	unsigned block_size = (1 << block_bits);
 	size_t poff = offset_in_folio(folio, *pos);
 	size_t plen = min_t(loff_t, folio_size(folio) - poff, length);
+	size_t orig_plen = plen;
 	unsigned first = poff >> block_bits;
 	unsigned last = (poff + plen - 1) >> block_bits;
 
@@ -237,7 +238,7 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 	 * handle both halves separately so that we properly zero data in the
 	 * page cache for blocks that are entirely outside of i_size.
 	 */
-	if (orig_pos <= isize && orig_pos + length > isize) {
+	if (orig_pos <= isize && orig_pos + orig_plen > isize) {
 		unsigned end = offset_in_folio(folio, isize - 1) >> block_bits;
 
 		if (first <= end && last > end)
-- 
2.43.0



