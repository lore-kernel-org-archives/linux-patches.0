Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F5E4F5DFB;
	Tue, 13 Oct 2026 11:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892796; cv=none; b=FGrS9ivg/0QqNo3stpzKNYCGXx8u0XearGmJrYBQ8seBOoVjGjjgUNqzVTbbmx1S9H6OrFbu+W+MLZuPQta/AJ0j7FiVfleRqBuNx4yp61Ho0qFyEXjQpiaLOgGlDxNuKMJyIc+1J39l3XfN9hls5KMoyDY65uKKwaYtqc5fOkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892796; c=relaxed/simple;
	bh=ZYQcvse47x9Rswl7GufecRJBTqtgQFaeIO2R8MB83CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2wvPEPVGh/elLXWeowc0GJhlZsoBfmhYytqbGoMm0aU2rV8c9FpwL2D4fIttlRtCicbR+evQ4rvYAjKKX3EvY1KkHqtDCsZdYcJe9wLmzOkl9hcm9EmX7/X2DMxfw+A5Ul3uyt6n8TxMIhI/itavgbQ3ZxNzfUVhNH+NWfvb8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+IxoKeK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+IxoKeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EFB1F000FF;
	Tue, 13 Oct 2026 11:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892795;
	bh=kUi02dVGxTPUjat4azkebMdoxxeYszm5WJ2zjANpzRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+IxoKeKE60MlIkjkmonVdIQwdW5IzMejyHvIBzi7mwMrwqdbv+CThHnbwNJYP2QR
	 tsDzMMBZt0SFSOt9rcHfMoKVlcUzy2hJ5+a6w2FrJiLjE03X+MC58XKMZejmJ9Xp3N
	 Ac6HYd8JiqF4uD4UtQi4LnID2vHhkFEgktv/wXUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/621] f2fs: fix to reset all pinned status during fggc
Date: Tue, 13 Oct 2026 13:30:07 +0200
Message-ID: <20261013112921.155466023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 07ea51e68d741..02bd008d79b5c 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2153,6 +2153,9 @@ int f2fs_gc_range(struct f2fs_sb_info *sbi,
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



