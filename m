Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53AF3D9DC0;
	Sat, 12 Sep 2026 11:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214246; cv=none; b=W5ZaAJZblReFNh6L1sh2z772ZhaIAIMJkD4D44QiLxfdV5rbNw/7NHZMFDViSKx6o9BRDpntsydSWClaxAaknrG0smrvHMWX1mvGZNc0OOY6YMklJtBW3VAKMmd/vmeF46fGQFWpk9KRJ/d/I+301ajBdr8uUyeBKPG3bRqh7TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214246; c=relaxed/simple;
	bh=SyRa36/jhvJUqa3kDQ17ydVTrBY9hOWz1WTB50+cZtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkyFOwG39dlZ0RHyG9iDZCWj03zB/n0+CmSiOnBLZQvLuMnq5Y8NgjJfMxzJ+zjCzDXF5jZMByVmUjaS9T+6Bcidrtn5E0k44Rq2d0dheV3+N8c20MbudUEW99IuyHkR68QTlR4pwgFxGF8hJZ/CLu+G8ZvOJ5X0FHmlAkR/7wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vp3qMSLz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vp3qMSLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F611F000FF;
	Sat, 12 Sep 2026 11:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214245;
	bh=5oouWxmQBM46J7M1iXI6SgFbtL9iSS1N8SMHvXqfnus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vp3qMSLzkje+KbHSOpmPf0Oqv8EHsRl6p2UdjmqXHlR2MfEtGYrRiYtxKU2VG4iXm
	 YhyxFijbIyFqD355sY6peC8lnWkf0K6OizCcwxPjqyhU3R2wTeHi4DUD1eAM09ydtL
	 z1VIJspU+liFmk3C/z7Tl9zjczeCwRVlbLMdaQ44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 0256/1376] f2fs: fix valid block count leak on data block allocation failure
Date: Sat, 12 Sep 2026 08:44:42 +0200
Message-ID: <20260912065613.244572685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -1454,8 +1454,11 @@ static int __allocate_data_block(struct
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
 		f2fs_invalidate_internal_cache(sbi, old_blkaddr);


