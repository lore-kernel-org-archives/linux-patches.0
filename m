Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D6C26982A;
	Tue,  8 Apr 2025 11:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113529; cv=none; b=QKBrzfqcJBxvcI7gwb8aOv1CV+pkFY0mYeggtVID3S5k7n87ksfvCoeBNCkwY7KyItypZPK4g+4Mq+OvmFbT4f7CSigmz1gQZvT4DAabTgojckaMqg9RPhAgP9zgsROyRpfRThAH8Fr2W8G1WYrUMIxNgcCCBFn40fm0LDqy0WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113529; c=relaxed/simple;
	bh=QxJyNm79F2Djf++QI1sHarLO3Vo38FX77GIqpALGO7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mhm1+2iN19976PyYtdj86zJo6tVIBfMlNJpXmFE1Xyru79zv52PSyUXB055Y7l3Y9mVxWcC+Z4z0dlaxav3DIQ8/OYpwouCGNVHY4nlYQLhBeqUxO0BpME9sd9VO5a6p5q8RCWfKcYizZCwt/7EAeP1kNHw0oCbFK1sRwmXaK2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfjfQLkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfjfQLkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBDEC4CEE5;
	Tue,  8 Apr 2025 11:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113529;
	bh=QxJyNm79F2Djf++QI1sHarLO3Vo38FX77GIqpALGO7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfjfQLkGXm6ch/DiUl8f1Xl/Z6V8WZQRM9iutgSVcf4KFqmR/diQCeRWQ4C2nSVlA
	 oPnvAUxHXOo4eqWci/rs1fPT2KoGoEsMS8nXmMj3TvpTonFu1xtJl3NQPNsUz4kQyv
	 A7Jz3Cz8XvVCa3NDYBfohYjlmbgA37KqiZjmD3Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/268] spufs: fix a leak on spufs_new_file() failure
Date: Tue,  8 Apr 2025 12:50:02 +0200
Message-ID: <20250408104833.709301989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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
index 38c5be34c8951..8acefe5f654c9 100644
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



