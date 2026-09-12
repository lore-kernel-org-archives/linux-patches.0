Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E20935F191;
	Sat, 12 Sep 2026 09:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203640; cv=none; b=rYgvhpFfBaTtylNC2eWuzdKormBZfIUVEAJ3pjJdjfxqcTT68xq28+KfE+AdFYIrNIZCjbJYrAROA/oyieW7pB1PbJw3X0u/+gB0X88soEor6u5roTkde9Em6m0sfVo5uFt0FySaFRnOUPhQPQqrqe1JfsJgfI59WpG5x7ZPItQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203640; c=relaxed/simple;
	bh=lCFhCKrFyDSwl+P0pvfhuXBhxWrXt2I/FZ1JzdBgT3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZdXg0TExSe4l0Xc0NQ9X94OuqqRUP6BW4yxlSFncEkUf0LX9U1odczQuedZNT65O9NquPVKUFTxkEPRCFehszkzNA0C3oaH5SKvHtyYCTV4MM9LZLoosYqWurygezEX79qvshVhA/t8K0bk5t2D+un57BMqx8SnX1N2pqLYVSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YebL6pFx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YebL6pFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1461F000FF;
	Sat, 12 Sep 2026 09:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203639;
	bh=/pAW8HzXQNEZFzVqVCS7MgLxDUdJlLTrIeGGSF4kHLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YebL6pFx6D3Nx/wYBd5U9XW6AcGqGe+b+ZBVd1qe9u8QACEuj4WiIfrKQt2Q/s7HQ
	 wJsjayqvD8qGn3SplTE7PzNuIIy+A5O+rCl5NMM+xNaINdC6NM2UKXbwtwM+JLwJUU
	 zf4pyDhmmzNTVhznhGqeqN+BUWYJl95Lbp227XyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1448/1815] fs/ntfs3: reject out-of-range evcn in mi_enum_attr()
Date: Sat, 12 Sep 2026 08:53:18 +0200
Message-ID: <20260912065723.008912924@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit 20fd9f64c0050658f2031e6bd5d552c6f0c8f7e3 ]

In mi_enum_attr(), the start/end VCN validation for non-resident
attributes is:

	if (svcn > evcn + 1) goto out;

When evcn is U64_MAX the "evcn + 1" expression wraps to 0 and any svcn
passes the check. For evcn values close to U64_MAX (but not equal to it)
the right-hand side is still a meaningless near-wrap upper bound, so a
malformed on-disk attribute with svcn == 0 and evcn near U64_MAX can pass
mi_enum_attr() unrejected.

VCN (virtual cluster number) is a cluster index, so any valid evcn is
bounded by the volume's total cluster count, which ntfs3 holds in
sbi->used.bitmap.nbits (set up in ntfs_init_from_boot() before any caller
of mi_enum_attr() runs). Reject evcn values that fall outside this range.

However, an empty non-resident attribute (no allocated clusters) is
legitimately encoded with svcn == 0 and evcn == -1 (U64_MAX), e.g. via
attr->nres.evcn = cpu_to_le64((u64)vcn - 1) with vcn == 0. That sentinel
must keep passing, so exclude evcn == U64_MAX from the range check. The
existing "svcn > evcn + 1" test still tolerates the sentinel ("0 > 0" is
false) and continues to require svcn == 0 for it, while the range check
rejects every other out-of-range evcn and thereby also defuses the
"evcn + 1" wraparound.

svcn does not need its own bound: once evcn < nbits, "svcn > evcn + 1"
implies svcn <= nbits.

Fixes: 013ff63b6494 ("fs/ntfs3: Add more attributes checks in mi_enum_attr()")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
[almaz.alexandrovich@paragon-software.com: fixed evcn check]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/record.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 32bdb034c2a30..4f12ce15b03b4 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -202,7 +202,7 @@ struct ATTRIB *mi_enum_attr(struct ntfs_inode *ni, struct mft_inode *mi,
 	u32 used = le32_to_cpu(rec->used);
 	u32 t32, off, asize, prev_type;
 	u16 t16;
-	u64 data_size, alloc_size, tot_size;
+	u64 svcn, evcn, data_size, alloc_size, tot_size;
 
 	if (!attr) {
 		u32 total = le32_to_cpu(rec->total);
@@ -310,10 +310,38 @@ struct ATTRIB *mi_enum_attr(struct ntfs_inode *ni, struct mft_inode *mi,
 	if (t32 && le16_to_cpu(attr->name_off) + t32 > t16)
 		goto out;
 
-	/* Check start/end vcn. */
-	if (le64_to_cpu(attr->nres.svcn) > le64_to_cpu(attr->nres.evcn) + 1)
+	/*
+	 * Check start/end vcn.  svcn == 0 with evcn == -1 (U64_MAX) is the
+	 * sentinel for an empty non-resident attribute (no allocated
+	 * clusters) and must be accepted: "svcn > evcn + 1" tolerates it,
+	 * since "(u64)-1 + 1" is 0 and "0 > 0" is false.
+	 *
+	 * For a non-empty attribute evcn is a cluster index and must lie
+	 * within the volume (sbi->used.bitmap.nbits, set up in
+	 * ntfs_init_from_boot() before any caller of mi_enum_attr() runs).
+	 * Bounding evcn also prevents a malformed value close to U64_MAX
+	 * from slipping through the near-wrap "evcn + 1" upper bound.
+	 */
+	svcn = le64_to_cpu(attr->nres.svcn);
+	evcn = le64_to_cpu(attr->nres.evcn);
+	if (svcn > evcn + 1)
 		goto out;
 
+	if (is_attr_ext(attr)) {
+		/* sparsed/compressed attribute. */
+#ifdef CONFIG_NTFS3_64BIT_CLUSTER
+		/* No limits. */
+#else
+		/* Check evcn fits into 32 bits. */
+		if (evcn != U64_MAX && evcn >= (1ull << 32))
+			goto out;
+#endif
+	} else {
+		/* Check out of volume for normal attribute. */
+		if (evcn != U64_MAX && evcn >= mi->sbi->used.bitmap.nbits)
+			goto out;
+	}
+
 	data_size = le64_to_cpu(attr->nres.data_size);
 	if (le64_to_cpu(attr->nres.valid_size) > data_size)
 		goto out;
-- 
2.53.0



