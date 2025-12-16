Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0487A3590BB;
	Tue, 16 Dec 2025 12:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888466; cv=none; b=VrS4QSdSskJZZdDeb22JB9igoiB9cI//uw9eYxk0tamJ3y5VPOwKgSYnfiE7UHHU7DY3w/R7QpFEodOfj3THNq0Uwj9HEeTSHhNvBu4P4rKrCOa2wFfBBYf650cVv9fjobQJHASQjvrvwuxIgGc/LGLqyFa0PmbGDk3Ctxhkjrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888466; c=relaxed/simple;
	bh=pZIVsb4o6MKZhBLGp9Pm0xBNdwvK2jCMJJ/1lQMO1sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQ4vNfI2OOl3LjzWe01QGEVxMcO4FD+QkhPce8N2WrZ3G9fho6a/zc1EYNN9UhHyFTkoJKxoq+Cz6NIZl0VA7iIUpYKvTInxlp3VqKW0Asj2dNyKzKoLetZPJ4RdjRfD8TGy5KSFGwBGSpmV1dxHlDPZ4BGuWMhEeOd3KSgd4u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxoPhcnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxoPhcnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4845DC16AAE;
	Tue, 16 Dec 2025 12:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888465;
	bh=pZIVsb4o6MKZhBLGp9Pm0xBNdwvK2jCMJJ/1lQMO1sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxoPhcnBIlrscKaGvYnizHCVXkmy1pBm7mIXB9JixbpaJuDQxV47PLg3eZO4VASJ8
	 9R55Bbe9/qh+mtowstYYd7OSaTz77THN3q0JBHid01/x71/cet12SuOQx70TSqYcDg
	 bukPEf3PZu3bOIszmQ5DTNhReNC5vINservCCIVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Stoler <michael.stoler@vastdata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 543/614] NFS: Initialise verifiers for visible dentries in nfs_atomic_open()
Date: Tue, 16 Dec 2025 12:15:10 +0100
Message-ID: <20251216111421.053338669@linuxfoundation.org>
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
index 2eead7e85be5b..3b8250ee01412 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2144,12 +2144,12 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
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



