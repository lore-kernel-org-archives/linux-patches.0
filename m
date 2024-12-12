Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513CF176AA1;
	Thu, 12 Dec 2024 17:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024142; cv=none; b=tFqS8O+WsBLQSFbBAEE6Il7cdJAu/S2+P88mWSOi8+W6cfOWPSphxfwEHldxNZPoH6lzdW5yBd9HxTAJk9YE+u7SOVcBxb558eNKijBDHhhTmPVSj++Mg/RpCHTRW8J7Z0dyUIDsLMvROWZ+UmCAUyc0Eb8kB07VxyMUbWEtADI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024142; c=relaxed/simple;
	bh=jnBXcu/XPez81SoOIcxF/cRcn8yX5rFK6A8tceNbrSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyXn4+o3cdt8Q1EOaf1D+dBUw3XYkVNkeWLlQ0bLOjQT71Y5HRS4gNmmlHAZqI2f4WW8CMDPvKRJWxwAYFtRNqBl2Ab1S+Y3h9xxaRj7RSD5yAh0UA+3wmixQoHYkV6i2nAi/YouKpZrq3+zRlDrVDuhKFwLqw0mTmyNlIUZZko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixluNsUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixluNsUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE673C4CECE;
	Thu, 12 Dec 2024 17:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024142;
	bh=jnBXcu/XPez81SoOIcxF/cRcn8yX5rFK6A8tceNbrSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixluNsUVhq52PccwF8b3oCrcYOJngHUo4TBo6xhd3Ra9pat5Xij9ucgyPKo07V0rC
	 uJ/QZByZrIsVAQz/5O+caJ3EGwxX3F+9LkigzwdRprkhNmJjVgkRnU7r6qi8BDmZuO
	 WOGbNp+/Ug4azzEwXm4P0dCkIlkDXP7GzMGOYpBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng1@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/459] f2fs: check curseg->inited before write_sum_page in change_curseg
Date: Thu, 12 Dec 2024 15:58:58 +0100
Message-ID: <20241212144301.467819232@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d99c9e6a0b3e4..a6d05264f1365 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2691,7 +2691,8 @@ static void change_curseg(struct f2fs_sb_info *sbi, int type)
 	struct f2fs_summary_block *sum_node;
 	struct page *sum_page;
 
-	write_sum_page(sbi, curseg->sum_blk, GET_SUM_BLOCK(sbi, curseg->segno));
+	if (curseg->inited)
+		write_sum_page(sbi, curseg->sum_blk, GET_SUM_BLOCK(sbi, curseg->segno));
 
 	__set_test_and_inuse(sbi, new_segno);
 
-- 
2.43.0



