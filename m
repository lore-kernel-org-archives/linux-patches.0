Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B514C81;
	Thu, 15 Jan 2026 17:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497801; cv=none; b=f42fzqI9GMwIHW68PJG2u8ucnS3skBJKimDOft1UQ2oxiiP9DdU2a0OtOAARH4u5xrIHxINzrl6a/gUF/LhAK3VGSBuAWW6s7vjndV85GpNTQB2UgePUm4s1/SV+5FVsp+fJ4Su8jxiUVzozYgLZsmWB+JGs1Kvl7PzhqqyRU/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497801; c=relaxed/simple;
	bh=eeiPP0uPgP30kbfHQYwFgovCOZW1yy7H1vBKal8/hDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3RO+69xi/LJVeTx3CA16qZ4WzdgsiSyh7IfRDu9YIFGYQnWWi0gOU9Jd70GHwxAZkhWVvoKuGs7KtUAlAqzpK0sOsdr1By7fZrtbOPZ3K8E1GWN/Nkah7/L56fgx2Rgdxz57hVc6KrU65SzTJzamskcPB8bXqLtDNrHIKKSXv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSWiqiWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSWiqiWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02561C116D0;
	Thu, 15 Jan 2026 17:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497801;
	bh=eeiPP0uPgP30kbfHQYwFgovCOZW1yy7H1vBKal8/hDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSWiqiWQkuaz0wHLqJIf0l7BmdxZmAh8hWvAGikCU/ffjU6SyIgqYRZGzLwhOAr0B
	 tTaRny/4082Ru9t1POoWken6n6dNqbF0rTWiIZJet0ez7YxkAruWIbPq0un2WCU4lV
	 KwjGwocxZg3I/94EeDp0VHjb+DE4ipCQVG/ykKOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Stoler <michael.stoler@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/554] NFS: Initialise verifiers for visible dentries in nfs_atomic_open()
Date: Thu, 15 Jan 2026 17:44:01 +0100
Message-ID: <20260115164252.603390907@linuxfoundation.org>
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

[ Upstream commit 518c32a1bc4f8df1a8442ee8cdfea3e2fcff20a0 ]

Ensure that the verifiers are initialised before calling
d_splice_alias() in nfs_atomic_open().

Reported-by: Michael Stoler <michael.stoler@vastdata.com>
Fixes: 809fd143de88 ("NFSv4: Ensure nfs_atomic_open set the dentry verifier on ENOENT")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index dc0c50b97643b..6dd56841feab9 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1960,12 +1960,12 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 		d_drop(dentry);
 		switch (err) {
 		case -ENOENT:
-			d_splice_alias(NULL, dentry);
 			if (nfs_server_capable(dir, NFS_CAP_CASE_INSENSITIVE))
 				dir_verifier = inode_peek_iversion_raw(dir);
 			else
 				dir_verifier = nfs_save_change_attribute(dir);
 			nfs_set_verifier(dentry, dir_verifier);
+			d_splice_alias(NULL, dentry);
 			break;
 		case -EISDIR:
 		case -ENOTDIR:
-- 
2.51.0



