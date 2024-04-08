Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCCA79F0;
	Mon,  8 Apr 2024 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584700; cv=none; b=IS8nAi3IS9AV7glAZfGTed1UQdFPbQu/xV3cxcBzBMqRtgxAmHe3FiA6cOKvby9Xge1IWb5t1AOH3faF5wteWPfSlCsSIkvyUZoXu0Ovtu6F7T3tT/40Wqs19pXJPYTm51rmr6RQDSTYCMk+IVi/TffZzVIP1YipAfcu1mK78Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584700; c=relaxed/simple;
	bh=KjbviYmJ2nc6t7MbxU31MzGMbqKDGHgMmTCiDcIv8xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NC8/dLoOGz8wgcr9gVdDJc5qKWac23VD9I8BdEwoJm2vE7mu2p0RG2x/77itSN9D5Ov0ov1Mg0QGebZYIw7VKw+Q2l/H1UcFTBMcZvLge++MEmMe0G70ZH1eChmaDzvGFCEnWm0vL5CjnsCPDHfStFjkXqF4fyosdz/ckPS8AGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c40nYdjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c40nYdjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B36C433F1;
	Mon,  8 Apr 2024 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584700;
	bh=KjbviYmJ2nc6t7MbxU31MzGMbqKDGHgMmTCiDcIv8xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c40nYdjo16xQ7HkRClTyClpIvXc+fredQSPJklqdoiXGsS1lOqpyFJtSsnFfzgVxs
	 weJifm3EMswnPOIXVVogEiyQpXMMsH2u/iBBqntQEe74OIkOK7hb8tNEUVNgI1+Dbq
	 EohnYYMjkmvR5MZsHH053pdmDNKoUi1a1cZ542sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <yieli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 528/690] nfsd: call op_release, even when op_func returns an error
Date: Mon,  8 Apr 2024 14:56:34 +0200
Message-ID: <20240408125418.774399350@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 15a8b55dbb1ba154d82627547c5761cac884d810 ]

For ops with "trivial" replies, nfsd4_encode_operation will shortcut
most of the encoding work and skip to just marshalling up the status.
One of the things it skips is calling op_release. This could cause a
memory leak in the layoutget codepath if there is an error at an
inopportune time.

Have the compound processing engine always call op_release, even when
op_func sets an error in op->status. With this change, we also need
nfsd4_block_get_device_info_scsi to set the gd_device pointer to NULL
on error to avoid a double free.

Reported-by: Zhi Li <yieli@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2181403
Fixes: 34b1744c91cc ("nfsd4: define ->op_release for compound ops")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
[ cel: adjusted to apply to v5.15.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 9c9ff3bdc62a9..30c64c3f5fa05 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5398,10 +5398,8 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
 	__be32 *p;
 
 	p = xdr_reserve_space(xdr, 8);
-	if (!p) {
-		WARN_ON_ONCE(1);
-		return;
-	}
+	if (!p)
+		goto release;
 	*p++ = cpu_to_be32(op->opnum);
 	post_err_offset = xdr->buf->len;
 
@@ -5416,8 +5414,6 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
 	op->status = encoder(resp, op->status, &op->u);
 	if (op->status)
 		trace_nfsd_compound_encode_err(rqstp, op->opnum, op->status);
-	if (opdesc && opdesc->op_release)
-		opdesc->op_release(&op->u);
 	xdr_commit_encode(xdr);
 
 	/* nfsd4_check_resp_size guarantees enough room for error status */
@@ -5458,6 +5454,9 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
 	}
 status:
 	*p = op->status;
+release:
+	if (opdesc && opdesc->op_release)
+		opdesc->op_release(&op->u);
 }
 
 /* 
-- 
2.43.0



