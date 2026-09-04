Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2666C40F754;
	Fri,  4 Sep 2026 05:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498645; cv=none; b=md+NPxBhTp14VIPI283u/zc5HquRri+dAayrXrYjw88ahx8XGf1qSZZuKPNsRauWKq0O60kvqdVIfs1fEoVfZ2XIPaP70Nauj9k8ZhiuMvdPrxF2co2O4xdXvxgG3MKL1PMJIbAFhpWWSDZh1xR5/DTbaniC+BhKcjqcJLtfw1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498645; c=relaxed/simple;
	bh=2f1mJ5xzXX/flEE9wkKRw4bsf5xJvcSWmj0iGukE+2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ci5ZHB9X/xWQXcpU4ruBeorM8gnMYG6FE0LAuN5WJZSCtJNCj1lS4tJPmfcChNKthpnycXGl4C/cmcpDpiNxjrlzugEeQOJptrByv9ISNl5o0/3Kg58suqFhDY813dgm8e9yGT7/OPj9b91PUlbCBMP5ZDaxlM+dmORVh6VGYXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZS79KmY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZS79KmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3E51F00A3D;
	Fri,  4 Sep 2026 05:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498643;
	bh=1PrTDcXpqmN4z2D3Anfm70ZYW77JjsomtFLDV9iTsWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZS79KmYTqSL2LzGZ6qXcvRSLCw/DRdg8n+1ZDltTd1IcdWLamRODAFbiKAYDZivp
	 pbRO9tuKR8tHqQ/fyh9zYimpWSyqI7eLKYhFwb5RdJUtbqxHmI9NrzO1uCOIpSBPFD
	 YyNde7b12vHtzAhg480oDq32e66/69O+apqhXgas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nate Prodromou <nate@prodromou.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 7.2 137/713] NFS: fix delegation_hash_table leak when nfs4_server_common_setup() fails
Date: Fri,  4 Sep 2026 06:51:45 +0200
Message-ID: <20260904045806.903105081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -915,20 +915,22 @@ static int nfs4_server_common_setup(stru
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
@@ -937,7 +939,7 @@ static int nfs4_server_common_setup(stru
 
 	error = nfs_probe_server(server, mntfh);
 	if (error < 0)
-		return error;
+		goto out_free_delegation_hash;
 
 	nfs4_session_limit_rwsize(server);
 	nfs4_session_limit_xasize(server);
@@ -949,6 +951,11 @@ static int nfs4_server_common_setup(stru
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


