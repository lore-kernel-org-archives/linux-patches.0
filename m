Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAF31A38E7;
	Tue, 18 Jun 2024 13:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716435; cv=none; b=bc3rV8+DQLAoOgFR5LWMW+rYnw3teVrPIVrkDG7Smazxn9bSwXmKsKZme7xs6vyP6l2NV/wsS8NQhe9+vfFxhRPKxSKhNMeBoqi7XFnLcl5GPbBSGjd2lXParWWuS/gwjxH/fX/oSCCsSuSXjJQL/4ad6CNQiTlwZSDrqvcU9cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716435; c=relaxed/simple;
	bh=7JF2YWxkyNEn7AkZCLzzzeWyLWkRPHxvJT1h1nf5WgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJ9U2dEQNk7jxWlXOk0zC90hTYEXzREL+55KrJgh67GJAyBlBnKwLYxGxsjEoyP9D6M3xJhD4eNze9pKdeIJsx3FtS0HZUytPvcD1GTqc/kVWsKnk9jiMdUObkmO0mjXeDrgzAGhQircfBMdIBVluJ7nT3IdtUjyP7kd99D1da8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j90fWi7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j90fWi7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74995C3277B;
	Tue, 18 Jun 2024 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716434;
	bh=7JF2YWxkyNEn7AkZCLzzzeWyLWkRPHxvJT1h1nf5WgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j90fWi7RaglDzopC/541sOwTf3Cqc7mkAZ0ckYWBCt6kKRVIQtFBXmnN+BsHORppo
	 WNdMEB0R9LlOFkDlyx0zZNY2gKoYQmG6rMKV7Rs9IVTCzcbcYwF7wMY8yUeCWMmJlC
	 oYzOnfnEAa6xxg2LLr7OkTgylhSKj+L+B+D+Yhi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Mammedov <imammedo@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 644/770] NFSD: Make nfsd4_setattr() wait before returning NFS4ERR_DELAY
Date: Tue, 18 Jun 2024 14:38:17 +0200
Message-ID: <20240618123432.147484994@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 34b91dda7124fc3259e4b2ae53e0c933dedfec01 ]

nfsd_setattr() can kick off a CB_RECALL (via
notify_change() -> break_lease()) if a delegation is present. Before
returning NFS4ERR_DELAY, give the client holding that delegation a
chance to return it and then retry the nfsd_setattr() again, once.

Link: https://bugzilla.linux-nfs.org/show_bug.cgi?id=354
Tested-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index e32b0c807ea9d..dc79db261d6a2 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -426,6 +426,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	int		host_err;
 	bool		get_write_count;
 	bool		size_change = (iap->ia_valid & ATTR_SIZE);
+	int		retries;
 
 	if (iap->ia_valid & ATTR_SIZE) {
 		accmode |= NFSD_MAY_WRITE|NFSD_MAY_OWNER_OVERRIDE;
@@ -480,7 +481,13 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	}
 
 	inode_lock(inode);
-	host_err = __nfsd_setattr(dentry, iap);
+	for (retries = 1;;) {
+		host_err = __nfsd_setattr(dentry, iap);
+		if (host_err != -EAGAIN || !retries--)
+			break;
+		if (!nfsd_wait_for_delegreturn(rqstp, inode))
+			break;
+	}
 	if (attr->na_seclabel && attr->na_seclabel->len)
 		attr->na_labelerr = security_inode_setsecctx(dentry,
 			attr->na_seclabel->data, attr->na_seclabel->len);
-- 
2.43.0



