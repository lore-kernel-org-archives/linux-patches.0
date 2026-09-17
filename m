Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9B44B44AE;
	Thu, 17 Sep 2026 17:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667526; cv=none; b=cengNnl0tQ8D/ChIRQBMvWUgoI+sqhieA0/uE24iRcAXRgcb6mR/Sc3gNX2ZjuvN2wcab/7asXMoHdavkWv5TlFJ5ElwP/c2YGVvc8SrmfpAxoMul4EjMkJrQHEulCy+Lr0TTYur45ThaDfjGr7K5g+GLGqpdUAQd8Z3k3DfNNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667526; c=relaxed/simple;
	bh=8abgyrOfdIy8G1JyHI2P2uCszxUeYm0vXud2CXVb7Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzghnmpYdIcAUZP6As2GYySQsxDrMpSkR8cnfvxos6kzlFwJPEfjhhnhZdxFkKTZDTURNWv5HRldvvftMH1x58qzki7Xuzb3LyvRJz0H738Uf46YlEBiS1J739Dit3ZBSggfWk/mUWOtVJTRb47nDT2lCddwj4chhWOPn7gyT+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxsPon5J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxsPon5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C401F000FF;
	Thu, 17 Sep 2026 17:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667524;
	bh=n1yvEE9gECLPR3ZctJSXkXfnYhw63iwafDRYS/48EuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BxsPon5JgTYPanKyHigqZOVWpmqeb/Lzl4ojWlfCQKXH14qgx3X3Z4MR/QK8zOi1r
	 HmDguGaFtrzrk6wcW7RliKQ5ekF+sPnNAFtBNPKrN6QG7gMqycmgF6IZB7LVNbrQoa
	 z8jmmNM1lzH4UU5rXorOQdpP/wpvFn/zec9DWNXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0121/1102] ntfs3: handle set_blocksize failures
Date: Thu, 17 Sep 2026 16:01:04 +0100
Message-ID: <20260917151542.547914533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 24f7d1824b7581ae3daf9d443c5dfeabd89df6d8 ]

ntfs3 uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-10-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index b0c46840f75fa..4b1941e3f3a67 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1102,7 +1102,10 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 	rec->total = cpu_to_le32(sbi->record_size);
 	((struct ATTRIB *)Add2Ptr(rec, ao))->type = ATTR_END;
 
-	sb_set_blocksize(sb, min_t(u32, sbi->cluster_size, PAGE_SIZE));
+	if (!sb_set_blocksize(sb, min_t(u32, sbi->cluster_size, PAGE_SIZE))) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	sbi->block_mask = sb->s_blocksize - 1;
 	sbi->blocks_per_cluster = sbi->cluster_size >> sb->s_blocksize_bits;
@@ -1153,7 +1156,8 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 			/*
 			 * Try alternative boot (last sector)
 			 */
-			sb_set_blocksize(sb, block_size);
+			if (!sb_set_blocksize(sb, block_size))
+				return -EINVAL;
 			hint = "Alternative boot";
 			dev_size = dev_size0; /* restore original size. */
 			goto read_boot;
-- 
2.53.0



