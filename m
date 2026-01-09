Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE56359FB0;
	Fri,  9 Jan 2026 12:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960030; cv=none; b=NshhyVH9QUTBGzXhV9GIUeD3uc+MDCJ9VuR1CYnNyCsrbMNfGxbcPHykWjFeotzPdyawl0k332b+kWkICp2bY030tv0ZpuaAOSERedNeFl4xCITChwd6Ai3NgMWALaoOW5ANF/rAlOXJc+uqkMze57oeKgmbG3RRCnpk7LWevU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960030; c=relaxed/simple;
	bh=MjOysWjLDU90px2RXgaWmOa6t4UXvpbna87BpWlIOXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qiq4B7QsPlkBqfOFpdL6kghIdtffB2XsBa/QXvaFDJFVhyIkci0UFj6FmTXQo4nHmBEKfUhabwqI6HF49nfqwxII8jEwcPH9dpEoGQKMYDRNUOOxPZyf9aUbzUjJssCcVh1g26H7clnp5wWnKOg9tXlTBDWv8ecokLigiLKdMAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17P5pIXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17P5pIXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBFEC4CEF1;
	Fri,  9 Jan 2026 12:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960030;
	bh=MjOysWjLDU90px2RXgaWmOa6t4UXvpbna87BpWlIOXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17P5pIXGXFSeVf0Wq0cN6+poO43NCJj/1wAo1n+utDGtJrObA1s7+cbo9A7lnyFy5
	 uZLwFq1pb1U81+sdgr/rKyybr5mu9hUFCzv21UeqodvsTo/z7CQSaLYZ2ixPv5xqV/
	 cJ32MO0mK1Pgei1U9pNsDYgxg7GwBmTGvuG2zMiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Stoler <michael.stoler@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 261/737] NFS: Initialise verifiers for visible dentries in readdir and lookup
Date: Fri,  9 Jan 2026 12:36:40 +0100
Message-ID: <20260109112143.810056808@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 70f55df9e4f95..d47e908ef411c 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -785,16 +785,17 @@ void nfs_prime_dcache(struct dentry *parent, struct nfs_entry *entry,
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
@@ -2000,13 +2001,14 @@ struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, unsigned in
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



