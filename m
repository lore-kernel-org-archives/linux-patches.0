Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF96E1F6696;
	Tue,  3 Dec 2024 15:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239209; cv=none; b=SHBsp0JSAYbv7X7mp5valMcRZinMitsIHb75iLA2C+dMdlQZ+4jfuxisF362OnI/XuYoNr712fCu4nxUhlMx5x/2+Ec/dns49prEVXjQrL3DALD3vrT0g21Pb0kF1LUBVGi1sSUBzVzAi73btU4I189x4xUZyN41f6TOqFVMlCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239209; c=relaxed/simple;
	bh=jRZnISTpeeHMzze58iio5jFVX2uO9drP9skvJ6MKvEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZswLOQbCsSoEffDNAfrNAylI+BxZrDNNLpyyw8iVagp0x1lWzu8insU2D/peUH3JA+rUtVfHyLjxtaOq4YjOEFwQkd36LUFeIzzY61TNBStd/jYOsmZH10v5eWBTyl4n5SUxRf1apll7da4S3PeBAtt0dvXLcB8rAa2fXqhu8nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULiAbQz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULiAbQz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60186C4CECF;
	Tue,  3 Dec 2024 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239208;
	bh=jRZnISTpeeHMzze58iio5jFVX2uO9drP9skvJ6MKvEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULiAbQz1iQ6YMhqNsiMVx+KI/jEYDLXHwPSagYummEUUyqcoyNC82q68nOB4l/x4J
	 PnItaVaPQ3FTir4NdXkeX5l03l2STVjl+I5Xw7gv7dWZ3DIYT9bLo5vRUgGyDEw8XW
	 NhtPqHsRcD8cFVun0v+ht2esj9xEsruMHfs4xidk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng1@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 509/817] f2fs: check curseg->inited before write_sum_page in change_curseg
Date: Tue,  3 Dec 2024 15:41:21 +0100
Message-ID: <20241203144015.742660817@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 3f49a9e0ec642..6379d9c40a024 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2926,7 +2926,8 @@ static int change_curseg(struct f2fs_sb_info *sbi, int type)
 	struct f2fs_summary_block *sum_node;
 	struct page *sum_page;
 
-	write_sum_page(sbi, curseg->sum_blk, GET_SUM_BLOCK(sbi, curseg->segno));
+	if (curseg->inited)
+		write_sum_page(sbi, curseg->sum_blk, GET_SUM_BLOCK(sbi, curseg->segno));
 
 	__set_test_and_inuse(sbi, new_segno);
 
-- 
2.43.0



