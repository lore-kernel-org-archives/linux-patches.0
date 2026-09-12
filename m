Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F45353A75;
	Sat, 12 Sep 2026 11:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212619; cv=none; b=O1oEwBfNwWYGxj2b2qtKnpj15ByXBUnvZDyjUISEXymHx94gVAtIfEKroFAsZmYbqRj6Zh4jZAdLyiPdOKYDWF2SHtWf+zFiCk7RWxx6g0a6f/QlhOZVXvHtE0HRUFSyZA7HemfkUXkK4HQzML8GyDii0V6O2jvpauoZEJ1JSWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212619; c=relaxed/simple;
	bh=VkBfUCr1G3+XWSe6jii+JG+9VWZF+jTcOKbMXoE4DrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9tuq2Z07mJR50dipZ4h7k/aU2Liu+PJayMEByMIAuu0NTibhKpB1Bd3Kr0dywiZ5fXbRVwxIp9JVxlFF07O23o5sG+M2Z2+K6yfafPnyhJdf5vE3wLQ2Y7qDCQb7RkREac9rkmHtPXNbZhBCuxt8JaJ0DxXPxGGBVZoY9G1QEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlmpCa7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlmpCa7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A076D1F000FF;
	Sat, 12 Sep 2026 11:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212617;
	bh=mwsxRzOlgApWcjNtiHiDz1lTQ779yWCbJ2HtlFnzttw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WlmpCa7FMAbYM3EH3XuH+NKM29CQYIz3J+6Q4FCYSS2E0cl3xX/3IOLOOkzbcBMl+
	 OUhgBK9MZUXOK6vYmbwPayPfx0TKS3SVnlln/b23Y5xjPLi3R71+2Hzlpw+r972I3O
	 GLGAM5qohB9Ps3d4CM66h3IFcdwx+xvTTVuhhL6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1431/1518] ceph: Fix ERR_PTR(0) in ceph_mkdir()
Date: Sat, 12 Sep 2026 09:00:00 +0200
Message-ID: <20260912065655.922913063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 4f49c3f8a5a86d237bb202ecb17c2802ddc8fd2f ]

When mkdir succeeds, ceph_mkdir() sets ret to ERR_PTR(0) which is
incorrect. It should return NULL instead for success.

Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index e4577a80da58c..24abe4dbf774d 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1173,7 +1173,7 @@ static struct dentry *ceph_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	    !req->r_reply_info.head->is_target &&
 	    !req->r_reply_info.head->is_dentry)
 		err = ceph_handle_notrace_create(dir, dentry);
-	ret = ERR_PTR(err);
+	ret = err ? ERR_PTR(err) : NULL;
 out_req:
 	if (!IS_ERR(ret) && req->r_dentry != dentry)
 		/* Some other dentry was spliced in */
-- 
2.53.0



