Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EAF3A48E4;
	Sat, 17 Oct 2026 17:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259662; cv=none; b=Ak2ynao/n9GjdLaBm8D5Id7G9Xdwc8V+Yc+UebU6bqtmmPq7ZwGKkQS1UBJdvxztA/+MrgINalY8x4NHXHgV0q1pgpoXJgAgbsOSp7J+GgurIfw7SZkhvPz0kNUr9sH5WvKRAoE/VQVM5T7zHfSkq6tlbmgYiNL7sCd1zO++UtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259662; c=relaxed/simple;
	bh=ri4QmbAQTSRTjh3Bk0vy6wGUhIrFvWGLQ6yPLkbPReA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1Hmt6eAp7gaZR55/WxzCod2napMXs7Wk4Lcl0SAwVp9HyNxi4fScqysy4beiWh3jUFNpNRgAZBjIOYpxwrU/yowLEm7l/A6sKrLJh36jg8MR9GNbqN4Jq8vRS9JTbutVMw3qt38dP0NOPD9S2FwnhyNW/9mhO8jUB/3PZvMQcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4k+mt5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4k+mt5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CC91F000C4;
	Sat, 17 Oct 2026 17:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259661;
	bh=/z1EbAtp19kGN0AdOWgJASAQO66fd0plnlzlP2kOjwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4k+mt5CwuQe71NYjKI6AyjZVGjzS1bPsG7p2qt6leQhyirXflftCbkGnnx3eSw56
	 yPp/6yY2O/7PGFlCTbLNKV4/0yUVCNpFfgGT0iBkLRsprTVcL74GEnfTvdNKE+UrrM
	 oyEFa9KfRH7bQ+9aMXX5e3bYBScmmNbeUwaC7Eks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <dstsmallbird@foxmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Luxiao Xu <rakukuip@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1289/1674] sunrpc: fix use-after-free in __rpc_clnt_handle_event and __rpc_clnt_remove_pipedir
Date: Sat, 17 Oct 2026 17:59:21 +0200
Message-ID: <20261017160504.227081013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luxiao Xu <rakukuip@gmail.com>

[ Upstream commit 932a8cf6abb2b2f8677b79153a823108d8861fe2 ]

Normal client creation goes through rpc_setup_pipedir(), which records
clnt->pipefs_sb, but the mount-event path in __rpc_clnt_handle_event()
calls rpc_setup_pipedir_sb() directly and never refreshes that field.
The umount path also removes the directory without clearing
clnt->pipefs_sb.

After a late pipefs mount or any remount, rpc_clnt_remove_pipedir()
compares the current superblock against a stale pipefs_sb pointer and
skips cleanup, leaving pipefs dentries whose inode private data still
points at a freed rpc_clnt, leading to a potential use-after-free during
subsequent rpc_info_open() or rpc_show_info() calls.

Fix this by properly updating clnt->pipefs_sb upon mount events and
clearing it during unmount or failure paths.

Fixes: bfca5fb4e97c ("SUNRPC: Fix RPC client cleaned up the freed pipefs dentries")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <dstsmallbird@foxmail.com>
Reviewed-by: Ren Wei <enjou1224z@gmail.com>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 85cfd7b7c212a..29b73519220fe 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -101,7 +101,10 @@ static void rpc_unregister_client(struct rpc_clnt *clnt)
 
 static void __rpc_clnt_remove_pipedir(struct rpc_clnt *clnt)
 {
-	rpc_remove_client_dir(clnt);
+	if (clnt->pipefs_sb) {
+		rpc_remove_client_dir(clnt);
+		clnt->pipefs_sb = NULL;
+	}
 }
 
 static void rpc_clnt_remove_pipedir(struct rpc_clnt *clnt)
@@ -183,26 +186,33 @@ static int rpc_clnt_skip_event(struct rpc_clnt *clnt, unsigned long event)
 }
 
 static int __rpc_clnt_handle_event(struct rpc_clnt *clnt, unsigned long event,
-				   struct super_block *sb)
+				    struct super_block *sb)
 {
 	struct dentry *dentry;
+	int err = 0;
 
 	switch (event) {
 	case RPC_PIPEFS_MOUNT:
+		clnt->pipefs_sb = sb;
 		dentry = rpc_setup_pipedir_sb(sb, clnt);
 		if (!dentry)
-			return -ENOENT;
-		if (IS_ERR(dentry))
-			return PTR_ERR(dentry);
+			err = -ENOENT;
+		else if (IS_ERR(dentry))
+			err = PTR_ERR(dentry);
+		if (err)
+			clnt->pipefs_sb = NULL;
 		break;
 	case RPC_PIPEFS_UMOUNT:
-		__rpc_clnt_remove_pipedir(clnt);
+		if (clnt->pipefs_sb == sb) {
+			__rpc_clnt_remove_pipedir(clnt);
+			clnt->pipefs_sb = NULL;
+		}
 		break;
 	default:
 		printk(KERN_ERR "%s: unknown event: %ld\n", __func__, event);
 		return -ENOTSUPP;
 	}
-	return 0;
+	return err;
 }
 
 static int __rpc_pipefs_event(struct rpc_clnt *clnt, unsigned long event,
-- 
2.53.0



