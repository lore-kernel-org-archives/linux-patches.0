Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551AC30216D;
	Sat, 17 Oct 2026 16:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253810; cv=none; b=Sf2Mup18VbiEVlaWnuf/DZ3GQa+8SbrBZEQNql6wF0vtmoQjc1PAtVCyp/7bA6R8Z8HKuWYJjDTqadg1HlLf9AxQIZZ1c610nYqz/xlstTVaoWbEUrdhELUWqnyFJHkja3AIknfsFzjvDSGlmstiBBbDrBtsduF+xWdBWa04Tic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253810; c=relaxed/simple;
	bh=LjWa1559LwtmOC0WBgLhY7uODCmFmV77y61Tt4LUpwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/f8HDcw8CT0ReeyWZaOme2lkRt4Rn9hvu0AxWw5Isl2vDslw/s8ZxjQoyPnVOhhsJ0MOWrnwWKqXFSiUozl7nKUI6ycC8wFXz0vvmQBvIfbKZiPHylpa6JaB7Kt8n7r3chBvt6gm+xhoTaxcv+FWoflSSqqtUniRZ6KCgg5iLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNy2aM75; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNy2aM75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14891F000C4;
	Sat, 17 Oct 2026 16:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253809;
	bh=9mchsPcEaS5BQtTXq3h9hCXq8R2h+UteQYBZ5JQo/yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNy2aM75ljGa6yOLAhUgZparse4j/u0yls9YlFomMmqZUy01LhyLpGf8LtEL50lOC
	 9X+hMfXXaGuqdau9Dv/ZqCkZSFlVHYaZRptv7I/ulKM2NgEeHDE2zddB4bjU8y8gxe
	 gDGNfqO1lXIkj+DKGyOYtOCnHyQ16oDYEqKiN/8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d27edf9f96ae85939222@syzkaller.appspotmail.com,
	Szymon Wilczek <swilczek.lx@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/869] ntfs3: fix circular locking dependency in run_unpack_ex
Date: Sat, 17 Oct 2026 17:51:20 +0200
Message-ID: <20261017160043.183274845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Szymon Wilczek <swilczek.lx@gmail.com>

[ Upstream commit 08ce2fee1b869ecbfbd94e0eb2630e52203a2e03 ]

Syzbot reported a circular locking dependency between wnd->rw_lock
(sbi->used.bitmap) and ni->file.run_lock.

The deadlock scenario:
1. ntfs_extend_mft() takes ni->file.run_lock then wnd->rw_lock.
2. run_unpack_ex() takes wnd->rw_lock then tries to acquire
   ni->file.run_lock inside ntfs_refresh_zone().

This creates an AB-BA deadlock.

Fix this by using down_read_trylock() instead of down_read() when
acquiring run_lock in run_unpack_ex(). If the lock is contended,
skip ntfs_refresh_zone() - the MFT zone will be refreshed on the
next MFT operation. This breaks the circular dependency since we
never block waiting for run_lock while holding wnd->rw_lock.

Reported-by: syzbot+d27edf9f96ae85939222@syzkaller.appspotmail.com
Tested-by: syzbot+d27edf9f96ae85939222@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d27edf9f96ae85939222
Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/run.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs3/run.c b/fs/ntfs3/run.c
index 18b8767acba5f..66baaada02e9a 100644
--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -1136,11 +1136,14 @@ int run_unpack_ex(struct runs_tree *run, struct ntfs_sb_info *sbi, CLST ino,
 			struct rw_semaphore *lock =
 				is_mounted(sbi) ? &sbi->mft.ni->file.run_lock :
 						  NULL;
-			if (lock)
-				down_read(lock);
-			ntfs_refresh_zone(sbi);
-			if (lock)
-				up_read(lock);
+			if (lock) {
+				if (down_read_trylock(lock)) {
+					ntfs_refresh_zone(sbi);
+					up_read(lock);
+				}
+			} else {
+				ntfs_refresh_zone(sbi);
+			}
 		}
 		up_write(&wnd->rw_lock);
 		if (err)
-- 
2.53.0



