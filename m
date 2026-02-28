Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACA8421A16
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301190; cv=none; b=j8Pc1rK8RSzFx2XSGZNxAbqhvCsphlzqBsw505GRTpkIQZK+OXEabCaJ8E7bC79p7MbcY+iUIPnyYk2rb0UPrekkqNeKojBH2et1oKotl+Qb4Td/eE0rMyWR1RjOJLfFfivJHT5V8taEVoEc69HIPI34xXkRAORa2lGbCN6EiMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301190; c=relaxed/simple;
	bh=nEBHn/E2vI88MIJ7nIqaANfuIDHotYdC5cPu7qAjxCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/i7xXSodPBeqjCjVtFWT9Y+tvdzSI6niLxleJz64iB9SiSsO0d9FkxLO3R95UTYIfVnkamjjBYc/R5ubeXxtMNaKrK6XYM3A+PsB0z+QPDLDE8+PJcbmGxk2h0YJ1JnaNGj7eKFs6+V83bntpcRPSTbtcim7kxZ3wH2bagotKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BllrImbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BllrImbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EB9C19423;
	Sat, 28 Feb 2026 17:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301190;
	bh=nEBHn/E2vI88MIJ7nIqaANfuIDHotYdC5cPu7qAjxCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BllrImbVsMff3OCklIezNs1Deu744ecUsZHKzAnNEwZLKeRK/P45FO9DoWi0VLnTd
	 zY7TEtC3wgkPco5ZasaMaqy+7ab3XXczQJ6rhnXeDZlY2byhLrUMv68xtJ2DA4FjDw
	 wvhb7eJHAH/HBk+i2lBAsS/+kqqWJPtZI/ht55z1Ry6HJJueIMz6PgjWC3OKrOM3VP
	 Tfje4QhHye3XnnX3gnu4CZTahoN+v2cMkV1a1TJpgNSzHem0eajiid4GgUAdfH1a9n
	 YCZWBb11x3tdqlyJuIGXTC5h5c/3Zc4ljBswqGwCtFwMBKVeFsqlv0mKZDiov/Hycg
	 2ZB/rAUtqjHkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jaehun Gou <p22gone@gmail.com>,
	Seunghun Han <kkamagui@gmail.com>,
	Jihoon Kwon <kjh010315@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 360/752] fs: ntfs3: fix infinite loop triggered by zero-sized ATTR_LIST
Date: Sat, 28 Feb 2026 12:41:11 -0500
Message-ID: <20260228174750.1542406-360-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jaehun Gou <p22gone@gmail.com>

[ Upstream commit 06909b2549d631a47fcda249d34be26f7ca1711d ]

We found an infinite loop bug in the ntfs3 file system that can lead to a
Denial-of-Service (DoS) condition.

A malformed NTFS image can cause an infinite loop when an ATTR_LIST attribute
indicates a zero data size while the driver allocates memory for it.

When ntfs_load_attr_list() processes a resident ATTR_LIST with data_size set
to zero, it still allocates memory because of al_aligned(0). This creates an
inconsistent state where ni->attr_list.size is zero, but ni->attr_list.le is
non-null. This causes ni_enum_attr_ex to incorrectly assume that no attribute
list exists and enumerates only the primary MFT record. When it finds
ATTR_LIST, the code reloads it and restarts the enumeration, repeating
indefinitely. The mount operation never completes, hanging the kernel thread.

This patch adds validation to ensure that data_size is non-zero before memory
allocation. When a zero-sized ATTR_LIST is detected, the function returns
-EINVAL, preventing a DoS vulnerability.

Co-developed-by: Seunghun Han <kkamagui@gmail.com>
Signed-off-by: Seunghun Han <kkamagui@gmail.com>
Co-developed-by: Jihoon Kwon <kjh010315@gmail.com>
Signed-off-by: Jihoon Kwon <kjh010315@gmail.com>
Signed-off-by: Jaehun Gou <p22gone@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrlist.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ntfs3/attrlist.c b/fs/ntfs3/attrlist.c
index a4d74bed74fab..098bd7e8c3d64 100644
--- a/fs/ntfs3/attrlist.c
+++ b/fs/ntfs3/attrlist.c
@@ -52,6 +52,11 @@ int ntfs_load_attr_list(struct ntfs_inode *ni, struct ATTRIB *attr)
 
 	if (!attr->non_res) {
 		lsize = le32_to_cpu(attr->res.data_size);
+		if (!lsize) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		/* attr is resident: lsize < record_size (1K or 4K) */
 		le = kvmalloc(al_aligned(lsize), GFP_KERNEL);
 		if (!le) {
@@ -66,6 +71,10 @@ int ntfs_load_attr_list(struct ntfs_inode *ni, struct ATTRIB *attr)
 		u16 run_off = le16_to_cpu(attr->nres.run_off);
 
 		lsize = le64_to_cpu(attr->nres.data_size);
+		if (!lsize) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		run_init(&ni->attr_list.run);
 
-- 
2.51.0

