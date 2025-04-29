Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F83227E95;
	Tue, 29 Apr 2025 17:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948450; cv=none; b=ELAhL1wXeLt3lmOEKvwXGruPYdDG0KTX+PKYEaDYZJPpFL5ZeUPwHr9fZ8emmA3HZ7MI7qR0xa15gGYCqkevoOVHO2y3eIcEmLOzQVHim5pnVwlc6Any15paCODKZnSoN7S1L9mKqN+BjLAxfrMl4QnK+a+YyBGw64v8svfJDtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948450; c=relaxed/simple;
	bh=H2FPHnH4KV+ld/XhjCM7wnZ7Ni+1cTv6AhFEhn93zjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4xj/9kABDMGY7VW+lzhYrc48rjiWudma+YkcsHWWRKX7vHFQZbNWJmwMRH7Wg4q8Wgt8M+e3Rug/ZsV4OjbXaQ1XLA4ndTN8/w/ffVfqJy7OKjrzoWhsLhsOJhwM26/owJQsA/HYoulLZ8g7rkumjmHkz97mwab+v//RCPVx+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEnjVAgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEnjVAgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D51C4CEE3;
	Tue, 29 Apr 2025 17:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948450;
	bh=H2FPHnH4KV+ld/XhjCM7wnZ7Ni+1cTv6AhFEhn93zjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEnjVAgwGhSBV0LrilrVR84VsdZyQ43kVWr1EMSPznBx4loM0yyPIRzzx81UZMFmw
	 7go0oH22xBH8ER0RpuqVoWv46lQXxT9X0bzSNQ6yjANQRXy0d93jp+rUQLIRCEexqt
	 X3NQGGSc1aq+gMtXlACigLhr27N/oYHypPa8N5Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/373] umount: Allow superblock owners to force umount
Date: Tue, 29 Apr 2025 18:38:08 +0200
Message-ID: <20250429161123.598595551@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 22af4b6c737f4..642baef4d9aaa 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1734,6 +1734,7 @@ static void warn_mandlock(void)
 static int can_umount(const struct path *path, int flags)
 {
 	struct mount *mnt = real_mount(path->mnt);
+	struct super_block *sb = path->dentry->d_sb;
 
 	if (!may_mount())
 		return -EPERM;
@@ -1743,7 +1744,7 @@ static int can_umount(const struct path *path, int flags)
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



