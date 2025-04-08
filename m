Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A4819AD5C;
	Tue,  8 Apr 2025 11:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111810; cv=none; b=KyFmW5U4besOglPhlxyMlHeUrMVs2gu+GhoAN+2CBde/HNQRyZKA7sUB3NgE32aNcpm7gn5HsCwy8zaMI0amPh5cnTeSVQ1r3FUCsLRyQWDaeRCIw+pmbjh4gyNj/zQ2iVTshwAgwallCcYKzWsYbaclRrFl2kU45imIy0QfGaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111810; c=relaxed/simple;
	bh=6Y1UxT96F48oGhZcOr0VvPYZh/9XKMriTe4s3XPtG70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTFq5nMuSddkfiSoBxt8VN3MMLd/MYQX2EQZ4ITi7MiLj6ba838UUEu5EvagiQpodwxSU8r7khzdSqeeNCyKziD5bjoRgwwsG3Cmt4kn8vqYzwnU6fBMmRFZ4jBWdCh+quqhiddj+bc4B3EFCk3YfoP9KvItccbE6h1j5xdbOYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jhrXAt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jhrXAt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C627C4CEE5;
	Tue,  8 Apr 2025 11:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111809;
	bh=6Y1UxT96F48oGhZcOr0VvPYZh/9XKMriTe4s3XPtG70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jhrXAt6W+rv08t1Th/wUM0AVus9ncq4Cz+uAt6wLFCTGFgQqRVk9jjgoY8KVMuyF
	 Y7duD1KjS88W2uGwSRwGR9LHSMU3ymVhlanBWidUp5H8EzPLC0ySmCPPPRtQ7nCAY1
	 kE1TQyQDu8IGlnImq4fAoPD+fIgqKcetZvKtgIVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 551/731] NFS: Shut down the nfs_client only after all the superblocks
Date: Tue,  8 Apr 2025 12:47:28 +0200
Message-ID: <20250408104927.093700517@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 2d3e998a0bc7fe26a724f87a8ce217848040520e ]

The nfs_client manages state for all the superblocks in the
"cl_superblocks" list, so it must not be shut down until all of them are
gone.

Fixes: 7d3e26a054c8 ("NFS: Cancel all existing RPC tasks when shutdown")
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/sysfs.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/sysfs.c b/fs/nfs/sysfs.c
index 7b59a40d40c06..784f7c1d003bf 100644
--- a/fs/nfs/sysfs.c
+++ b/fs/nfs/sysfs.c
@@ -14,6 +14,7 @@
 #include <linux/rcupdate.h>
 #include <linux/lockd/lockd.h>
 
+#include "internal.h"
 #include "nfs4_fs.h"
 #include "netns.h"
 #include "sysfs.h"
@@ -228,6 +229,25 @@ static void shutdown_client(struct rpc_clnt *clnt)
 	rpc_cancel_tasks(clnt, -EIO, shutdown_match_client, NULL);
 }
 
+/*
+ * Shut down the nfs_client only once all the superblocks
+ * have been shut down.
+ */
+static void shutdown_nfs_client(struct nfs_client *clp)
+{
+	struct nfs_server *server;
+	rcu_read_lock();
+	list_for_each_entry_rcu(server, &clp->cl_superblocks, client_link) {
+		if (!(server->flags & NFS_MOUNT_SHUTDOWN)) {
+			rcu_read_unlock();
+			return;
+		}
+	}
+	rcu_read_unlock();
+	nfs_mark_client_ready(clp, -EIO);
+	shutdown_client(clp->cl_rpcclient);
+}
+
 static ssize_t
 shutdown_show(struct kobject *kobj, struct kobj_attribute *attr,
 				char *buf)
@@ -259,7 +279,6 @@ shutdown_store(struct kobject *kobj, struct kobj_attribute *attr,
 
 	server->flags |= NFS_MOUNT_SHUTDOWN;
 	shutdown_client(server->client);
-	shutdown_client(server->nfs_client->cl_rpcclient);
 
 	if (!IS_ERR(server->client_acl))
 		shutdown_client(server->client_acl);
@@ -267,6 +286,7 @@ shutdown_store(struct kobject *kobj, struct kobj_attribute *attr,
 	if (server->nlm_host)
 		shutdown_client(server->nlm_host->h_rpcclnt);
 out:
+	shutdown_nfs_client(server->nfs_client);
 	return count;
 }
 
-- 
2.39.5



