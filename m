Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003B1405845;
	Tue, 21 Jul 2026 17:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655891; cv=none; b=Cf4evgjYLfAuvGcovYDwyLYmywa4/qEhHsxXuAO5784b9NU9OJUT1Tc9ilAy6u7H0YeIOFiJGEA0Ds+5MAeOt7wTLAt46bpbKXosJV3xu2mKv0q8AgmVmoQzOU53wEB148GqDq+zr8RQKS1v+rLm4YApGCWXIx0n/LW0vzMnm/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655891; c=relaxed/simple;
	bh=exuFSLaRQAsNelGNEzT9aPp4P2DcneQST4mHdDEYw/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZcF6PWo4q1OXu8FMm6HaVvPEW8vP3mQ3gqsyRXiMyWdvwA1uCF2tXk8P/IhLIj7yUer1EBS6NgdrQMOKfvlepeJKCT+CrezmxWB1jrDNDTu4kVqza4tz4VtotW7OjQTXLwyFYPKg72LyEbH2jR4Q7hgD2u3SdJqjo8twZlz+us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orHx/myL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orHx/myL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AD71F000E9;
	Tue, 21 Jul 2026 17:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655889;
	bh=4LLSWFlC/otm1xwm02XNvtnWZvGkSpJM8zZhLuhxzCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=orHx/myLB2/SEzKSZMwPdOHnyRv2qzfrwgAL7Zp/ndu6+RzxT6hmDrPmCSOkTJlO6
	 C4MTYmecIeBcb/F4J34YrEX6pHF2PRGlee3fAT7Nh15+SaUOJZsvLr/yPUeRBEW1B0
	 ospNPeNHPpI1LXaPXCtuf60unCA1oT2C6GL04Hbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0179/1611] nilfs2: Fix return in nilfs_mkdir
Date: Tue, 21 Jul 2026 17:04:55 +0200
Message-ID: <20260721152518.942175660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit e5925f33e4fa9ee313d481557607adce8e30ed2e ]

Return NULL instead of passing zero to ERR_PTR.
  Fixes smatch warning:
     - fs/nilfs2/namei.c:261 nilfs_mkdir() warn: passing zero to 'ERR_PTR'

Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 40f4b1a28705b6..4132be9810a053 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -258,7 +258,7 @@ static struct dentry *nilfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	else
 		nilfs_transaction_abort(dir->i_sb);
 
-	return ERR_PTR(err);
+	return err ? ERR_PTR(err) : NULL;
 
 out_fail:
 	drop_nlink(inode);
-- 
2.53.0



