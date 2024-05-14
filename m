Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C862320F;
	Tue, 14 May 2024 10:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684280; cv=none; b=tHOO0cDSDEaEINn9bim5vH7MtjNsf0d1zaTf5HJ7Vg978gfhNZNntWUVHPEwYl2C3QbiQiu4824AnSfQxEA4eeN1yEqVUxxrhp3/S1mTqnxfzyBPi9qyi31d2Bfp7/BiORam2vwzSpda59RjOSbzXN4SgYy46dQmtetscAMEL/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684280; c=relaxed/simple;
	bh=w/E8FOp3Du4BtVxITmLQHqVzAQ8pXzb3vGQgzzQsK4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwVXShTHK3S06r7r+NvT2Ej+y/lwIipjfE4gDQw9ANDiHbTYwYXBwJYlj1GKeY1uZoLppone4RAhkdttf74EOZiw8mfsyo2cl6JKnJakaloOo2OTqN2wbIr+6brOsX/KLy6heS5u4desu4FyBVfq+CRcBxlKrWCshnEs55Md0mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXg1AOAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXg1AOAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AC2C2BD10;
	Tue, 14 May 2024 10:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684279;
	bh=w/E8FOp3Du4BtVxITmLQHqVzAQ8pXzb3vGQgzzQsK4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXg1AOAwK/00DiGw92tsnC1qvz/7SnxqeJQHrBXzyAAFCYn+uviWQC/T9jIyXreQw
	 e83juTXi3PoeOMikd/nfu5PRzO2t4BlZBeXBWSn54UEka+kY6v2zS4PqiFmuVtq3JZ
	 Wz+yFkOEpd/RBhwsUiUk1Jk2eUQfzUghL/Iix7IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/301] nfs: expose /proc/net/sunrpc/nfs in net namespaces
Date: Tue, 14 May 2024 12:14:49 +0200
Message-ID: <20240514101032.932119193@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit d47151b79e3220e72ae323b8b8e9d6da20dc884e ]

We're using nfs mounts inside of containers in production and noticed
that the nfs stats are not exposed in /proc.  This is a problem for us
as we use these stats for monitoring, and have to do this awkward bind
mount from the main host into the container in order to get to these
states.

Add the rpc_proc_register call to the pernet operations entry and exit
points so these stats can be exposed inside of network namespaces.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 24457f1be29f ("nfs: Handle error of rpc_proc_register() in nfs_net_init().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index e21c073158e5b..d7d937597001d 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -2427,11 +2427,13 @@ EXPORT_SYMBOL_GPL(nfs_net_id);
 static int nfs_net_init(struct net *net)
 {
 	nfs_clients_init(net);
+	rpc_proc_register(net, &nfs_rpcstat);
 	return nfs_fs_proc_net_init(net);
 }
 
 static void nfs_net_exit(struct net *net)
 {
+	rpc_proc_unregister(net, "nfs");
 	nfs_fs_proc_net_exit(net);
 	nfs_clients_exit(net);
 }
@@ -2486,15 +2488,12 @@ static int __init init_nfs_fs(void)
 	if (err)
 		goto out1;
 
-	rpc_proc_register(&init_net, &nfs_rpcstat);
-
 	err = register_nfs_fs();
 	if (err)
 		goto out0;
 
 	return 0;
 out0:
-	rpc_proc_unregister(&init_net, "nfs");
 	nfs_destroy_directcache();
 out1:
 	nfs_destroy_writepagecache();
@@ -2524,7 +2523,6 @@ static void __exit exit_nfs_fs(void)
 	nfs_destroy_inodecache();
 	nfs_destroy_nfspagecache();
 	unregister_pernet_subsys(&nfs_net_ops);
-	rpc_proc_unregister(&init_net, "nfs");
 	unregister_nfs_fs();
 	nfs_fs_proc_exit();
 	nfsiod_stop();
-- 
2.43.0



