Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E3A585964;
	Wed,  9 Sep 2026 14:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964271; cv=none; b=UKDrOO76Qu//lDU3CXjtuQ5k1rkjqhyJpN5qCC/DOcvbu6fudcCsD3ynNaA685PtKf/dr3ICLszmLK82S/r07ImlvcI9ti1yq0maynsKD3EtjznXNqw8QdxeUmwwkcXx6ICzvsRAlu6WgR5IdYogE6eG+ijtRcGDuAvGZcFH5iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964271; c=relaxed/simple;
	bh=fE74YMHcQaqx3ZJfWHlOW2zp64pTcx5LYV92lFHMObQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmlH+z66vCnaXpjLSY5vA6tAA4SVGS2vzcyhApiRQTsEG7Mxx76xFE9BKn5rlJ+26cbcccAFLixT2R46S/aG8z1OfqzLK8ZuhzBF0SMfg7LdFUg7ioWsxnoxoaIrup4n0oT2VHyHs5o30n87m+LeLJej5nMRr9+GpF85y9qbe1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVxjVqu1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVxjVqu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253731F00A3A;
	Wed,  9 Sep 2026 14:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964269;
	bh=K9OdIvwHb6xXY1zfAM8Osq75Ajo4mPDyMQF2dN+4PdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVxjVqu1KIF2M/33axYwVDMbGRcen9lX5pFeaTbup3KsbFMr7GUuNYi4BqcRFTe0o
	 JTNLVQbRn10BajC1UtGsoqzgIzlYUQ2qllntJxs+G1GU3wDpVxHHtDqYI85/BQ+waR
	 XFb+RuKW8VGdeqp2pBdOB5ja6HHA6aqJEmIlEgYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 366/583] f2fs: fix valid block count leak on data block allocation failure
Date: Wed,  9 Sep 2026 15:40:51 +0200
Message-ID: <20260909134250.715448583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Chen Changcheng <chenchangcheng@kylinos.cn>

commit 0f9af07ecc1ab486038373db6ae0436c5d674b19 upstream.

In __allocate_data_block(), when allocating a new data block
(dn->data_blkaddr == NULL_ADDR), inc_valid_block_count() is
called first to increment total_valid_block_count and i_blocks.
If the subsequent f2fs_allocate_data_block() fails, the function
returns the error directly without rolling back the
already-incremented block counts, causing a permanent leak.

Fix this by calling dec_valid_block_count() to undo the
increment before returning the error. The condition
old_blkaddr == NULL_ADDR precisely identifies the case where
inc_valid_block_count() was called.

Fixes: 7d009e048d7c ("f2fs: fix to handle segment allocation failure correctly")
Cc: <stable@vger.kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1453,8 +1453,11 @@ static int __allocate_data_block(struct
 	old_blkaddr = dn->data_blkaddr;
 	err = f2fs_allocate_data_block(sbi, NULL, old_blkaddr,
 				&dn->data_blkaddr, &sum, seg_type, NULL);
-	if (err)
+	if (err) {
+		if (old_blkaddr == NULL_ADDR)
+			dec_valid_block_count(sbi, dn->inode, count);
 		return err;
+	}
 
 	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO)
 		f2fs_invalidate_internal_cache(sbi, old_blkaddr, 1);


