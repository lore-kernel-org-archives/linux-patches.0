Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021160;
	b=qGB1SMmNo5E/xWHWTafC6ujpunpntJdIOXGkhC7lzAgieg6WrDv9RF3PoND9cYvdK+iY
	 jmELS1ZmOolI0DOqSWHOpt0jfZI9cuPgIKOhoIK7PNUK4Y4+l/1wkpvM811broFAOZrro
	 +0sxIbl5MTxnfzjpTc27wh4jF8vKBu0kXpGJNEM2aoqK8m7wnEpnJb2MQnjQYnLZYO9Ae
	 mP8SbD27Vbo531DrJIvqTIsLvak1c1+9etqJpt92BNs9hGDROCglonwUX+sON9hEJ+o/T
	 AbGQ0rIQLvZunebzNAIi6V20gV9dGoOfBG/yc3saPew9ZkobsqTt2pmFnBEPKnU3YMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w3TmsygmJp3BgHS5hUmQWtykdTEcBWpbl+OxpVQpHTM=;
	b=FFNVAK3m02nOcibGaVVmyWBjgg7jIscaS1ehxpRsLz05/avHACIK37UvLaSSthFmm/mm
	 8WQqy0nIiZOiPs/q/HjQu48D5zvSd38LNfHoFlDMhX+Ysk7kJAakx0eRXvhjTHwQrcbw6
	 PZLissoy+gWwCW2iNrhFkaWKVD0iElFd9nYCQGEifraTs39gmNz1IBBmW9g/oMZJCc3+p
	 HJWwBGh2X22eSv4bPgyKio1HoOc5JKickyz2ttTQbuNkC5BeF//5Np8EdlmQV8nPaDyY3
	 sDzwfNuhTbqHqHU/QPv+fX/ZZ0KtoxmPqtKEpR7TFUqYcn/uh1gGpiDZwlAltV2Y/DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cu+V/uCl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325FC606A31C;
	Wed, 18 Nov 2026 16:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cu+V/uCl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88ADE1F000C5;
	Wed, 18 Nov 2026 16:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021160;
	bh=w3TmsygmJp3BgHS5hUmQWtykdTEcBWpbl+OxpVQpHTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cu+V/uClZ2+4pQHLBw3nbnd1V0PP7yDtSOvQjl925Cy5EM9SoTBRoOtK9ZXu5wTQL
	 wCSH7gDnFsw2Cq91PjktsZ4S3CE6l0yPhdxmo9li3b/AMQcq8jJ+5JWuWw+wCm/Z6r
	 9EOY3P3HO3tVRVDUGDNCxU5QRs5gcH/4Kd+FwUk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2208/2651] ntfs: fix error handling in ntfs_extent_inode_open and propagate errors
Date: Wed, 18 Nov 2026 15:57:28 +0100
Message-ID: <20261118150405.157045830@linuxfoundation.org>
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

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit 67f27176e2ca8161f212b72ec48d8c8d6e7f5e7e ]

ntfs_extent_inode_open() has two issues:

1. When map_mft_record() fails or a stale extent reference is found,
   it returns the non-NULL 'ni' pointer instead of an error, causing
   the caller to treat the failure as success.

2. For allocation failures, it returns NULL, losing information about
   what actually went wrong (-ENOMEM).

Fix both by converting the function to return ERR_PTR() on error, and
update the single caller (ntfs_inode_attach_all_extents) to check with
IS_ERR() and propagate the actual error code with PTR_ERR().

Fixes: af0db57d4293 ("ntfs: update inode operations")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 5e53a50edeea3..302089f7f83a4 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2943,8 +2943,7 @@ int __ntfs_write_inode(struct inode *vi, int sync)
  * abort if deprotection or checks fail.
  *
  * Finally attach the ntfs inode to its base inode @base_ni and return a
- * pointer to the ntfs_inode structure on success or NULL on error, with errno
- * set to the error code.
+ * pointer to the ntfs_inode structure on success or ERR_PTR() on error.
  *
  * Note, extent inodes are never closed directly. They are automatically
  * disposed off by the closing of the base inode.
@@ -2960,7 +2959,7 @@ static struct ntfs_inode *ntfs_extent_inode_open(struct ntfs_inode *base_ni,
 	struct super_block *sb;
 
 	if (!base_ni)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	sb = base_ni->vol->sb;
 	ntfs_debug("Opening extent inode %llu (base mft record %llu).\n",
@@ -2979,7 +2978,7 @@ static struct ntfs_inode *ntfs_extent_inode_open(struct ntfs_inode *base_ni,
 			if (IS_ERR(ni_mrec)) {
 				ntfs_error(sb, "failed to map mft record for %llu",
 						ni->mft_no);
-				goto out;
+				return ERR_CAST(ni_mrec);
 			}
 			/* Verify the sequence number if given. */
 			seq_no = MSEQNO_LE(mref);
@@ -2988,7 +2987,7 @@ static struct ntfs_inode *ntfs_extent_inode_open(struct ntfs_inode *base_ni,
 				ntfs_error(sb, "Found stale extent mft reference mft=%llu",
 						ni->mft_no);
 				unmap_mft_record(ni);
-				goto out;
+				return ERR_PTR(-EIO);
 			}
 			unmap_mft_record(ni);
 			goto out;
@@ -2997,7 +2996,7 @@ static struct ntfs_inode *ntfs_extent_inode_open(struct ntfs_inode *base_ni,
 	/* Wasn't there, we need to load the extent inode. */
 	ni = ntfs_new_extent_inode(base_ni->vol->sb, mft_no);
 	if (!ni)
-		goto out;
+		return ERR_PTR(-ENOMEM);
 
 	ni->seq_no = (u16)MSEQNO_LE(mref);
 	ni->nr_extents = -1;
@@ -3007,8 +3006,10 @@ static struct ntfs_inode *ntfs_extent_inode_open(struct ntfs_inode *base_ni,
 		i = (base_ni->nr_extents + 4) * sizeof(struct ntfs_inode *);
 
 		extent_nis = kvzalloc(i, GFP_NOFS);
-		if (!extent_nis)
-			goto err_out;
+		if (!extent_nis) {
+			ntfs_destroy_ext_inode(ni);
+			return ERR_PTR(-ENOMEM);
+		}
 		if (base_ni->nr_extents) {
 			memcpy(extent_nis, base_ni->ext.extent_ntfs_inos,
 					i - 4 * sizeof(struct ntfs_inode *));
@@ -3021,10 +3022,6 @@ static struct ntfs_inode *ntfs_extent_inode_open(struct ntfs_inode *base_ni,
 out:
 	ntfs_debug("\n");
 	return ni;
-err_out:
-	ntfs_destroy_ext_inode(ni);
-	ni = NULL;
-	goto out;
 }
 
 /*
@@ -3062,9 +3059,12 @@ int ntfs_inode_attach_all_extents(struct ntfs_inode *ni)
 	while ((u8 *)ale < ni->attr_list + ni->attr_list_size) {
 		if (ni->mft_no != MREF_LE(ale->mft_reference) &&
 				prev_attached != MREF_LE(ale->mft_reference)) {
-			if (!ntfs_extent_inode_open(ni, ale->mft_reference)) {
+			struct ntfs_inode *ext_ni;
+
+			ext_ni = ntfs_extent_inode_open(ni, ale->mft_reference);
+			if (IS_ERR(ext_ni)) {
 				ntfs_debug("Couldn't attach extent inode.\n");
-				return -1;
+				return PTR_ERR(ext_ni);
 			}
 			prev_attached = MREF_LE(ale->mft_reference);
 		}
-- 
2.53.0



