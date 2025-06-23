Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3960D2417C3;
	Mon, 23 Jun 2025 13:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684379; cv=none; b=VZ8o2scnB7yP7B5U/4AG/NCi2T8Q0pnYKgZcBfGtmBYTYL3RL+SOV9oKFDv5CpbfF+9R/CL1aY16UKwnyA0AGEDZtUNTxqGgGlv8TMtDF0D6cnWQ8d0NgmoEx3FS2u7YU8ow0ViFKV6bZ5KGKXwvM/l6oUy0SUflnFXQZKfoDLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684379; c=relaxed/simple;
	bh=shZIPhNd1OD6DZPBRpaIzNuiwjmLzoSKjQoy9IaSRCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gj977HQFQwVl4kRCOh3voAPEg5oLZel/VQqsF4QGqxK3hsUKzyzHWzZnSHHOw6C+yVbArTbx1nwQ1qi1CzRwM0htswUVAgG+foVLDT2xKvz2oSQu7aF6i9dhJnlJiJeovO4zs03R9HG++f3QzRl0ogTUGOiDowOoqnV5RrByvYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FECj383h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FECj383h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C310CC4CEEA;
	Mon, 23 Jun 2025 13:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684379;
	bh=shZIPhNd1OD6DZPBRpaIzNuiwjmLzoSKjQoy9IaSRCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FECj383h4AEhKR5sng6+Aa8aZG48K1NKVq2690ODoILgqr2l/eeig+OiO/VKvuCaS
	 nwltNFRQDaHDVlpg83qYp/XVHpqdIugUTbyF39UefRpYrQ15zVu1WWHlL7z2quCr5r
	 NwBbTFbSkB9/ryFYOxXcinmTlOeETSwLH9w+jnCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.15 046/592] NFS: always probe for LOCALIO support asynchronously
Date: Mon, 23 Jun 2025 15:00:04 +0200
Message-ID: <20250623130701.340340225@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

commit 1ff4716f420b5a6e6ef095b23bb5db76f46be7fc upstream.

It was reported that NFS client mounts of AWS Elastic File System
(EFS) volumes is slow, this is because the AWS firewall disallows
LOCALIO (because it doesn't consider the use of NFS_LOCALIO_PROGRAM
valid), see: https://bugzilla.redhat.com/show_bug.cgi?id=2335129

Switch to performing the LOCALIO probe asynchronously to address the
potential for the NFS LOCALIO protocol being disallowed and/or slowed
by the remote server's response.

While at it, fix nfs_local_probe_async() to always take/put a
reference on the nfs_client that is using the LOCALIO protocol.
Also, unexport the nfs_local_probe() symbol and make it private to
fs/nfs/localio.c

This change has the side-effect of initially issuing reads, writes and
commits over the wire via SUNRPC until the LOCALIO probe completes.

Suggested-by: Jeff Layton <jlayton@kernel.org> # to always probe async
Fixes: 76d4cb6345da ("nfs: probe for LOCALIO when v4 client reconnects to server")
Cc: stable@vger.kernel.org # 6.14+
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/client.c                           |    2 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c |    2 +-
 fs/nfs/internal.h                         |    1 -
 fs/nfs/localio.c                          |    6 ++++--
 4 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -439,7 +439,7 @@ struct nfs_client *nfs_get_client(const
 			spin_unlock(&nn->nfs_client_lock);
 			new = rpc_ops->init_client(new, cl_init);
 			if (!IS_ERR(new))
-				 nfs_local_probe(new);
+				 nfs_local_probe_async(new);
 			return new;
 		}
 
--- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
+++ b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
@@ -400,7 +400,7 @@ nfs4_ff_layout_prepare_ds(struct pnfs_la
 		 * keep ds_clp even if DS is local, so that if local IO cannot
 		 * proceed somehow, we can fall back to NFS whenever we want.
 		 */
-		nfs_local_probe(ds->ds_clp);
+		nfs_local_probe_async(ds->ds_clp);
 		max_payload =
 			nfs_block_size(rpc_max_payload(ds->ds_clp->cl_rpcclient),
 				       NULL);
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -455,7 +455,6 @@ extern int nfs_wait_bit_killable(struct
 
 #if IS_ENABLED(CONFIG_NFS_LOCALIO)
 /* localio.c */
-extern void nfs_local_probe(struct nfs_client *);
 extern void nfs_local_probe_async(struct nfs_client *);
 extern void nfs_local_probe_async_work(struct work_struct *);
 extern struct nfsd_file *nfs_local_open_fh(struct nfs_client *,
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -171,7 +171,7 @@ static bool nfs_server_uuid_is_local(str
  * - called after alloc_client and init_client (so cl_rpcclient exists)
  * - this function is idempotent, it can be called for old or new clients
  */
-void nfs_local_probe(struct nfs_client *clp)
+static void nfs_local_probe(struct nfs_client *clp)
 {
 	/* Disallow localio if disabled via sysfs or AUTH_SYS isn't used */
 	if (!localio_enabled ||
@@ -191,14 +191,16 @@ void nfs_local_probe(struct nfs_client *
 		nfs_localio_enable_client(clp);
 	nfs_uuid_end(&clp->cl_uuid);
 }
-EXPORT_SYMBOL_GPL(nfs_local_probe);
 
 void nfs_local_probe_async_work(struct work_struct *work)
 {
 	struct nfs_client *clp =
 		container_of(work, struct nfs_client, cl_local_probe_work);
 
+	if (!refcount_inc_not_zero(&clp->cl_count))
+		return;
 	nfs_local_probe(clp);
+	nfs_put_client(clp);
 }
 
 void nfs_local_probe_async(struct nfs_client *clp)


