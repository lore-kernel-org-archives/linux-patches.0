Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701ABE555;
	Sat, 17 Oct 2026 17:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258543; cv=none; b=SbD319vbmIqBy8CJqvNNrvdRYTx+eavSrGzP3YPiYfpbsghBlTVqgG96d6NQQ1gHvZDsTgSg7A502hONItzsipda6vtwArgsEafwWfmyRFwyhDoclfI+rOa7PWkSIWcS3bsl5ibjpjrbrYswMlM+kxWANEL2npMiqUFcd5DSkEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258543; c=relaxed/simple;
	bh=lG3TyZAjjYafo2GbsvJvuC3uRMlv0XvTY4l3ECv63WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2KQVaHZmSQkS4v1s8ktJMe+P2VWZ5FVhe5vBSGArkCLxxtp6Cs9mXMdQtpQGuZNXlqvi4He7yx3cvShlfMiWOy0q9Gcv4ltb98DTfPfUM07RgcAOvU8JxgmijC9lU+R2CCoVFNHTMozIlU2D2/Jlqol2anRGDhWf3xaqsuDkXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lR1c4kpV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lR1c4kpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78741F000C5;
	Sat, 17 Oct 2026 17:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258542;
	bh=OvT00m7x48c2vJ4AgFS4i5UOLQxZ+X4KWngen+dkvEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lR1c4kpVmMTXejjB9rrkgTfkBu0HzHxU5SK5KIVeJNcKZh0KCd+a8+i0krh/Cpyz5
	 By2MnqnGr+JG9mKxyxEzmFmA18EzoukO8b1GTZYivZ1VujOKfzVe0o7hGHXP4kfiQ7
	 l90JkyS9gIEVbMX8d/DPG1vB9ocv+u9qWPNTVQRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d27edf9f96ae85939222@syzkaller.appspotmail.com,
	Szymon Wilczek <swilczek.lx@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0918/1674] ntfs3: fix circular locking dependency in run_unpack_ex
Date: Sat, 17 Oct 2026 17:53:10 +0200
Message-ID: <20261017160454.695565358@linuxfoundation.org>
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
index 8d05f3f276db4..6c7f311f24c60 100644
--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -1134,11 +1134,14 @@ int run_unpack_ex(struct runs_tree *run, struct ntfs_sb_info *sbi, CLST ino,
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



