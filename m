Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6AF4F7CCB;
	Thu, 17 Sep 2026 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663964; cv=none; b=X4TgxyDqXpiBFApfoKmyENrWXWHocmIhQ3uoG/3o1hdCPxZW9MFZjOkcAqFhOGP7zJU3XkSn5kjN6ZSNvrjQn7+kQr86IlmzCnHi9N9Ky8s1r2v5qOy9xs+2wrVAbir3dTkbSejiPYr203N5+scBoxDbm5LCZVwnzaVnv7QUtA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663964; c=relaxed/simple;
	bh=8x/cAqme8g9mbn9f6s+21xeK4VbdaM2Il2T7ohsIpPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YD+4WB3LCTIfe9uL9wTTSN7IG8/qXY86voakTq31YwG5PT4AHQ7cHgMuCj6pKnYGk4FDgK6RS3vzZxj2M3/x5XkhVpxLoU3PiBZuznahsTH5fltRML3BCjrdU3CBHrPFYjFOdKcMYaUnFVksVaEdSjSV+UGdOrxPe6IkLRXRVlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCVJn1Gr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCVJn1Gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78E81F000FF;
	Thu, 17 Sep 2026 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663963;
	bh=inswrxZkNQuMFmSPMibJeebiOsejS8cNfRikuBEwMTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCVJn1GrTZ4tOFGVVsY/Gm0blukNQ2YyucG+lgGQv/toHLr532OfCcQCPblNVVavH
	 Pf1VK9/jiLpTWwpbNr5dfGCng0HmsO8wT4DGkxtWm86W9gclCwHdF0n2MK4TFM3yWn
	 KvcbjrRyJa7p4gWouk9F50YHuUAuLBzmviUXEW0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0175/1250] ntfs3: handle set_blocksize failures
Date: Thu, 17 Sep 2026 15:59:30 +0100
Message-ID: <20260917151556.842011369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 98cfa33571629..66ad6d82bf5c5 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1143,7 +1143,10 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 	rec->total = cpu_to_le32(sbi->record_size);
 	((struct ATTRIB *)Add2Ptr(rec, ao))->type = ATTR_END;
 
-	sb_set_blocksize(sb, min_t(u32, sbi->cluster_size, PAGE_SIZE));
+	if (!sb_set_blocksize(sb, min_t(u32, sbi->cluster_size, PAGE_SIZE))) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	sbi->block_mask = sb->s_blocksize - 1;
 	sbi->blocks_per_cluster = sbi->cluster_size >> sb->s_blocksize_bits;
@@ -1194,7 +1197,8 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
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



