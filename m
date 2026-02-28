Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B060243636C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301192; cv=none; b=S347e5lPZIz7UmiKM5QCknn7XOhAVIUkkG304+Xs90ecDTPi/y8ep2qM68FA17j4TBQMlWaNZFwSy4F7FAX20PNXLqQsxSqwDovZOws688te28fAx5QOn2tF1PLsH7L8hUiBBauglJ7HtqswMal/6mOjbxINVsb7qmeWt+A3ZgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301192; c=relaxed/simple;
	bh=gMK2WcOWJT9VZiN/huhIBPabqNf1xlyuX+5Roxcyj/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tz1/PRjr+z0eRfdoKJxq63UfovzJdqgTcM/+DGF4OIAd1bhnwGIosgxOnza9LLStYa+68g0XB5q1bO3uTnOrVtH1CPRRQkAvM0KZ2DILU7jNR49Ooipr4H+WF7iura4aFNo/7i5xcB16AFhAngXTZ1cfIYNTmO8kCZWqBabPkck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mtENFUP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mtENFUP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E62CC116D0;
	Sat, 28 Feb 2026 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301191;
	bh=gMK2WcOWJT9VZiN/huhIBPabqNf1xlyuX+5Roxcyj/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtENFUP9oL2J1rIxI27ovZMfyI/K9qiLCUr6C6E+F/lEt8WAtnaq7gKMIceQ9nXvc
	 QeHo+QFvKeSheV81CqtbrtnAxA+TQaWPzh5SbeJbVa7TxWCVNEDS7kD/xAu2KVJ9hY
	 6GAUD0amPM5Ne1eUxxM0QwqBSl8HuUR6SP/+lP8loAsFjw4TQAiMSEM24WX5g+6PLR
	 hyOxijpI5bBrLXiL+hf6VvK9+UV+azyBwQq3otkdZpnjQUJQCg7BEnt8Im8Oy7NGLc
	 GjLuTa0AUv631qUrmUEbBGvvNtsp/8CXaqfnBSbVXcBSG8h3Vy5boahRpoNXCMII+o
	 b8XxBsUAulvUw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Szymon Wilczek <swilczek.lx@gmail.com>,
	syzbot+d27edf9f96ae85939222@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 362/752] ntfs3: fix circular locking dependency in run_unpack_ex
Date: Sat, 28 Feb 2026 12:41:13 -0500
Message-ID: <20260228174750.1542406-362-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 5df55e4adbb11..21decc2922823 100644
--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -1124,11 +1124,14 @@ int run_unpack_ex(struct runs_tree *run, struct ntfs_sb_info *sbi, CLST ino,
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
2.51.0

