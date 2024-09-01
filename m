Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105642B9C7;
	Sun,  1 Sep 2024 16:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208961; cv=none; b=aDCzlUeBtJx0n48jwV1EsnJ+YcqoMPzyQ9Jv1qyrSMfyd82fxAFkCQSoI+vBp4EfizTBkHLBS8XBHx0ZFoZREWQ2gAEZTa+w7+6D8s3lARos1c9vuDHB3HRxhrepczTpJT2PetE4B4BibDP21lL3/DHfdKe+fc6WU72Iw2BoG5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208961; c=relaxed/simple;
	bh=xfuaZwAAN78jLpfLqtU1rbNrPXBRI/47M1So2NSTXps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwdF7as3wZfQs66zTmf+EsmRCSnI/S985zLEUvTrQdomIzHocXR3cuLdxEAhnHSjZ+EJPAP//c5vRVU5VDGd18r0oQQeaykGpMhNuvEO07BZo0MXZA6tDWhSBBwkJaDDpEzX3WZR8sqeZOWD+0hs7z0AYgn6fWeN6kbfMfogGlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5SdUmO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5SdUmO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0EBC4CEC3;
	Sun,  1 Sep 2024 16:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208960;
	bh=xfuaZwAAN78jLpfLqtU1rbNrPXBRI/47M1So2NSTXps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5SdUmO5wzV3nZASmjhV1GknreyCqOq1lvx2iGwjCMJ9n8qwpQGLqsGxvxHeUuMHd
	 LmhV3dN9disZVu6vIgo0PAI9/WWicIYWZp+Msc2oP72Pl2IYZVxqlvoLMup25VkRd3
	 qZzKV2JricfIb71g11l7SLF68U3/IkUxlg/MvgF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/134] f2fs: fix to do sanity check in update_sit_entry
Date: Sun,  1 Sep 2024 18:16:46 +0200
Message-ID: <20240901160812.363665792@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 36959d18c3cf09b3c12157c6950e18652067de77 ]

If GET_SEGNO return NULL_SEGNO for some unecpected case,
update_sit_entry will access invalid memory address,
cause system crash. It is better to do sanity check about
GET_SEGNO just like update_segment_mtime & locate_dirty_segment.

Also remove some redundant judgment code.

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index e43b57755a7fe..da37e2b8a0ec7 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2131,6 +2131,8 @@ static void update_sit_entry(struct f2fs_sb_info *sbi, block_t blkaddr, int del)
 #endif
 
 	segno = GET_SEGNO(sbi, blkaddr);
+	if (segno == NULL_SEGNO)
+		return;
 
 	se = get_seg_entry(sbi, segno);
 	new_vblocks = se->valid_blocks + del;
@@ -3113,8 +3115,7 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 	 * since SSR needs latest valid block information.
 	 */
 	update_sit_entry(sbi, *new_blkaddr, 1);
-	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO)
-		update_sit_entry(sbi, old_blkaddr, -1);
+	update_sit_entry(sbi, old_blkaddr, -1);
 
 	if (!__has_curseg_space(sbi, type))
 		sit_i->s_ops->allocate_segment(sbi, type, false);
-- 
2.43.0



