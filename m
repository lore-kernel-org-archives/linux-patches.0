Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633B83A63E8;
	Mon, 20 Apr 2026 13:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691600; cv=none; b=oz31HK4gGDQPcQ3QZkRKe5tZnkkHIeef7MWjeL7QbYYpNkkuadM+9egtbyzlWue2Oe7/ZPab63fSIi9TKHWtGL0aulddUv80iGudJYxkqiHr3gjuCBrj6JAnWfYDGQrUM8N7d5KlF6vOTsJq0rHwcmX6977XcdxN29li8USdQfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691600; c=relaxed/simple;
	bh=k43V/qSmU7C+NtBAQOUmZaioCpCS405F2aNaLv2Pv2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cf6IxPwNYiZu1VSavpPdlopdquuH0ttpfpRLylX5l3Xzpc6M/2pTZixF+KGgWX9UpvafYuBjbC1gF5nYWnVKKQTJ64Dg4JS14G4DZDWa6MGICcSc7DLBEleFtFPla2C+np0Jv78m4mopkjXUXZ/RQZ4/fB++Bj/K9CRYjWZUULU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LKqZ9uDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LKqZ9uDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555A8C2BCB9;
	Mon, 20 Apr 2026 13:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691600;
	bh=k43V/qSmU7C+NtBAQOUmZaioCpCS405F2aNaLv2Pv2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKqZ9uDu9W19ShroGAzPcXdARXWx2+j0DrkIFEgHsbXuL0+Fe2cZgKgREv+Lbdy6q
	 xAiqN7rJYzyUFb+P+Mhef/Za35sh6rHHDXn13p7mPiPooGQgwmpzhQS9d1Wy5MsBzp
	 6EohYkWCurybDKJQwzxMe25YlKCfA0847+FRXOkSWL1OngCbyt+9vtp670g/wZKgLF
	 5g2vj49qmQHXiznZt5QB1IaMzPleN2lbMQu3PjutxFH5tIkdB910SiGY8WyBfHaJlD
	 sMCNhP/siYg+/4NcMlN4ZN8mo2rUGyxlq1MPsvrYh9jiDb9WrHvv4ZG67NWf0MVC3o
	 lMkaeeBolnreQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiexun Wang <wangjiexun2025@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	xemul@parallels.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] af_unix: read UNIX_DIAG_VFS data under unix_state_lock
Date: Mon, 20 Apr 2026 09:18:38 -0400
Message-ID: <20260420132314.1023554-124-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

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

