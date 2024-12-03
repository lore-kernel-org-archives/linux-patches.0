Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A82B1F76A4;
	Tue,  3 Dec 2024 16:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241723; cv=none; b=ERZdFXODSeVKxeaFqrHux+/DAMnw3fZeD04O3FT6jkAx1a8L6Nd5yGSxmnFdQBfjZg/fWxcCuDMpOGtxhNQQdrDJUz9qjCgB/qrJrNE0tkbYP9sxGVHpVpEeggUa0WPkm2gZyaRCUrSFiQzlpppoVosR0gaDOymLdWodLcJJmrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241723; c=relaxed/simple;
	bh=/j6F0g9IFuHiHuxHHLa99NqfmZVdU3OZ/ycOZ5vwPAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKJK7zdNux78vyib45ZU7r7CWkm49xWrL2CD1+eXS1rIZNEPKpVncnNl7j3hRHkUp5nHOssxSdKNe1JVum/yTHRBZ1/VgUWYtI55WCzFkdOpWlD4uCE+eDiABXRZvCdyZqQVMxJkbQhqayhxuzA3dm+Z5IgKwyjnb81NUpx5cA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNYmZJf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNYmZJf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D73BC4CECF;
	Tue,  3 Dec 2024 16:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241722;
	bh=/j6F0g9IFuHiHuxHHLa99NqfmZVdU3OZ/ycOZ5vwPAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNYmZJf5Rzj8WVuUKOtRmFlkaopGlKi2enlcpQgwuGjfdwFC9PLhyLwhLQq/yZiBo
	 fo+J0nent6gyLEzR2b8fJqC8GiNU5GCsY7FhxEFTPelgWUmKJsPXTL4RxuYPFpixrF
	 2FjSvyb98bBBGcfrPbN2kBqaf/gobJ2kcf3uqKgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng1@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 498/826] f2fs: check curseg->inited before write_sum_page in change_curseg
Date: Tue,  3 Dec 2024 15:43:45 +0100
Message-ID: <20241203144803.180296207@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7b54b1851d346..edf205093f435 100644
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



