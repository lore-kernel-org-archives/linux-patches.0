Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D1B1C4EF9;
	Tue, 27 Aug 2024 14:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770788; cv=none; b=K+Y3GBd7whXqHlJ3LWJIAyLLc/fUFCah3FHjqegVN8MMk55IelER8XDnv6Vppzi60OUvWKt7EJ40Xr+gk7riDYloATevtJ6dfX0bnrBAFx5pnJDIJ2cUalbyUDfO4qotqIy/kgHK/RmNT8LtM/YHHY1Kfr78s6jKSsdVAoIuhmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770788; c=relaxed/simple;
	bh=fmthrTYexew87ihGTxc4eo6dp2jE/KEKEoSyJi5h0mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXRyPRsT89JX2rAjyZdrKyCi4T/RNN6jAEw5Y1CZK2j98PFknsUm00ORPCjKDDmpMX3rW4mKSc6Ki0NiDdQZNypj43Kh/7aKKdhhbykXqQGRfmphw0Uy7E9NoQ4tN8j9EQV5CfBtzWu77CBeNPKzBznHrtwHnTsYDYHrn+ZWoEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjzx6ROx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjzx6ROx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40800C4AF1C;
	Tue, 27 Aug 2024 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770788;
	bh=fmthrTYexew87ihGTxc4eo6dp2jE/KEKEoSyJi5h0mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjzx6ROxsDrvhKh8MuTzAk198Mv+oEYSoG0GThKROEKLSe5lY1q/Eh4YQVFLlfQH1
	 7lkVffUlG/bHe/dZjIF/50uOjbvmKqA/n6J9tQZXZlz247xgAZR4AqgccEevmA+3YL
	 gmanHkbXR9Rb18C7mjQG8T7tYp0ZVpr35rivKkbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Li Lingfeng <lilingfeng3@huawei.com>
Subject: [PATCH 6.6 335/341] NFSD: simplify error paths in nfsd_svc()
Date: Tue, 27 Aug 2024 16:39:26 +0200
Message-ID: <20240827143856.141540017@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

commit bf32075256e9dd9c6b736859e2c5813981339908 upstream.

The error paths in nfsd_svc() are needlessly complex and can result in a
final call to svc_put() without nfsd_last_thread() being called.  This
results in the listening sockets not being closed properly.

The per-netns setup provided by nfsd_startup_new() and removed by
nfsd_shutdown_net() is needed precisely when there are running threads.
So we don't need nfsd_up_before.  We don't need to know if it *was* up.
We only need to know if any threads are left.  If none are, then we must
call nfsd_shutdown_net().  But we don't need to do that explicitly as
nfsd_last_thread() does that for us.

So simply call nfsd_last_thread() before the last svc_put() if there are
no running threads.  That will always do the right thing.

Also discard:
 pr_info("nfsd: last server has exited, flushing export cache\n");
It may not be true if an attempt to start the first server failed, and
it isn't particularly helpful and it simply reports normal behaviour.

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reported-by: Li Lingfeng <lilingfeng3@huawei.com>
Suggested-by: Li Lingfeng <lilingfeng3@huawei.com>
Tested-by: Li Lingfeng <lilingfeng3@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -567,7 +567,6 @@ void nfsd_last_thread(struct net *net)
 		return;
 
 	nfsd_shutdown_net(net);
-	pr_info("nfsd: last server has exited, flushing export cache\n");
 	nfsd_export_flush(net);
 }
 
@@ -783,7 +782,6 @@ int
 nfsd_svc(int nrservs, struct net *net, const struct cred *cred)
 {
 	int	error;
-	bool	nfsd_up_before;
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	struct svc_serv *serv;
 
@@ -803,8 +801,6 @@ nfsd_svc(int nrservs, struct net *net, c
 	error = nfsd_create_serv(net);
 	if (error)
 		goto out;
-
-	nfsd_up_before = nn->nfsd_net_up;
 	serv = nn->nfsd_serv;
 
 	error = nfsd_startup_net(net, cred);
@@ -812,17 +808,15 @@ nfsd_svc(int nrservs, struct net *net, c
 		goto out_put;
 	error = svc_set_num_threads(serv, NULL, nrservs);
 	if (error)
-		goto out_shutdown;
+		goto out_put;
 	error = serv->sv_nrthreads;
-	if (error == 0)
-		nfsd_last_thread(net);
-out_shutdown:
-	if (error < 0 && !nfsd_up_before)
-		nfsd_shutdown_net(net);
 out_put:
 	/* Threads now hold service active */
 	if (xchg(&nn->keep_active, 0))
 		svc_put(serv);
+
+	if (serv->sv_nrthreads == 0)
+		nfsd_last_thread(net);
 	svc_put(serv);
 out:
 	mutex_unlock(&nfsd_mutex);


