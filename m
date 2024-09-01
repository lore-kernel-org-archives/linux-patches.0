Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83322183061;
	Sun,  1 Sep 2024 16:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207619; cv=none; b=GeklFiCTcmPVdu9B/SZTrfA/mTiM4UGTkgT7W+VYT2e89FIeXED6yrp0Y6Wll3HKpT8wkyeMhHBdz/8rkWstKEE+aUQ6xcMvFl7FmnBE9XOt5ERUvrTHNv9+bKtn2fLuL/r0vwUTSp9g5z+r0xWwJxxUBX+DhtrP7vbYpBwH9KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207619; c=relaxed/simple;
	bh=OKZsBfQHlCsVo4qRvTLB49hgMduVcRUbZkiH3WZJC/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GV32LyG6jZpj7jFfPtn+4xc8YVFXRTVKGX0Tx+EsKXIa6IdwJV5oU0A7mhCauRVdDyC/z2DFH6pJXxcvCw4+hLSZzh5tJOBUFt8RHPGBVmH2MQYcKPiOBUqr8wsP+bVqEWOiX0CZmkMMh+mki832V//PVPf9Y3Uac/2ID5H5vgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAJX1/sU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAJX1/sU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5102C4CEC3;
	Sun,  1 Sep 2024 16:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207619;
	bh=OKZsBfQHlCsVo4qRvTLB49hgMduVcRUbZkiH3WZJC/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAJX1/sUC28U8ukKge1wmYDyAbLnVEbc6wk9XnYsbc5Rv8r7WloY+aTuh5OqNv+/6
	 f8SgpW2+IHsSb0mIFrp/o5hbXXfyF+2hUGtFjLnkR4Ge/U2jx9rurGQdvPg3dS9+9m
	 e9aa070jVNOzBOmxn6peGGPs9zriB/O9bF6M+qx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.19 08/98] fix bitmap corruption on close_range() with CLOSE_RANGE_UNSHARE
Date: Sun,  1 Sep 2024 18:15:38 +0200
Message-ID: <20240901160803.999210410@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 9a2fa1472083580b6c66bdaf291f591e1170123a upstream.

copy_fd_bitmaps(new, old, count) is expected to copy the first
count/BITS_PER_LONG bits from old->full_fds_bits[] and fill
the rest with zeroes.  What it does is copying enough words
(BITS_TO_LONGS(count/BITS_PER_LONG)), then memsets the rest.
That works fine, *if* all bits past the cutoff point are
clear.  Otherwise we are risking garbage from the last word
we'd copied.

For most of the callers that is true - expand_fdtable() has
count equal to old->max_fds, so there's no open descriptors
past count, let alone fully occupied words in ->open_fds[],
which is what bits in ->full_fds_bits[] correspond to.

The other caller (dup_fd()) passes sane_fdtable_size(old_fdt, max_fds),
which is the smallest multiple of BITS_PER_LONG that covers all
opened descriptors below max_fds.  In the common case (copying on
fork()) max_fds is ~0U, so all opened descriptors will be below
it and we are fine, by the same reasons why the call in expand_fdtable()
is safe.

Unfortunately, there is a case where max_fds is less than that
and where we might, indeed, end up with junk in ->full_fds_bits[] -
close_range(from, to, CLOSE_RANGE_UNSHARE) with
	* descriptor table being currently shared
	* 'to' being above the current capacity of descriptor table
	* 'from' being just under some chunk of opened descriptors.
In that case we end up with observably wrong behaviour - e.g. spawn
a child with CLONE_FILES, get all descriptors in range 0..127 open,
then close_range(64, ~0U, CLOSE_RANGE_UNSHARE) and watch dup(0) ending
up with descriptor #128, despite #64 being observably not open.

The minimally invasive fix would be to deal with that in dup_fd().
If this proves to add measurable overhead, we can go that way, but
let's try to fix copy_fd_bitmaps() first.

* new helper: bitmap_copy_and_expand(to, from, bits_to_copy, size).
* make copy_fd_bitmaps() take the bitmap size in words, rather than
bits; it's 'count' argument is always a multiple of BITS_PER_LONG,
so we are not losing any information, and that way we can use the
same helper for all three bitmaps - compiler will see that count
is a multiple of BITS_PER_LONG for the large ones, so it'll generate
plain memcpy()+memset().

Reproducer added to tools/testing/selftests/core/close_range_test.c

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c              |   28 ++++++++++++----------------
 include/linux/bitmap.h |   12 ++++++++++++
 2 files changed, 24 insertions(+), 16 deletions(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -41,27 +41,23 @@ static void free_fdtable_rcu(struct rcu_
 #define BITBIT_NR(nr)	BITS_TO_LONGS(BITS_TO_LONGS(nr))
 #define BITBIT_SIZE(nr)	(BITBIT_NR(nr) * sizeof(long))
 
+#define fdt_words(fdt) ((fdt)->max_fds / BITS_PER_LONG) // words in ->open_fds
 /*
  * Copy 'count' fd bits from the old table to the new table and clear the extra
  * space if any.  This does not copy the file pointers.  Called with the files
  * spinlock held for write.
  */
-static void copy_fd_bitmaps(struct fdtable *nfdt, struct fdtable *ofdt,
-			    unsigned int count)
+static inline void copy_fd_bitmaps(struct fdtable *nfdt, struct fdtable *ofdt,
+			    unsigned int copy_words)
 {
-	unsigned int cpy, set;
+	unsigned int nwords = fdt_words(nfdt);
 
-	cpy = count / BITS_PER_BYTE;
-	set = (nfdt->max_fds - count) / BITS_PER_BYTE;
-	memcpy(nfdt->open_fds, ofdt->open_fds, cpy);
-	memset((char *)nfdt->open_fds + cpy, 0, set);
-	memcpy(nfdt->close_on_exec, ofdt->close_on_exec, cpy);
-	memset((char *)nfdt->close_on_exec + cpy, 0, set);
-
-	cpy = BITBIT_SIZE(count);
-	set = BITBIT_SIZE(nfdt->max_fds) - cpy;
-	memcpy(nfdt->full_fds_bits, ofdt->full_fds_bits, cpy);
-	memset((char *)nfdt->full_fds_bits + cpy, 0, set);
+	bitmap_copy_and_extend(nfdt->open_fds, ofdt->open_fds,
+			copy_words * BITS_PER_LONG, nwords * BITS_PER_LONG);
+	bitmap_copy_and_extend(nfdt->close_on_exec, ofdt->close_on_exec,
+			copy_words * BITS_PER_LONG, nwords * BITS_PER_LONG);
+	bitmap_copy_and_extend(nfdt->full_fds_bits, ofdt->full_fds_bits,
+			copy_words, nwords);
 }
 
 /*
@@ -79,7 +75,7 @@ static void copy_fdtable(struct fdtable
 	memcpy(nfdt->fd, ofdt->fd, cpy);
 	memset((char *)nfdt->fd + cpy, 0, set);
 
-	copy_fd_bitmaps(nfdt, ofdt, ofdt->max_fds);
+	copy_fd_bitmaps(nfdt, ofdt, fdt_words(ofdt));
 }
 
 static struct fdtable * alloc_fdtable(unsigned int nr)
@@ -330,7 +326,7 @@ struct files_struct *dup_fd(struct files
 		open_files = count_open_files(old_fdt);
 	}
 
-	copy_fd_bitmaps(new_fdt, old_fdt, open_files);
+	copy_fd_bitmaps(new_fdt, old_fdt, open_files / BITS_PER_LONG);
 
 	old_fds = old_fdt->fd;
 	new_fds = new_fdt->fd;
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -256,6 +256,18 @@ static inline void bitmap_copy_clear_tai
 		dst[nbits / BITS_PER_LONG] &= BITMAP_LAST_WORD_MASK(nbits);
 }
 
+static inline void bitmap_copy_and_extend(unsigned long *to,
+					  const unsigned long *from,
+					  unsigned int count, unsigned int size)
+{
+	unsigned int copy = BITS_TO_LONGS(count);
+
+	memcpy(to, from, copy * sizeof(long));
+	if (count % BITS_PER_LONG)
+		to[copy - 1] &= BITMAP_LAST_WORD_MASK(count);
+	memset(to + copy, 0, bitmap_size(size) - copy * sizeof(long));
+}
+
 /*
  * On 32-bit systems bitmaps are represented as u32 arrays internally, and
  * therefore conversion is not needed when copying data from/to arrays of u32.


