Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7151DF756;
	Tue,  8 Oct 2024 12:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390436; cv=none; b=A5C7839QogGnod8z7/vvpe0+nDjdJSSKxMyRbFJI3rZ2zajblhRtEGa/d8zZSOpHsFlEYsOcKZYi1L6PsIG6zR0ApqTmiydRjDx3Wm6uPK/xbloHq5PTuRo5XN7NQXHg663ZMp0oaPUw9ZuNf2LdBo0z3sctojmCD7vQxPgYnU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390436; c=relaxed/simple;
	bh=eGbeovqX/V6FBuWHwoT6RSmhJFgwPq2fbVoOG1c7ZbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtBJlCvVOchbjjfv6xy7cMVFt/tsc8VuIA2zlkx5YWZAXBBt47SLyZqcpazpSLM8KwlHQ0fM17N9ADEvD2Fc2ivfn2w6ZZzYKZKtIAKuPiHWWJFLMtPua8ESgtL1RR/bwEpUAX8M+U9FInxbt1ZKMX60mwW/v5fRXmXOPN2ed8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hifDn8Al; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hifDn8Al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B558DC4CECC;
	Tue,  8 Oct 2024 12:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390436;
	bh=eGbeovqX/V6FBuWHwoT6RSmhJFgwPq2fbVoOG1c7ZbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hifDn8AlgosaXVft4Yfac/lcRsCH4/quckPa+jwOlwYVDwxFmVRbGAKaQ7J41RlWL
	 9GB1ZWQXSHEmEtvxcZ1BmO7Dn5ky9DIwjOCnGCJdsvyzeKYgoAQafgumDt/xmyk7a/
	 IUUWeSb/AmEFhbRz93nm/c/52ggIbHGctgTPJxkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 287/482] f2fs: forcibly migrate to secure space for zoned device file pinning
Date: Tue,  8 Oct 2024 14:05:50 +0200
Message-ID: <20241008115659.572903096@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2fbac9965dc3f..e8bf72a88cac8 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2057,8 +2057,7 @@ int f2fs_gc_range(struct f2fs_sb_info *sbi,
 			.iroot = RADIX_TREE_INIT(gc_list.iroot, GFP_NOFS),
 		};
 
-		do_garbage_collect(sbi, segno, &gc_list, FG_GC,
-						dry_run_sections == 0, false);
+		do_garbage_collect(sbi, segno, &gc_list, FG_GC, true, false);
 		put_gc_inode(&gc_list);
 
 		if (!dry_run && get_valid_blocks(sbi, segno, true))
-- 
2.43.0



