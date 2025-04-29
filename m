Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC38482C60;
	Tue, 29 Apr 2025 17:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948108; cv=none; b=ZM/7Df2nqiYRqn5BlFo2PEttK4g14YuG1z3NRL5PITc2FMBXKKipCBq+7HNrUf3xTElw6EPwBfWDypoeqDTS6Nc/i8S6cAIBk9voqQeBb1VsOD7PZSNbXXl8vLiZX44PwdQG/xK2Xb0veuwyp2+izn04Jmt8ULVsWjCzNe61Ddg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948108; c=relaxed/simple;
	bh=UoF3IImy8zpRULCgt3+JcfHOCuwhRAGT8iU7ESKi764=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDDloWGcdXVKlpmmajCuy5iuBSwcRW23bu2n1wmaxjGiwfbpRIdGyCCG7yHtJ5U9LvOQQvjRMJUz5xCl3l62klyHmnnFWxt4x30ooOpEWdR3DVrHmLkon9+1PnQ+rC531bZhdV83cybGpK1bK9Nettr2UFuo7DVqMX2qThFWKqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZI/huq0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZI/huq0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F26C4CEE3;
	Tue, 29 Apr 2025 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948108;
	bh=UoF3IImy8zpRULCgt3+JcfHOCuwhRAGT8iU7ESKi764=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZI/huq0udijosaC2ILMvvVHOdCi8AibwNLceuuQs6P1r3jywdgrWSbftrKyOVAEp+
	 xHgY7y1R0ingR6he1fo8MD8Xj1d/7G6RPUXMHYVQJXxdU/KFaNJO+2IIldzMCUF+AS
	 eWM05e/Phtrt507sbb2cb1nEzPyBH7RdSbl3DCAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 192/280] qibfs: fix _another_ leak
Date: Tue, 29 Apr 2025 18:42:13 +0200
Message-ID: <20250429161122.959776436@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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



