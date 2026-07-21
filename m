Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF04E44AB9D;
	Tue, 21 Jul 2026 21:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670116; cv=none; b=eA7QBF3GwzPKhoYed/aGky/gQD1Vkx5TKMvFLewoXL1pFRAPzq061P8JaggXnqSj3gojRo6lvtnSaxpXYCkfIczZXWfOdBgeoPGILqg/RoeecIZYK1oMe8riNVuGnq4LzthC34pMaSviC6tY+KJ1oMriceix3pMSKWXrCPYooG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670116; c=relaxed/simple;
	bh=9G1Q4kjRRIyPEU8ktbUEjS1gpnm2tUPrhIKCIfnLm5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGXDM3ZiZkk2kx+c1MAwDMsvFrfEgNyUwARudaDzb1EeQDLJRsAn/E9ZBee1bvghqTn8vQOgPPEYeBLrxcyoqwosgMs9wznF+6e/jXhGbf3TvohT+CQr8RqROPWz0RX9pgccv5zo7Z3+kiXXkp9oFpLX52+d5dAl0NoGqhAm3Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZL3E0xu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZL3E0xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7BC1F000E9;
	Tue, 21 Jul 2026 21:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670115;
	bh=TQqP0/2qbahW4l2QAGZbHME/56cscKjukirUbR1iizE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZL3E0xuSt1Rp18XBrKz/VrB1rjR7VkS49ShEt6sQ/SOchJgeTchdRbLej+OXIkbb
	 vkqf9wGKDcjN/cH5PU3ytI0Ze0awP3flY4kFlILt/Nzdf1HLRLXC5wJDoMuQRz5Lr3
	 ufQ4nibbw1bFt1n8J2EBSliqBCaHdTYw1IOBhlh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 0794/1067] ntfs3: bound to_move in indx_insert_into_root before hdr_insert_head
Date: Tue, 21 Jul 2026 17:23:15 +0200
Message-ID: <20260721152442.323210086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1730,6 +1730,22 @@ static int indx_insert_into_root(struct
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
 


