Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012883F12CE;
	Tue, 21 Jul 2026 17:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654566; cv=none; b=J0uSwklHvIQAOiCpyzFTaQ2dhEAl5/G9jFM9gH94oxl3oKKTadv9PorowC1XzRDwEGLc+XXtsbw8v9yrcBmSNNDP9LSbipVrjSyv6u6L6/6+7ySB7iObkJjutq3qC5Wk0YjdP/ptQTRi21EMvwz19X7YfJN+Er3mmmKOtZKyaJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654566; c=relaxed/simple;
	bh=HiXavy9TGcuUv4PIEhhV9F/I/7uRPup00ghwlK2Gulo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctFaNjPxMZwRj4pZuT/Rc31vYeSFMQkbmjP2tsNfq6bqedf1RL8QCkivDYOr5Y88X73H23fBocj2+KetXZW67pNycIkfypE5/z4U+gf6X8iGr2JK2zjUuZdx4sAtnCGZWR7Ixn0Xy6cIVHo2PNNkhspwKo16uyUGwyewFwDGI0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0DawGJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0DawGJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CB01F000E9;
	Tue, 21 Jul 2026 17:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654564;
	bh=41r9YJsPXZucVLillndeXMXLc90T+hNH6zIL9r+eQuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0DawGJpmqBcTdHKfifkTXWXDrTpcmU2z1ZIi8bQl3QsaEtwzf/vV1JVIdini4qb9
	 kIzbhUM4s17j7Gc0tqXIr3tkR+bgwxCvDcVJkWnI9QAY/8oQcA4MujeHQ8/Cck93xL
	 Scxc2XBDEdeWdbAFL+s0LM8LTzeceshmWfi2BcEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 7.1 1710/2077] ntfs3: validate split-point offset in indx_insert_into_buffer
Date: Tue, 21 Jul 2026 17:23:03 +0200
Message-ID: <20260721152633.091333704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit f1df9d771df47aa40de6d70949c28720ae1e430d upstream.

indx_insert_into_buffer() computes

    used = used1 - to_copy - sp_size;
    memmove(de_t, Add2Ptr(sp, sp_size), used - le32_to_cpu(hdr1->de_off));

where sp and sp_size come from hdr_find_split().  hdr_find_split()
walks entries by le16_to_cpu(e->size) without validating that each
step stays within hdr->used or that the size field is at least
sizeof(struct NTFS_DE).  index_hdr_check(), the on-load gatekeeper,
only validates header-level fields (used, total, de_off) and does
not walk per-entry sizes.

A crafted NTFS image whose leaf INDEX_HDR reports used == total but
contains one interior NTFS_DE with size = 0xFFF0 therefore passes
validation, descends to indx_insert_into_buffer() through the
ntfs_create() -> indx_insert_entry() path, and makes hdr_find_split()
return an sp whose sp_size (0xFFF0) greatly exceeds the remaining
bytes in the buffer.  The u32 subtraction underflows and the memmove
count becomes a near-4-GiB value, producing an out-of-bounds kernel
write that corrupts adjacent allocations and panics the kernel.

Reproduced on 7.0.0-rc7 with UML + KASAN via a crafted image and a
single 'touch' inside the mounted directory; crash site resolves to
fs/ntfs3/index.c at the memmove.  Trigger requires only local mount
of an attacker-supplied filesystem image (USB, loopback, or removable
media auto-mount).

Reject the split whenever the chosen sp plus its declared size
already extends past hdr1->used.  This is the minimal fix; it
preserves the existing hdr_find_split() contract and relies on the
same out: cleanup path as the pre-existing error returns.

A prior OOB read in the very same indx_insert_into_buffer() memmove
was fixed in commit b8c44949044e ("fs/ntfs3: Fix OOB read in
indx_insert_into_buffer") by tightening hdr_find_e(), but that fix
does not cover the split-point size field path addressed here: sp is
returned by hdr_find_split(), not hdr_find_e(), and the underflow is
driven by sp->size rather than hdr->used exceeding hdr->total.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Cc: stable@vger.kernel.org
Reported-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/index.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1862,6 +1862,20 @@ indx_insert_into_buffer(struct ntfs_inde
 	memcpy(up_e, sp, sp_size);
 
 	used1 = le32_to_cpu(hdr1->used);
+
+	/*
+	 * hdr_find_split does not validate per-entry sizes, so a crafted
+	 * NTFS_DE whose le16 size field is out of range can place sp such
+	 * that (PtrOffset(hdr1, sp) + sp_size) exceeds used1. Without this
+	 * guard the u32 'used = used1 - to_copy - sp_size' underflows and
+	 * the subsequent memmove count becomes a near-4-GiB value,
+	 * triggering an out-of-bounds kernel write.
+	 */
+	if (PtrOffset(hdr1, sp) + sp_size > used1) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	hdr1_saved = kmemdup(hdr1, used1, GFP_NOFS);
 	if (!hdr1_saved) {
 		err = -ENOMEM;


