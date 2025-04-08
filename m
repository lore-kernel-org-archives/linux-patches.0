Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CB826988C;
	Tue,  8 Apr 2025 12:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117010; cv=none; b=JBTst3bIC3F/X6ahajp1CmicDBhy2d2a/XMY/nwS0zZr3PvSpR1FkLSgVQnt5AZaUHoRzNrrhYAwNhG2IpekOZJ+oXZvmOONtir/Jik9lwJcjVmG+sFacf+fXVPVtSG8NgOdSUx8DBzxJ4M+ME68iW2C7EW6KNRMblNGUKaAYfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117010; c=relaxed/simple;
	bh=J7tV5IcU9WIhE8Y3kl/xLkasIut5lCAfDtlj/WDuxTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swlXVcg05hanuG91TqlYYehBOEaeZtKMf3CnSkm+BJQFUgwYtBWXvQShGkSvr22tOUw9W8snQgMWzvjm+GKQHrZEypKIo41H8niyNh5+wpo9qCj4Kp6i2ONCF98rAuigrLo6e3ylDrkOEWtVb4yYmYrvWCrTL1sx++cMTphiq4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJafyjHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJafyjHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0D6C4CEE5;
	Tue,  8 Apr 2025 12:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117010;
	bh=J7tV5IcU9WIhE8Y3kl/xLkasIut5lCAfDtlj/WDuxTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJafyjHJdmg+3uMcjDgnVHemZoE3BYGYncAl6eUCUhhHekhAjtFez+Bruy4Gw5cmU
	 D3k07hUQIaX+FZNOOn1nxiRNWygD4ASCZ3SbVCcO9zrrtkU/USOdNlPwg6gnhA1ys1
	 t5FwWWNHn4IiF+90oLDq28jgApOlDQe3+hamu/FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 301/423] spufs: fix a leak on spufs_new_file() failure
Date: Tue,  8 Apr 2025 12:50:27 +0200
Message-ID: <20250408104852.804263041@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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



