Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668D2382F25;
	Sat, 17 Oct 2026 17:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259004; cv=none; b=RekGLrWp4Dl4hUoAdKiFMVC3uip2nCp4yOLv9Sq5+jUhSFfyUdHYXeLTy8u9pD13Uwlh/fxZpesPtBbUuwEq49rfUSJAqrg1YuDURAKz17+6GVH47gCuOvwo2vT/T+SQkzNK1TZqgSsdJh2w1/G8Yt4d4E0UXKGK7OYJcZqBqd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259004; c=relaxed/simple;
	bh=XB8vip9pRTq1Fp3F6LBeEle7I2I/1o14mzMPvqufyb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdayu16HoZl0NEhnExN4W+nVT24iXJzZ7UpTb/sKXxXdzAoNbml+asVHYNTMBoYUMH1YLmf+CrKaTgFhxviL9v1ih0iEs0hqFXpsXQQnKMUCQz2l7K5tTi+NUgiU1KSjllbpYxf2uXyGZf1TU0A5ttUwUPjIbJ02FyqHUC8ube4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtjEN6Bj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtjEN6Bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4B61F000C4;
	Sat, 17 Oct 2026 17:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259003;
	bh=VJXNcWa2+OeFbJqwREEFWDNMLLlsJ1SX8Z3QDMttVsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtjEN6BjpEy9aCcj0YBcnb1nXK0+hjanSBwRpHdqGf6decNYT4zvTD50+t2fQyRrB
	 RFL9Nf+CcgyM7etgZ8nWhHYmS8cA4V9lsiHuzj/WSiayaVTvGPwjoDZlJ1HlBw0uEI
	 z6CGy8LvlOeqvQB3GCHTpt357jLHfbfenBne0v4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1071/1674] ksmbd_vfs_rename(): vfs_path_parent_lookup() accepts ERR_PTR() as name
Date: Sat, 17 Oct 2026 17:55:43 +0200
Message-ID: <20261017160458.610263574@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit ba33ac100d3feb1efb43b32e63cc0c6430936aa3 ]

no need to check in the caller

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 1c8951963d8e ("ksmbd: fix path resolution in ksmbd_vfs_kern_path_create")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 43dc18192d058..fc49bb9aa8261 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -712,10 +712,6 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 		return -ENOMEM;
 
 	to = getname_kernel(newname);
-	if (IS_ERR(to)) {
-		err = PTR_ERR(to);
-		goto revert_fsids;
-	}
 
 retry:
 	err = vfs_path_parent_lookup(to, lookup_flags | LOOKUP_BENEATH,
@@ -817,7 +813,6 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 	}
 out1:
 	putname(to);
-revert_fsids:
 	ksmbd_revert_fsids(work);
 	return err;
 }
-- 
2.53.0



