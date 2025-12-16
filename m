Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD59350D62;
	Tue, 16 Dec 2025 12:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888462; cv=none; b=QPlW2XV9wKTNlzz6VAIippHPKARUKRdIvQYmA20cVvWjY/AIX1P/5k/y23GQuyK1v78ph4IMAEOncJ1Ka2mMr3Jsg/0NTw96Tepcbu2096RivEjolxPEf5PBe1r/TjgVrGqLR3vvi1X0wSuqTE3w6Jufo/2mBS2aSQ8uCbJRVhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888462; c=relaxed/simple;
	bh=0OEH73+eVlBW6WnBpzCcRodTGCL5+NvhQzFvhJ8p6rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cy67j8R/eHvIiy/rBTacDdW/EIGFcgTowvQO66pXXuGwpbuUrThhnI1/SEjZvAp2poQ7f0w+jNRtUElgbI6Zvq1u5XY9F7PA4klzI7vTnRNu67hz55Id2Lx5A+o9D8eEi7/6R/0DnKuFtzCKFFOoFtm2K0XmELFWdzp/8akLGRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reQb7ZuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reQb7ZuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A32C16AAE;
	Tue, 16 Dec 2025 12:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888462;
	bh=0OEH73+eVlBW6WnBpzCcRodTGCL5+NvhQzFvhJ8p6rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=reQb7ZuJTNXmWTrPCl8EOVC1XlS4Fd2BOjKYeXhxCbH20PIm820xjq5p68wV/8q6y
	 7Bvb9eji5kZJac5ftjUIX25v/t//D3qtduXKbnipJ0qSVJY7F0k+Sf1GRmofTAFdzn
	 j8oHQ6Dp+MCOn9L+Usp6zu4Z63ygc4b6V/KjsYCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Stoler <michael.stoler@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 542/614] NFS: Initialise verifiers for visible dentries in readdir and lookup
Date: Tue, 16 Dec 2025 12:15:09 +0100
Message-ID: <20251216111421.017091365@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 9bd545539b233725a3416801f7c374bff0327d6e ]

Ensure that the verifiers are initialised before calling
d_splice_alias() in both nfs_prime_dcache() and nfs_lookup().

Reported-by: Michael Stoler <michael.stoler@vastdata.com>
Fixes: a1147b8281bd ("NFS: Fix up directory verifier races")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index d557b0443e8b0..2eead7e85be5b 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -789,16 +789,17 @@ void nfs_prime_dcache(struct dentry *parent, struct nfs_entry *entry,
 		goto out;
 	}
 
+	nfs_set_verifier(dentry, dir_verifier);
 	inode = nfs_fhget(dentry->d_sb, entry->fh, entry->fattr);
 	alias = d_splice_alias(inode, dentry);
 	d_lookup_done(dentry);
 	if (alias) {
 		if (IS_ERR(alias))
 			goto out;
+		nfs_set_verifier(alias, dir_verifier);
 		dput(dentry);
 		dentry = alias;
 	}
-	nfs_set_verifier(dentry, dir_verifier);
 	trace_nfs_readdir_lookup(d_inode(parent), dentry, 0);
 out:
 	dput(dentry);
@@ -1994,13 +1995,14 @@ struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, unsigned in
 	nfs_lookup_advise_force_readdirplus(dir, flags);
 
 no_entry:
+	nfs_set_verifier(dentry, dir_verifier);
 	res = d_splice_alias(inode, dentry);
 	if (res != NULL) {
 		if (IS_ERR(res))
 			goto out;
+		nfs_set_verifier(res, dir_verifier);
 		dentry = res;
 	}
-	nfs_set_verifier(dentry, dir_verifier);
 out:
 	trace_nfs_lookup_exit(dir, dentry, flags, PTR_ERR_OR_ZERO(res));
 	nfs_free_fattr(fattr);
-- 
2.51.0



