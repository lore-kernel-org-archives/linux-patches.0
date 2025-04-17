Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA8F2566F2;
	Thu, 17 Apr 2025 17:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912558; cv=none; b=VP89ggyL78cJKgTe69bMMipnX38i8F0DWHojhBV0PYYOzbLe+91lHn9oD6gjK3wJwDGc/09JQ2b1rs+d8mdqBiIiIGvlpz/vx9OsQ0JPEn7vs+LNctyBMbAZmfqz/gZQNzK2uPPhLwQjrQxtM4tCS5fh2pdgeIrA/hYHUOmvqvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912558; c=relaxed/simple;
	bh=zPNXRH9qnC464MZjiWEND96LLdyPET4TNkB7QVqOLD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUUBTqtEApMmCMSHksrxwKzc5PnEO4yST0XeWkq7iRghMmKW7qIdQ6VyDR8lZgQIu53kI2uTU3UniXifccAl0qBNNnDfo6/PElyWeg6I9avIoMusC1NRkd/DTWLQ8yImw0amB6OKdbLbCEp/l+RhEHgriU9CzkYCo4jHtbFfmWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVVXPWs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVVXPWs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8C2C4CEE4;
	Thu, 17 Apr 2025 17:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912558;
	bh=zPNXRH9qnC464MZjiWEND96LLdyPET4TNkB7QVqOLD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zVVXPWs3jaW19sJZiFcR87CmEtR4SHTjvVKBy0d01WJ/eQk8WzBVNWnMfMG1F/XoC
	 yoYD8cDaa0GrF1kF6KQ4T4t/ho9C+z+Rk4kvniIVR4M2SU1CIimJLM3wT+TMGKCj2h
	 xCkaGm4IPESpcXY2J/BGHiTvBVnyD7y8JVnHwGhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 050/449] umount: Allow superblock owners to force umount
Date: Thu, 17 Apr 2025 19:45:38 +0200
Message-ID: <20250417175119.999087703@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e1ff7aa34dec7e650159fd7ca8ec6af7cc428d9f ]

Loosen the permission check on forced umount to allow users holding
CAP_SYS_ADMIN privileges in namespaces that are privileged with respect
to the userns that originally mounted the filesystem.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Link: https://lore.kernel.org/r/12f212d4ef983714d065a6bb372fbb378753bf4c.1742315194.git.trond.myklebust@hammerspace.com
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 8f1000f9f3df1..d401486fe95d1 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2026,6 +2026,7 @@ static void warn_mandlock(void)
 static int can_umount(const struct path *path, int flags)
 {
 	struct mount *mnt = real_mount(path->mnt);
+	struct super_block *sb = path->dentry->d_sb;
 
 	if (!may_mount())
 		return -EPERM;
@@ -2035,7 +2036,7 @@ static int can_umount(const struct path *path, int flags)
 		return -EINVAL;
 	if (mnt->mnt.mnt_flags & MNT_LOCKED) /* Check optimistically */
 		return -EINVAL;
-	if (flags & MNT_FORCE && !capable(CAP_SYS_ADMIN))
+	if (flags & MNT_FORCE && !ns_capable(sb->s_user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
-- 
2.39.5



