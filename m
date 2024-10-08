Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93B31DED7A;
	Tue,  8 Oct 2024 12:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392302; cv=none; b=nFMRXOpLD2ZUlSMxxhmN/kah4DWmhnUkKHCFd7ME4Df1syvAGbnDEB+s4+wJOw7kCubxPe9vi1kMAIQuBDtW6c+VQkHYVdElImVxp8ZG18SJV4Voehj9LcYTNf++uXSSsea69a3ffAkrlKvFos97eSIn7nJqax9Sw8wPk/wDxk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392302; c=relaxed/simple;
	bh=oaoijTgn43LntV2/ztkdf3IvBtSxdu4Khb0Q9qyfT2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDzEk2pcJa47cnlybVtpqRQ0C/tkiA8zSFYKqBXdljA17L9TDkDk3k+gN3x/t8Bc1qLGd44LivY7AzjLVnfEhTqygfyWKgwdU29Cg4+frCsLX3Sxyw8MFAiiEA/1nox4gzJRXNPTe+k8JBxSG5M+bV+Bn/ksn/6cWV3whLVo9xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sC/soE9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sC/soE9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37039C4CEC7;
	Tue,  8 Oct 2024 12:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392302;
	bh=oaoijTgn43LntV2/ztkdf3IvBtSxdu4Khb0Q9qyfT2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sC/soE9EQDX4uCV+2auzioupVCsU2tKSdaKzTVGSuocOpy6LOrpmAjuOs5N+8UAGm
	 /wNjFLV817+E56f2PohwrM8/jh98xCZP+yDgm0ksyAXNDBQsr8i6P5o2k6d4kbL2W8
	 yOyLltIT5PzRsmtdllZh6NqTl+WCBOplP+v1hpb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 344/558] f2fs: forcibly migrate to secure space for zoned device file pinning
Date: Tue,  8 Oct 2024 14:06:14 +0200
Message-ID: <20241008115715.837507306@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 5cc69a27abfa91abbb39fc584f82d6c867b60f47 ]

We need to migrate data blocks even though it is full to secure space
for zoned device file pinning.

Fixes: 9703d69d9d15 ("f2fs: support file pinning for zoned devices")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index a59fec64eccfb..938249e7819e4 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2056,8 +2056,7 @@ int f2fs_gc_range(struct f2fs_sb_info *sbi,
 			.iroot = RADIX_TREE_INIT(gc_list.iroot, GFP_NOFS),
 		};
 
-		do_garbage_collect(sbi, segno, &gc_list, FG_GC,
-						dry_run_sections == 0, false);
+		do_garbage_collect(sbi, segno, &gc_list, FG_GC, true, false);
 		put_gc_inode(&gc_list);
 
 		if (!dry_run && get_valid_blocks(sbi, segno, true))
-- 
2.43.0



