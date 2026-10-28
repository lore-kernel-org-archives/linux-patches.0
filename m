Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215985;
	b=L46u0YDYyu8znUfORBG6u3x8gnA9bY4RuLmhcWrbTQ94DjFeUSZhV7EzPD5xBEh6SdEf
	 RVRyMeE6b5g5kLXsd+PcINT3cnJdETCSlX0kiJylvMOElc7tcgx8Wi0Tg9MueEiGcIM2q
	 NYMh65uA/br4zyXQRC4hlfFoWQHWE19e+HsSvaY5aTRlWEopKNtNRfRg7P6977vWWaTE9
	 T4oyES20kHS8sfa778nt+hNhUY4aWTJpJKQhN+yuDwcQG+G48M1JQf8qwReWgvb51uBNu
	 3xNsXsRwS3McyFwJGZ0ucE+dhDalL/DZgShB9J5TcsmRxPUHpWXKUUIqwBHM1Pb1srA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZEVpfFcLvWV6MEJbtpzk3pLUSPKihhOYscDDBZFX3Q4=;
	b=FagP/O3uTBcqUqLDkQmp+qBi75PcqnCRU4XfDTDqYF2DWQDMISMDfSebjoNuxN4KOnKz
	 phGhWOWoMhC5Ao/JlBOBHS8rx7kLhvpYg6NVoDiYo65y+eQ9XfLjgdo5IjoI9makeptZ8
	 C8I5HUTjF5/XRiB2q2uj8ZiicLQKtcQIWyBqlErMWr/7ZEklvr2MCkBYnms2kS13NhXr7
	 tNEItGZLHyqBb0MnBAJNGCIO4fcrYolcwMux+Re6W2M6Yj03nXfe21zyS8aHFsTmcAVsP
	 /SHPtqx54+fvC+lTq2tvGSxJnCV0/KIrZ8BdXBZrw6iNCFhPx5q+Bhx1b1z9c50X8Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQcRq5eS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED6C606A31A;
	Wed, 28 Oct 2026 19:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQcRq5eS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66FF1F01828;
	Wed, 28 Oct 2026 19:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215985;
	bh=ZEVpfFcLvWV6MEJbtpzk3pLUSPKihhOYscDDBZFX3Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQcRq5eS7/q3Jr7H0dOERlc5cTRYIf7eNU2IQjU8mXrb11GNH5WEFp7tFL7T96ty6
	 4LEeRSd3PbWeFRXL2wMqMLWSBK49QJBPHKaWU1bE9zMqOM7AJzwK7M/JVgOqYzLIB8
	 /3YQyjFrWUM0T2aKFfkDxs++dtp+bza7TYDD1Gpw=
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
Subject: [PATCH 6.1 1400/1887] sunrpc: fix use-after-free in __rpc_clnt_handle_event and __rpc_clnt_remove_pipedir
Date: Wed, 28 Oct 2026 17:58:16 +0100
Message-ID: <20261028170531.310161418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 net/sunrpc/clnt.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index a390a4e5592f2..212e1a4705964 100644
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
@@ -186,23 +189,30 @@ static int __rpc_clnt_handle_event(struct rpc_clnt *clnt, unsigned long event,
 				   struct super_block *sb)
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



