Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AA0134AC;
	Tue, 21 Oct 2025 20:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076999; cv=none; b=Si7ay/xTNnnOk8M3W8utFY34KWTYcO9oqnA2YvK3gmQ4qyYSOGg61XM3QB8neAaAyW5k7tP8ktRnkyFtZ6hgtxzL1KugQxhiNoJ+CZ8s1cE5RkZVBWM5nodskMFQmr1xsoChB+YSyJL0ym+g7coNa5/tNNfDMWBugBtjr6Z8n7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076999; c=relaxed/simple;
	bh=Xlhs2PnIzejRrsV82/YlhjIU+bhIUPufCWK2QCL6m4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKZwCfXgKWCz3qDIwntqE0e/rosa1Ti4xyGhAhsJ2I7ANXx4uQGk5senABDmdC5Dtks8Rrzv54+ISnkfx0qPlxNR9yGcbXlUOam16qwqz3UzPuLkHhIqZ+ya4iB7EofSE42W21899gdE5Q1REeUktgtp8WDDGzEp6SVZV9ZhcwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpS7tKcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpS7tKcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57E4C4CEF1;
	Tue, 21 Oct 2025 20:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076999;
	bh=Xlhs2PnIzejRrsV82/YlhjIU+bhIUPufCWK2QCL6m4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpS7tKcD4So2i336rYZiUWXXyX4KH+SxoxM60c3CKlLOPj/0HPmbcUlXGX6a2upM4
	 Td1jN3HY8Jz3wNA3s9gU1AqS0Pk3ULKItJQn4pxYsxUF4Lh5sWCdnPyAHFOHDD9ru1
	 CqHzpoI1RpwfK7txWKBfFdomM/VEPa63B9xjOGnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/136] NFSD: Minor cleanup in layoutcommit processing
Date: Tue, 21 Oct 2025 21:51:33 +0200
Message-ID: <20251021195038.486617868@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit 274365a51d88658fb51cca637ba579034e90a799 ]

Remove dprintk in nfsd4_layoutcommit. These are not needed
in day to day usage, and the information is also available
in Wireshark when capturing NFS traffic.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: d68886bae76a ("NFSD: Fix last write offset handling in layoutcommit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2379,18 +2379,12 @@ nfsd4_layoutcommit(struct svc_rqst *rqst
 	inode = d_inode(current_fh->fh_dentry);
 
 	nfserr = nfserr_inval;
-	if (new_size <= seg->offset) {
-		dprintk("pnfsd: last write before layout segment\n");
+	if (new_size <= seg->offset)
 		goto out;
-	}
-	if (new_size > seg->offset + seg->length) {
-		dprintk("pnfsd: last write beyond layout segment\n");
+	if (new_size > seg->offset + seg->length)
 		goto out;
-	}
-	if (!lcp->lc_newoffset && new_size > i_size_read(inode)) {
-		dprintk("pnfsd: layoutcommit beyond EOF\n");
+	if (!lcp->lc_newoffset && new_size > i_size_read(inode))
 		goto out;
-	}
 
 	nfserr = nfsd4_preprocess_layout_stateid(rqstp, cstate, &lcp->lc_sid,
 						false, lcp->lc_layout_type,


