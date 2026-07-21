Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1EC46D2D9;
	Tue, 21 Jul 2026 18:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658703; cv=none; b=IN+8gG8hxIyA8tKU3DCtUMsl+XD/wRzcdHOCV7iMRhaHrznEuMZZWKRFPb7jQVKYu/R2dz+vm4ZXUO64A4pSsTz7ZkTY4QkmO56nB+qx3wvavP55LNbU79hJ0iODCalXJBjJrG/tSoaMCteYJuLT5nMkFkk+I0/kZFK/qiLKB9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658703; c=relaxed/simple;
	bh=JnIF1gmQVaYg84egfxzXVPeMsGjiNC4dXDE77hiulZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qtr39c7pf+N0S+dYrC2UJvklTuL2wLwYS1nzejg5B7tn4LVzW1gPXDq5Z+vW3gRmyKfZJV59qg11AoEaEQxdoZSvPw3PH9K9NylLzAeWZ/P9WI/6ZSKPDh8JepLbsBjK+mduiwTnOaKzP1YhPRZyMWq+wXqvlxnDIIorj9ltbss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuappq5x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuappq5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDF61F000E9;
	Tue, 21 Jul 2026 18:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658702;
	bh=G4Au8NlOfaz9q2x/3hAi9NAiMswcmKJsIuXuCBybIXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cuappq5xPgm9LeTmDueRFxxNicJbaRkhtSCxf0Th8umMNfMgPc4JUkokTQAAszpYx
	 /cEjCL4jUeEj7YFpXGI94MVL2Ch94nQ15dXC2EUPZAwSYF2X4+A4nHxDt0FKI+p2cc
	 LUGb7h6BvPeyTjG2P1EGXkMKuQu2rPEftgUaTGxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.18 1242/1611] ntfs3: bound to_move in indx_insert_into_root before hdr_insert_head
Date: Tue, 21 Jul 2026 17:22:38 +0200
Message-ID: <20260721152543.378369347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 9b6926ac9c970ae0b2c2fe6289b16e9aa10b6a67 upstream.

indx_insert_into_root() promotes a full resident $INDEX_ROOT into
$INDEX_ALLOCATION and copies all non-last resident root entries into
a newly allocated INDEX_BUFFER via hdr_insert_head(). The source
byte count 'to_move' is summed from the on-disk resident entry sizes
and is independent of the destination buffer size, which comes from
root->index_block_size (via indx->index_bits).

A crafted NTFS image that keeps a valid, full resident root but
shrinks root->index_block_size down to 512 after the root has been
populated makes hdr_insert_head() memcpy attacker-controlled resident
entry bytes past the end of the kmalloc(1u << indx->index_bits)
allocation returned by indx_new(). For a 512-byte destination and a
resident root whose non-last entries total 560 bytes, the memcpy
overruns by 120 bytes and a following memmove extends the highest
written offset to 136 bytes past the allocation. The overflow bytes
are a direct copy of on-disk entries (via kmemdup), so they are
fully attacker-controlled.

The write is reachable from unprivileged open(O_CREAT) on a mounted
crafted NTFS image: a single sufficiently long create in a directory
whose resident root is already full forces root promotion and
triggers the copy.

This is a controlled out-of-bounds write of 120-136 bytes past a
kmalloc(index_block_size) allocation, with attacker-controlled
content. It is a bounded adjacent-heap corruption primitive; it is
not an arbitrary-address write. Successful exploitation into a named
victim object depends on the surrounding slab layout.

Reject the copy at the sink. The destination's INDEX_HDR already
reports hdr_total (the payload capacity of the new buffer) and
hdr_used (the bytes already consumed by the terminal END entry
installed by indx_new()); require that to_move fits in the remaining
payload before calling hdr_insert_head(). On mismatch, fail with
-EINVAL and mark the filesystem as having a detected on-disk
inconsistency, which is the same behaviour as the surrounding
validation in this function.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/index.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1743,6 +1743,22 @@ static int indx_insert_into_root(struct
 	hdr_used = le32_to_cpu(hdr->used);
 	hdr_total = le32_to_cpu(hdr->total);
 
+	/*
+	 * The destination INDEX_BUFFER has 'hdr_total' bytes of payload
+	 * available after the header, of which 'hdr_used' are already
+	 * consumed by the single terminal END entry installed by
+	 * indx_new(). A crafted image can present a resident root whose
+	 * non-last entries (summing to 'to_move') exceed what fits in
+	 * this buffer; copying them unchecked would overrun the
+	 * kmalloc(1u << indx->index_bits) allocation backing the new
+	 * buffer. Reject the copy in that case.
+	 */
+	if (to_move > hdr_total - hdr_used) {
+		err = -EINVAL;
+		ntfs_set_state(sbi, NTFS_DIRTY_ERROR);
+		goto out_put_n;
+	}
+
 	/* Copy root entries into new buffer. */
 	hdr_insert_head(hdr, re, to_move);
 


