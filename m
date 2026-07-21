Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4A23D3321;
	Tue, 21 Jul 2026 17:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654403; cv=none; b=KDnQhBHkrkDCy8JyUGkwWiDJZzrr68UzRX7nBMqq6XqQNDQleqiDC2QMjWZEPN/jef1a83FwhqpG9d3bH0+r4EJzRca2tLNraNaLTGzeIxIM1yFFf+PqnzaSBLMV5WD/iU7FYAeOECdl0Wy7d7pjYPweZweBZUHIAh8RgwWzeuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654403; c=relaxed/simple;
	bh=EQIB/3SUpOcEVdR305WNxxIwQEMeJKDtC3cnRIdnVvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cceJxQNlteY2V5C2sMaXhqMbyH3tUnVPjSrWlk6MtONUMu4RIWVUej3TGSBQxyHHENbNKbj6EMuWJImoBxp+GYBiwQ1j00Ynrf++wcUzESSmcUjJDUfxXsaZR+vootgrW7duJAcCLtJ3kTsvSuGTOu1+X5HBiw2Aie5LMhoW21U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgeYgxXG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgeYgxXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35B11F000E9;
	Tue, 21 Jul 2026 17:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654402;
	bh=GX7445J3ziA1VkWICfPVwUYs6fwQ7ZESeo0x/oUR3wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dgeYgxXGdErO9ARltbNekXcsXQyjnIANAqSPeF+CsSQnAXinw2RCiAHYhWBY53cak
	 bbnJ8E7uIg/Rms3+/0Lk7OKyU/y0qEdGiJlgQiDNnGcFf8jBohSkEV631fqbu9m95r
	 9OfBw40dY7ebPY7aiMPmyMSh89C5DSRGL4tj5Gdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	woot000 <woot000@woot000.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1690/2077] ntfs: centalize $INDEX_ROOT header validation
Date: Tue, 21 Jul 2026 17:22:43 +0200
Message-ID: <20260721152632.614848008@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

commit 8b97b302f553a480fb76d2afd53cd6c0635a9dcd upstream.

Add a dedicated helper to perform stricter validation of $INDEX_ROOT and
use it for both directory inodes and named index inodes. This keeps the
root size and header geometry checks consistent across both read paths.

Cc: stable@vger.kernel.org # v7.1
Tested-by: woot000 <woot000@woot000.com>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/index.c |   18 ++++++++++++++++++
 fs/ntfs/index.h |    3 +++
 fs/ntfs/inode.c |   11 ++---------
 3 files changed, 23 insertions(+), 9 deletions(-)

--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -544,6 +544,24 @@ int ntfs_index_block_inconsistent(struct
 	return 0;
 }
 
+int ntfs_index_root_inconsistent(struct ntfs_volume *vol,
+				 const struct attr_record *a,
+				 const struct index_root *ir, u64 inum)
+{
+	u32 value_length = le32_to_cpu(a->data.resident.value_length);
+
+	if (value_length < offsetof(struct index_root, index)) {
+		ntfs_error(vol->sb, "$INDEX_ROOT in inode %llu is too small.",
+			   (unsigned long long)inum);
+		return -EIO;
+	}
+
+	return ntfs_index_header_inconsistent(vol, &ir->index,
+					      value_length -
+					      offsetof(struct index_root, index),
+					      inum);
+}
+
 static struct index_root *ntfs_ir_lookup(struct ntfs_inode *ni, __le16 *name,
 		u32 name_len, struct ntfs_attr_search_ctx **ctx)
 {
--- a/fs/ntfs/index.h
+++ b/fs/ntfs/index.h
@@ -89,6 +89,9 @@ struct ntfs_index_context {
 	bool sync_write;
 };
 
+int ntfs_index_root_inconsistent(struct ntfs_volume *vol,
+				 const struct attr_record *a,
+				 const struct index_root *ir, u64 inum);
 int ntfs_index_block_inconsistent(struct ntfs_volume *vol,
 				  const struct index_block *ib,
 				  u32 block_size, s64 vcn, u64 inum);
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -896,7 +896,6 @@ skip_attr_list_load:
 	 */
 	if (S_ISDIR(vi->i_mode)) {
 		struct index_root *ir;
-		u8 *ir_end, *index_end;
 
 view_index_meta:
 		/* It is a directory, find index root attribute. */
@@ -946,10 +945,7 @@ view_index_meta:
 		}
 		ir = (struct index_root *)((u8 *)a +
 				le16_to_cpu(a->data.resident.value_offset));
-		ir_end = (u8 *)ir + le32_to_cpu(a->data.resident.value_length);
-		index_end = (u8 *)&ir->index +
-				le32_to_cpu(ir->index.index_length);
-		if (index_end > ir_end) {
+		if (ntfs_index_root_inconsistent(ni->vol, a, ir, ni->mft_no)) {
 			ntfs_error(vi->i_sb, "Directory index is corrupt.");
 			goto unm_err_out;
 		}
@@ -1492,7 +1488,6 @@ static int ntfs_read_locked_index_inode(
 	struct attr_record *a;
 	struct ntfs_attr_search_ctx *ctx;
 	struct index_root *ir;
-	u8 *ir_end, *index_end;
 	int err = 0;
 
 	ntfs_debug("Entering for i_ino 0x%llx.", ni->mft_no);
@@ -1543,9 +1538,7 @@ static int ntfs_read_locked_index_inode(
 	}
 
 	ir = (struct index_root *)((u8 *)a + le16_to_cpu(a->data.resident.value_offset));
-	ir_end = (u8 *)ir + le32_to_cpu(a->data.resident.value_length);
-	index_end = (u8 *)&ir->index + le32_to_cpu(ir->index.index_length);
-	if (index_end > ir_end) {
+	if (ntfs_index_root_inconsistent(vol, a, ir, ni->mft_no)) {
 		ntfs_error(vi->i_sb, "Index is corrupt.");
 		goto unm_err_out;
 	}


