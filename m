Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560D0313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301068; cv=none; b=GX7KfqrITOp1OJHhG5GnySJ6e/GHZ+aYS6gu7lVlfpfe+dMYLapA0vvZOATeWq2OCJNNlya1yZB4ce1lpfIPCHghtQ0hB2F3uZ91ga4ahyzBFSE/vePrzgLRmeSzyHuABiTjQVs2rnuafuiafoU78ScTlrPeGBxCTvJj7S8dBAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301068; c=relaxed/simple;
	bh=lrmkfEUu4w0lrbRBiahKpHE0krA3exWJACHWwDbLqs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOvXU5k377k3/Yqi4CNczdpy7OmCtoSU4KHSQmkK9ZH9cE7ptpdZolgagBZmHgAur52OI5cztuG1zRdKk0UN61MwyvfX9BM/AXBQ3tsXdkK3pLOSqe+W20SaerxU7dtn+0be5NfMq/Tse0DZZYq0raddAHO1Gp8Df/Ad2YnpdYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SGuqbZgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGuqbZgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FBBC116D0;
	Sat, 28 Feb 2026 17:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301068;
	bh=lrmkfEUu4w0lrbRBiahKpHE0krA3exWJACHWwDbLqs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGuqbZgf36n2rD0FzEY8LFk90Nazgj2cVasCzdMCijc0RP1dhCsG/XCaTmsM3Xi+j
	 B5Vghhq5pNJfvSqWwJCVN1TEZBlCIYcaRiNvp0MPjN0gF1iTp5WGPHpZQcVQGRseDi
	 Ho5kSfOzrmj3J4g3qH82+K6nCWhNw7uB5pXqeigvVQYv8bMbBOAR+WwiJnIsKk4Zsi
	 9bTfmxxO4Y3BN/baO18ivrGrHFfJiTqNjJZ3Lc3b5hyl6xNiv0md04U1ORUoFoG/N7
	 sew3pJw1lDOu6zXcpFBVWXJ/Iyz6a2TxO1a2AxYsRtpwLSrqfVJkMF2LV1z9XB6iuM
	 SR2ZnZRDKoefQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jori Koolstra <jkoolstra@xs4all.nl>,
	syzbot+9131ddfd7870623b719f@syzkaller.appspotmail.com,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 212/752] jfs: nlink overflow in jfs_rename
Date: Sat, 28 Feb 2026 12:38:43 -0500
Message-ID: <20260228174750.1542406-212-sashal@kernel.org>
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

From: Jori Koolstra <jkoolstra@xs4all.nl>

[ Upstream commit 9218dc26fd922b09858ecd3666ed57dfd8098da8 ]

If nlink is maximal for a directory (-1) and inside that directory you
perform a rename for some child directory (not moving from the parent),
then the nlink of the first directory is first incremented and later
decremented. Normally this is fine, but when nlink = -1 this causes a
wrap around to 0, and then drop_nlink issues a warning.

After applying the patch syzbot no longer issues any warnings. I also
ran some basic fs tests to look for any regressions.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Reported-by: syzbot+9131ddfd7870623b719f@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=9131ddfd7870623b719f
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/namei.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 65a218eba8faf..7879c049632b3 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1228,7 +1228,7 @@ static int jfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 				jfs_err("jfs_rename: dtInsert returned -EIO");
 			goto out_tx;
 		}
-		if (S_ISDIR(old_ip->i_mode))
+		if (S_ISDIR(old_ip->i_mode) && old_dir != new_dir)
 			inc_nlink(new_dir);
 	}
 	/*
@@ -1244,7 +1244,9 @@ static int jfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		goto out_tx;
 	}
 	if (S_ISDIR(old_ip->i_mode)) {
-		drop_nlink(old_dir);
+		if (new_ip || old_dir != new_dir)
+			drop_nlink(old_dir);
+
 		if (old_dir != new_dir) {
 			/*
 			 * Change inode number of parent for moved directory
-- 
2.51.0

