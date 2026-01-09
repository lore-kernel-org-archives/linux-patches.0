Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B1A359F99;
	Fri,  9 Jan 2026 12:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960033; cv=none; b=iwcyqt/OZ+zakeWipkg9wCS9BQY4g+c13lKYbkp4DEiBkAFrif8gliP3Uff/BtlXTk6kPhNCyNIj67p20vqwor3TUGlf5HNFY8yMo3C+RozAARr5cZgr8EwjTuIBYmUVvF4ErSKZJJ1yz2PkJe1kCqCtuTg+ile4I7pj746KOCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960033; c=relaxed/simple;
	bh=YGiFDbTuK43Q7J8skr1lbpjz5ZJkJJprz1ddJq6SN2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3yuEpRLlAyZwT4fEIummulMINvvKGS1ojdySqepZCU+hdAZhJkjqm8p04tNrbxqmJKZ6oxLSxX5WtGNQUcHrasXIhZaWfOjmOidM3dspgP9oRPh2lt/zQtiq0dCQb6mFbu5c2yZx7AtPcxiJ+fJnCNy89IFnFHr4b0S99AmkQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDpRDTkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDpRDTkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34FAC4CEF1;
	Fri,  9 Jan 2026 12:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960033;
	bh=YGiFDbTuK43Q7J8skr1lbpjz5ZJkJJprz1ddJq6SN2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDpRDTkrWbbONdzDOPE+hpIEhSy/kHWqtyQ1oY4RU9wfDN243SJQEfIBqUh//NQMG
	 hu4Q9GJDHKTEMRv/ot+GcrvSCpIY9ezAGEXsYrK87eoAWdItLdZvyNSDFXRLmxqOkA
	 WClNcpZgb2W72czOWJNjblX7ym/GbiG8BlGwb/CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Stoler <michael.stoler@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/737] NFS: Initialise verifiers for visible dentries in nfs_atomic_open()
Date: Fri,  9 Jan 2026 12:36:41 +0100
Message-ID: <20260109112143.847472346@linuxfoundation.org>
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
index d47e908ef411c..32e922a20d0d4 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2149,12 +2149,12 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
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



