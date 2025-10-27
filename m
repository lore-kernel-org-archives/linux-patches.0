Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F4A31D36D;
	Mon, 27 Oct 2025 18:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591231; cv=none; b=Mw1/dW44mnR7LDFUvwVVKOYFt+fMFlPT6fOogAMQ7j+BFRSBF6BlYdh6d7akN9SRgqpGuPZyy21dhw10/n9B6wxldLzlg3cXMZRon8al7tUys1uVoXFfcwreNwNXMtxOzyGxmCyoajX0miLNMRlXsaQL0RhBH7bEET+JinmfjO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591231; c=relaxed/simple;
	bh=k+NuDgMkHm4OY6yXVF/R9hPRvMLnWg+0l0gV9djLOdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfaS7mKf6Q/PbIPq9xCCzuZvZez6TbbH23eCooSH24K/JBTQzGmR4C4P5Bm7uXoGjWDVTV+K6vH3/Q4ZLlVvXM5L0dDYY6wlv2W1+hb4Wzw0Lg+EM0Q8bC9k3WewtExEOqYEM7JWlUVNvTCL7Hpq3vSYg4rTfIcoJkEQgmcmCbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vm6iuIgm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vm6iuIgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B79C113D0;
	Mon, 27 Oct 2025 18:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591231;
	bh=k+NuDgMkHm4OY6yXVF/R9hPRvMLnWg+0l0gV9djLOdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vm6iuIgmiQY9U0bM++b8UkKIbyb2h47bXPa0Mwiy3WTW7sFLiX7weGgu0DAldpnNx
	 JX7g34E/g1CLRJTWrC0AqkBIn/x6ym0Us/qjIkhs+yD8D8FRxgnLj3G/4+LWtr8hYq
	 wey0l2cnJMYhpsBE1hEskEjy8UK3njRjmTa1PhvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/332] RDMA/siw: Always report immediate post SQ errors
Date: Mon, 27 Oct 2025 19:32:11 +0100
Message-ID: <20251027183526.679970621@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Metzler <bernard.metzler@linux.dev>

[ Upstream commit fdd0fe94d68649322e391c5c27dd9f436b4e955e ]

In siw_post_send(), any immediate error encountered during processing of
the work request list must be reported to the caller, even if previous
work requests in that list were just accepted and added to the send queue.

Not reporting those errors confuses the caller, which would wait
indefinitely for the failing and potentially subsequently aborted work
requests completion.

This fixes a case where immediate errors were overwritten by subsequent
code in siw_post_send().

Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Link: https://patch.msgid.link/r/20250923144536.103825-1-bernard.metzler@linux.dev
Suggested-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_verbs.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 1d4e0dc550e42..edfbad96665ca 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -757,7 +757,7 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
 	struct siw_wqe *wqe = tx_wqe(qp);
 
 	unsigned long flags;
-	int rv = 0;
+	int rv = 0, imm_err = 0;
 
 	if (wr && !rdma_is_kernel_res(&qp->base_qp.res)) {
 		siw_dbg_qp(qp, "wr must be empty for user mapped sq\n");
@@ -943,9 +943,17 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
 	 * Send directly if SQ processing is not in progress.
 	 * Eventual immediate errors (rv < 0) do not affect the involved
 	 * RI resources (Verbs, 8.3.1) and thus do not prevent from SQ
-	 * processing, if new work is already pending. But rv must be passed
-	 * to caller.
+	 * processing, if new work is already pending. But rv and pointer
+	 * to failed work request must be passed to caller.
 	 */
+	if (unlikely(rv < 0)) {
+		/*
+		 * Immediate error
+		 */
+		siw_dbg_qp(qp, "Immediate error %d\n", rv);
+		imm_err = rv;
+		*bad_wr = wr;
+	}
 	if (wqe->wr_status != SIW_WR_IDLE) {
 		spin_unlock_irqrestore(&qp->sq_lock, flags);
 		goto skip_direct_sending;
@@ -970,15 +978,10 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
 
 	up_read(&qp->state_lock);
 
-	if (rv >= 0)
-		return 0;
-	/*
-	 * Immediate error
-	 */
-	siw_dbg_qp(qp, "error %d\n", rv);
+	if (unlikely(imm_err))
+		return imm_err;
 
-	*bad_wr = wr;
-	return rv;
+	return (rv >= 0) ? 0 : rv;
 }
 
 /*
-- 
2.51.0



