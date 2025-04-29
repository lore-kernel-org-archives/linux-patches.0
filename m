Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F388C82C60;
	Tue, 29 Apr 2025 17:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946314; cv=none; b=gbfpSk6agQcUKK57khuI71vK8Xr7bM/xcxjfZV3SLcJUHBZ2DACyLxstNP70b9bR2EnYrhLsovjS9rseXQ1rmau3soOBib8kBfSAyuEw1I6JDkCv7CdZ+4xNkmJuxzHhuclTonskRqG717k6CldpPO6ejgHA5P1eiQPXTQ8tGsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946314; c=relaxed/simple;
	bh=MlcqemCTVsp0Fi8Ev4JDuvpd+PQq3Gxbki4Da5OYBdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTwBk5IurBnX22dcVM7JxHEumMNIB1l6fxksCqcQ3cOJl2ebRMJL2reW44PU0ZZoSfiaHyx78F8nWZE96+ZJk1a6lGKoNLmGDY0mZ8ULtltZjsqbsH+BThXtXVR3hsWN7nP1E/Cx1+Ab0Buh5IdkG+mvYlgKZsic3b4cQt3ih24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grIKHh7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grIKHh7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7E7C4CEF4;
	Tue, 29 Apr 2025 17:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946313;
	bh=MlcqemCTVsp0Fi8Ev4JDuvpd+PQq3Gxbki4Da5OYBdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grIKHh7YS1dzTY9GQOdqXYrLnQvV8gGrFfwyELVkWHoel7EOcV5jOl57bjrKMpdYp
	 cV0QLZBFKrg2HBTRawM6IhYz8Xh/g5RocqOTtiDvLgiztyNKgf4zTxOy4AjG+L68Hu
	 Wy4JCSOOA6YdtWG+LtbXKKEgdvC8vSUzD54AktnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 226/311] qibfs: fix _another_ leak
Date: Tue, 29 Apr 2025 18:41:03 +0200
Message-ID: <20250429161130.293149251@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

[ Upstream commit bdb43af4fdb39f844ede401bdb1258f67a580a27 ]

failure to allocate inode => leaked dentry...

this one had been there since the initial merge; to be fair,
if we are that far OOM, the odds of failing at that particular
allocation are low...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qib/qib_fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index b27791029fa93..b9f4a2937c3ac 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -55,6 +55,7 @@ static int qibfs_mknod(struct inode *dir, struct dentry *dentry,
 	struct inode *inode = new_inode(dir->i_sb);
 
 	if (!inode) {
+		dput(dentry);
 		error = -EPERM;
 		goto bail;
 	}
-- 
2.39.5



