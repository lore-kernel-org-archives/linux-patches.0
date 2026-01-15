Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461082C027B;
	Thu, 15 Jan 2026 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497739; cv=none; b=IMWOwcpjhPkTUSrKzykdX0sDn2erT2/oxGjOUrYxIZPcihxZfGKT1VxzB02He4RWGIJiRak3pYjCCUG8N/606o9clUvs1TzDJrLYcQP/1oK1wATtqCymvtcvCMziCcym2ax1hZCgwywqwZzTPCktg9cJpnb1vCJG4xG98PMTri0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497739; c=relaxed/simple;
	bh=JNO6g6eT+QP+2Cq1ExekdTxpeTUFe5/yw+fV7XS6/eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gU7Yu1y1m7pVzFQRJw8fbWGGDFU0cDzFno/vPtD8H6NGWs5QHTDuiDX8Uuo2EcuhhSLZBSVc0NOBxLhZ3H/fdH573LEnZSExISS4bRu76Z7phZPrSy6+QmRn4PuK+K/B24At4/gQ50FJZ08hX50tszJoPo7ovvCdZTOqDBMa5Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHKgBi4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHKgBi4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C680AC116D0;
	Thu, 15 Jan 2026 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497739;
	bh=JNO6g6eT+QP+2Cq1ExekdTxpeTUFe5/yw+fV7XS6/eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHKgBi4z3bfxuF1IvUnv+1LXyRizA7rgAm+FQRzxbysjssRwYX7a3S/k/72KdFPtv
	 tRaftH0NQQL9Bb5U5QQlOzRO/RysIGuPR8hxGY1umYpEHlq3jNeialVp9yRqr8k0Z5
	 V//vJv3EmvXq8arvMTC8H76ROWJDcBc4lw7vn4Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 169/554] NFS: Label the dentry with a verifier in nfs_rmdir() and nfs_unlink()
Date: Thu, 15 Jan 2026 17:43:55 +0100
Message-ID: <20260115164252.384480774@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 9019fb391de02cbff422090768b73afe9f6174df ]

After the success of an operation such as rmdir() or unlink(), we expect
to add the dentry back to the dcache as an ordinary negative dentry.
However in NFS, unless it is labelled with the appropriate verifier for
the parent directory state, then nfs_lookup_revalidate will end up
discarding that dentry and forcing a new lookup.

The fix is to ensure that we relabel the dentry appropriately on
success.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: bd4928ec799b ("NFS: Avoid changing nlink when file removes and attribute updates race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 32c3d0c454b19..9dceb6cb10417 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2212,6 +2212,18 @@ static void nfs_dentry_handle_enoent(struct dentry *dentry)
 		d_delete(dentry);
 }
 
+static void nfs_dentry_remove_handle_error(struct inode *dir,
+					   struct dentry *dentry, int error)
+{
+	switch (error) {
+	case -ENOENT:
+		d_delete(dentry);
+		fallthrough;
+	case 0:
+		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
+	}
+}
+
 int nfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int error;
@@ -2234,6 +2246,7 @@ int nfs_rmdir(struct inode *dir, struct dentry *dentry)
 		up_write(&NFS_I(d_inode(dentry))->rmdir_sem);
 	} else
 		error = NFS_PROTO(dir)->rmdir(dir, &dentry->d_name);
+	nfs_dentry_remove_handle_error(dir, dentry, error);
 	trace_nfs_rmdir_exit(dir, dentry, error);
 
 	return error;
@@ -2303,9 +2316,8 @@ int nfs_unlink(struct inode *dir, struct dentry *dentry)
 	}
 	spin_unlock(&dentry->d_lock);
 	error = nfs_safe_remove(dentry);
-	if (!error || error == -ENOENT) {
-		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
-	} else if (need_rehash)
+	nfs_dentry_remove_handle_error(dir, dentry, error);
+	if (need_rehash)
 		d_rehash(dentry);
 out:
 	trace_nfs_unlink_exit(dir, dentry, error);
-- 
2.51.0



