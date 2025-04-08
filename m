Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3342676CF;
	Tue,  8 Apr 2025 11:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110169; cv=none; b=s+fX5/CpY+vE+kYJ+8+zczn4QJyJkHEcik4E3LJD8kbW8KSxn5XqAbLFgWG6kUS2Q/cS1M1qR3FV8cxAVQ80gBY9yqCrujOspEeRIhyzbsRv6ifndRnPCZdWqU+JSNJetABXvRgTOAFOcxETwKuna5T71VDNM1sGLSetsvT5Ml0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110169; c=relaxed/simple;
	bh=59JsmgNYY7q4zmZb5/rHNISxeoHKdRubYSMJ3V2Wa1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSbXemuV0RsQTKNeGs0eLAP2CuWmfHbR5frgEGLBccikViUy0itWOEyZfwth2/9B9QDBBZ2wI9Ml5JabenddIbblXV6zM2JpuQjmasSicmLsLaBqUiAyQjllK2gYKnzowrngCVyWurYVNxrJp7X67YUMLliNoFjpVYSYlpvhKBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e54vcfTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e54vcfTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E78C4CEE5;
	Tue,  8 Apr 2025 11:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110169;
	bh=59JsmgNYY7q4zmZb5/rHNISxeoHKdRubYSMJ3V2Wa1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e54vcfTuXqDqXxFGgHqKbO27Xl2q5HJ/P7hKkdJITqtxx4GHHkxOoBZnE+zBpVdvN
	 uhR+bRvPfIQ1BKOGCokTyW6zvJgZ+YyR2g9BqolxJf3oZlxvdRvN4zn2bd+5AS6PiX
	 482Rmn6c2rRWm7rRBGvipbWQ3tCH029pZqU1juCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/227] spufs: fix a leak on spufs_new_file() failure
Date: Tue,  8 Apr 2025 12:49:31 +0200
Message-ID: <20250408104826.087578358@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 908e9b8e79fe6..0159bd9231ef8 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -189,8 +189,10 @@ static int spufs_fill_dir(struct dentry *dir,
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



