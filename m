Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED53267731;
	Tue,  8 Apr 2025 12:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115110; cv=none; b=G3YN5v9CL03PKaGlVwDZn4ARm8Xf22jos3WP7jAxk5sEU6HQCjRMjVulgz+ByG1qx7PmWVFV9KS5gtpypUxppUjkld36vDSW36K6uCoagtmYNIlJgRUPLe5V1H/PSV4kshfPtVkEyALXh043XELv+d6Pi7wRPn3OpdCpEG6o4do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115110; c=relaxed/simple;
	bh=ZpHksXkTi7n03CrhDzf3IiDss76XnZkD7/UmW4o4Sw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7GFC8YHhIP3Chi1dOnsic8nIA4Gt0A/YOm1zRWN2/KY2m13GVFBE3BHWopjN+caGhVniuLd+aAr1aywLF53gSKd2+aiOizchigA/vXYu4WjcAvKUc83azJI6hab4WZ1RDynlTDukNr7UxR3DB7/B8JSR4TZCc6/vD3k6QWeuz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJM3SQzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJM3SQzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1CAC4CEEA;
	Tue,  8 Apr 2025 12:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115110;
	bh=ZpHksXkTi7n03CrhDzf3IiDss76XnZkD7/UmW4o4Sw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJM3SQzCMZGGw6r16yEiwZbONDpNL4Bwft4QxExgdFkQljIblaUv/S3HVcb/XPCmt
	 kCNbT0vczj3YJXj8uGzAetkQfCEzE+qQjQ20bQQml3ZrBp1q5hivRIEWH9PRHMOIQz
	 uiQwmHfFf56lQ0s6kbmYqzAM/INmFYAhhJdAstpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 354/499] spufs: fix a leak on spufs_new_file() failure
Date: Tue,  8 Apr 2025 12:49:26 +0200
Message-ID: <20250408104900.061455769@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 70236d1df3d3e..793c005607cf0 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -192,8 +192,10 @@ static int spufs_fill_dir(struct dentry *dir,
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



