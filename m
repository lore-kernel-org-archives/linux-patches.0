Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702D78F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3076C433C8;
	Sun, 16 Jul 2023 20:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538898;
	bh=GYe3VqSJXOpFw5eG3mjR8dMHbM4YhemJ+fFG/Sx4piw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNtQgykRTHCyDgWAM2pEQ5dSgqw/oXfaZVGdDPWAhNK4wB7mHnRUeuWUCsAx8XCeG
	 H26qqMSef05wGd1MLVx/+RwA6b6kIO60NK+tOkho5iNiC/gtU/4yzJkx5tg/j3oNHM
	 b0JxbN73XII/ttMvV8WzaBpk68D8udW3pl9s8qj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 615/800] f2fs: fix the wrong condition to determine atomic context
Date: Sun, 16 Jul 2023 21:47:48 +0200
Message-ID: <20230716195003.395801742@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 633c8b9409f564ce4b7f7944c595ffac27ed1ff4 ]

Should use !in_task for irq context.

Cc: stable@vger.kernel.org
Fixes: 1aa161e43106 ("f2fs: fix scheduling while atomic in decompression path")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 901c12d14457 ("f2fs: flush error flags in workqueue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 2ec7cf4544180..905b7c39a2b32 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -743,7 +743,7 @@ void f2fs_decompress_cluster(struct decompress_io_ctx *dic, bool in_task)
 		ret = -EFSCORRUPTED;
 
 		/* Avoid f2fs_commit_super in irq context */
-		if (in_task)
+		if (!in_task)
 			f2fs_save_errors(sbi, ERROR_FAIL_DECOMPRESSION);
 		else
 			f2fs_handle_error(sbi, ERROR_FAIL_DECOMPRESSION);
-- 
2.39.2



