Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FF420B7E4;
	Fri,  6 Dec 2024 15:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497765; cv=none; b=cDoOy59whaxDYyi8TDe8UcdakDVtAM+yojsCXaKEDv14mD7jCLE4U6hEBKZrf1ogBN1s8f1tst7aGm0eW7/ExI/Vndmwwrcw3eJqHPAMmOwNdAuelRjn6M6mkSlX4ptJqOkG82mHopzIEVla4VrlstDZk4PzJHeBB0FfQi2HXnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497765; c=relaxed/simple;
	bh=rtYQ7fNALZ4O/LCq5UozlkERZ7frxO39cq4osP0Y4Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IN1dbQ0o7IHdpwh2vvKKxzWcKc0qsMzHjUPlP1LjbE9lCHyJbVy5nKPR2ptmVFKFGc7tjIHR0na6gx11BcR2WUkfTcvgyzRLvR7OYQoYERPFzeu4OTKLbo4/Rwkx+UqadVBrHis8NjJq5lQxaaG2kepwyZNbV8um8rew8eEg9vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQABMP6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQABMP6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF36C4CEDC;
	Fri,  6 Dec 2024 15:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497764;
	bh=rtYQ7fNALZ4O/LCq5UozlkERZ7frxO39cq4osP0Y4Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQABMP6pHR0NejULMMgTDtaUMh1HZpgLEe7+p4fsn7sA7rE2gwr8DSHFx9xo5ITno
	 +yH7Zw0VrzHZmH0xbBDiHTWQs7zRDGxFxhqbmd6B7F+M86xR7y2Cd2OKUsnL9dTgZh
	 4YK8G/98ZiM8K1HjGBBlzbiOQDD1/V883bXy1fTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng1@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 355/676] f2fs: check curseg->inited before write_sum_page in change_curseg
Date: Fri,  6 Dec 2024 15:32:54 +0100
Message-ID: <20241206143707.215282183@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 9ccff4f159c3b..670104628ddbe 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2848,7 +2848,8 @@ static void change_curseg(struct f2fs_sb_info *sbi, int type)
 	struct f2fs_summary_block *sum_node;
 	struct page *sum_page;
 
-	write_sum_page(sbi, curseg->sum_blk, GET_SUM_BLOCK(sbi, curseg->segno));
+	if (curseg->inited)
+		write_sum_page(sbi, curseg->sum_blk, GET_SUM_BLOCK(sbi, curseg->segno));
 
 	__set_test_and_inuse(sbi, new_segno);
 
-- 
2.43.0



