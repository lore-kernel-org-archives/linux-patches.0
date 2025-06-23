Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BA93FB1B;
	Mon, 23 Jun 2025 22:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716285; cv=none; b=ARmor0Zy/pAFsuSxyWgCAZtOQpMzyLs1vbLG1SiksN/Diqt/8xYVqmERo992aeybZdDgCERPGdwRH0AJ8PuxLD6NAyafu/JmidI3EyS5xggtzVWrOEVIKylX+BQjAPlLefaG+g0HiiHEK2Xp9XAeAolQehsBgCzImHmQiE3ZtV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716285; c=relaxed/simple;
	bh=z+io1kUgWoBvD8dk2fKl+DFDESLE91qOUAy93X8oKy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MM8/dgvj/7IfwqW8Awxv8x/90hzq9y9ZJjRiDWx7vcev8M8J37FRRG1JxAGlX2qrFox4AFnln2uTUULr4QqakfujAnLa266lmm3OhR+AifxLyOv/4DjaSfl2ZceoG8novahwPnnux1YCyqTHlPQx8n7t2bBW9wv8xsj4ewdUHuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWm6fhq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWm6fhq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42750C4CEEA;
	Mon, 23 Jun 2025 22:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716284;
	bh=z+io1kUgWoBvD8dk2fKl+DFDESLE91qOUAy93X8oKy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWm6fhq4iLo65vFEHp4lrjSBY5bTg1iYpAmOtApvHwFF72Rtffg8TFPbtHnFqmmqv
	 7qIimx2pB786afDrbEP6/K1jLKqFzvL4brbyjYdqsyYRWd3vNLDho1zDEfV0kvOtJs
	 UlT04mzu4kpbf+3iGw9CcjbDAaGqpe1bmWZXKAY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/414] f2fs: fix to bail out in get_new_segment()
Date: Mon, 23 Jun 2025 15:06:18 +0200
Message-ID: <20250623130648.073178436@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit bb5eb8a5b222fa5092f60d5555867a05ebc3bdf2 ]

------------[ cut here ]------------
WARNING: CPU: 3 PID: 579 at fs/f2fs/segment.c:2832 new_curseg+0x5e8/0x6dc
pc : new_curseg+0x5e8/0x6dc
Call trace:
 new_curseg+0x5e8/0x6dc
 f2fs_allocate_data_block+0xa54/0xe28
 do_write_page+0x6c/0x194
 f2fs_do_write_node_page+0x38/0x78
 __write_node_page+0x248/0x6d4
 f2fs_sync_node_pages+0x524/0x72c
 f2fs_write_checkpoint+0x4bc/0x9b0
 __checkpoint_and_complete_reqs+0x80/0x244
 issue_checkpoint_thread+0x8c/0xec
 kthread+0x114/0x1bc
 ret_from_fork+0x10/0x20

get_new_segment() detects inconsistent status in between free_segmap
and free_secmap, let's record such error into super block, and bail
out get_new_segment() instead of continue using the segment.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c       | 6 +++++-
 include/linux/f2fs_fs.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b9ffb2ee9548a..769a90b609e2c 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2772,7 +2772,11 @@ static int get_new_segment(struct f2fs_sb_info *sbi,
 	}
 got_it:
 	/* set it as dirty segment in free segmap */
-	f2fs_bug_on(sbi, test_bit(segno, free_i->free_segmap));
+	if (test_bit(segno, free_i->free_segmap)) {
+		ret = -EFSCORRUPTED;
+		f2fs_stop_checkpoint(sbi, false, STOP_CP_REASON_CORRUPTED_FREE_BITMAP);
+		goto out_unlock;
+	}
 
 	/* no free section in conventional zone */
 	if (new_sec && pinning &&
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index c24f8bc01045d..5206d63b33860 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -78,6 +78,7 @@ enum stop_cp_reason {
 	STOP_CP_REASON_UPDATE_INODE,
 	STOP_CP_REASON_FLUSH_FAIL,
 	STOP_CP_REASON_NO_SEGMENT,
+	STOP_CP_REASON_CORRUPTED_FREE_BITMAP,
 	STOP_CP_REASON_MAX,
 };
 
-- 
2.39.5



