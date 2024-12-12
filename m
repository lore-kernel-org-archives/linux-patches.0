Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93663229687;
	Thu, 12 Dec 2024 16:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022479; cv=none; b=dloostu6qk+C8hS1nRHbWkzm/3p45IftUntPO/YllOxb+YGVFchLfb0lfPBpSbZa6gjq4aMOOGCCyCj3JXUwuQEQj+5PyhtxhOziB0a25AjNd9atkjjOYAG2WG1y1JvEFmpCLQnNA3reeCTlw9Ik0dXRfzIq+7rkR7gXHZLVuLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022479; c=relaxed/simple;
	bh=GV031yMwLCnx0Coq/RK4Q/0D448hBuy5wKlTeyyugqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4WbiaTcs0UMpwnRSnKSpkXjnFe+HPwrQzhtFm0x+V7iVfySZglASs/BPjhuA8g8mngcP7Po1QJP5fjWX0ar7rtvPkSkaDF9/e4dZTisjhmtdC6VuE+uvO0UF6SrSy4l4vyqu8ZQX1EDDVpdN54ohJsMHyJ5cXJj7sQMEWuSjvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxHY4dqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxHY4dqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132CCC4CED0;
	Thu, 12 Dec 2024 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022479;
	bh=GV031yMwLCnx0Coq/RK4Q/0D448hBuy5wKlTeyyugqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxHY4dqaDFs7EjWtPc22GI2RR4/kPs2tkErG7WGQKCrvZ8N+sz2XJeWhnAqh+Uikq
	 SwhzxdcPeSjjxGXLc7S0fY6oIliIJtFA4oNFDUSwbs++TEye7oGE/wLjRCGGVsKbV1
	 ZvIwY6es5Gv+/D4BvJ2Y8CMy51Kc1JKhr0w8g7iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng1@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 251/565] f2fs: check curseg->inited before write_sum_page in change_curseg
Date: Thu, 12 Dec 2024 15:57:26 +0100
Message-ID: <20241212144321.399350467@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3e5900ddb92b0..0b284a28afeda 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2737,7 +2737,8 @@ static void change_curseg(struct f2fs_sb_info *sbi, int type)
 	struct f2fs_summary_block *sum_node;
 	struct page *sum_page;
 
-	write_sum_page(sbi, curseg->sum_blk, GET_SUM_BLOCK(sbi, curseg->segno));
+	if (curseg->inited)
+		write_sum_page(sbi, curseg->sum_blk, GET_SUM_BLOCK(sbi, curseg->segno));
 
 	__set_test_and_inuse(sbi, new_segno);
 
-- 
2.43.0



