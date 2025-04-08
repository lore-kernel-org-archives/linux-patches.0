Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7988926A0D4;
	Tue,  8 Apr 2025 12:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114896; cv=none; b=EyWHEpkElxe47EnH7Tn7Mnu08aQeMet6JOr4mSMIa9HSPGdIoEGLYb3Ulupe+iKG8gNPb8WgSqI0Olk73LgN682s0k2VFJ3on4Gwgl1jgSZxeUEap2tULHdXXD4zQ2nt/1HY3CY6Y0fBjoyrWx7QFA0XBFtdUy4dSDhseUKAgJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114896; c=relaxed/simple;
	bh=lE9070NnEwNPPpxEzb89vZibm50ixqnj07KX/1p6BNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8W7DoAJppZ9zFlaiAHoHz2Umyj4Xy0N86XoWdxrw/Hm7qn6iowZhIDyGkTjMHFZzCPlfGK0N5As2wCLJ3MLaGqemLu3ekSSP7IpIOQ8pXlvX3QyxzieXxSQ3kBXY1XLXVQt5we4p+ARWTAJx+2YQ94FOtsXRHsRGKZnIPssUJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awkcwvNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awkcwvNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7BCC4CEE5;
	Tue,  8 Apr 2025 12:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114896;
	bh=lE9070NnEwNPPpxEzb89vZibm50ixqnj07KX/1p6BNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awkcwvNsHjD335g/Z8YAWeteRg1rx+whbOkD5l79fzim0JXOtr7QcB3I33K+WmKFQ
	 kp0nF6lnkfP0FrYGYXCNDdp1n2dOOZNqsUHc/zPii69bEs3RmSpG/bO2XycclQDXqm
	 NEQqlvx/J6rpLLL3HuiLlrmfAqIaoP3aNaadmBUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 275/499] NFS: Shut down the nfs_client only after all the superblocks
Date: Tue,  8 Apr 2025 12:48:07 +0200
Message-ID: <20250408104858.075622601@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



