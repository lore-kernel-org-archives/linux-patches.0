Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB2D2571AE;
	Thu, 17 Apr 2025 18:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915188; cv=none; b=TSsT77kgj1FOE6AjQeM5VTSgFLpmgilyqnecEnYgeZgRCyddK9R57/+LCIAUxIY517tEt4y23bs/KK4H+oVJJRQsSAoyC9w4DIucMHqxDQ2eY8y8Jn6N2qOp8xv/C7Do6iD2nfOZ8PDxGaX1l+YwWg0FgpMnNzgDbFp6F3XIiTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915188; c=relaxed/simple;
	bh=k2Frq0YEFHLhNsZldau92A3GQT+1yTk01jy1VQbDzBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxEvOm0Kiy9FHF4WTiiCPD0FH5HDNsAlk4LRRuZAtdPEwrlquCB/P8cMixe77lhb6VH2S3pI14c9FbP+5hXO9+Lg/6HQFvIg/X2Q3Isqfzmi01pDYdtJF0Eiaiq+NM2w3klZE6WRH1Rj94x5PsM4WjmDC7X8uemw0Ng1+cU+I8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrfoKJA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrfoKJA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48768C4CEE4;
	Thu, 17 Apr 2025 18:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915188;
	bh=k2Frq0YEFHLhNsZldau92A3GQT+1yTk01jy1VQbDzBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrfoKJA1RbveEYvw8Qk1ePzyYclbKDZtbsTjSgjiHT40NIN4PeVQS9RBh8tOnglsD
	 A6NP0spWxkPPa9M03g9Urt9vZi7kucoj/cAbF41E0oA65+HCxXgEmQG0khar3VulPM
	 YG1DsdVrt/EgWNGgeQDqR4d08eGNFbG6uUhlvFkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/393] umount: Allow superblock owners to force umount
Date: Thu, 17 Apr 2025 19:47:35 +0200
Message-ID: <20250417175109.444219302@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 73da51ac5a034..f898de3a6f705 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1986,6 +1986,7 @@ static void warn_mandlock(void)
 static int can_umount(const struct path *path, int flags)
 {
 	struct mount *mnt = real_mount(path->mnt);
+	struct super_block *sb = path->dentry->d_sb;
 
 	if (!may_mount())
 		return -EPERM;
@@ -1995,7 +1996,7 @@ static int can_umount(const struct path *path, int flags)
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



