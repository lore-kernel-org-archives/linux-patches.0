Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76022741A0;
	Mon, 23 Mar 2026 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277636; cv=none; b=gqrUxryQw2Fkjj2l5p3Ox1V1rQjX3b04uRPTxpwooQ6xtiSTYvN2J6TH+d5JWhoFsrFkmH6BgGqV4VcPLunFN1goYf83OC6jUt+9UuvNO5o2XFQDGcR+FNI4SVrig7eoYDFG8Mj6FWpe2b4voTdQeKyHmHHTVoSE2uJhO2sZf6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277636; c=relaxed/simple;
	bh=uvr7cxYrC+GoAd2BdPaHDvlohRANM5DjkF/7SOHFogY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFJ0Q4bAN9zNyxDEY5tEGphqT1G1q8ovaxhiGvQlLNKll2E1QU8QA2TwtsZGA7gaDyC2XuRXeQtk2oIISdMMFNQgGRC2Pc8H0NqzMTSU66z9eGy3xPiv/hgQ3HsmgvXmwRxyZAXaE4Fv1D5ui7tGFdQxt/OFFQOKAzqDNsSLuwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPbIYFL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPbIYFL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6F1C4CEF7;
	Mon, 23 Mar 2026 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277636;
	bh=uvr7cxYrC+GoAd2BdPaHDvlohRANM5DjkF/7SOHFogY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPbIYFL6+hNtkAV19oq4Qxa6qsEuzoOs8MBl4/EEPyIfkqPie+orNJrV3gnyCSZ2B
	 y0Tc0AtezXfOPp0R56YpxhpafxMaLRVEqoPe8NiL17gaN4TjS76zk1wQ97TQFtppAC
	 2SRYrmUz/IKK1jePu0HEzgLrNkgj/sKS9Dv9L83A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Baokun Li <libaokun1@huawei.com>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/567] ext4: subdivide EXT4_EXT_DATA_VALID1
Date: Mon, 23 Mar 2026 14:39:28 +0100
Message-ID: <20260323134534.995357539@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 22784ca541c0f01c5ebad14e8228298dc0a390ed ]

When splitting an extent, if the EXT4_GET_BLOCKS_CONVERT flag is set and
it is necessary to split the target extent in the middle,
ext4_split_extent() first handles splitting the latter half of the
extent and passes the EXT4_EXT_DATA_VALID1 flag. This flag implies that
all blocks before the split point contain valid data; however, this
assumption is incorrect.

Therefore, subdivid EXT4_EXT_DATA_VALID1 into
EXT4_EXT_DATA_ENTIRE_VALID1 and EXT4_EXT_DATA_PARTIAL_VALID1, which
indicate that the first half of the extent is either entirely valid or
only partially valid, respectively. These two flags cannot be set
simultaneously.

This patch does not use EXT4_EXT_DATA_PARTIAL_VALID1, it only replaces
EXT4_EXT_DATA_VALID1 with EXT4_EXT_DATA_ENTIRE_VALID1 at the location
where it is set, no logical changes.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Cc: stable@kernel.org
Message-ID: <20251129103247.686136-2-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 33ed753ea82e9..18520281e1b5f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -43,8 +43,13 @@
 #define EXT4_EXT_MARK_UNWRIT1	0x2  /* mark first half unwritten */
 #define EXT4_EXT_MARK_UNWRIT2	0x4  /* mark second half unwritten */
 
-#define EXT4_EXT_DATA_VALID1	0x8  /* first half contains valid data */
-#define EXT4_EXT_DATA_VALID2	0x10 /* second half contains valid data */
+/* first half contains valid data */
+#define EXT4_EXT_DATA_ENTIRE_VALID1	0x8   /* has entirely valid data */
+#define EXT4_EXT_DATA_PARTIAL_VALID1	0x10  /* has partially valid data */
+#define EXT4_EXT_DATA_VALID1		(EXT4_EXT_DATA_ENTIRE_VALID1 | \
+					 EXT4_EXT_DATA_PARTIAL_VALID1)
+
+#define EXT4_EXT_DATA_VALID2	0x20 /* second half contains valid data */
 
 static __le32 ext4_extent_block_csum(struct inode *inode,
 				     struct ext4_extent_header *eh)
@@ -3173,8 +3178,9 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 	unsigned int ee_len, depth;
 	int err = 0;
 
-	BUG_ON((split_flag & (EXT4_EXT_DATA_VALID1 | EXT4_EXT_DATA_VALID2)) ==
-	       (EXT4_EXT_DATA_VALID1 | EXT4_EXT_DATA_VALID2));
+	BUG_ON((split_flag & EXT4_EXT_DATA_VALID1) == EXT4_EXT_DATA_VALID1);
+	BUG_ON((split_flag & EXT4_EXT_DATA_VALID1) &&
+	       (split_flag & EXT4_EXT_DATA_VALID2));
 
 	/* Do not cache extents that are in the process of being modified. */
 	flags |= EXT4_EX_NOCACHE;
@@ -3365,7 +3371,7 @@ static int ext4_split_extent(handle_t *handle,
 			split_flag1 |= EXT4_EXT_MARK_UNWRIT1 |
 				       EXT4_EXT_MARK_UNWRIT2;
 		if (split_flag & EXT4_EXT_DATA_VALID2)
-			split_flag1 |= EXT4_EXT_DATA_VALID1;
+			split_flag1 |= EXT4_EXT_DATA_ENTIRE_VALID1;
 		path = ext4_split_extent_at(handle, inode, path,
 				map->m_lblk + map->m_len, split_flag1, flags1);
 		if (IS_ERR(path)) {
@@ -3728,7 +3734,7 @@ static int ext4_split_convert_extents(handle_t *handle,
 
 	/* Convert to unwritten */
 	if (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
-		split_flag |= EXT4_EXT_DATA_VALID1;
+		split_flag |= EXT4_EXT_DATA_ENTIRE_VALID1;
 	/* Convert to initialized */
 	} else if (flags & EXT4_GET_BLOCKS_CONVERT) {
 		split_flag |= ee_block + ee_len <= eof_block ?
-- 
2.51.0



