Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131711798F;
	Mon, 23 Jun 2025 13:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684687; cv=none; b=Tzbd7ln6GMcXROh0f4LASFilEicpcKf+WbdcXNVysP+IQsMhg/UKgBaoNmM/liObnY3xU/SgAloRa+JSAqFMhx78fErktNg8NLQf+s7YQmLbFmgWU6Vezb5Jj43/GRKnWRbVwvXdqLfpsHynuKBOWRJzfBc2ctnCgVDLfwD2Gzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684687; c=relaxed/simple;
	bh=mcRS7goReYCGXXbGXmVZ/juEpUftEjh8GAj6MwWixVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sz9vmQrdYVx4yc418NFt62AwsJUu580/VuAf3jeqW35HIBkPVUWmWWgxw3c4BEACMw/FfQuKvCo4ybLpHHnHDCpcjHVwnl1PIntS4j12IXH/JkhAX8rRRZBSAeNJTNmEPC6jQx3SPlVt4VQMIcP/yZYeCXPeIKVHpNvq/MLJ/u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uf64fRX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uf64fRX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2EDC4CEEA;
	Mon, 23 Jun 2025 13:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684686;
	bh=mcRS7goReYCGXXbGXmVZ/juEpUftEjh8GAj6MwWixVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uf64fRX14O8H6Ewsq9/fdSBTnOy6OwkTNwDMcwOFJOlrgxcX0S3nBtgjcCGd0oua4
	 6V5F8ST2LePFkRfdsnG1L4Jml6ITupGJmR5c2/66TecW53WMUMXBq8wuX8TNNEE+PS
	 lCbeI+NjsPTEHnkDAKiL2YGZLmqe+fFOTU+1p1U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/222] gfs2: gfs2_create_inode error handling fix
Date: Mon, 23 Jun 2025 15:05:44 +0200
Message-ID: <20250623130612.179770164@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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
index 4e0c933e08002..496449fccc828 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -616,7 +616,8 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
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



