Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C102846D548;
	Tue, 21 Jul 2026 15:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648594; cv=none; b=rQBNZ0iuykxmxyB1H0CVjhpZ1a2D2JLLo/sYhih0cQNNiCWjJiSNLhdRWdcvT7qHALcX+AflzqwvhxmHp0gTqYKwcfV0tK+vvGHx9ClFT5nYmT9d/uVdTE1jcvf6QWKgbV48l83X+PPUXABD9pMx1qi5ICnr1kM11iBhi74DdmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648594; c=relaxed/simple;
	bh=0x1LB2eFyxW/0OZJhD2FI5MxMpBvwkXDg2qRMeMEgE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioZmI/3+JuJ0usQs/aQo8RWBIUXn9TEwB9uRPyCjkyyDhlkOtCLJMYMWwKbl4HZ5gzlRPHn7S0CQak07Ekic5L/NO+2fG51QTjpumqT0T/dSMY38D5fExzAqMHUwQzIcBhUxHfYT6ktmMZzaOLQrvafsCfbZ9tS6gSTfKuPSBcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNAvqtIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNAvqtIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321D11F00A3D;
	Tue, 21 Jul 2026 15:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648592;
	bh=+3ibhACGDkPZpnkH046S5yfZ2869JdWDrCihu9Tsrdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNAvqtIwO7qUy0gJkjs7bpgs8VOAEs2DWAPFQfPSD7WcVQM4GNk0dNuiUGpDiE8FJ
	 ot9eNiUk9qnNhetvWUL0qqnjg1qJcO2in0uqaMR0h7ga426ZH8HUEHnkCa9iWU5LmK
	 a8DbDItQI8xiRiEUMKQ54udqUgrv6MkSOxKSHt0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0257/2077] nilfs2: Fix return in nilfs_mkdir
Date: Tue, 21 Jul 2026 16:58:50 +0200
Message-ID: <20260721152558.741885539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 40ac679ec56e40..e2fe95de3d71ca 100644
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



