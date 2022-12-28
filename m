Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F851C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FAFC433F0;
	Wed, 28 Dec 2022 16:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244034;
	bh=clzR/cOOdvHGH/VHudpxjtC4w2o6YMPvqn56P5T68o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuXaMimpvGgSrrdbbbreN52JjeheqH0DCuCoXUMOSPMFrQ5mW8cfGjGlEug0w0BAI
	 3N1xH/YAvuf5JfphCjkecp0tXuzcKixMu7OyLTCA46SARB1jYpeRIDZ9Np/EWFi1y1
	 /Bw4knfJZ8qhHDDLLGR8U8RNa2PCAA2z0pvTN8QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonggil Song <yonggil.song@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0635/1073] f2fs: avoid victim selection from previous victim section
Date: Wed, 28 Dec 2022 15:37:03 +0100
Message-Id: <20221228144345.289603303@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yonggil Song <yonggil.song@samsung.com>

[ Upstream commit e219aecfd4b766c4e878a3769057e9809f7fcadc ]

When f2fs chooses GC victim in large section & LFS mode,
next_victim_seg[gc_type] is referenced first. After segment is freed,
next_victim_seg[gc_type] has the next segment number.
However, next_victim_seg[gc_type] still has the last segment number
even after the last segment of section is freed. In this case, when f2fs
chooses a victim for the next GC round, the last segment of previous victim
section is chosen as a victim.

Initialize next_victim_seg[gc_type] to NULL_SEGNO for the last segment in
large section.

Fixes: e3080b0120a1 ("f2fs: support subsectional garbage collection")
Signed-off-by: Yonggil Song <yonggil.song@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index af915f801455..68eb1d33128b 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1738,8 +1738,9 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 				get_valid_blocks(sbi, segno, false) == 0)
 			seg_freed++;
 
-		if (__is_large_section(sbi) && segno + 1 < end_segno)
-			sbi->next_victim_seg[gc_type] = segno + 1;
+		if (__is_large_section(sbi))
+			sbi->next_victim_seg[gc_type] =
+				(segno + 1 < end_segno) ? segno + 1 : NULL_SEGNO;
 skip:
 		f2fs_put_page(sum_page, 0);
 	}
-- 
2.35.1



