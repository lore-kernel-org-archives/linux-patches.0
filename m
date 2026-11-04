Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829043;
	b=cfytDsLBkHPvjs/NrT5Cz6dPrC0KYLC9QHjMqiKaPkcqyyBM2gB+PCRgAt00j6fpcnNG
	 xQQGaBLCXtvtxvkFFIJo/YecJUw/o1EWakT9Ibc+3C86HzJ0oh2O3LdgxaSGaz/pUp2IP
	 kw5pXuz3jbYUQ3jSNf0NDLu6XCPVT9mB69Pn3LZ5925/gcepj5PcX5Eh5WIHbRGmC5NDV
	 5aF4bEOeSziMzkJsARc4Q2pVn6DMTso/qWp5F9fnZf21Fq5r5LQCx+TI5iEY3d3Ku5YDP
	 gM+ReNEOJ7CZ2Dv6f0xJJwIvdOtnf8MmRoMj6ABxQkkqv8yaI665wvwsNTDBBWlK9HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0x8tc1Odgo6Rm5WE1szhuwIr9JHjCNku+VLFQh9ekjs=;
	b=fxvGDg76nq86aRRjdB4jZKqmIBr9vW8A4I7tH2u9b4a09GpixX00dkd/KiR4W3nHM7My
	 j7oXeWbmMse4ulmh1K/5igkymWS+iHo59jvykDKxn5ACpZ+XLWAOd6Pqay2AO0BF7mTz+
	 utHyWLQYrcbOMgoGjPV4mNxg26N6Pz+x1HsFIeWt+IwDhq3TImjNZhaO8sd2JxTS+DUWy
	 t91KJssZLzUaAL/PyzL4fccIQOR+sGwCg26ck0BV8ljW1rZnNVUhnkpNxFEpwzAYQH4wV
	 NBw5OaDIWi0H/hfO3ousHEyLnJsRRkkHNaj7H9Tgpzr3iVBepQSCMtpMC7SBSax4wRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bmGxHgO/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399496080797;
	Wed,  4 Nov 2026 21:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bmGxHgO/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE0E1F00A16;
	Wed,  4 Nov 2026 21:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829042;
	bh=0x8tc1Odgo6Rm5WE1szhuwIr9JHjCNku+VLFQh9ekjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmGxHgO/9T6yBTXowM1caL298sPDry19RHeVG/vuA1WwQIMrwTShDuIZgtCPzeBn3
	 iuIgUrD2LMRgz0Ijxu1unx4e3AtU0OFWF83QTKbF5qNxlyXl1PtdPH3Q3sdbnWfoPF
	 aEpX0sRPKBcZMXUZCdkbVgkMXIwbO2pZ7dWm/vV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.3 407/547] NFS/localio: detect a short read or write before the iterator has moved
Date: Wed,  4 Nov 2026 16:09:51 -0500
Message-ID: <20261104211049.878896229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

commit db3ca539c1142d2c5380c5dbd3154ab7bb1c7d77 upstream.

nfs_local_call_read() and nfs_local_call_write() issue a misaligned
DIO as up to three segments and must stop at the first short one, or
the next segment lands at the wrong file offset.  They test for that
by comparing the bytes transferred against iov_iter_count() of the
segment, read after read_iter() or write_iter() has advanced the
iterator, when the count is the residual rather than the request:

    before the call:  count == expected
    after the call:   count == expected - status

The test is therefore status < expected - status, and it fires only
when less than half of the segment was transferred.  A short I/O that
covers between 50% and 99% of a segment slips through: the loop moves
on with ki_pos advanced by the short amount, the next segment is
issued at the wrong offset, and the header's byte count is
over-reported to the caller.  A write that slips through also never
sets NFS_CONTEXT_WRITE_SYNC, which is what makes the writes that
follow a short one synchronous.

Take the segment's count before issuing it and compare against that.

This is the same defect that commit 250ec14932d5 ("nfsd: fix
partial-write detection in nfsd_direct_write") fixed in NFSD's version
of this loop.

Fixes: c817248fc831 ("nfs/localio: add proper O_DIRECT support for READ and WRITE")
Fixes: d0497dd27452 ("nfs/localio: backfill missing partial read support for misaligned DIO")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/localio.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -674,6 +674,8 @@ static void nfs_local_call_read(struct w
 
 	n_iters = atomic_read(&iocb->n_iters);
 	for (int i = 0; i < n_iters ; i++) {
+		size_t expected;
+
 		if (iocb->iter_is_dio_aligned[i]) {
 			iocb->kiocb.ki_flags |= IOCB_DIRECT;
 			/* Only use AIO completion if DIO-aligned segment is last */
@@ -684,6 +686,8 @@ static void nfs_local_call_read(struct w
 		} else
 			iocb->kiocb.ki_flags &= ~IOCB_DIRECT;
 
+		/* read_iter() advances the iterator: measure it beforehand */
+		expected = iov_iter_count(&iocb->iters[i]);
 		scoped_with_creds(filp->f_cred)
 			status = filp->f_op->read_iter(&iocb->kiocb, &iocb->iters[i]);
 
@@ -691,7 +695,7 @@ static void nfs_local_call_read(struct w
 			continue;
 		/* Break on completion, errors, or short reads */
 		if (nfs_local_pgio_done(iocb, status) || status < 0 ||
-		    (size_t)status < iov_iter_count(&iocb->iters[i])) {
+		    (size_t)status < expected) {
 			nfs_local_read_iocb_done(iocb);
 			break;
 		}
@@ -890,7 +894,7 @@ static void nfs_local_call_write(struct
 	file_start_write(filp);
 	n_iters = atomic_read(&iocb->n_iters);
 	for (int i = 0; i < n_iters ; i++) {
-		size_t icount;
+		size_t expected;
 
 		if (iocb->iter_is_dio_aligned[i]) {
 			iocb->kiocb.ki_flags |= IOCB_DIRECT;
@@ -902,16 +906,17 @@ static void nfs_local_call_write(struct
 		} else
 			iocb->kiocb.ki_flags &= ~IOCB_DIRECT;
 
+		/* write_iter() advances the iterator: measure it beforehand */
+		expected = iov_iter_count(&iocb->iters[i]);
 		scoped_with_creds(filp->f_cred)
 			status = filp->f_op->write_iter(&iocb->kiocb, &iocb->iters[i]);
 
 		if (status == -EIOCBQUEUED)
 			continue;
 		/* Break on completion, errors, or short writes */
-		icount = iov_iter_count(&iocb->iters[i]);
 		if (nfs_local_pgio_done(iocb, status) || status < 0 ||
-		    (size_t)status < icount) {
-			if ((size_t)status < icount) {
+		    (size_t)status < expected) {
+			if ((size_t)status < expected) {
 				struct nfs_lock_context *ctx =
 					iocb->hdr->req->wb_lock_context;
 


