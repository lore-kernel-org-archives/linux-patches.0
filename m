Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49873269AE4;
	Tue,  8 Apr 2025 12:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115909; cv=none; b=eF6u2SsFiKuOhTaSXWUZvWroKfOFlOMWS4gB0txHkfOKSZUruORXM4525tNgXK6aS3ZCu4NHMxb3+yiXffBUlc+P09YQZkIkQfZbqwy4hd1qSMp7Kxt2W2XLVzQWU+6/F6o7v3GYsQSJ1W+wP9T7EXE/VbfHkA/58MV8MgcU1/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115909; c=relaxed/simple;
	bh=sIiZJF+OTrjM+MyJNVgc5IlhmP/vO17eK5UcF+VpvYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTWNo8aD0wU3jSeKmgiJjHCnf9FXWKwTlusl3G8I8PaN0ZBg9ZvDXp0cx9mqgIKW0/R6xkSqrzZ+ncs76lezOLt4+ag+Wgwf+EJezcThghD8JklCpTlRKd1WSVn5eruYp39XBr5be4sePWI2HpCfkoxNUE+RU7eh56GMEmBfRFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rb9Zu3Jh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rb9Zu3Jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72543C4CEE5;
	Tue,  8 Apr 2025 12:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115908;
	bh=sIiZJF+OTrjM+MyJNVgc5IlhmP/vO17eK5UcF+VpvYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rb9Zu3JhkmwoDImPs0DwA11Y8toSLfaugyK8F7cSE0SPghTOKfOjmFhJbjv8a8NTs
	 5B8xuEIDynwJ78kjCfqBCq5fgpTIxpVd5T90/lqjyD4SoWjnJAhgD6W4t7PMvSBR/e
	 nU50qL5xfSVesYodFRwym0HeuBP2PeHmjOYjrJE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/204] spufs: fix a leak on spufs_new_file() failure
Date: Tue,  8 Apr 2025 12:51:18 +0200
Message-ID: <20250408104824.634354890@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit d1ca8698ca1332625d83ea0d753747be66f9906d ]

It's called from spufs_fill_dir(), and caller of that will do
spufs_rmdir() in case of failure.  That does remove everything
we'd managed to create, but... the problem dentry is still
negative.  IOW, it needs to be explicitly dropped.

Fixes: 3f51dd91c807 "[PATCH] spufs: fix spufs_fill_dir error path"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index dbcfe361831a6..ac10339ea4172 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -191,8 +191,10 @@ static int spufs_fill_dir(struct dentry *dir,
 			return -ENOMEM;
 		ret = spufs_new_file(dir->d_sb, dentry, files->ops,
 					files->mode & mode, files->size, ctx);
-		if (ret)
+		if (ret) {
+			dput(dentry);
 			return ret;
+		}
 		files++;
 	}
 	return 0;
-- 
2.39.5



