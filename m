Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F12356744;
	Sat, 12 Sep 2026 11:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211234; cv=none; b=hzHuX3Tc1XzoobPjLtmz620qGHPIdGY4fOcYAfkBljyS5AVjXebIOccYHw103bgCK9B6jBkyt7DG9m8nWlZlXlTlgXQfj5V3qx22ENWOkG49ags67gpiu1ZoDP4pzzxjpgg9ssX/XeQkO2gapOe7rQ+Zi8uOqT9jRnc61BhI0lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211234; c=relaxed/simple;
	bh=wZwyXBuVqMI62jqCu/gfoGqWTVApEnSn6xfHqsHCnHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+wCmki7bTRT1nyOOhoMhFfsgq00mk8S+J8sgQ/B49/4C0mEqIfbOh0IwLqVqvEeY5tgmdyoruUMSJyFF8IEX15ImW7eCa9brctqmdFRHCdzzCBBZRnqxFwozlq9K6nQdzvp3enM8IXkWc4JVDQvsXcAWr+hq1gN1e70wNl4tP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6Bc71NR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6Bc71NR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198F81F000FF;
	Sat, 12 Sep 2026 11:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211233;
	bh=ArBx4wEdprzlaKIwGi+I05FXUS34tZlljsula4wStEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6Bc71NRnLlwcAW8rPdrnb/e0kBell7SZCtYDgi0t5wfWCOd8V1q4Lx/+r0mufVgy
	 neR6poR7izXwiP6p/3BmkfBbZHSrVp55Xb+oVcIem0Xup4xbySci8k2oYBniXkT3vv
	 8jQvxhmVRHpFkwSnJYipOHASS7SqRa8mwiPzfoCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1187/1518] fs/ntfs3: reject out-of-range evcn in mi_enum_attr()
Date: Sat, 12 Sep 2026 08:55:56 +0200
Message-ID: <20260912065650.329338754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 714c7ecedca83..0f8ba76094fe1 100644
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



