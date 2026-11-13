Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590064;
	b=bjwvrOWniitxQpek1Dx46oj68kgrVTrzNAEVa88QGuSH0v6i1rQNGUnWK4jAc7P1xX4L
	 3M62qfEGLZrRDG/f4v6pr7PWtzX/8ZEabiBP9W4Vq77OeHoaOdDCIkBz0Jkmnm9eAPfTu
	 EKUSFjdFRdKmJUqrqX9dVglDEbZWbbUmnIHL7yT8OtL6TiNZFsu5gTwuXRv9qxSe7QlwS
	 vgjJmJi0d6bzkpRY38INs2XGQ9Z+9I8439Cz0pyqUcTRrtUkDn52k7WXq7eeODMrZJA09
	 DY/81lkqjffl3zV1N96Kx2wuMpOwx5W1qBxOBWeCt1FODGHGlrrU0P/WijioybDioEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kjf/LKPrR2g7QciogwIgV9knIhQSwijgBhAAlKht2bA=;
	b=qneBIOm2t49/GR/LtAb8dzPCVDj/8GD33MvbOQO5XtlFY46dP5ksk6N+H+PR7WG/tFgA
	 ROOXUsQSFnP5QUPUvkraxV8LklM0thMrkZMTg2KNB9FkQgwc81V6CWeaeeQ7hw8JpyD0U
	 bGa8YBSEm6tL34lNJGcEZpN9Q2ggB/McvGVq7W2cQWArEGt8y99Lnl8zIOZhYu0SSFSvB
	 vm51Z65ZYx+IHSNUVEMr4Tz07aPeGxzwzAwtUMb/C0t/NqYM/VI6obueBk9KtGyxQk+/h
	 BWc8KtGxzcRSMukupM0Mrr8yzTEWHrzIQ54XP0qO4CRb5M0MLj9YJPc/ft5mAxoQe1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0qF1SpBw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8299A606A890;
	Fri, 13 Nov 2026 17:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0qF1SpBw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF7B1F000C4;
	Fri, 13 Nov 2026 17:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590064;
	bh=Kjf/LKPrR2g7QciogwIgV9knIhQSwijgBhAAlKht2bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0qF1SpBwtfG/3VM/dVKTSUbe2lCeIBiusnHdQ5VfL9Y5LT82TWRYW1cTFNaFjM2SG
	 5NEEEDEkbGzXo4Os7ZKd5nvSTrY2g690hEwBFMdvO7DMC3ic0LLNh/ND5qjmGfRRi0
	 j9qqmQtIZHzYRz4IO6SaQgFupM5u71CwUfSa951g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/686] NFS/localio: detect a short read or write before the iterator has moved
Date: Fri, 13 Nov 2026 10:42:57 -0500
Message-ID: <20261113153822.458033574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit db3ca539c1142d2c5380c5dbd3154ab7bb1c7d77 ]

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
[ sashal: adapted completion handling to the three-argument nfs_local_pgio_done() helper using force_done ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 3c5891d3ab897..3138439d19109 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -682,6 +682,8 @@ static void nfs_local_call_read(struct work_struct *work)
 
 	n_iters = atomic_read(&iocb->n_iters);
 	for (int i = 0; i < n_iters ; i++) {
+		size_t expected;
+
 		if (iocb->iter_is_dio_aligned[i]) {
 			iocb->kiocb.ki_flags |= IOCB_DIRECT;
 			/* Only use AIO completion if DIO-aligned segment is last */
@@ -692,12 +694,14 @@ static void nfs_local_call_read(struct work_struct *work)
 		} else
 			iocb->kiocb.ki_flags &= ~IOCB_DIRECT;
 
+		/* read_iter() advances the iterator: measure it beforehand */
+		expected = iov_iter_count(&iocb->iters[i]);
 		save_cred = override_creds(filp->f_cred);
 		status = filp->f_op->read_iter(&iocb->kiocb, &iocb->iters[i]);
 		revert_creds(save_cred);
 
 		if (status != -EIOCBQUEUED) {
-			if (unlikely(status >= 0 && status < iocb->iters[i].count))
+			if (unlikely(status >= 0 && (size_t)status < expected))
 				force_done = true; /* Partial read */
 			if (nfs_local_pgio_done(iocb, status, force_done)) {
 				nfs_local_read_iocb_done(iocb);
@@ -878,6 +882,8 @@ static void nfs_local_call_write(struct work_struct *work)
 	file_start_write(filp);
 	n_iters = atomic_read(&iocb->n_iters);
 	for (int i = 0; i < n_iters ; i++) {
+		size_t expected;
+
 		if (iocb->iter_is_dio_aligned[i]) {
 			iocb->kiocb.ki_flags |= IOCB_DIRECT;
 			/* Only use AIO completion if DIO-aligned segment is last */
@@ -888,12 +894,14 @@ static void nfs_local_call_write(struct work_struct *work)
 		} else
 			iocb->kiocb.ki_flags &= ~IOCB_DIRECT;
 
+		/* write_iter() advances the iterator: measure it beforehand */
+		expected = iov_iter_count(&iocb->iters[i]);
 		save_cred = override_creds(filp->f_cred);
 		status = filp->f_op->write_iter(&iocb->kiocb, &iocb->iters[i]);
 		revert_creds(save_cred);
 
 		if (status != -EIOCBQUEUED) {
-			if (unlikely(status >= 0 && status < iocb->iters[i].count))
+			if (unlikely(status >= 0 && (size_t)status < expected))
 				force_done = true; /* Partial write */
 			if (nfs_local_pgio_done(iocb, status, force_done)) {
 				nfs_local_write_iocb_done(iocb);
-- 
2.53.0



