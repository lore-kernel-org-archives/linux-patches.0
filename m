Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E992F35B130;
	Fri,  9 Jan 2026 12:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961939; cv=none; b=CuEVnD/x6t0pxhAk5n+JV3ZtqeI8b8DLDohBlkeWZrdohC9NZRNw6S96nfmernr+RhvUV8O+VEVCTIHzWzEtOZjR9Xcdh5nl9Iw9cHN+xcWOib64y4k1AEW429NcWBkOx98f7StqN9nMz/MDSG/0BN44OAU/W1zdq8U57ijybQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961939; c=relaxed/simple;
	bh=SidY7b74nIHjR4VtRvErsXN/Ayy7icV3AFZQD4ZlFQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mO/38BgEuXP1TUMfyWr4jtXaI8guNCW1cDpbBSBpss/1/jlx9S5qM95bQi4RkmAJatVqEYlmBtK87hqKWqw2MLFk7WGwM4tYT0Vx5eqRv8ZoAXPGLSLJmBHx5v0NB3FhomUtRRdDFKHfOIDy+Opq3SoHo7pm5YrsxQRdSA6Ju/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQqEQY1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQqEQY1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F33C16AAE;
	Fri,  9 Jan 2026 12:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961938;
	bh=SidY7b74nIHjR4VtRvErsXN/Ayy7icV3AFZQD4ZlFQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQqEQY1vtAzzHhNhhbM7PuJ0FVVgjvXPOGv8l0tpxb7ap64d0W7WAJSw4v26up8vC
	 /IAF2RC5zd932RzmKBycKEAiaZMoCq4VWLMEKMb3Q0va20gm6kEUnBB9eLxx8NMw9u
	 cgnJSob+NcEhSTnQeGzDQ63XBdjk5Lh5OBNPj9xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Stoler <michael.stoler@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/634] NFS: Initialise verifiers for visible dentries in readdir and lookup
Date: Fri,  9 Jan 2026 12:37:47 +0100
Message-ID: <20260109112124.550780322@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b54c92d8e2730..c395b3ccaf6ec 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -788,16 +788,17 @@ void nfs_prime_dcache(struct dentry *parent, struct nfs_entry *entry,
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
@@ -1990,13 +1991,14 @@ struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, unsigned in
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



