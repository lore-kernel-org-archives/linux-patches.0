Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924F4222D68;
	Thu, 12 Dec 2024 16:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019703; cv=none; b=mruUcLb/ynXFBnMCWgk0JxeWFvG0inCJzfl20R0M9yPNfR3bykyNQuRoJfY/3ZZz8jNY0+MWQlvwgY52cXeJNUYRca33pqIxrz9DVPKOVnApjeSAldXV5pbxV8UpTKE6jAgbfyQ4nvv40SV7U9MiDrDIDVOdw+NpJLYUnlTnD6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019703; c=relaxed/simple;
	bh=KZswlLjyVgSstdDZvwzdP3K/xVqU3YsrDEth47rwqUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYHGGAHiD7mTHodzXgISmsYMaCey9kAhlAK6rvm93ZdpbzWnzOg3x8h4CbuDgq36pjMI9RPNIywveFOy43Xs7PrcN/XxpUzhHv5u3GhEkfmYGdSfW6TqoIsxdd66CiEyNk3jrqrLBaVClsfNcEmhnUHvdEAEh+hGy4dpi0WLs2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bM+rHbfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bM+rHbfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A81C4CED3;
	Thu, 12 Dec 2024 16:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019703;
	bh=KZswlLjyVgSstdDZvwzdP3K/xVqU3YsrDEth47rwqUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bM+rHbfrObTZVtwggPVDEE+gHkttCw8h/OiIyPtREUiqm6pph+zx63W1VQvNrH0ta
	 excCaJ2O8QNNZ1DUs8Lya4U6VvWeTR7BUfy24N4tah52kyWyn8ex7sZ6h/YewZiQ9o
	 9puoZCpXFda0nHjTXcCmA6D3k5QAMMOzOijFjy7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng1@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 276/772] f2fs: check curseg->inited before write_sum_page in change_curseg
Date: Thu, 12 Dec 2024 15:53:41 +0100
Message-ID: <20241212144401.315950558@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng1@oppo.com>

[ Upstream commit 43563069e1c1df417d2eed6eca8a22fc6b04691d ]

In the __f2fs_init_atgc_curseg->get_atssr_segment calling,
curseg->segno is NULL_SEGNO, indicating that there is no summary
block that needs to be written.

Fixes: 093749e296e2 ("f2fs: support age threshold based garbage collection")
Signed-off-by: Yongpeng Yang <yangyongpeng1@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 884b3d9d1de62..72bbdb29e8381 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2674,7 +2674,8 @@ static void change_curseg(struct f2fs_sb_info *sbi, int type)
 	struct f2fs_summary_block *sum_node;
 	struct page *sum_page;
 
-	write_sum_page(sbi, curseg->sum_blk, GET_SUM_BLOCK(sbi, curseg->segno));
+	if (curseg->inited)
+		write_sum_page(sbi, curseg->sum_blk, GET_SUM_BLOCK(sbi, curseg->segno));
 
 	__set_test_and_inuse(sbi, new_segno);
 
-- 
2.43.0



