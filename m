Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065354;
	b=RCK2isYC0s7diqRF64DF7PA0VA/dR/IJ55Kjlt6UyAhTBFv0ct9UUNHvl5eTujYA7Kxt
	 lgHhaPPzLGkjmxqsx9I1hqeOSG3MLDFw0GvnyDE3cghfnmQtXYxApC5vF35qZijv4tS6N
	 ZWNw6vT2v/KoyVNpY6fgTRhY5lCA8TU4o5mEIh2XhWCmHTQRXiT12J6VQF5sUN7CtbrJE
	 roZNaIwtBzLnheLM0eqIUFyjGacGaB8xl7dEeYsWHZ4pJ5CH9nIBHrTwRrynmyYGjunex
	 OlOsBarxZf4ggfhCWxHeXyBlBaFIO8BVza6F8AZJwsz90klg9zRd/+7AJ5TnBBIs4IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iTs2e6uhC93jTJPIp7tDOKyoKwvb0LaX7bidPJ24Q+E=;
	b=txmKe7W4WRvAvScibEQvM6jZ+GqgH8CbSv1gphdGz3jY7kvRm91H7wwnsBSZRkshJYE0
	 iYic+64697awc1Tx4JbG8AN9JNHEcFwsjpNDzntKqVFb/Guri9eJmQVwSM1PjEJ2Bh8ws
	 nyBe1ixw1qzB3bI0hvFV/LDMDq0s1Qo7CS+zEvWVJBM3TK+diG3+tIm0GGD9BbqPQxU4J
	 RJQu5H4xbFDKlPUMf5eA+cdtBNIx9UguYCG4TuaCjjUPCCCIJQtOj2s+zZ6rZD9zBPtCU
	 Ik83KX+DNl922uvGzFQQDdVBuy6rx2zGkhjSCh8HMMMqhEB3mGfcUSJEVDrvwcfmo/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Vim/EBnq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7963B606A326;
	Sat,  7 Nov 2026 15:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vim/EBnq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4401F0089F;
	Sat,  7 Nov 2026 15:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065354;
	bh=iTs2e6uhC93jTJPIp7tDOKyoKwvb0LaX7bidPJ24Q+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vim/EBnqqY7i8ErGHji2g1Ak6OdulY/l6NgN6lH3B8b7Y1DDCHosD6Q7g3ucwutRJ
	 NFRZU4WYSUT0OeC6d2iWCtKjSfwShMVzK9lM5xK1JstabSOdNNYkGQJZpzXccPqKk+
	 xsPo4kjxaMgcz0ZkqH80LMKrx+TuiACWp11A8XuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Brian Foster <bfoster@redhat.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1091/1257] mm/truncate: fix the zeroing end of pagecache_isize_extended()
Date: Sat,  7 Nov 2026 08:56:27 -0500
Message-ID: <20261107135009.399069858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 8f9039840588dd618c72a726c192126bb7b98228 ]

A process that extends a file by 4 GiB or more past a dirty folio, on a
file system whose block size is smaller than the page size (ext4 with 1k
blocks), reads back the bytes it wrote through a shared mapping beyond the
old end of file instead of zeroes, and a later write into that block
carries them to the disk.  With the example of commit 52aecaee1c26 ("mm:
zero range of eof folio exposed by inode size extension") and the truncate
taken 4 GiB further (pwrite 2k at 0, mmap the first page and write 'X'
over [2k, 4k), truncate(2) to 4 GiB + 2k), the read of [2k, 4k) returns
the 2048 'X' bytes, and a pwrite of 16 bytes at 3k followed by fsync() and
a remount leaves 1008 'X' bytes on the disk in [3k+16, 4k).  No privilege
is needed, and every size extension of 4 GiB or more reaches it:
truncate(2)/ftruncate(2) through truncate_setsize(), writes beyond the end
of file through generic_write_end(), ext4, iomap, btrfs, exfat, ntfs, afs
and orangefs.  Affected since v6.13.

pagecache_isize_extended() zeroes the part of the dirty folio straddling
the old end of file that the size extension exposes, from the old size to
the new size or the end of the folio, whichever comes first:

	end = min_t(unsigned int, to - folio_pos(folio), folio_size(folio));

min_t() converts both operands to unsigned int before comparing, so the
loff_t difference to - folio_pos(folio) is reduced modulo 2^32 first.
When the file grows by 4 GiB or more past the folio, end is that residue
instead of folio_size(folio): below offset nothing is zeroed, above it
only [offset, end) is.  The bytes beyond the old end of file stay in the
dirty folio and, now inside i_size, are file data.

Compare in loff_t; the result is at most folio_size(folio) and fits end.

Found while formally verifying pagecache_isize_extended() against the
kernel binary.

Link: https://lore.kernel.org/20261016222721.791785-1-nickolai@csail.mit.edu
Fixes: 52aecaee1c26 ("mm: zero range of eof folio exposed by inode size extension")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Assisted-by: LLM
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/truncate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 7912d3123170e..29782aced8bad 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -880,8 +880,7 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
 		unsigned int offset, end;
 
 		offset = from - folio_pos(folio);
-		end = min_t(unsigned int, to - folio_pos(folio),
-			    folio_size(folio));
+		end = min_t(loff_t, to - folio_pos(folio), folio_size(folio));
 		folio_zero_segment(folio, offset, end);
 	}
 
-- 
2.53.0



