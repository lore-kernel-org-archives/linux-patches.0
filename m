Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CB53806DA;
	Sat, 17 Oct 2026 17:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257119; cv=none; b=nnP6eJEz3KD0YWDyc13tsOvVHyOfWGo42D670ASe7N+8Ky5339PPcfBS1ihH6fojl17xJ4dP8077rbqzWYxw9dGDh7FwMHYLzIayhcoFkoKG/pmERWI91kQ4WJD+jbskXUJF6e7QlD5S4pmhn1z4M5xRrdFhkfb1wUHEEQp39ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257119; c=relaxed/simple;
	bh=XKNyjbQfefmsdSS8j+Jq/myo+iMWj1FGKkBdq4polMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miskXu+GB0ptVIMSoV0rXDw0w4eC6KJfBvyNjJ58lEPn0gHBCOMWaUb+W0uoKCCAnOKhV2zFd4NmJh8NEXvmDapxB5WKVISX96oejphS6EEmXE3VVEmaxg4epCY2d2VUmtfnPQe9cX0InYKuIohdn8Y+8CNzDLiORIdMZzpbVAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZYa6Ia8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZYa6Ia8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6996F1F000C4;
	Sat, 17 Oct 2026 17:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257118;
	bh=ATfW7gxkAqU6WKVk+my6wtqWJjpRXkutmtJmoA8+E8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZYa6Ia89Ad5Db4q2DZMWtL4Swpmh5tPAQoNp3tLd3boQ+55MXfxwLi9Q9zg7iuvA
	 7U+e8pgse5xmpU4sPyPCNgQuX3vPVfdX8CNGH5tgzLDcW/Y5neC8YQ2eNAg8P/tG/O
	 o8J/6wAOOJHYfTWV5Mnr4/HG0ILeKq5/l9MjCw9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0457/1674] f2fs: fix to reset all pinned status during fggc
Date: Sat, 17 Oct 2026 17:45:29 +0200
Message-ID: <20261017160442.844812521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 2b8704b6a8b2896ccad1f5941d9a3e2c5031a470 ]

Otherwise, the pinned status may affect latter flow of fggc.

Cc: stable@kernel.org
Fixes: 9703d69d9d15 ("f2fs: support file pinning for zoned devices")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index f1e1ee8e4c44c..d8e247cb60a25 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2058,6 +2058,9 @@ int f2fs_gc_range(struct f2fs_sb_info *sbi,
 						dry_run_sections == 0);
 		put_gc_inode(&gc_list);
 
+		/* reset all pinned status during fggc */
+		f2fs_unpin_all_sections(sbi, true);
+
 		if (!dry_run && get_valid_blocks(sbi, segno, true)) {
 			err = -EAGAIN;
 			goto next;
-- 
2.53.0



