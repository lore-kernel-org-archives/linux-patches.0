Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F7F2264A3;
	Fri,  4 Sep 2026 05:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500556; cv=none; b=dgEC7jKNqaSdXSB/p69feIq5JCoWH+FbtlxyFcGT/DE6HwTqtSsN9G9y3Zmqfp65IVIMNSWVCIi62RB4aYE+W0H4gFrkobOIry4JY0lJaZRIW/tdio306U6MPKfg3LY4vZX06l4/bSx3LuyZx+whWibTIiiIMhMftLIkVPKHE7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500556; c=relaxed/simple;
	bh=2U4Zv1f4z6I0S4IKqXeGLasUBYFmvNUMiTto0tbvih8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X12QHI6TaWvmhMlrur0GaLoJ6LpWEWQxpAWwDMNyMYJV+EO0x94k+wVw8NOQ7gpVuFxZX0gxJD0fmLt36djEWjbgjP+WB4xRyCkVco6MOEnKgStRLRpXiGHqi+7LbjenNTuslWo9ne8DI9ZX0Rvkt/AGegDM896pAEtjKZM6qYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1Afpu8p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1Afpu8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92D11F00A3D;
	Fri,  4 Sep 2026 05:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500555;
	bh=BDwMY2/u9Z+E4hWeZU3Ef7zP3u8owwGSIV+OlkYylnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1Afpu8pNR5tYJI2SRKwCWdNgXel+oyzBnZff/uq1XwVI26Nnrbdct2zasJ96azGi
	 wVPRfgCn12IeGU3m4vpTBkKo3rhTdsn626e0DxVx1jDwnJz+tvvFmsafFO8GYFwSCJ
	 rSR3qm19BpuNbf1qnCel8VHwnp7Nch03Ii17k5QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nate Prodromou <nate@prodromou.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.18 098/552] NFS: fix delegation_hash_table leak when nfs4_server_common_setup() fails
Date: Fri,  4 Sep 2026 06:54:15 +0200
Message-ID: <20260904045750.118770693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Nate Prodromou <nate@prodromou.com>

commit 2092f5b38f88be306140c77aeeeb43fc1adacacc upstream.

nfs4_server_common_setup() allocates server->delegation_hash_table
first, but server->destroy - the only path that frees the table via
nfs4_destroy_server() - is not assigned until the very end of the
function. If any intermediate step fails (the is_ds_only_client()
check, nfs4_init_session(), nfs4_get_rootfh(), or nfs_probe_server()),
the function returns with server->destroy still NULL, so the caller's
nfs_free_server() skips the destroy callback and the hash table is
leaked (4 KiB per attempt with the default delegation watermark).

This is trivially reachable from userspace: every failed NFSv4 mount
leaks one allocation. A client that persistently retries a mount that
cannot succeed leaks kernel memory without bound. Observed in
production where a Longhorn backup poller retried mount.nfs4 against
an NFSv3-only server roughly 10 times per second, leaking ~3.4 GiB of
unreclaimable slab (kmalloc-rnd-13-4k) per day; the node accumulated
12 GiB of leaked slab before the source was identified via the
kmem:kmalloc tracepoint (call_site=nfs4_delegation_hash_alloc).

Reproducer:

  # server exports NFSv3 only (or export path absent for v4)
  while :; do mount -t nfs4 <server>:/missing /mnt; done
  # watch SUnreclaim in /proc/meminfo grow 4 KiB per iteration

Free the table on the error paths between the allocation and the
assignment of server->destroy.

Fixes: f5b3108e6a14 ("NFS: use a hash table for delegation lookup")
Cc: stable@vger.kernel.org
Signed-off-by: Nate Prodromou <nate@prodromou.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4client.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1095,20 +1095,22 @@ static int nfs4_server_common_setup(stru
 		return error;
 
 	/* data servers support only a subset of NFSv4.1 */
-	if (is_ds_only_client(server->nfs_client))
-		return -EPROTONOSUPPORT;
+	if (is_ds_only_client(server->nfs_client)) {
+		error = -EPROTONOSUPPORT;
+		goto out_free_delegation_hash;
+	}
 
 	/* We must ensure the session is initialised first */
 	error = nfs4_init_session(server->nfs_client);
 	if (error < 0)
-		return error;
+		goto out_free_delegation_hash;
 
 	nfs_server_set_init_caps(server);
 
 	/* Probe the root fh to retrieve its FSID and filehandle */
 	error = nfs4_get_rootfh(server, mntfh, auth_probe);
 	if (error < 0)
-		return error;
+		goto out_free_delegation_hash;
 
 	dprintk("Server FSID: %llx:%llx\n",
 			(unsigned long long) server->fsid.major,
@@ -1117,7 +1119,7 @@ static int nfs4_server_common_setup(stru
 
 	error = nfs_probe_server(server, mntfh);
 	if (error < 0)
-		return error;
+		goto out_free_delegation_hash;
 
 	nfs4_session_limit_rwsize(server);
 	nfs4_session_limit_xasize(server);
@@ -1129,6 +1131,11 @@ static int nfs4_server_common_setup(stru
 	server->mount_time = jiffies;
 	server->destroy = nfs4_destroy_server;
 	return 0;
+
+out_free_delegation_hash:
+	kfree(server->delegation_hash_table);
+	server->delegation_hash_table = NULL;
+	return error;
 }
 
 /*


