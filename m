Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F61246DFEF;
	Tue, 21 Jul 2026 19:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663952; cv=none; b=ruLwL7jyGBCnYSBRwDDDBN9Uq3YbKtpu1sdccRatu7eVwB58waOdLNPuTwdrIuq+3heYLO9RCvzDV3OJ9/h6XV/9sbaQ/m2wjU/MGITrMzAPouqVjpzqhhRnwBBKSFvAmGLUk4RVALVuLqtLa7asQcSiwOSHaUt/pkSQ9DiVwlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663952; c=relaxed/simple;
	bh=55lVEgCS0CTQndhoL5f6/8OlhbqS1ORIiTf9IZKqy1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIHU5YOTpdAFA6IkiJOc8Xg+3YJie6XYZjMaatrRiCT4riSAYMUcWBt/37wcB2y985zitIyJPQyMagEGQ2Lt80RJ5QU5XyYOAsDEq55eE4gU3qKCH20aYa4AzwQ68mfnsEBGjeRk2DO+4dHEQVgC3wfTYhznaxUh8zAeJ+UTuyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dMJlS+p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dMJlS+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FE81F00A3A;
	Tue, 21 Jul 2026 19:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663951;
	bh=+I92FjjhTb2gEWQ/MN8SrwxjFu1A2oM/pG7U7gFpREs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dMJlS+p/zywC+JBZ9MsCovqQml58MFCMeMI3HIYi04vvFzVRy8A3Unh5Y9Ss0gIL
	 rkxve/lvsHT7ZaTy8wR0M+QvO2PxTQFOdzRfxGvwnaiIAK8FlDEdAwV1dfzpQHdhZ2
	 1DDNTsYBOr0qga2udoFkWiZKItfNdRZwghwtvshc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 0974/1276] ksmbd: fix integer overflow in set_file_allocation_info()
Date: Tue, 21 Jul 2026 17:23:37 +0200
Message-ID: <20260721152507.816069494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ibrahim Hashimov <security@auditcode.ai>

commit 1c0ae3df692ea2a4ce992f786346154e75a3f0d5 upstream.

set_file_allocation_info() converts the client-supplied
FILE_ALLOCATION_INFORMATION::AllocationSize into a 512-byte block
count with:

	alloc_blks = (le64_to_cpu(file_alloc_info->AllocationSize) + 511) >> 9;

AllocationSize is a fully client-controlled __le64 field; the only
validation performed by the caller (smb2_set_info_file(), case
FILE_ALLOCATION_INFORMATION) is that the fixed buffer is at least
sizeof(struct smb2_file_alloc_info) == 8 bytes. The value itself is
never range-checked before this arithmetic.

When AllocationSize is close to U64_MAX (e.g. 0xffffffffffffffff),
"AllocationSize + 511" wraps around mod 2^64 to a small number
(0xffffffffffffffff + 511 = 510), so alloc_blks becomes 0. Since any
existing regular file has stat.blocks > 0, the function then takes
the "shrink" branch and calls:

	ksmbd_vfs_truncate(work, fp, alloc_blks * 512);   /* == 0 */

silently truncating the file to size 0, even though the client asked
to grow the allocation to (what looks like) the maximum possible
size. The trailing "if (size < alloc_blks * 512) i_size_write(inode,
size);" restore is guarded by a comparison that is never true once
alloc_blks == 0, so the truncation is not undone. This lets an
authenticated SMB client that already holds an open handle with
FILE_WRITE_DATA on a file silently truncate that same file to size 0
via a single crafted SET_INFO(FILE_ALLOCATION_INFORMATION) request
advertising a near-U64_MAX AllocationSize, even though the request
asks to grow the file's allocation rather than shrink it. This is a
functional/data-loss bug, not a privilege-boundary
violation: the same client could already truncate the file via
FILE_END_OF_FILE_INFORMATION or a plain write.

Fix it by validating AllocationSize against MAX_LFS_FILESIZE, the
same upper bound the VFS itself uses to reject unrepresentable file
sizes, before doing the "+511" rounding, and rejecting oversized
values with -EINVAL. Bounding AllocationSize to
MAX_LFS_FILESIZE - 511 guarantees the "+511" addition cannot wrap,
and that the subsequent "alloc_blks * 512" values passed to
vfs_fallocate() and ksmbd_vfs_truncate() stay within a representable
loff_t as well.

No legitimate SMB client asks for an allocation size anywhere near
2^64 bytes, so this only rejects a value that was previously
silently misinterpreted as zero.

Runtime-verified on a v6.19 KASAN test stand: sending SET_INFO
(FILE_ALLOCATION_INFORMATION) with AllocationSize = 0xffffffffffffffff
against ksmbd now returns -EINVAL and leaves the target file's size
unchanged, where the unpatched kernel truncated it from 4096 to 0
bytes.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6311,6 +6311,7 @@ static int set_file_allocation_info(stru
 	 */
 
 	loff_t alloc_blks;
+	u64 alloc_size;
 	struct inode *inode;
 	struct kstat stat;
 	int rc;
@@ -6323,7 +6324,19 @@ static int set_file_allocation_info(stru
 	if (rc)
 		return rc;
 
-	alloc_blks = (le64_to_cpu(file_alloc_info->AllocationSize) + 511) >> 9;
+	/*
+	 * AllocationSize is fully client-controlled (the caller only
+	 * validates the fixed 8-byte buffer length). Reject values that
+	 * would overflow the "round up to 512-byte blocks" conversion
+	 * below instead of silently wrapping it to a tiny block count,
+	 * which would truncate the file to a size the client never
+	 * asked for.
+	 */
+	alloc_size = le64_to_cpu(file_alloc_info->AllocationSize);
+	if (alloc_size > MAX_LFS_FILESIZE - 511)
+		return -EINVAL;
+
+	alloc_blks = (alloc_size + 511) >> 9;
 	inode = file_inode(fp->filp);
 
 	if (alloc_blks > stat.blocks) {


