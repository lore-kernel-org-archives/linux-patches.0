Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4E51C578E;
	Tue, 27 Aug 2024 14:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770426; cv=none; b=oV1rIirs/CPjfPsCouWZkJ0s4c2SptlqCG9tLmWuKqhMawaCjzMLXeVfTqXDQjeiml4IMf0FBifqyGrKRrqxxuLUJ1IBLKyu2eyMQaMLT+WjVND+a56Rwnwm97B1M5ICYnVu7WG8cJtVGOOfi3qWHDh2waCXC1oi57Ww61Ed1hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770426; c=relaxed/simple;
	bh=vtzgXNNNCcCiJDUwoj/jS5pt+AWLONQM49lyjcD60wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gihqu7TUb4xghMVFBunwXg+Ju7l5Q+lwvGldDsuL8jE/G2cG0Kpf3DdNndpfpA1OzghGrlsC9NQVBD7yKfKiko8kPT/+p+CTIpD0/r3duxxp5iYcB7r2XSZCK0a3ZGFm9Y/jajiQBigPXGt0FDNiiF0yMdr9bIR9mnFQiJX7SN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/tLHZLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/tLHZLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA64C61053;
	Tue, 27 Aug 2024 14:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770426;
	bh=vtzgXNNNCcCiJDUwoj/jS5pt+AWLONQM49lyjcD60wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/tLHZLv/9uqWzIQORwBR/SMXPJiBirKVIQy1ex+eJgd5UXc0B5iaOK0Qc94S7JlC
	 O5LI6kTsYsy6wFMDcxUWFKk+O07ZkMO6gxEq5JZ48p3DfkIFfo3w5wm4kkLX4obWe2
	 Ftu2UgMHqyKBM0QrTIM1JOCGlJLeDOTUNSD+d7yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/341] f2fs: fix to do sanity check in update_sit_entry
Date: Tue, 27 Aug 2024 16:37:05 +0200
Message-ID: <20240827143850.793413263@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 50c7537eb2250..e3e2c0b2f4959 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2398,6 +2398,8 @@ static void update_sit_entry(struct f2fs_sb_info *sbi, block_t blkaddr, int del)
 #endif
 
 	segno = GET_SEGNO(sbi, blkaddr);
+	if (segno == NULL_SEGNO)
+		return;
 
 	se = get_seg_entry(sbi, segno);
 	new_vblocks = se->valid_blocks + del;
@@ -3481,8 +3483,7 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 	 * since SSR needs latest valid block information.
 	 */
 	update_sit_entry(sbi, *new_blkaddr, 1);
-	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO)
-		update_sit_entry(sbi, old_blkaddr, -1);
+	update_sit_entry(sbi, old_blkaddr, -1);
 
 	/*
 	 * If the current segment is full, flush it out and replace it with a
-- 
2.43.0



