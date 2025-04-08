Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8835A264FB6;
	Tue,  8 Apr 2025 12:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114100; cv=none; b=jya+geE5qmZ/h1I8YpAqF56d/hss0TSOlqOyqi6+A+26bNbSLfv+k1WEeDXU3hKhDzMfNHHm850VRdV8szp8+uQRV7i/Kucugh/vKj7syj1BRlZoGLvC7DD89mN6zf8aeTW3VfeiebVkE8eP7DcBkMjhMg2uoGsubm6oetCZvKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114100; c=relaxed/simple;
	bh=DeVkP3jWyYXApd71Vz/WKPFaqNgP6kDAzScTlaIujIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iz+zwyTTGgrXvisG8QxMl3nEtWqFyBM2tLZviyiLxvLE6Ya9VYyoatlgqmFj855L2pqgrm0tk+HrddxzWHX8M5wAYu8VJIQ3Ut4YY416YEqus5mdHrRbGmY0J0zxbuoh6XGUax9tiQWLv9J+L2ym8e++9zX8vuyyjH1yUFdKO8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmaxbYSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmaxbYSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18ACC4CEE5;
	Tue,  8 Apr 2025 12:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114100;
	bh=DeVkP3jWyYXApd71Vz/WKPFaqNgP6kDAzScTlaIujIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmaxbYSga32p0un9ssbtf59E1jPLjHYSEYYyCF/RlstYLj+PO+pe41KwsU36V6Ccg
	 jgDk8AnVKORYNLBCS+BqpJ0vKqx5asTCmOdXkJc5MeRlhof7LGvqWLleHhEfTV5pJR
	 0WwZHzCMThmK4kXGRdOWOoP+G9cwwd/0coXcN0ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/154] spufs: fix a leak on spufs_new_file() failure
Date: Tue,  8 Apr 2025 12:51:17 +0200
Message-ID: <20250408104819.671964800@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 99e688498a9cb..1183e264ff421 100644
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



