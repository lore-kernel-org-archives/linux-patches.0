Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43214BEE54;
	Sat, 12 Sep 2026 09:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205214; cv=none; b=QhjwIDb49cQU5spEntut6bJAYWHLenmtGbgsUXwT+32sMF+1DYNHqQZZVeuEx/+Ws6Qtdayw0D35IPr+NUWHUFqZp5UYA2Jxf3/A8pKcxLv5pfbHkaE9PKH+pK0BIAlHt/rNlXx48u1THQx8G9Gru4KJyOxElz2EA5L/lkSkjDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205214; c=relaxed/simple;
	bh=ewCt0hiJU6aqlb+ZFzYGzXCo2NqFy5000fum2sw0h84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elK8omGXTFpenSe5DYqrxnSq54TFFciFuV+sjHIIPG3zWhKOLQXnhRXRx6N40cVLqulX1WJstvfhe0/qgwgHusjyqe1NFvIFnc+1EakgUZTg1svE//FJkTr845muoAJCuMBtkIMOTZYiJSjJ8vy338S+sFxzI14SeQzpCwbOm9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLAJaNmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLAJaNmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FC51F000FF;
	Sat, 12 Sep 2026 09:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205213;
	bh=AnxrVMe6+9JJSJKufwGtN46TxJPnDvEjjJNjAf8Jg70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLAJaNmc2RNNJgYozbX8+gASyqbAOMxc6LHiAAzkT9hSgZtTtIADoS4zX6voj8XLP
	 k87O7s4aoHWmeTPpeoewAHVLjg1PtTqTBBbk+WGCK2e8kl/ST4aLPQdNGbTgq+YUfY
	 4Gycp+06+y7NkFqH5ZA4n9ci0s/FlEQneZwxeFHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1771/1815] ceph: Fix ERR_PTR(0) in ceph_mkdir()
Date: Sat, 12 Sep 2026 08:58:41 +0200
Message-ID: <20260912065730.584800424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 40326517481cf..12dd3dc539152 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1174,7 +1174,7 @@ static struct dentry *ceph_mkdir(struct mnt_idmap *idmap, struct inode *dir,
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



