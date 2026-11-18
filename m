Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021406;
	b=cs4TEgNkO/6C9ga2E1laBImqmpWj+uPA8tiVT5Doqny7n1euQJ3iil8xcNdXwj8LhFaq
	 84q4taOMGntKI8O95lDTXWgE5xiRcZnJh3ma03tl60xTrQ6M+vuVIaJWxlIPm2LKep/k/
	 XQeClDZ5m6bcWpyMVTqbCNkc18QOtN+LRo5Ic6tY3Uweubta/7rukEDsK0KIeH4Wrp4rF
	 WCU2kKzYXM9b3K52M70WBiAA8itHhRpvdQqP0DM/4JcX/5h61INSZpPx+Q5vkQ32Cdur/
	 yEpJ2hpihu47wMqWKKrWSW9YRGPh81/NZa/DaBit4xSlQy1SixktB7MJ19uc0ZKqlDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MILwORQ5XJQJSDN0ED4xjjxxBjI1Q6CEhPoSgsgBQcA=;
	b=fDN0xOka/BuhPM/TFYikeQPwtq9SZk/b7gUEJbNz3/lXY93vIs6Z8LtePlkh+JQtkXdn
	 LbwA1DXbB3uvC6mn814nyYRxgApl00UssVrRqvSzPPnqJPbaek33M3fdkxcBfEdHIoXaq
	 nsuqWbwk+twWPvRZ1HUrpk1z4wNxMhe0JlOjCkQpcNkA6yypCkvX97ex6gHz1hpejh7BU
	 8VpFNyNRF2D2wyNd28fgCVHU+QB/7snG7WiJcNmz4nR5hIvraviRAS3opA6W1vIrwaWlq
	 Um3gu2NhkVLQBSAy+6bm3ckg7Lt5w+ssvj0jz/XQ63D+correVWz/Wxv+S3Xh/6tl6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UkvVY71I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2BD606A332;
	Wed, 18 Nov 2026 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UkvVY71I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8F81F000C4;
	Wed, 18 Nov 2026 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021406;
	bh=MILwORQ5XJQJSDN0ED4xjjxxBjI1Q6CEhPoSgsgBQcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkvVY71IPFZBXkYguwyYhxHCfAIe3Xhjwm/GWmtIB2WQMKEvhykxZE47BcN+jx1KH
	 QVwVuLSWT8K7XFXIWCVlOY2+rB3ZKrvPc+do64MCiGcHfUO7rThCpg5w3bUEcbDXZj
	 qag4KwUaOv7MrmK7ofArNO8igsbw3WIYiGVcKqi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2296/2651] ksmbd: round SetAllocation to the advertised allocation unit
Date: Wed, 18 Nov 2026 15:58:56 +0100
Message-ID: <20261118150407.898663987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit aad7d86a6651efefb2c0a4f02c86dfeff3c176a2 ]

SetAllocation rounds requests to 512-byte blocks, although
FS_SIZE_INFORMATION advertises the filesystem's f_bsize as its
allocation unit. For example, on a filesystem with a 4 KiB unit, a
1000-byte request can truncate an 8 KiB file to 1024 bytes instead of
4 KiB.

Round the request to the advertised unit and use the same result for
the block-count decision, fallocate, truncate, and the size stored on
the open handle. Validate the unit and rounded size before either
operation. Use DIV_ROUND_UP_ULL() so the calculation works on 32-bit
kernels.

This does not change the existing block-count decision for whether to
call fallocate. In particular, success does not yet guarantee
reservation of holes within the requested range on a sparse file.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index c380f82ed8796..81c8bc5033cdf 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8483,10 +8483,11 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 	 * properly with any smb.conf option
 	 */
 
-	loff_t alloc_blks;
-	u64 alloc_size;
+	u64 alloc_size, target, alloc_blks;
+	u32 alloc_unit;
 	struct inode *inode;
 	struct kstat stat;
+	struct kstatfs stfs;
 	int rc;
 
 	if (!(fp->daccess & FILE_WRITE_DATA_LE))
@@ -8499,44 +8500,48 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 			 AT_STATX_SYNC_AS_STAT);
 	if (rc)
 		return rc;
+	rc = vfs_statfs(&fp->filp->f_path, &stfs);
+	if (rc)
+		return rc;
 
 	/*
-	 * AllocationSize is fully client-controlled (the caller only
-	 * validates the fixed 8-byte buffer length). Reject values that
-	 * would overflow the "round up to 512-byte blocks" conversion
-	 * below instead of silently wrapping it to a tiny block count,
-	 * which would truncate the file to a size the client never
-	 * asked for.
+	 * Use the allocation unit advertised in FS_SIZE_INFORMATION.
+	 * Reject requests that overflow when rounded to a whole unit.
 	 */
 	alloc_size = le64_to_cpu(file_alloc_info->AllocationSize);
-	if (alloc_size > MAX_LFS_FILESIZE - 511)
+	if (stfs.f_bsize <= 0 || (u64)stfs.f_bsize > U32_MAX)
+		return -EINVAL;
+	alloc_unit = stfs.f_bsize;
+	if (alloc_size > MAX_LFS_FILESIZE - (alloc_unit - 1))
 		return -EINVAL;
 
-	alloc_blks = (alloc_size + 511) >> 9;
+	target = DIV_ROUND_UP_ULL(alloc_size, alloc_unit) * alloc_unit;
+	alloc_blks = DIV_ROUND_UP_ULL(target, 512);
 	inode = file_inode(fp->filp);
+	if (target > inode->i_sb->s_maxbytes)
+		return -EINVAL;
 
 	if (alloc_blks > stat.blocks) {
 		smb_break_all_levII_oplock(work, fp, 1);
-		rc = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
-				   alloc_blks * 512);
+		rc = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0, target);
 		if (rc && rc != -EOPNOTSUPP) {
 			pr_err("vfs_fallocate is failed : %d\n", rc);
 			return rc;
 		}
 	} else if (alloc_blks < stat.blocks &&
-		   alloc_blks * 512 <= i_size_read(inode)) {
+		   target <= i_size_read(inode)) {
 		/*
 		 * Truncate at or below EOF to discard excess allocation.
 		 * Truncating above EOF would extend the file on disk.
 		 */
-		rc = ksmbd_vfs_truncate(work, fp, alloc_blks * 512);
+		rc = ksmbd_vfs_truncate(work, fp, target);
 		if (rc) {
 			pr_err("truncate failed!, err %d\n", rc);
 			return rc;
 		}
 	}
 
-	fp->allocation_size = le64_to_cpu(file_alloc_info->AllocationSize);
+	fp->allocation_size = target;
 	fp->allocation_size_set = true;
 	return 0;
 }
-- 
2.53.0



