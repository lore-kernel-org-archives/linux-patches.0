Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1E43451B2;
	Fri, 20 Feb 2026 12:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771591100; cv=none; b=poermzghyxP2IVpNvCETuZHKLmafUkdoau307w4a8JbH4wq1OuDDFcfm8ERALCiPLJcN+pwQ8PbgCuYZnciPRJqxV+Oy0u3HMYKmzaQmIa3njcFY0N7mLMSbd7NBcjvGm/iTlnAgyGN5sPINdEZgbkvV0NvnJ4YzZ3Fe9/81lf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771591100; c=relaxed/simple;
	bh=PPTL2cjpbxNRendpC7/1CPalRuE6QYiEj3iAMQtCzjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGmn/hFOxh0+7knil4lziB82ulIqCoy0w70zOe1loZ0whfx0X+LiG2zC5V1qYhkLpKsoT5ZPtrwCLV2x/nUJ96Z4dfM7lG1JRS1Ofk1ktrKTAq6nI8hWuCswLIOQ9cm6HjnAAAxPPmc27hI8GT7PrkrORl4JZ5JbDiUNz+4prBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HDmVya+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HDmVya+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FBBC116D0;
	Fri, 20 Feb 2026 12:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771591100;
	bh=PPTL2cjpbxNRendpC7/1CPalRuE6QYiEj3iAMQtCzjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDmVya+u5Qtsm0j9+uvwf6PBPfKW3r/Yjz5HESLscOiHl7N5PxjgEPoyphaawVJHU
	 +OJKu+L6D7nsdrVCM2DpeFZUORlZvefBz6K8XvbWIKjQTXAhbbhFbBMZkmHfXQKKOr
	 Ie1Nyq27eQMVGy8TV1lzJrj+KnqO8a8asv53yI63RGWszT6VlYyIlYOyw6Dh6SFFRg
	 G0//QuyN+3QRJ8+6eQ2Y9ZWOMB8GZ47VpqF4TWf5lAzob7NZXGOGgrgDbV106x8bUQ
	 ZME4KvqIPEH02yY7lh9zJiV9SBPXiyHpns3lT2/s3aTQsz8qH/aULymV6idbwR0IGe
	 NbpT2McBqp4Hw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Szymon Wilczek <swilczek.lx@gmail.com>,
	syzbot+d27edf9f96ae85939222@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ntfs3: fix circular locking dependency in run_unpack_ex
Date: Fri, 20 Feb 2026 07:37:58 -0500
Message-ID: <20260220123805.3371698-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260220123805.3371698-1-sashal@kernel.org>
References: <20260220123805.3371698-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
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

LLM Generated explanations, may be completely bogus:

The background task completed but I already have all the information I
need from my analysis. My verdict stands as given above.

**YES**

 fs/ntfs3/run.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs3/run.c b/fs/ntfs3/run.c
index 395b204925258..dc59cad4fa376 100644
--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -1131,11 +1131,14 @@ int run_unpack_ex(struct runs_tree *run, struct ntfs_sb_info *sbi, CLST ino,
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

