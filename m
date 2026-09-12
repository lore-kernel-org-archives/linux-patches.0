Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9611E34CFAB;
	Sat, 12 Sep 2026 07:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199581; cv=none; b=OQkpOwO0i2qjW7XpHZOblpgXLjUOMPBRdJgH9x1FXZnNZDsXoIsyldcc/fWsoBfzSbDSa3Bqc3auI8mVKD401gRAJtmYqZaWQM1n2OQ3jzz8VL++0EWKy+ob40CpnQQrZ6h/RlYpF2hE0zSDurEMAGoSB/QIP2B2sDT/m+zQYkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199581; c=relaxed/simple;
	bh=mxcMkrkSAjQotx1f6s+ArsrBYY5K2qGOu2gIEPuKxXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCu6uE/bmCpI979GNXi7932HSG8OsJsEMnpaxtXOB6SdtiWP2XSw2K8W8a//f3LpxG1ciwXwIkKr4sFgcWukhBxAU0nm6/qoJe2BFZqHaGax8ri1h1bvg4jp7rRlFUrNwNpMZkoJfmxO62pklewTmiYKRzemyoaNwBdP39e93tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dt6f+8cm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dt6f+8cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996891F000FF;
	Sat, 12 Sep 2026 07:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199580;
	bh=9WjBENt2iCwC0iyA7b0I6SwqBAbQ9a7e95zlLcnceNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dt6f+8cmWjstjPxdCpV7sATOWJFd4U7NEu/FHeAsxdtmJV/J+eEtYQo5nTHQkbZBm
	 OUdRnfcmme7oYQbGkhFkCIeEbMv2xhAmxZB0/smSCuWvKHQAyVTyO+zE8ABDkaLxCT
	 xuiTRFFknDhL1F9u7v+LVAnVyMg9R3rxZFv4TH4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0614/1815] ext4: skip tail block zeroing for inline data files
Date: Sat, 12 Sep 2026 08:39:24 +0200
Message-ID: <20260912065703.296009917@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 2fff82f081401a61a47e8171f6392d2b0cde5a30 ]

ext4_block_zero_eof() is called from ext4_write_checks() on every
append write beyond EOF. For inline data files, ext4_get_block()
returns -ERANGE when ext4_load_tail_bh() looks up the tail block.
However, this error is currently ignored because the return value
of ext4_get_block() in ext4_load_tail_bh() is discarded.

Before we fix ext4_load_tail_bh() to properly propagate the error,
skip the zeroing for inline data inodes to avoid unnecessary
failures or confusion.

Fixes: 3f60efd65412d ("ext4: zero post-EOF partial block before appending write")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260714080044.4038124-3-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c4eb8171a6444..1ce10bbdcfabf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4234,6 +4234,14 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	offset = from & (blocksize - 1);
 	if (!offset || from >= end)
 		return 0;
+	/*
+	 * Inline data has no tail block to zero out.  Note that a race with
+	 * ext4_page_mkwrite() converting inline data to an extent without
+	 * holding i_rwsem is safe, as that path zeroes the full block before
+	 * copying in the inline data.
+	 */
+	if (ext4_has_inline_data(inode))
+		return 0;
 	/* If we are processing an encrypted inode during orphan list handling */
 	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
 		return 0;
-- 
2.53.0



