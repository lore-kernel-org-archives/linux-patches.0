Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D53319E7F0;
	Thu,  6 Jun 2024 14:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683529; cv=none; b=BsQbfqUZhMnTT5YHY1KG2DxYDbAkUJz+H3Jpd4bt1aSbyaKcg/c9NA+P7ABX5wqaZ4h6BmNICr1II28aQflF6xKkeZy5U9u5mkpvQYuXuaIKQ2oroFwh4sRegKe4AHkhj72UHZkGi0Du7v6eiSROkZVnhkJjy4qTPNwB6ATonDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683529; c=relaxed/simple;
	bh=0XY5YJJ+h1OwzGpEjvOx6dmUrRCOSsjl0wuwFiAhovg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpA/CiUMcvoiGSxzLaaFkOhUNVQuxGztoCcDRE/tXPAxwitKBOplYYmsJtaiOM4TfW5NwRJPpKiZcKJiGC2SpKXVDmixJDMOI/c1EfeUtDVGnKjrdXazUmfIYxGicmJJfSv8Y4TdddiewYtXELfWZd/X+tmWevq9Ld5+AzPOTDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0LwIQOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0LwIQOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC44C2BD10;
	Thu,  6 Jun 2024 14:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683529;
	bh=0XY5YJJ+h1OwzGpEjvOx6dmUrRCOSsjl0wuwFiAhovg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0LwIQOKUPV8s2+sjrK5SZwUVrx8PUvRfSQkQwk0psIr6GAuICWr573exA4PkJzWa
	 BG4XjBUGPpL0fc1cHGexFNXhSegFWxSCt1buGP/3sBuWBNGWc6+uqKtj2A/vDdoL8n
	 sFSISkx7Gjkj1b44Mfc+VYAtR6D56MSxF0GJkYI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 407/473] NFSv4: Fixup smatch warning for ambiguous return
Date: Thu,  6 Jun 2024 16:05:36 +0200
Message-ID: <20240606131713.260150440@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 37ffe06537af3e3ec212e7cbe941046fce0a822f ]

Dan Carpenter reports smatch warning for nfs4_try_migration() when a memory
allocation failure results in a zero return value.  In this case, a
transient allocation failure error will likely be retried the next time the
server responds with NFS4ERR_MOVED.

We can fixup the smatch warning with a small refactor: attempt all three
allocations before testing and returning on a failure.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: c3ed222745d9 ("NFSv4: Fix free of uninitialized nfs4_label on referral lookup.")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 457b2b2f804ab..2b19ddc2c39ad 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2113,6 +2113,7 @@ static int nfs4_try_migration(struct nfs_server *server, const struct cred *cred
 {
 	struct nfs_client *clp = server->nfs_client;
 	struct nfs4_fs_locations *locations = NULL;
+	struct nfs_fattr *fattr;
 	struct inode *inode;
 	struct page *page;
 	int status, result;
@@ -2122,19 +2123,16 @@ static int nfs4_try_migration(struct nfs_server *server, const struct cred *cred
 			(unsigned long long)server->fsid.minor,
 			clp->cl_hostname);
 
-	result = 0;
 	page = alloc_page(GFP_KERNEL);
 	locations = kmalloc(sizeof(struct nfs4_fs_locations), GFP_KERNEL);
-	if (page == NULL || locations == NULL) {
-		dprintk("<-- %s: no memory\n", __func__);
-		goto out;
-	}
-	locations->fattr = nfs_alloc_fattr();
-	if (locations->fattr == NULL) {
+	fattr = nfs_alloc_fattr();
+	if (page == NULL || locations == NULL || fattr == NULL) {
 		dprintk("<-- %s: no memory\n", __func__);
+		result = 0;
 		goto out;
 	}
 
+	locations->fattr = fattr;
 	inode = d_inode(server->super->s_root);
 	result = nfs4_proc_get_locations(server, NFS_FH(inode), locations,
 					 page, cred);
-- 
2.43.0



