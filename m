Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D72047CC7F;
	Sat, 12 Sep 2026 13:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220018; cv=none; b=b8mb9nlrqzdcAQESCBBP0DLdchrIajBZpzcQaK6aTw9UKyewBUV+rjS0U2UmT32VHZFCAXoP469M3VtKGu3Cunkvze1XcEpiLwuZ64JVXvWKsXaTRd7aV3neKltVepOCSQrt/i0qyhnfGyRqJhhWL/2EW/caS/YynCjLoYU6Atg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220018; c=relaxed/simple;
	bh=NSK1a6m3RrHEzwCN6E2Os7cGVx04gTCHGSzfJkWK+eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4pSylnCQjqI70/JRmquvJuKUn4V3/WoKaLgdP84WMog+XZ2cvgK8SA0GGhiIivfR4JBdTjIG59f971S0Ct8EfO6L7So6fQpTyej4EApQL/oYDcRWCqoEbm2wE99lqdhtvW0qbAOn89RQDB/FHsVpcNn3PhUwqcZvhNT96nSVMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJy0DJ+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJy0DJ+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377B01F000FF;
	Sat, 12 Sep 2026 13:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220017;
	bh=EjeUhZ9ColjuMTWqNmCH/Ds0U6arjA9I+xm6yJyanyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJy0DJ+XtLvyyOK4FwO883vcTyUj1FSrU+uGKG2zAFWlYfrGf/Aw2qdpt30AYYM31
	 sNoE5Y0w1ThNLNj0o66u0cfK61mzKOQcw0miDocvGvgg+kAI30nsvmGDJwomoTxQyZ
	 DbO7P9Dn8fqEa9Pb+z/hht3VOglbYi9v7QQAukm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Page <sam@bynar.io>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 0091/1424] fs/ntfs3: fix info-leak on partial LZNT decompress in ni_read_frame()
Date: Sat, 12 Sep 2026 08:42:03 +0200
Message-ID: <20260912065609.343573760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Page <sam@bynar.io>

commit 35d1ea92c7d946e2ebdbe36cdb2c969c8704bebd upstream.

ni_read_frame() decompresses an LZNT $DATA frame into the vmapped target
pages and then trusts decompress_lznt()'s return value:

  unc_size = decompress_lznt(frame_ondisk, ondisk_size, frame_mem,
                             frame_size);
  if ((ssize_t)unc_size < 0)        err = unc_size;
  else if (!unc_size || unc_size > frame_size)  err = -EINVAL;

decompress_lznt() stops as soon as the compressed stream is exhausted
(e.g. a zero chunk header) and returns the number of bytes it actually
wrote, which may be far less than frame_size. The bytes between unc_size
and frame_size are never written. The only memset() that follows zeroes
the region beyond i_valid; when the frame lies entirely within the file's
valid size that memset() does not run, so the gap retains whatever was in
the just-vmapped pages. All pages are then marked uptodate and returned
to userspace, disclosing uninitialized (recently-freed) kernel page
memory. A crafted compressed file whose stream decompresses to only a few
bytes leaks the remainder of every frame on a plain read(2), which is
enough to recover kernel pointers and defeat KASLR.

Zero the [unc_size, frame_size) tail immediately after a successful LZNT
decompress so the remainder reads back as zero.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Cc: stable@vger.kernel.org
Assisted-by: Bynario AI
Signed-off-by: Samuel Page <sam@bynar.io>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/frecord.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2707,6 +2707,15 @@ int ni_read_frame(struct ntfs_inode *ni,
 			err = unc_size;
 		else if (!unc_size || unc_size > frame_size)
 			err = -EINVAL;
+		else if (unc_size < frame_size) {
+			/*
+			 * Partial decompress: zero the [unc_size, frame_size)
+			 * tail.  decompress_lznt() leaves it untouched, so
+			 * without this the freshly vmapped pages would expose
+			 * uninitialized kernel memory to userspace.
+			 */
+			memset(frame_mem + unc_size, 0, frame_size - unc_size);
+		}
 	}
 	if (!err && valid_size < frame_vbo + frame_size) {
 		size_t ok = valid_size - frame_vbo;


