Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD441168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33ACCC433EF;
	Mon,  8 May 2023 10:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540279;
	bh=tStkMQ6lfeqNfiLI0NZmx3bZzT/NOweDFNWzH7WYP5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhdptwbpVhtkfKXrK38EIPUK6J+SbfFaagjZ2Dz4/EH+TKA6jcITDTGzgJJJmeLab
	 rVs6LYfCXHvziUnqs2vdUIJM/401fufG6vR1Efjde9HaVdROpBkR7YQnX+cxV5+M6k
	 OUIKdl1wpS2goTJ2yI5tAmv5x/6Qer291nR3ocA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonggil Song <yonggil.song@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 304/611] f2fs: fix uninitialized skipped_gc_rwsem
Date: Mon,  8 May 2023 11:42:26 +0200
Message-Id: <20230508094432.303471796@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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

[ Upstream commit c17caf0ba3aa3411b96c71b4ce24be1040b8f3e8 ]

When f2fs skipped a gc round during victim migration, there was a bug which
would skip all upcoming gc rounds unconditionally because skipped_gc_rwsem
was not initialized. It fixes the bug by correctly initializing the
skipped_gc_rwsem inside the gc loop.

Fixes: 6f8d4455060d ("f2fs: avoid fi->i_gc_rwsem[WRITE] lock in f2fs_gc")
Signed-off-by: Yonggil Song <yonggil.song@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index ee6836478efe6..aa928d1c81597 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1792,8 +1792,8 @@ int f2fs_gc(struct f2fs_sb_info *sbi, struct f2fs_gc_control *gc_control)
 				prefree_segments(sbi));
 
 	cpc.reason = __get_cp_reason(sbi);
-	sbi->skipped_gc_rwsem = 0;
 gc_more:
+	sbi->skipped_gc_rwsem = 0;
 	if (unlikely(!(sbi->sb->s_flags & SB_ACTIVE))) {
 		ret = -EINVAL;
 		goto stop;
-- 
2.39.2



