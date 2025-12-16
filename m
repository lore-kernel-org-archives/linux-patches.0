Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49B4341AC3;
	Tue, 16 Dec 2025 11:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884805; cv=none; b=eYI8GvQ71dGWQheDEW0GgE3Ok+/+MztycKw5cTF+I4IOvxKAtxi5hrAZKEi/xBsVizBYzuklijCGKiHYTHrUpSUAfRirApMDRfr2mH0vXOnju+byCvKmmLqS+NCXr8tCpQUivbbC5kWW9YUw2YOaEckLuVdDqfYz/2+tc3h2cGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884805; c=relaxed/simple;
	bh=2YJObbejIoCSiH9cJlxpTzW3IZC33D6rFGZbVuPxvBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYjBdl0NLXlVeGrw7KnVpiHAlkHE9BwyUcJWj/HhaBmRu+CwosJAb5PWDGIKkYCpwRibrnHuZKQAFo0QVmAjGBZz84bDVCD2cvFiSK0RU/6a7w7k2ubCMkdcbLqYbSol/hAkX2FJ4ZQkVDkhTJLmOzOmRJDPkWCMGY6Bimu3Vq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6g3M4Bg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6g3M4Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4733DC4CEF1;
	Tue, 16 Dec 2025 11:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884805;
	bh=2YJObbejIoCSiH9cJlxpTzW3IZC33D6rFGZbVuPxvBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6g3M4BgOoRw3hSPDXrj5r0Yllfx+6oveJaSV/Otm0lBQ3lVpjJ9m3je0m0vMBtVd
	 rHCPpPPoq6kRhxaQtjZlOvO96AGHdA7f6KB2HVx6V6VKn/GpRt8KSr17kTJX0UfKxR
	 WXuP3+/ALlYAlOYAa/TOjngiQsiym/dJZP57Adqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Stoler <michael.stoler@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 304/354] NFS: Initialise verifiers for visible dentries in readdir and lookup
Date: Tue, 16 Dec 2025 12:14:31 +0100
Message-ID: <20251216111331.926746561@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 01af2bb8a7216..8c4fcd140fa13 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -787,16 +787,17 @@ void nfs_prime_dcache(struct dentry *parent, struct nfs_entry *entry,
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
@@ -2002,13 +2003,14 @@ struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, unsigned in
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



