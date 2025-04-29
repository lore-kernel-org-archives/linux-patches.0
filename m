Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C3C251792;
	Tue, 29 Apr 2025 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945596; cv=none; b=KWvpIEOwjsSM20IsnQzMJiRsz01ucorQH5oh6aldPVhXVdgg1YZFy6Zwj05SLTCHnZlKR2fvDzW1X+rL3FZbP7y7J/Wo3vP7homZhornkPub9VLfXW4ULC5jeNAH7BsxOyxLc2qt3JrrSbUDJYGiVsGJa4H7gJ1TzYe/nwqfeQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945596; c=relaxed/simple;
	bh=hm/Hyiw0lPgeGvfNghySOhCaiHLWwT9udt+FzRSupws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqdY4Rp9E0OGEttXBL5bDfCCYg11RXM8UwzDrUJOc/8+MCBuQ99cDcUG+aiRybvchwEoimMwaIi21n302rvA9S5GL8EJ0cPUM13v3GuIkdVUVx5bcf1xSvgUnYWFE95Ey+ZKRcoiuDW2ykQpxFojIgNPF3FaWQKgAH5HfFkQb/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xu5T4U2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xu5T4U2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0213BC4CEE3;
	Tue, 29 Apr 2025 16:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945595;
	bh=hm/Hyiw0lPgeGvfNghySOhCaiHLWwT9udt+FzRSupws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xu5T4U2iPiT4DTrvNQc/F8Ep9UzN3EsN8htYTJxDM7Htnfe8v/CFQQMKLlk2P3JqJ
	 mxucWYHeXPAuH+C58FoYoU1cwvtJrMWJTiYMNlBzz5F3Kwk5mX/e/ZynIbjXoJDAcE
	 zKrEbH1clbZRirUnXH0/ecasYML3vcChK5PlJ/Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 166/179] qibfs: fix _another_ leak
Date: Tue, 29 Apr 2025 18:41:47 +0200
Message-ID: <20250429161056.097108021@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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
index e336d778e076e..5ec67e3c2d03c 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -56,6 +56,7 @@ static int qibfs_mknod(struct inode *dir, struct dentry *dentry,
 	struct inode *inode = new_inode(dir->i_sb);
 
 	if (!inode) {
+		dput(dentry);
 		error = -EPERM;
 		goto bail;
 	}
-- 
2.39.5



