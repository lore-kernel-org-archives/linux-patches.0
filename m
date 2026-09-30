Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA27A2EA732;
	Wed, 30 Sep 2026 18:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794078; cv=none; b=OGsrYTFyLrcXwnWh+NRnYhUErBAxY8FPAEDbghcftrt8sgXP/4sLBqPuVeXKDI35tdO1JeyIY49Kzk9bqnJLaqeax8w+c3nerkH+bexoCdL5v+uP1KzZrSgoSBwcoP4FaisW98X2Z/nqAnZNhhCi3PzTdvXtBT+9TtbWWO9YpRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794078; c=relaxed/simple;
	bh=YmSjWUi4zM5XGMo86olp5NrNLMJj7DKoPdaDblQZTYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKk5tFpL4zb9lx8y6BAbytmEZs4JI046A4FUa6mYQnEhLe7kVeLb35K37ws3VzLLM6wB/YlFwHNFpuoveY+xBrVVNbhFpyYePGNMUQobRMLdQqpFK6TPfIepLsvMF2fNRdZ4VVJvwQ+no6IQ0mL8aMo0iJnrScjprrnH+90RoC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lCqGehQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lCqGehQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2270D1F000FF;
	Wed, 30 Sep 2026 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794077;
	bh=RbGfwFh4x7inh9wIj/qAX32urNI6isEnck6GA+xd+l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lCqGehQf8vCUGDwnEXdvg/US9IUZ0Vfc0IEAjGAwkGSVMBVggCKgkwBbV6noklws
	 ljpBaz/ZGnXRLGPZGvg3vR+soOyZK7cgEJP+clhRCAavvqN3rX7dzbNAWSAtZ2hetp
	 pI2XOy6x4llYWhM2oCgiRzLsSX1m6PDKe7C+0A4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0083/1193] ntfs3: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:12:47 +0200
Message-ID: <20260930152436.094001102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 935115a75ea1e..15b1f2027b4ed 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1095,7 +1095,10 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 	rec->total = cpu_to_le32(sbi->record_size);
 	((struct ATTRIB *)Add2Ptr(rec, ao))->type = ATTR_END;
 
-	sb_set_blocksize(sb, min_t(u32, sbi->cluster_size, PAGE_SIZE));
+	if (!sb_set_blocksize(sb, min_t(u32, sbi->cluster_size, PAGE_SIZE))) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	sbi->block_mask = sb->s_blocksize - 1;
 	sbi->blocks_per_cluster = sbi->cluster_size >> sb->s_blocksize_bits;
@@ -1146,7 +1149,8 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
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



