Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792787D074;
	Mon,  8 Apr 2024 13:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583523; cv=none; b=UvScgoyt8ODlH4zB9Hk1ZpD9XBQ95vgQgCg0vBQE7IBWz9Gh5WgZM+vWQwvO28MSPc18IYF+nZQH7PufdilBickFBZk7BHwFachusMnqGen69N9uvDKVSOUNL8MF5Shh3uV+MBUkhs60+w5HwOjwvYbdKxxIsQy9jGUgYRRogiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583523; c=relaxed/simple;
	bh=HjnMS+nk7a/XLqIsgMgYXJo25fEuCzyLMofd8jOoaHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gh2h2NxyWKN4tHHzbTJTnRjCAVvBH2Su0DMJkwP+SHWXd7JENoGNMEO4/G5ZcLy4lqdx2j3G+Y+c8ZZWgrDT3alpRh8PU8v4GUt3x00qHIXZt2/BN43GsU0XbDdxEETqUvaod8CJZ1Ixs2L6HvkLMKu3gdfrFTCrt4I4Xs85H84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqtK+YNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqtK+YNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F64C433F1;
	Mon,  8 Apr 2024 13:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583523;
	bh=HjnMS+nk7a/XLqIsgMgYXJo25fEuCzyLMofd8jOoaHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqtK+YNYVJPudYUFsVXhA4wqVJ5z3tG540xrXP/6kuN1qIeIixzHhHNPOKg6dPtJM
	 c+Q6QXt70phpcSsW2D17Fi07Pxx8hGgImbFDPDIOr2gf0be/g/PIQN2yewrSMEyzsB
	 q3CSq+AfRjevjqLsK5QP3az7fXBn+0iAIUynQW3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jeff.layton@primarydata.com>,
	Lance Shelton <lance.shelton@hammerspace.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 256/690] nfsd: Retry once in nfsd_open on an -EOPENSTALE return
Date: Mon,  8 Apr 2024 14:52:02 +0200
Message-ID: <20240408125408.887864948@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/nfsd/nfsproc.c |  1 +
 fs/nfsd/vfs.c     | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 406dc50fea7ba..f65eba938a57d 100644
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
index 925aa08ca1075..bc025fe5a595b 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -791,6 +791,7 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
 		int may_flags, struct file **filp)
 {
 	__be32 err;
+	bool retried = false;
 
 	validate_process_creds();
 	/*
@@ -806,9 +807,16 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
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



