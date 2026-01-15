Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F373AEF27;
	Thu, 15 Jan 2026 17:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499144; cv=none; b=QxZwE0McNg3/lpYfXqeYuRWLWoMy7pNkFztLLCD53wX22DjHL7Iicgd3Ec+M+aAo9WcC1I3tmezkg9WpgZBxlCJR/qf/Tp4WYJsyvJSeRecxFVYVF1072bQi5mSgDqp5aAblbrvokibtURDfp9cL6rR/Y5ev/zkBCIO1ZFB9zjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499144; c=relaxed/simple;
	bh=4FzbSd/Z/PghwYDuVAd3W8M/TlhCi35xQ0TUaH5A2U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWNcaXOiPDpHCqq1Vt+reQ+2acWaDejX+K30AE03DGE7VYTyRElwjDrQ4zcPpfRsKKGXDEotNkCYABW1fKav43XAfa/OiITEgD4nTBMksDt7B46qHf3psDhbY6vteuPsj17wwqrZzWbrccFiEnXWqu8lUbR4JpEH1Lf1em00H0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcVLEhcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcVLEhcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82318C116D0;
	Thu, 15 Jan 2026 17:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499143;
	bh=4FzbSd/Z/PghwYDuVAd3W8M/TlhCi35xQ0TUaH5A2U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcVLEhcn9SUDrqwjkWO4jf97+dxofCiXyebn4YI4z99KV8Wb6qSxG8fZ/IQ3e3Iw8
	 v5ERCfGsESrxYLd+uiG8aM7x39tNK132uwObiGfRVXEdIqyDp5GpnKfvVw5pDYPW0A
	 HdrKk4wKrLX0+D83kVsmPN3S42DalqEFpN+K35l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/451] NFS: Label the dentry with a verifier in nfs_rmdir() and nfs_unlink()
Date: Thu, 15 Jan 2026 17:45:23 +0100
Message-ID: <20260115164235.336895912@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 62a614f4a64b5..442e9835d5a3f 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1995,6 +1995,18 @@ static void nfs_dentry_handle_enoent(struct dentry *dentry)
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
@@ -2017,6 +2029,7 @@ int nfs_rmdir(struct inode *dir, struct dentry *dentry)
 		up_write(&NFS_I(d_inode(dentry))->rmdir_sem);
 	} else
 		error = NFS_PROTO(dir)->rmdir(dir, &dentry->d_name);
+	nfs_dentry_remove_handle_error(dir, dentry, error);
 	trace_nfs_rmdir_exit(dir, dentry, error);
 
 	return error;
@@ -2086,9 +2099,8 @@ int nfs_unlink(struct inode *dir, struct dentry *dentry)
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



