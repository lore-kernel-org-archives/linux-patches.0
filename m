Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DF43A16A0;
	Wed,  8 Apr 2026 18:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672224; cv=none; b=KHAAwqncZ63X9dAtw9NJrU+F+977EJ7u4bBCPu4Xv5Do7hTv+1mnbpwXHzSxJtJCh951iMM+/0lX3VxpLwqDh7oWimTRMZO4qG8BHrGHq5QKwzaUNB4jD6GagY6YRNYdxIITaOXT/sp/NOE6+x+BlkdhdAKiztZpJ/KUDSHtF1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672224; c=relaxed/simple;
	bh=+6S05uKbP0AhoRr8Lh2rgSlRgFopB9KpDIYvPPaX1zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcgtW+0LQgz4Kz6F5aTQ4TlmvORYBRSE5+KksoT6Y2pWg5hi+/CJru7bF8vfxVDTcwoDMVrb7WSVNg0CE6czKEN7XCPPtnFEsN86IVbO9IGqn1xSGNaY0wp71oCGUz0vQOK38J2eLSVezPJLnv5ulEpZKS9Rvfeg3uxVoqiyx9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXskGmBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXskGmBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9380C19421;
	Wed,  8 Apr 2026 18:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672224;
	bh=+6S05uKbP0AhoRr8Lh2rgSlRgFopB9KpDIYvPPaX1zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXskGmBQo8mT2IFBZmE3NZiyoedFFFRlqDTesAJjcBYbWIt8QqSixhXUTLY/BP/3c
	 w37sF2WbERt3SlaJ1kME3XYtWuQ2x8nhqQDFBP8sv1bsglC60CJ2e22AonJr/ufAXF
	 eZ/m0OI1+7LBS49HUJjwQZlmOynMedQGDdkvl/ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 238/312] Revert "ext4: subdivide EXT4_EXT_DATA_VALID1"
Date: Wed,  8 Apr 2026 20:02:35 +0200
Message-ID: <20260408175942.640485694@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 1606176c5c6c323167dcd7d4b4f7212b2c8d3d13.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e2f9c27c7e161..6da0bf3cf406d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -43,13 +43,8 @@
 #define EXT4_EXT_MARK_UNWRIT1	0x2  /* mark first half unwritten */
 #define EXT4_EXT_MARK_UNWRIT2	0x4  /* mark second half unwritten */
 
-/* first half contains valid data */
-#define EXT4_EXT_DATA_ENTIRE_VALID1	0x8   /* has entirely valid data */
-#define EXT4_EXT_DATA_PARTIAL_VALID1	0x10  /* has partially valid data */
-#define EXT4_EXT_DATA_VALID1		(EXT4_EXT_DATA_ENTIRE_VALID1 | \
-					 EXT4_EXT_DATA_PARTIAL_VALID1)
-
-#define EXT4_EXT_DATA_VALID2	0x20 /* second half contains valid data */
+#define EXT4_EXT_DATA_VALID1	0x8  /* first half contains valid data */
+#define EXT4_EXT_DATA_VALID2	0x10 /* second half contains valid data */
 
 static __le32 ext4_extent_block_csum(struct inode *inode,
 				     struct ext4_extent_header *eh)
@@ -3180,9 +3175,8 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 	unsigned int ee_len, depth;
 	int err = 0;
 
-	BUG_ON((split_flag & EXT4_EXT_DATA_VALID1) == EXT4_EXT_DATA_VALID1);
-	BUG_ON((split_flag & EXT4_EXT_DATA_VALID1) &&
-	       (split_flag & EXT4_EXT_DATA_VALID2));
+	BUG_ON((split_flag & (EXT4_EXT_DATA_VALID1 | EXT4_EXT_DATA_VALID2)) ==
+	       (EXT4_EXT_DATA_VALID1 | EXT4_EXT_DATA_VALID2));
 
 	/* Do not cache extents that are in the process of being modified. */
 	flags |= EXT4_EX_NOCACHE;
@@ -3373,7 +3367,7 @@ static int ext4_split_extent(handle_t *handle,
 			split_flag1 |= EXT4_EXT_MARK_UNWRIT1 |
 				       EXT4_EXT_MARK_UNWRIT2;
 		if (split_flag & EXT4_EXT_DATA_VALID2)
-			split_flag1 |= EXT4_EXT_DATA_ENTIRE_VALID1;
+			split_flag1 |= EXT4_EXT_DATA_VALID1;
 		path = ext4_split_extent_at(handle, inode, path,
 				map->m_lblk + map->m_len, split_flag1, flags1);
 		if (IS_ERR(path)) {
@@ -3737,7 +3731,7 @@ static int ext4_split_convert_extents(handle_t *handle,
 
 	/* Convert to unwritten */
 	if (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
-		split_flag |= EXT4_EXT_DATA_ENTIRE_VALID1;
+		split_flag |= EXT4_EXT_DATA_VALID1;
 	/* Convert to initialized */
 	} else if (flags & EXT4_GET_BLOCKS_CONVERT) {
 		split_flag |= ee_block + ee_len <= eof_block ?
-- 
2.53.0



