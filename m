Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719751552FD;
	Tue, 18 Jun 2024 12:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715381; cv=none; b=GXLU1eVJs3U//CiR3lOsUTKWumdVb5nStYy7oJxaxeAdRf9lL8mr3zZ4xF3aUe2xq6LQFKgrdoQGaKqvqC2bBoBJWXGb4bAr7qlgK99QWCGmc7lyjL4W3cwqB+B4L3FqoaUBrrywBeYp8EfxP1X5OTrUKD2woxKjwb9T6NW+A2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715381; c=relaxed/simple;
	bh=X7SFC4bNB6CgvgFqCatX5S8ZIW3xXsg/qFQdvdhzu3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxr7yy5J0kU6h5VzFztPvj5ByoMsNTqYHsnsdC84QGCM8UY1qZ1OihhsyMjpZZ9QVHlOsnxJoDyRdhRq6KRID45qS2ExMvToem0YRyQjtqU4HULCEV/kbIeEmwMtMcXykvP3beUZeNg14izE9fdDZykZggZimZdgIj2ed6fEe1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWdrgKVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWdrgKVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E943FC3277B;
	Tue, 18 Jun 2024 12:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715381;
	bh=X7SFC4bNB6CgvgFqCatX5S8ZIW3xXsg/qFQdvdhzu3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWdrgKVOfVxWdRQxFReX7KZnaBUdqbtLWXNUL1h1gAd5wrSsB2rpvhd2Cs2K+i8e9
	 Wjf2Fw23G+QY07gb/rFZqSWMhBv8xIm+CyjtM0BpIPMvLlEGnj9NmbqmkrVc14erk2
	 mw5d3HEtH47Wy7touDu9oy5aO+TAjB6GdHIa89mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Hsiang Huang <nickhuang@synology.com>,
	Bing Jing Chang <bingjingc@synology.com>,
	Robbie Ko <robbieko@synology.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 290/770] nfsd: Prevent truncation of an unlinked inode from blocking access to its directory
Date: Tue, 18 Jun 2024 14:32:23 +0200
Message-ID: <20240618123418.455619651@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Hsiang Huang <nickhuang@synology.com>

[ Upstream commit e5d74a2d0ee67ae00edad43c3d7811016e4d2e21 ]

Truncation of an unlinked inode may take a long time for I/O waiting, and
it doesn't have to prevent access to the directory. Thus, let truncation
occur outside the directory's mutex, just like do_unlinkat() does.

Signed-off-by: Yu Hsiang Huang <nickhuang@synology.com>
Signed-off-by: Bing Jing Chang <bingjingc@synology.com>
Signed-off-by: Robbie Ko <robbieko@synology.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 520e55c35e742..2eb3bfbc8a35f 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1870,6 +1870,7 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 {
 	struct dentry	*dentry, *rdentry;
 	struct inode	*dirp;
+	struct inode	*rinode;
 	__be32		err;
 	int		host_err;
 
@@ -1898,6 +1899,8 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 		host_err = -ENOENT;
 		goto out_drop_write;
 	}
+	rinode = d_inode(rdentry);
+	ihold(rinode);
 
 	if (!type)
 		type = d_inode(rdentry)->i_mode & S_IFMT;
@@ -1913,6 +1916,8 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 	if (!host_err)
 		host_err = commit_metadata(fhp);
 	dput(rdentry);
+	fh_unlock(fhp);
+	iput(rinode);    /* truncate the inode here */
 
 out_drop_write:
 	fh_drop_write(fhp);
-- 
2.43.0



