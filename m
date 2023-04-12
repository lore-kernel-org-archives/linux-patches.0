Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491822F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34AAC433EF;
	Wed, 12 Apr 2023 08:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288818;
	bh=d6SfSzroS3PhQ+bfyKRfetIkzFFtPKIlAUM3BekxO1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9qDbIu2CyDtezPDLFLPLC2ddZ3BLt4KjOxqJ1zjFIXHyw5hErSXyFQxXU1UdEWfX
	 trpACT1RVClWOBs7jqXVclXx3cMuVGy8O8OL6uip7mo95w5ABMnsQIAYY2HaS0S905
	 W0WDtsrtr8whoVKmHAK8vdciHdi67Zzugrh50Oaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <yieli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/164] nfsd: call op_release, even when op_func returns an error
Date: Wed, 12 Apr 2023 10:32:31 +0200
Message-Id: <20230412082838.162285504@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/blocklayout.c |  1 +
 fs/nfsd/nfs4xdr.c     | 11 +++++------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index b6d01d51a7465..e7e6e78d965db 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -296,6 +296,7 @@ nfsd4_block_get_device_info_scsi(struct super_block *sb,
 
 out_free_dev:
 	kfree(dev);
+	gdp->gd_device = NULL;
 	return ret;
 }
 
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 405087bda8cc1..8f5b41dc07734 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5353,10 +5353,8 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
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
 
@@ -5371,8 +5369,6 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
 	op->status = encoder(resp, op->status, &op->u);
 	if (op->status)
 		trace_nfsd_compound_encode_err(rqstp, op->opnum, op->status);
-	if (opdesc && opdesc->op_release)
-		opdesc->op_release(&op->u);
 	xdr_commit_encode(xdr);
 
 	/* nfsd4_check_resp_size guarantees enough room for error status */
@@ -5413,6 +5409,9 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
 	}
 status:
 	*p = op->status;
+release:
+	if (opdesc && opdesc->op_release)
+		opdesc->op_release(&op->u);
 }
 
 /* 
-- 
2.39.2



