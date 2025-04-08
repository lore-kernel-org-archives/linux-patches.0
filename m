Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364A4227EBD;
	Tue,  8 Apr 2025 11:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111834; cv=none; b=AZel5zuXM4RnQj93jNdpcOsObs98tNtsrCjTaHXqM7Jikixi/TF1ENzH/n+JyHqsPN/J491X+KlZIBjqb9jxZ79wsMLyvGCN8Dx6Hg9kVHPcTSb9IWgLqSdX9xZ3jIhQTJZcMm2s/af5AFa4qqdtj/PMw5x14sGWKJnzeakKUEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111834; c=relaxed/simple;
	bh=jVjegiv0izC+WPfh/jeszQlyn3uJ2yR9qsb1t8UC60o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSVMMk0GvZK/ZQSRAp3P4CnoMzWaUAmnnXhUM0+Q4uvUGCYeDHyPKU3F7LtfaMOwZydUUc7Cu6EwbNEf14xXW6UnOq8EOvV1QskHdxOyvtxtG5iAtiKMbnLSYCZqZWJSCaQCTmIbFQOKVDHs+CEC2iYBp+DgvLiYjoc2ZxXHKIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtW5Puwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtW5Puwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B44C4CEE5;
	Tue,  8 Apr 2025 11:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111834;
	bh=jVjegiv0izC+WPfh/jeszQlyn3uJ2yR9qsb1t8UC60o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtW5PuwbxV7xCTzrn3/y0iIHpcPsRZi3sI4cTT96VrfpjutqG1M9MriRSB3kMUNIc
	 WgBVOth9pRtoerwzn3AU91WFAWHYVJG4X69qqeq2FT4UlGHoXjDAuq/ER1TBp2QHYx
	 Owjoye7oSVlBQxyvd331ISqsi2/dkhwca3ePGoRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 577/731] spufs: fix a leak on spufs_new_file() failure
Date: Tue,  8 Apr 2025 12:47:54 +0200
Message-ID: <20250408104927.695858475@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



