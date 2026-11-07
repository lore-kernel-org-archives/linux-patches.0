Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063639;
	b=iyjvW0X4ILaKgJ4oIQ7nKYuYrxbyVEx96BY2Cu5r0RIDAwimjQoDcZmET9f8QuAzje0Q
	 fEbqRQwc+eQJcigOZcl3Z6dV7YR2dZNS3Sn6yBgDeQKeDm02WL7s6Hr5RJF/Oc+fOQHXo
	 2RlNnxd8HZ7x05WvZDjkzG7sVIQOQY0luTe2A3+ZQ27a5u1kNppbM90FPCZzbvKDJDQfR
	 PmmGfKRuSkYZ49KI4OZRPgT9msjgQO2b0W0lYiK3y0ln9FAe61OqWVfR9na2xOTMgWyfm
	 gVizb+vkPl+ctW1pj/9mGLt80EsQkvvnrIm4ruUZmHv9NzhOPGL08S82RF6QytIHA5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OuIy3hAUzvRxqw4dq+UidRWxeszZ1by4tCKlT1wpoqE=;
	b=rvJwEu026hi4MnYcuwNavs383TyU9gVUbCJoqpQ+UGxBnNKTMnvAwe0pRlmgrPsQr17F
	 Q5fSUEVoexwGjkGKYEFVhZ67ZgpxiRh4fpHMSa4eniNs+rhjLHw9LkyUoShQ0bW/emCSt
	 R0RFO3DnLTZpFKdSXFI3ZHdTTPshCHFEoSOtGndPAADw6z7t72Ndk/swp/KBCNgbsXAa7
	 G8WA3k5Bd9FjLHyCvigTnuJnUq6aA5Sckgj+Kl6CEoL8cfza5e1JADBQdY0ZiUcrUDc+C
	 cMq6Qg6LkWF38WamzvnqXFOR8O5AV8XGXHuEjUkskNdYrDXgTsAFaUej2AXP5WNQkwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Shu3zMnr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B84D606A333;
	Sat,  7 Nov 2026 15:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Shu3zMnr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4171F0089F;
	Sat,  7 Nov 2026 15:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063639;
	bh=OuIy3hAUzvRxqw4dq+UidRWxeszZ1by4tCKlT1wpoqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Shu3zMnrRtfbXY5xcSgEPJa17pQL6ZRprBqPE5ViGjrcNoardXaDVkqdrceSPvPFE
	 lhzmq/gr+jo46VzCMGynvYSvOthAYZuxVR+lOqCKUcEuce46u1TM2/G3w4LgieRJo8
	 iQZ8C7TeXdeiUeENTsWyDIrx0bFGyI+GV7/kBuDM=
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
Subject: [PATCH 6.18 754/869] mm/truncate: fix the zeroing end of pagecache_isize_extended()
Date: Sat,  7 Nov 2026 08:57:16 -0500
Message-ID: <20261107134918.300618598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9b1baa688a104..3534bc320a9c5 100644
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



