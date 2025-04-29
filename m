Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9749E253334;
	Tue, 29 Apr 2025 18:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950596; cv=none; b=SsNG8VwmqFW1Af8+fK77GIkPgmLk3S6KKep4oFt3s7jFEMpk4Ixog5F0qeZZfbqpSZAWDgyiR96+R49VBsxC8+g/Rd+5/63dEGjrAS9Z4bDem1f9j6JWkubjznpTuBwmgXUnzqz/lkUbyHp2QSqZnbPNy8FQprc2+/CSLMQsPz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950596; c=relaxed/simple;
	bh=bBJmSuIzi7X5t+Q7SBv/lGZJut5cA71cLiiTO+BlXxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVL/NaCT5UoE4OiADxjCz3D59mmH4nJXw9Jqmbdko4QctPMBbu1sy+ySftV6vYGVRypZ5aPU9WWCRAqGIkm8HLt4o+LLcYAbgLUjmRz5/rCSUpebIrp0L7BZhfip1/G4LOpDtnk3t1rUDxktVULtW+qhKvYaz4YkPvMmoTFT+y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7q+H5LP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7q+H5LP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2016AC4CEE9;
	Tue, 29 Apr 2025 18:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950596;
	bh=bBJmSuIzi7X5t+Q7SBv/lGZJut5cA71cLiiTO+BlXxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7q+H5LP4tmJVkv5cU+Qnr/2ckl0R/HkJUNphxVZJyeNFbLUnmd6sFgLycT6B+X7X
	 OOMNa49QneYQSjuNXwrwwLObqFRi3GPNxTDSwRrvlK71Mm5IBZ4lfFuZ9kTA4Ala11
	 h2VlTg3ey3oKpGsgG+l1rJdE9KHo7Wfa5dpEUAdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/204] qibfs: fix _another_ leak
Date: Tue, 29 Apr 2025 18:43:54 +0200
Message-ID: <20250429161105.397950483@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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
index 11155e0fb8395..35d777976c295 100644
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



