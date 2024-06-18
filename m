Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923E7158A16;
	Tue, 18 Jun 2024 13:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716730; cv=none; b=ZzdZpON/mYturr3Ti6jsAWhM5kb8sX722zIyOqNxqDs0Rofe+Rz6kYDP01+Jf5mU91SU9mXvMmcsTA05nbU3dmdPbsBIN7RMGhWr5A6VhwdcDmb7KlRr+05wCDqgLjt90DO5Z0Yo/0eV1IJGIsoXlKAa3F6mEiD60WNUlO+6BW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716730; c=relaxed/simple;
	bh=h65DK0Uc3eyLFixy/ONenMTG0+pyAnH+g6flTWsp9D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fo+RY4TEzNfyUIdzUaBnknVwYDxonIT1nYpm0ZedMqt6t61m/TiKFRuYR12aTWI22/P9Iq787kTdscjBugQWsiFploMfhQOHuWeR9xV6sNQzcU73/17keWmsWkuvvplFfFSW0SIA3e6CdU2PiIgRv90sQR5Akp+97gRfLPfwF8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sh6ia8pV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sh6ia8pV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D36C3277B;
	Tue, 18 Jun 2024 13:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716730;
	bh=h65DK0Uc3eyLFixy/ONenMTG0+pyAnH+g6flTWsp9D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sh6ia8pVnlq4LekjwN5Qh1j6rffw7FDK/FgTg16ZOyPpWl27AzTAErRX6XqISvfvB
	 9P3PSdUcF6BpTyRpIVSaJyPXCKvRcFi9oNGDlYn4sK8cjZvTP9WzuYrT/oepL2G/Cs
	 IEOcGgGEAsMP1x4eacz9Ot48fBJeDx//lh0jTRAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <yieli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 743/770] nfsd: call op_release, even when op_func returns an error
Date: Tue, 18 Jun 2024 14:39:56 +0200
Message-ID: <20240618123435.948031915@linuxfoundation.org>
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
 fs/nfsd/nfs4xdr.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index e1f2f26ba93f2..d62382dfc135e 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5397,10 +5397,8 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
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
 
@@ -5415,8 +5413,6 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
 	op->status = encoder(resp, op->status, &op->u);
 	if (op->status)
 		trace_nfsd_compound_encode_err(rqstp, op->opnum, op->status);
-	if (opdesc && opdesc->op_release)
-		opdesc->op_release(&op->u);
 	xdr_commit_encode(xdr);
 
 	/* nfsd4_check_resp_size guarantees enough room for error status */
@@ -5457,6 +5453,9 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
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



