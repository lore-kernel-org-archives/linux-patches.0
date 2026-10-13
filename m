Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896C5339872;
	Tue, 13 Oct 2026 12:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895653; cv=none; b=ubW8QkJyfi/Y3Yh5kgdvOxOaYebX/kfGw42Wp6dFd2NnPDaNu9h6Ylq5mlMtXlVPpjCD78CQ/CTNCWzXepOoTZDLxfFBe50/AHtzMsuKc/yJL1nXhzCdQodDiMfNY/BXvv8onIbiV7iO7dQCtlGXCppLVD2OymqY5trBJbLaCj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895653; c=relaxed/simple;
	bh=cBYDMla1bpyUazD512Zvu4MrC2IdaNvmR6NrUkGnfT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/71JYDG7iyKQqUasNB57SPvfavy/FkxmjeCcc5PsUhbZ3NaI5mfP+9KlVrGYJui5m6XoaGgkY4ht56K+3LSco50scMjq202W4iI/nrDsPm7UsTZVp/Dto02vOLTIHWQufofK0XDlt7sB6/WThSNGiMnH911Ru1p22PCMm3jzGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYh+ndrH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYh+ndrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7F11F00893;
	Tue, 13 Oct 2026 12:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895652;
	bh=8IsvMPAsyje8Hkgf/e5KJu/vm+iDLyFq8fsICya9zF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYh+ndrHfCvFdkimKolOGNCjI0p8zoCS6+LuQ3IfgjzfGTteIjWDRJcw2ckPd9ova
	 OehZ/H57p6HWtc+buPjYQ+RrciSlBv3xT3kC3dLv3v7RvPEJTipKIexU+ZxwT3o+P6
	 WRdyraDu9XYNTb8bA/Yc+UL9qAz7fsDGvYD/ogGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 347/497] f2fs: fix to reset all pinned status during fggc
Date: Tue, 13 Oct 2026 13:38:34 +0200
Message-ID: <20261013112916.142019708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 664260807072f..6c831276d81da 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2132,6 +2132,9 @@ int f2fs_gc_range(struct f2fs_sb_info *sbi,
 		do_garbage_collect(sbi, segno, &gc_list, FG_GC, true, false);
 		put_gc_inode(&gc_list);
 
+		/* reset all pinned status during fggc */
+		f2fs_unpin_all_sections(sbi, true);
+
 		if (!dry_run && get_valid_blocks(sbi, segno, true)) {
 			err = -EAGAIN;
 			goto next;
-- 
2.53.0



