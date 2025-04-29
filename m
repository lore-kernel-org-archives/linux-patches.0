Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BDD2AE96;
	Tue, 29 Apr 2025 17:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949497; cv=none; b=rnfObcUL6jg/gb2AjmOHCIhPgx2G5F0/fBaxlbekePLw/IFXZGraRwh3P4PRerXKujsj2Nsx6ti66vfZbyo552Xdrv2zzH/jbwNMB+Ud0iclewlsmLy011G0nicfKnQFQpWaVuypPmRTRLinvYoGPe20xn8QygXbiBpua35AFZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949497; c=relaxed/simple;
	bh=tRVg9xxTS6+KpLVSOFSY38YtrmbnvoMIJZ+SgAZvBIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBz8Agu3dwcgi2fJcafWkZqmT4BfvUtwuPzPUxzvjx5zVDeYKuBFVqv84b+15PEfbH9/lHd6qRmE37bauVx4StoVCSBQ6hIejzq/I3kAya4sZ/EIsKpPioRQj0L0LVRInfZc+RyGIkAxHUF8DwcV7n6dBM7IXfIsDaVbL523Uyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5Cg+Nbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5Cg+Nbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23154C4CEE3;
	Tue, 29 Apr 2025 17:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949497;
	bh=tRVg9xxTS6+KpLVSOFSY38YtrmbnvoMIJZ+SgAZvBIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5Cg+NbdkNkThISdaJt2XRSzGbMca0/h3Ludsi60LN/+v49K3V7B/4XrdA8nHrAhK
	 s1YLRPo54HPUo5/pYEu4QFVlJQMqmsL/3LiKnvSnGOO5+fZIBXprIfbA7PhyxKVsHp
	 phsr70Dd10xzdkPUtmI1homu4Xvgo5fBMbsa9BPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 337/373] qibfs: fix _another_ leak
Date: Tue, 29 Apr 2025 18:43:34 +0200
Message-ID: <20250429161136.987780833@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8665e506404f9..774037ea44a92 100644
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



