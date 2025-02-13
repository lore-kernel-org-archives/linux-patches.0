Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CFD26B0B8;
	Thu, 13 Feb 2025 15:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459920; cv=none; b=gU0g/xcAH7V5RSh9qyH/TNV42VFkHiK6IaNiS7jheBFATIdMJXtpMoQp9PGTJWSzb+G30vpMx/slhHtw+/MnC1obAGumPTvPF/4c6n42KPs5VW9qLqR0v75ZCKF7IQjAMbrtoMBRKLo6dR3fhlPjhMmBRnUXadZKgogBKvdc0so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459920; c=relaxed/simple;
	bh=mlZc8Vgg1hprTzOCW2Bh2L09SVG4BdyT+3xbpSKLSKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCRie2SnGW80ZUpi45kzwynKKv2uMYP0lswrV7P8mU1bB3FT5cTxso+H5xLVfLwx+On2MWd4HiPW5ZoR+yRMUoIKycCjY7Qhr47TABbvzcL1y4wol1o9A1ZK3kjtJCSNECfynUnD+/+NeB0xINPRm0RSpgPOoeEWTTYBT1EEJYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=syDMMwiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="syDMMwiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C60C4CED1;
	Thu, 13 Feb 2025 15:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459919;
	bh=mlZc8Vgg1hprTzOCW2Bh2L09SVG4BdyT+3xbpSKLSKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=syDMMwiII9kJ8Hys9FI0ti2aHglzdpgdWFgFL6RB1V9sSZ12DUgJ+fmuyV5Xjn5XL
	 xGr5tXiDPWzzwosbzD+umMtgxPLTuPC64x/LCliKSVwVr13T9h/FaYsNiRhRBlBcPr
	 QxkfqS/Y0ZFid2P1ALAJu/pTHNTZdUyJI/K/Zfi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	J David <j.david.lists@gmail.com>,
	Rick Macklem <rmacklem@uoguelph.ca>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.13 403/443] NFSD: Encode COMPOUND operation status on page boundaries
Date: Thu, 13 Feb 2025 15:29:28 +0100
Message-ID: <20250213142456.159403674@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit ef3675b45bcb6c17cabbbde620c6cea52ffb21ac upstream.

J. David reports an odd corruption of a READDIR reply sent to a
FreeBSD client.

xdr_reserve_space() has to do a special trick when the @nbytes value
requests more space than there is in the current page of the XDR
buffer.

In that case, xdr_reserve_space() returns a pointer to the start of
the next page, and then the next call to xdr_reserve_space() invokes
__xdr_commit_encode() to copy enough of the data item back into the
previous page to make that data item contiguous across the page
boundary.

But we need to be careful in the case where buffer space is reserved
early for a data item whose value will be inserted into the buffer
later.

One such caller, nfsd4_encode_operation(), reserves 8 bytes in the
encoding buffer for each COMPOUND operation. However, a READDIR
result can sometimes encode file names so that there are only 4
bytes left at the end of the current XDR buffer page (though plenty
of pages are left to handle the remaining encoding tasks).

If a COMPOUND operation follows the READDIR result (say, a GETATTR),
then nfsd4_encode_operation() will reserve 8 bytes for the op number
(9) and the op status (usually NFS4_OK). In this weird case,
xdr_reserve_space() returns a pointer to byte zero of the next buffer
page, as it assumes the data item will be copied back into place (in
the previous page) on the next call to xdr_reserve_space().

nfsd4_encode_operation() writes the op num into the buffer, then
saves the next 4-byte location for the op's status code. The next
xdr_reserve_space() call is part of GETATTR encoding, so the op num
gets copied back into the previous page, but the saved location for
the op status continues to point to the wrong spot in the current
XDR buffer page because __xdr_commit_encode() moved that data item.

After GETATTR encoding is complete, nfsd4_encode_operation() writes
the op status over the first XDR data item in the GETATTR result.
The NFS4_OK status code (0) makes it look like there are zero items
in the GETATTR's attribute bitmask.

The patch description of commit 2825a7f90753 ("nfsd4: allow encoding
across page boundaries") [2014] remarks that NFSD "can't handle a
new operation starting close to the end of a page." This bug appears
to be one reason for that remark.

Reported-by: J David <j.david.lists@gmail.com>
Closes: https://lore.kernel.org/linux-nfs/3998d739-c042-46b4-8166-dbd6c5f0e804@oracle.com/T/#t
Tested-by: Rick Macklem <rmacklem@uoguelph.ca>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5760,15 +5760,14 @@ nfsd4_encode_operation(struct nfsd4_comp
 	struct nfs4_stateowner *so = resp->cstate.replay_owner;
 	struct svc_rqst *rqstp = resp->rqstp;
 	const struct nfsd4_operation *opdesc = op->opdesc;
-	int post_err_offset;
+	unsigned int op_status_offset;
 	nfsd4_enc encoder;
-	__be32 *p;
 
-	p = xdr_reserve_space(xdr, 8);
-	if (!p)
+	if (xdr_stream_encode_u32(xdr, op->opnum) != XDR_UNIT)
+		goto release;
+	op_status_offset = xdr->buf->len;
+	if (!xdr_reserve_space(xdr, XDR_UNIT))
 		goto release;
-	*p++ = cpu_to_be32(op->opnum);
-	post_err_offset = xdr->buf->len;
 
 	if (op->opnum == OP_ILLEGAL)
 		goto status;
@@ -5809,20 +5808,21 @@ nfsd4_encode_operation(struct nfsd4_comp
 		 * bug if we had to do this on a non-idempotent op:
 		 */
 		warn_on_nonidempotent_op(op);
-		xdr_truncate_encode(xdr, post_err_offset);
+		xdr_truncate_encode(xdr, op_status_offset + XDR_UNIT);
 	}
 	if (so) {
-		int len = xdr->buf->len - post_err_offset;
+		int len = xdr->buf->len - (op_status_offset + XDR_UNIT);
 
 		so->so_replay.rp_status = op->status;
 		so->so_replay.rp_buflen = len;
-		read_bytes_from_xdr_buf(xdr->buf, post_err_offset,
+		read_bytes_from_xdr_buf(xdr->buf, op_status_offset + XDR_UNIT,
 						so->so_replay.rp_buf, len);
 	}
 status:
 	op->status = nfsd4_map_status(op->status,
 				      resp->cstate.minorversion);
-	*p = op->status;
+	write_bytes_to_xdr_buf(xdr->buf, op_status_offset,
+			       &op->status, XDR_UNIT);
 release:
 	if (opdesc && opdesc->op_release)
 		opdesc->op_release(&op->u);


