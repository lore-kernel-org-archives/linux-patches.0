Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713BE19DF52;
	Tue, 18 Jun 2024 13:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715950; cv=none; b=EqG57Iiz/b75erP0eCi+AKj2rtRchDWl65SBm0vJWiVa7ZHEutF0aBSPAjwTaaiIauFOOS/9hP51WK4NaJNd5gqKA4HGIAQs6WXYqe2rrLtsVwn98ZLqvJREsdnXQBnxrz6YvOx/N6cuJijZ39sQh2j7Uw1L1W4qgClYNRDF/qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715950; c=relaxed/simple;
	bh=k7QjfjZ2Byt+0IcFixTMENAtapbvkms0fO89+0eFObA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjfX4FlIy3ELQxO3wWDk4FNIHs9xDtif85Whl822i8DcXzufBUSGmllNP4FNmpuo1jUvl7VOnJFsJbmq/WBKNinNykcAEmeSnxJjEPp8GPQJswjCejI3EiHfzXZpB2JJ1ZdYGwxQ7ucxBD1bdxyqT0uqOrUztunnnm2DMB7OP3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgDoYtuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgDoYtuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48CEC4AF1D;
	Tue, 18 Jun 2024 13:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715950;
	bh=k7QjfjZ2Byt+0IcFixTMENAtapbvkms0fO89+0eFObA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgDoYtuXvvipPuLNUhDFIgDbECYYsKvjfD7Zr3ARjasZZnAho1YFIlLAHbjZqhD1G
	 Le9rKN10f7ooybtZ+RSJ0ZWLvkZMLSLvJ0IRQ/Dpd5r1FgzFc3uGvTqBca/+45SL21
	 Ali16HI41oOj3QoGMc52Fp/clki9B3nQBVWV2d5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jeff.layton@primarydata.com>,
	Lance Shelton <lance.shelton@hammerspace.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 450/770] nfsd: Retry once in nfsd_open on an -EOPENSTALE return
Date: Tue, 18 Jun 2024 14:35:03 +0200
Message-ID: <20240618123424.661514331@linuxfoundation.org>
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

From: Jeff Layton <jeff.layton@primarydata.com>

[ Upstream commit 12bcbd40fd931472c7fc9cf3bfe66799ece93ed8 ]

If we get back -EOPENSTALE from an NFSv4 open, then we either got some
unhandled error or the inode we got back was not the same as the one
associated with the dentry.

We really have no recourse in that situation other than to retry the
open, and if it fails to just return nfserr_stale back to the client.

Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
Signed-off-by: Lance Shelton <lance.shelton@hammerspace.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c |  1 +
 fs/nfsd/vfs.c     | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 6ed13754290a2..b8ddf21e70ea0 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -875,6 +875,7 @@ nfserrno (int errno)
 		{ nfserr_serverfault, -ESERVERFAULT },
 		{ nfserr_serverfault, -ENFILE },
 		{ nfserr_io, -EREMOTEIO },
+		{ nfserr_stale, -EOPENSTALE },
 		{ nfserr_io, -EUCLEAN },
 		{ nfserr_perm, -ENOKEY },
 		{ nfserr_no_grace, -ENOGRACE},
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index deaf4a50550d5..b343677b01efa 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -805,6 +805,7 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
 		int may_flags, struct file **filp)
 {
 	__be32 err;
+	bool retried = false;
 
 	validate_process_creds();
 	/*
@@ -820,9 +821,16 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
 	 */
 	if (type == S_IFREG)
 		may_flags |= NFSD_MAY_OWNER_OVERRIDE;
+retry:
 	err = fh_verify(rqstp, fhp, type, may_flags);
-	if (!err)
+	if (!err) {
 		err = __nfsd_open(rqstp, fhp, type, may_flags, filp);
+		if (err == nfserr_stale && !retried) {
+			retried = true;
+			fh_put(fhp);
+			goto retry;
+		}
+	}
 	validate_process_creds();
 	return err;
 }
-- 
2.43.0



