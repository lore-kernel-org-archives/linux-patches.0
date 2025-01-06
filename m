Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CB91CBA02;
	Mon,  6 Jan 2025 15:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177137; cv=none; b=dmms/5eNPLSkQKjJgqk1W5gQzpXmCq2fGmsiMURHvDPWr4PxuCudAG8tm6wCiCrg08LNBo5bhurWFcsXivHOQ7Kjvgar1BpaFIjjRAjH4yDdgg+z1/7Tuq35yGPrWcu1KY2waJHzKXREryZIR5nn0BEADOSFHWiHKCAoQNLxMpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177137; c=relaxed/simple;
	bh=EWHH1M5CTHVYER+vjzsVTVeNzNFicOE9Bi1fYBa2b5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEuaxGxiWqxXNSCnBJIYm2HrjARYy6QR2tIEs7r0MlECVqgKRZ2E+86GIeHMSbRcxwu5iY/cohr1dfltX56Vu1PQ3WOArmW1HMO6eWkg6Dbb2irwwBLUkUf0zstFD/8V8S03NIV3xnGWqfiAPxhPLghvM4mzlv6z5nCW5FNZOh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCx9RpYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCx9RpYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A61AC4CED2;
	Mon,  6 Jan 2025 15:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177136;
	bh=EWHH1M5CTHVYER+vjzsVTVeNzNFicOE9Bi1fYBa2b5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCx9RpYksTghPUVTjAQhGjcZXmQ2NcvtObbmdmpXhE9VfmT5KHA42uu82QR/9DekJ
	 QwUqblfZGU76zbRfS5SFvrs8jr56BmOtWjSEZZFEjRLgGyrU2a0VWqOQIwIzvlu7vJ
	 9i+y1VOOtHQJvmibU+zv386Q8dNAgmiddjcrfCdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/222] fs/ntfs3: Implement fallocate for compressed files
Date: Mon,  6 Jan 2025 16:14:20 +0100
Message-ID: <20250106151152.726991041@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 9a2d6a40b8a1a6fa62eaf47ceee10a5eef62284c ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: e2705dd3d16d ("fs/ntfs3: Fix warning in ni_fiemap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 25 +++++++++++++++----------
 fs/ntfs3/inode.c  |  3 ++-
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index fc6cea60044e..582628b9b796 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -977,15 +977,17 @@ int attr_data_get_block(struct ntfs_inode *ni, CLST vcn, CLST clen, CLST *lcn,
 		goto out;
 
 	/* Check for compressed frame. */
-	err = attr_is_frame_compressed(ni, attr, vcn >> NTFS_LZNT_CUNIT, &hint);
+	err = attr_is_frame_compressed(ni, attr_b, vcn >> NTFS_LZNT_CUNIT,
+				       &hint);
 	if (err)
 		goto out;
 
 	if (hint) {
 		/* if frame is compressed - don't touch it. */
 		*lcn = COMPRESSED_LCN;
-		*len = hint;
-		err = -EOPNOTSUPP;
+		/* length to the end of frame. */
+		*len = NTFS_LZNT_CLUSTERS - (vcn & (NTFS_LZNT_CLUSTERS - 1));
+		err = 0;
 		goto out;
 	}
 
@@ -1028,16 +1030,16 @@ int attr_data_get_block(struct ntfs_inode *ni, CLST vcn, CLST clen, CLST *lcn,
 
 		/* Check if 'vcn' and 'vcn0' in different attribute segments. */
 		if (vcn < svcn || evcn1 <= vcn) {
-			/* Load attribute for truncated vcn. */
-			attr = ni_find_attr(ni, attr_b, &le, ATTR_DATA, NULL, 0,
-					    &vcn, &mi);
-			if (!attr) {
+			struct ATTRIB *attr2;
+			/* Load runs for truncated vcn. */
+			attr2 = ni_find_attr(ni, attr_b, &le_b, ATTR_DATA, NULL,
+					     0, &vcn, &mi);
+			if (!attr2) {
 				err = -EINVAL;
 				goto out;
 			}
-			svcn = le64_to_cpu(attr->nres.svcn);
-			evcn1 = le64_to_cpu(attr->nres.evcn) + 1;
-			err = attr_load_runs(attr, ni, run, NULL);
+			evcn1 = le64_to_cpu(attr2->nres.evcn) + 1;
+			err = attr_load_runs(attr2, ni, run, NULL);
 			if (err)
 				goto out;
 		}
@@ -1530,6 +1532,9 @@ int attr_wof_frame_info(struct ntfs_inode *ni, struct ATTRIB *attr,
 
 /*
  * attr_is_frame_compressed - Used to detect compressed frame.
+ *
+ * attr - base (primary) attribute segment.
+ * Only base segments contains valid 'attr->nres.c_unit'
  */
 int attr_is_frame_compressed(struct ntfs_inode *ni, struct ATTRIB *attr,
 			     CLST frame, CLST *clst_data)
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 52b80fd15914..af7c0cbba74e 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -604,7 +604,8 @@ static noinline int ntfs_get_block_vbo(struct inode *inode, u64 vbo,
 
 	bytes = ((u64)len << cluster_bits) - off;
 
-	if (lcn == SPARSE_LCN) {
+	if (lcn >= sbi->used.bitmap.nbits) {
+		/* This case includes resident/compressed/sparse. */
 		if (!create) {
 			if (bh->b_size > bytes)
 				bh->b_size = bytes;
-- 
2.39.5



