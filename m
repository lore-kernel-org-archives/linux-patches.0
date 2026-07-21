Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FC8472F69;
	Tue, 21 Jul 2026 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656591; cv=none; b=PEIIJadDisD/OgJAlth4OdXTJByZNH/Uv9npVojfShHImZxTAsiYH6qAhK4w3Qm1hOTzlFpH/jtzp/IaAuj2IaRIGCUXiuxvG3UwbtQN2a4CAfrHaUDc9BbhwJp0aHgVr2TzGAk8F9Uppzd6UvQncw+Zb3EOOHCmqI+tmayAujk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656591; c=relaxed/simple;
	bh=oyYB7dP4eWH8D+1gB839n51dgbAqIElXjUBS/XU+RQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+cp/XJIUzx66mJdGxtP90uN3vWCophjMUCq8QxD/oB7OFVQrVO/72MjdEkCHv4yS0OnGJQa/POouJCebTy/HNcXfO2TVk0WI57SD5oPKK3DdqE0dWu8DeRn4Bifj0wDDYjK0JdzRBdDVMsvGCwYcRLVBKG+Z1kojfzdwUnf2Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNMTyNHn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNMTyNHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83BE1F000E9;
	Tue, 21 Jul 2026 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656590;
	bh=oy3mtvDBNSsxi+y1XyDmR9bIqXdLXusUPqlSL8dePlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sNMTyNHnBVHnqMgFHLB31YmlqEP2whAf8RXaO4/rPkt8RtM9ImbWcbIb+0dUzmwrF
	 YJpwlQAwLCioy78th2S20vx2aQtl9ROL3aK/9HYgI8odcvc4eoNKloFurvot2Bjt38
	 LyowGxtr9TlNr93mjBkyGBlP/pUscjYvUkMxbfGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0445/1611] ext4: fix ERR_PTR(0) in ext4_mkdir()
Date: Tue, 21 Jul 2026 17:09:21 +0200
Message-ID: <20260721152525.304919453@linuxfoundation.org>
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

[ Upstream commit 8e1c43af7cf5091d99db38b7c8129e394d7f45b5 ]

When mkdir succeeds, ext4_mkdir() returns ERR_PTR(0) which is incorrect.
It should return NULL instead for success and ERR_PTR() only with
negative error codes for failure.

Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20260604073647.211279-1-zenghongling@kylinos.cn
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2cd36f59c9e363..2e35453a56f28a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3049,7 +3049,7 @@ static struct dentry *ext4_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 out_retry:
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
-	return ERR_PTR(err);
+	return err ? ERR_PTR(err) : NULL;
 }
 
 /*
-- 
2.53.0



