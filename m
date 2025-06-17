Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D872EBDCC;
	Tue, 17 Jun 2025 15:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174814; cv=none; b=u3fSS6e6ukXBOCVW3E/5dZtiM7nco5FANFxH0vP4ONS8Cm17RKsNH/8YtEGRdJbu7w440vjCkK0B6mX8XkJW1HCkbSjvFgI/FCoDm8suKp0mnQyPX3kervzQ+S2Q4+nhKRQk0bRfGDhE48/4anpI52d6eF+iWygl0FKzJqvR9Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174814; c=relaxed/simple;
	bh=96NajRRPtIPxt9D2rGKIIIt+P7tCGiyKYq+iQPDiFFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VI7sRjpTxqVSO+ebJ0zc7l8ndVzoJs/ZR/2DWKKdQdTs+L5UNi7dLptZJ0lctVJuKV5Pq1c9qD3T6m9I/uxc5Xc7r30ZqlrPUNWUSpzKDUCvtQhWFtOE8DbthZs1kiYgxnxF3WXxq+bBSwue/XzMvZW43yxUA8BpfB2sq+f4wP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtiXTqG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtiXTqG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C6EC4CEE3;
	Tue, 17 Jun 2025 15:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174814;
	bh=96NajRRPtIPxt9D2rGKIIIt+P7tCGiyKYq+iQPDiFFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtiXTqG2JyNamfzPLDcGYNQSH4ZWGzMCfOJt1tTu11vuovC6jyU31kfL2112V7K3c
	 NCUDGTpSyKEl4L9OQTjH+btIbSP1x/1LeAyiebacpxYF6XsbdAq/gn9DUsrW1FGxlS
	 uBvW6n6Ua0JNctGuGs0JN2lMeEY+nxkpYCwM/tl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 014/780] gfs2: gfs2_create_inode error handling fix
Date: Tue, 17 Jun 2025 17:15:22 +0200
Message-ID: <20250617152452.074979547@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 198a8cbaf5e5a..9621680814b80 100644
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



