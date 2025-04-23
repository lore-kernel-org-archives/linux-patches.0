Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24228280A5A;
	Wed, 23 Apr 2025 14:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420100; cv=none; b=IKpODRyRZLnt6zOPi7mt5ScqOv9j4r9IFYrIAt9UtXIgqW29igPeWbqsZjs2KBUiRm6RIhDeauHmZLlXBuDyP8wU3i1JwfNIn3GxLVJWNTTsAXvqfgVqBIIW0BYRIVsnPMC8nD5VN+xYiEEfJITQVqBKkudh/4lSZu1JnnnwwZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420100; c=relaxed/simple;
	bh=w/d0qTn5QfNyVS681qIEUhZYa9+1WLrRtVLipH0HyXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSqBq+rZryeMo1q5C0GLBRH4YUmtM6/IGNTm7tuzk3RmusyfSd1nd4sfY+059AT2XuXrE2I0PpWOE6CDmIFDBhsfUxsM7+DPnnquCoyvI3LbfTcJ3yKkHvLv00flTsKFexpD8ergIpJHVcpOZ8D2gEd+4LIq47tulCMkf8v3cug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esGPzwSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esGPzwSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6133C4AF09;
	Wed, 23 Apr 2025 14:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420100;
	bh=w/d0qTn5QfNyVS681qIEUhZYa9+1WLrRtVLipH0HyXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esGPzwSYYpdk/z2YkQdVlkNX8ZK4YDhiXTUfxzyJKrl26z+Mrsgk4hw3mwT2J4Sx8
	 4+E6rgYR42EtkcgdRL3z6V4d92mEznyztn15zaJ3SAk+Et7l2vVChchpTOP7dggnBC
	 lpZ5R9mqvbJngh06hr0iLa7TJODmsEhpLkaEXKIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/393] umount: Allow superblock owners to force umount
Date: Wed, 23 Apr 2025 16:38:54 +0200
Message-ID: <20250423142644.862885701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b4385e2413d59..671e266b8fc5d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1869,6 +1869,7 @@ static void warn_mandlock(void)
 static int can_umount(const struct path *path, int flags)
 {
 	struct mount *mnt = real_mount(path->mnt);
+	struct super_block *sb = path->dentry->d_sb;
 
 	if (!may_mount())
 		return -EPERM;
@@ -1878,7 +1879,7 @@ static int can_umount(const struct path *path, int flags)
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



