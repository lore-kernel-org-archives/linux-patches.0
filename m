Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8409A1E8332;
	Tue, 17 Jun 2025 15:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174452; cv=none; b=mt3twNoZprnYpyrLTpjFJrjC3nM5Ue7os7Rgku2nXDT9FXQ0t+S5uQVckEfM7T2cXN0k3QFE4YdpvVETL26/zBiuC9uu8gDOQoFVkKuXhIOlTQG/XcvR4wK93+DuPEMYLPFVmSauu3Ma7eHnecrmtAeNGeJxagnsbqx967Q7V5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174452; c=relaxed/simple;
	bh=xiQWHwr4V0WUQtAIhxKse2dOqB/IfbBLDIsBr9BFH6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9id1hYSzBhMJBGsNP3AeaF3HVM5GCq6JvOIigtjdaW+Fdx0B2jV09IcTt2BHTRWTgkoJi0i+pjlyKKoTFI5VeDhacSBpHVYDZTOPIpm5Wlgkpw8JEHdDMvA08ICSb8yQ5ly/g3ExRTywb7ZIUuti2GDQO3Rak45qi5z3LugPeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/4xDdIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/4xDdIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DDBC4CEE3;
	Tue, 17 Jun 2025 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174452;
	bh=xiQWHwr4V0WUQtAIhxKse2dOqB/IfbBLDIsBr9BFH6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/4xDdIifjfJXNXaV7phJNuRJ8RrMe2WGXvIugaKBY/zNHcqIgJNjDX0SvZ736N0x
	 j9zXPZtBKkrZjbJ6rBet5kBPhBVx/fsb39TROVBb7fuHs4BDQKpfCObcQokkhmfTOY
	 GJ6U6ptPcd7lOOhtzYKIvWrqmp+8guyQLOlA0bdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/512] gfs2: gfs2_create_inode error handling fix
Date: Tue, 17 Jun 2025 17:19:34 +0200
Message-ID: <20250617152419.862469257@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit af4044fd0b77e915736527dd83011e46e6415f01 ]

When gfs2_create_inode() finds a directory, make sure to return -EISDIR.

Fixes: 571a4b57975a ("GFS2: bugger off early if O_CREAT open finds a directory")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 1b95db2c3aac3..3be24285ab01d 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -659,7 +659,8 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (!IS_ERR(inode)) {
 		if (S_ISDIR(inode->i_mode)) {
 			iput(inode);
-			inode = ERR_PTR(-EISDIR);
+			inode = NULL;
+			error = -EISDIR;
 			goto fail_gunlock;
 		}
 		d_instantiate(dentry, inode);
-- 
2.39.5



