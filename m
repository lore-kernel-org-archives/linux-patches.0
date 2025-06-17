Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3DD2E9753;
	Tue, 17 Jun 2025 15:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174224; cv=none; b=Y3hAffWbvzB28G9oi6idBUD0dj/8cfBnbgeVwWzt0EoBGjlQx0XXiesUCKnrzauYWPTjX72WsKnUmkJv/oFOHHJiSseO88lcVbuu/ZdIDp0EuEE0XR6lfldI4GDY11aT59Tunfzi1Gt8gSXo1Gi4aBlk4dC2zxMh/GL3YOM5+Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174224; c=relaxed/simple;
	bh=VaI5hsmK+u+t/CqIB1dPw9U8BCzvFQVyDpesiqewe5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qy+Fpy7v7a7igI/JR55iE0+/HRRipeYd306UY3e6DH20gacWzYaefUt40gqRA9C3G6biPB3Fd0KAXXcEhZC9wxvDrww+u1PtsIgNb6cpyZRkRsAYAA161+MmFHzwfjtetOUtEFkO6/wVQkcaZ9vwkcAQpIauu5EgxqQz7+bg/cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1h5vcFRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1h5vcFRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA50C4CEE7;
	Tue, 17 Jun 2025 15:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174223;
	bh=VaI5hsmK+u+t/CqIB1dPw9U8BCzvFQVyDpesiqewe5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1h5vcFRpwxm64a8+6SfzGVFTXskmRw9qgBe79EJsGrU9ELAeoGb7w66uKNiODiNMx
	 MUmZC2vzPZ8H9VJi9vP84tSNKOgGSFehjv3x7WEE5Ajmfl61e9EiwOyjdepxcdco7z
	 yWArSMi03gFWtghMnGAygqXz/cIogJ/vw2tsfxyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/356] gfs2: gfs2_create_inode error handling fix
Date: Tue, 17 Jun 2025 17:22:16 +0200
Message-ID: <20250617152339.087525335@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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
index 29085643ad104..1cb5ce63fbf69 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -658,7 +658,8 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
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



