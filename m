Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADCF1A0728;
	Fri, 17 Oct 2025 15:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715910; cv=none; b=aQRDnlFCLc4NaJeEALTf/GinuMh8JzPblSzhqFiLTUtTWe8T60vdwzq8INGjDyzctV4ALT75iqUT2wThAYu8H3cf2OmaHcxYEvxuy/u2lBjHE46aqC0o/RSwQ3ae6xZSCi5Mm11Iqjw7YG9DTl7OJ3A3jfbzx4tcjYYt3nuyD7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715910; c=relaxed/simple;
	bh=j6j6+CoMgMDrsz8JwYg8HM0UCLcNHdSmCOWJ2b0yKqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i77p9TQc0KqTxCgTy8BWceumEiE0/0fpHY8Pr2DKs5kH3vHI6hlH9NkeFUtb8oZ2g1rIe4mxTQDKtJkiKuc+LeugB6uLIBpr1MQPulaYGL/p7YX9lgw5pOChtrv4JaenjpdTxgq+Z9MfyzhnUoUAVnjk/a5tjaqB+nebu4I6bRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNk79abc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNk79abc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEE9C4CEE7;
	Fri, 17 Oct 2025 15:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715910;
	bh=j6j6+CoMgMDrsz8JwYg8HM0UCLcNHdSmCOWJ2b0yKqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNk79abc4QMQPZA63L1eqMlrV48z3RTgtciXwMvriIwvtxHPceTfJVJyK/IRcdr7G
	 BYPf6wRAyQtvqANrO7PPYo5oV6FZCAZ4bV0Ylh/QxPrujNtemTO2yBhP2S8ROCs644
	 qpdw6zEi03t2QY5qjCEQS5k5Sh/LawHCyo2SHWIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jan Kara <jack@suse.cz>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.17 339/371] ext4: fail unaligned direct IO write with EINVAL
Date: Fri, 17 Oct 2025 16:55:14 +0200
Message-ID: <20251017145214.347947647@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 963845748fe67125006859229487b45485564db7 upstream.

Commit bc264fea0f6f ("iomap: support incremental iomap_iter advances")
changed the error handling logic in iomap_iter(). Previously any error
from iomap_dio_bio_iter() got propagated to userspace, after this commit
if ->iomap_end returns error, it gets propagated to userspace instead of
an error from iomap_dio_bio_iter(). This results in unaligned writes to
ext4 to silently fallback to buffered IO instead of erroring out.

Now returning ENOTBLK for DIO writes from ext4_iomap_end() seems
unnecessary these days. It is enough to return ENOTBLK from
ext4_iomap_begin() when we don't support DIO write for that particular
file offset (due to hole).

Fixes: bc264fea0f6f ("iomap: support incremental iomap_iter advances")
Cc: stable@kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Message-ID: <20250901112739.32484-2-jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5b7a15db4953..c3b23c90fd11 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3872,47 +3872,12 @@ static int ext4_iomap_overwrite_begin(struct inode *inode, loff_t offset,
 	return ret;
 }
 
-static inline bool ext4_want_directio_fallback(unsigned flags, ssize_t written)
-{
-	/* must be a directio to fall back to buffered */
-	if ((flags & (IOMAP_WRITE | IOMAP_DIRECT)) !=
-		    (IOMAP_WRITE | IOMAP_DIRECT))
-		return false;
-
-	/* atomic writes are all-or-nothing */
-	if (flags & IOMAP_ATOMIC)
-		return false;
-
-	/* can only try again if we wrote nothing */
-	return written == 0;
-}
-
-static int ext4_iomap_end(struct inode *inode, loff_t offset, loff_t length,
-			  ssize_t written, unsigned flags, struct iomap *iomap)
-{
-	/*
-	 * Check to see whether an error occurred while writing out the data to
-	 * the allocated blocks. If so, return the magic error code for
-	 * non-atomic write so that we fallback to buffered I/O and attempt to
-	 * complete the remainder of the I/O.
-	 * For non-atomic writes, any blocks that may have been
-	 * allocated in preparation for the direct I/O will be reused during
-	 * buffered I/O. For atomic write, we never fallback to buffered-io.
-	 */
-	if (ext4_want_directio_fallback(flags, written))
-		return -ENOTBLK;
-
-	return 0;
-}
-
 const struct iomap_ops ext4_iomap_ops = {
 	.iomap_begin		= ext4_iomap_begin,
-	.iomap_end		= ext4_iomap_end,
 };
 
 const struct iomap_ops ext4_iomap_overwrite_ops = {
 	.iomap_begin		= ext4_iomap_overwrite_begin,
-	.iomap_end		= ext4_iomap_end,
 };
 
 static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
-- 
2.51.0



