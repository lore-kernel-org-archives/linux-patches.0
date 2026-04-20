Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B8B33262B;
	Mon, 20 Apr 2026 15:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700323; cv=none; b=jIYid8hH0XnLswfMGwukkn85p2tcoxIBvW6WA+9RybII3HmI9tQ45/H/jSjRpFAvs4HSywKr/e2rO3pelrmWhkNanzWIt8C/TE6kN0cz0DByXD4UCSmFyEidz+6pOYnA5g7H+M4ALYpMLNpqdCDBSxXhNdtrRQUjPr/XoyC1plc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700323; c=relaxed/simple;
	bh=4FULiEwre8gWiYOsa0GYw9YzYwaEkyE2VKsk8oVpIfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCpy+24U97SiYczmZeZAiL4vFF87MGKo9qTFGx07GZKacijeMsECIdPff1daxcBMwVQYlpevm0O6hQbFJHDvxXoz1bcfCGk/3BpsSBEAbEsMX9kDwayS2e/7gPdJH2IgfPhUQ6Q1aRjiy+rEhaAjKh+FRde/OHsSul9F4RFDh7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjimM3l7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjimM3l7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB45C19425;
	Mon, 20 Apr 2026 15:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700322;
	bh=4FULiEwre8gWiYOsa0GYw9YzYwaEkyE2VKsk8oVpIfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjimM3l7647fM8WRXhwgX/qMktFQ9kHq8T7xNkwMUrvIZGn+SABuyZTJzxCtzlwtX
	 qqylmivV2S0KC0ihV6UjQoP/hmLKYuuRQVTRLm+YFHI7zTVooSrES8Uq2+cJPn8OnY
	 BFoM33v6WnFaC6mjkOVG3KnPAKx+Go1r0m4LtjuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Jiexun Wang <wangjiexun2025@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 127/220] af_unix: read UNIX_DIAG_VFS data under unix_state_lock
Date: Mon, 20 Apr 2026 17:41:08 +0200
Message-ID: <20260420153938.600659761@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiexun Wang <wangjiexun2025@gmail.com>

[ Upstream commit 39897df386376912d561d4946499379effa1e7ef ]

Exact UNIX diag lookups hold a reference to the socket, but not to
u->path. Meanwhile, unix_release_sock() clears u->path under
unix_state_lock() and drops the path reference after unlocking.

Read the inode and device numbers for UNIX_DIAG_VFS while holding
unix_state_lock(), then emit the netlink attribute after dropping the
lock.

This keeps the VFS data stable while the reply is being built.

Fixes: 5f7b0569460b ("unix_diag: Unix inode info NLA")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Jiexun Wang <wangjiexun2025@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260407080015.1744197-1-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/diag.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index ca34730261510..c9c1e51c44196 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -28,18 +28,23 @@ static int sk_diag_dump_name(struct sock *sk, struct sk_buff *nlskb)
 
 static int sk_diag_dump_vfs(struct sock *sk, struct sk_buff *nlskb)
 {
-	struct dentry *dentry = unix_sk(sk)->path.dentry;
+	struct unix_diag_vfs uv;
+	struct dentry *dentry;
+	bool have_vfs = false;
 
+	unix_state_lock(sk);
+	dentry = unix_sk(sk)->path.dentry;
 	if (dentry) {
-		struct unix_diag_vfs uv = {
-			.udiag_vfs_ino = d_backing_inode(dentry)->i_ino,
-			.udiag_vfs_dev = dentry->d_sb->s_dev,
-		};
-
-		return nla_put(nlskb, UNIX_DIAG_VFS, sizeof(uv), &uv);
+		uv.udiag_vfs_ino = d_backing_inode(dentry)->i_ino;
+		uv.udiag_vfs_dev = dentry->d_sb->s_dev;
+		have_vfs = true;
 	}
+	unix_state_unlock(sk);
 
-	return 0;
+	if (!have_vfs)
+		return 0;
+
+	return nla_put(nlskb, UNIX_DIAG_VFS, sizeof(uv), &uv);
 }
 
 static int sk_diag_dump_peer(struct sock *sk, struct sk_buff *nlskb)
-- 
2.53.0



