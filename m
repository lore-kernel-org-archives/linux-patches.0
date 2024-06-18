Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA37E158A18;
	Tue, 18 Jun 2024 13:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716135; cv=none; b=ZA0L4PGCqYUtf/6G/zI6MHwcWm6aiplE51f/QYOGz1Q8++rKM3MS4+ybJCH6atr+cPoOAsMNcA9RHIWJ/FIB+YiJkbuxFH+wPlsqrD7INnUDPBlecS83toXybIG8tC+/BrnFk5sbJ7w31Ek7Jkgqu9sialidt3rWOPcwo84R610=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716135; c=relaxed/simple;
	bh=c/TR8vA+yDLI72HiYoOL8jdLayzZDplr1GM7pu9q/Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEcxIk8VB6cdHJBs+CyhxBFmXSxk+LiguC05JaXZIGIlwPwMsUDojJjaFIhba7I4gqwuk1qOPPF4LqtjC07R0FbilhTpj0sj3zFPLspO3+FtnXa2qmTtCKN3lWtfZhOdseo+Ys2fYsmgTcSlWizGVwP6pEdeWIjKC9a72gAMFsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpdE0Bjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpdE0Bjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214BDC3277B;
	Tue, 18 Jun 2024 13:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716135;
	bh=c/TR8vA+yDLI72HiYoOL8jdLayzZDplr1GM7pu9q/Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TpdE0BjjrYG1VLDo0Nnlhq75kj4cSC5BpSoZgsI9z1ph0pWhjKOzSbDHyUtDs93wY
	 czStQ0FuGpJ+Zl/zaqez3GzmihZt2sKtao3SlCQCQ1I8IYNKpzaDfM2rF/Ihd+SS4V
	 qFcjgu06udun/8TOk8JPMI8i/41ob4IP4mhSum6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 543/770] lockd: fix nlm_close_files
Date: Tue, 18 Jun 2024 14:36:36 +0200
Message-ID: <20240618123428.269547403@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 1197eb5906a5464dbaea24cac296dfc38499cc00 ]

This loop condition tries a bit too hard to be clever. Just test for
the two indices we care about explicitly.

Cc: J. Bruce Fields <bfields@fieldses.org>
Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcsubs.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index b2f277727469c..e1c4617de7714 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -283,11 +283,10 @@ nlm_file_inuse(struct nlm_file *file)
 
 static void nlm_close_files(struct nlm_file *file)
 {
-	struct file *f;
-
-	for (f = file->f_file[0]; f <= file->f_file[1]; f++)
-		if (f)
-			nlmsvc_ops->fclose(f);
+	if (file->f_file[O_RDONLY])
+		nlmsvc_ops->fclose(file->f_file[O_RDONLY]);
+	if (file->f_file[O_WRONLY])
+		nlmsvc_ops->fclose(file->f_file[O_WRONLY]);
 }
 
 /*
-- 
2.43.0



