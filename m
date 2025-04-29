Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75902459C9;
	Tue, 29 Apr 2025 17:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947459; cv=none; b=YlRnJK2i5ULL4LqfgXtDlXTm5RiOprZ2ytU3IiAG3BqPNDwZIDfAIiQGgKKNiFApVPw+bKpaUX5JbV66oUpAW6nPK01gAfmpMZCa9T2aOwCT+7b8++ANbjjqOMhCwf1MFkhhKDwy5MX5TK/+NsOTUwgYfA6XNBMaySAezRbf5L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947459; c=relaxed/simple;
	bh=OMzoB2dDZwEpa4DSdNG7aGuyetteH+H6/TGLYnjqWIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sgz6tmkucZOksUUzfkGfA46TF7kv5jz7UdiX7ETctukuQ4SFWtpS2eX4iN+6GkGMlCDUXmfhCLTPilNR922SSklRx8MtRBnqFy6hlMCumXKhQvJ1zf3n7zADLpArhFs21Hy41mMqkcMTiOEpk0P2muw6tqcqiv+IAB6LXa5YHcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdXv0uuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdXv0uuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA2DC4CEE3;
	Tue, 29 Apr 2025 17:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947459;
	bh=OMzoB2dDZwEpa4DSdNG7aGuyetteH+H6/TGLYnjqWIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdXv0uuCGems0jbwVcgRKYcSR8loDg4HdkNpFZdLTeiuxiAwsuKmIUv96SlunfZOO
	 LBXlwtfdah0pi+fPzumnsBy/rl69CA0LIjyPE22DJimX4J05Mv79Ir3Lrk4Y2X/gHW
	 h2y5BFAnhbMQOBS5ciecjqnTVdnQE4nokfT6F018=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/286] qibfs: fix _another_ leak
Date: Tue, 29 Apr 2025 18:42:45 +0200
Message-ID: <20250429161118.653023532@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



