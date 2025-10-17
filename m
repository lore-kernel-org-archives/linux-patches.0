Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C99330B06;
	Fri, 17 Oct 2025 15:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716170; cv=none; b=lK0JHfu40MgIwF92Uote1yAM1YPSXpM5T4jT/INA0IwX+bj8ypsIy9Q+7kwx64XwSAS0vW+GkhFfVgsMvi5BSV2gnmMk6qeUtP17MIcBgu4uXvsudJLYbAzrcZnvXGUtkiZV+LsYjmXVPiybEwmb1uZ8bWGh1/0KeFVnY4vMhYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716170; c=relaxed/simple;
	bh=oTkmZl95nz+1+FqKAW5uMzhzju4vpOOUkHdaaiodkxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hv3VQ82A81UcluqDbSLnFukard4l8aGZRwjdWSqFFtZ/+uK5PF8uGJBAqC1vmVvZP28EI6pWvwyT/ChSyOP/3Zk+WfYZp+eVp4rg4aPNZV0AoJHLTzxUIgHSm6bbJpArWq29Uyh3ta5QZGKJ9xEjY6triGdzjnYnm7B0WE7HeA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFNguUM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFNguUM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4ECC4CEE7;
	Fri, 17 Oct 2025 15:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716169;
	bh=oTkmZl95nz+1+FqKAW5uMzhzju4vpOOUkHdaaiodkxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFNguUM0RjYq5xugEV32finOSRh5voswgoZhk4aVk4CBkMhrpK6W58qxNj/w9YORb
	 v6A+c13kJ58jRykv3uBJ+Y8Onv/6sz7xedElcVvhqhvJIMSk3Y8MLDuis0O8+gQqSI
	 1x5tfpCxCjZvRFI4t/C4rFGFpJv901iIYlZkWUtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/276] RDMA/siw: Always report immediate post SQ errors
Date: Fri, 17 Oct 2025 16:53:10 +0200
Message-ID: <20251017145146.026002493@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 124242e387a59..c83701d04c955 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -759,7 +759,7 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
 	struct siw_wqe *wqe = tx_wqe(qp);
 
 	unsigned long flags;
-	int rv = 0;
+	int rv = 0, imm_err = 0;
 
 	if (wr && !rdma_is_kernel_res(&qp->base_qp.res)) {
 		siw_dbg_qp(qp, "wr must be empty for user mapped sq\n");
@@ -945,9 +945,17 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
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
@@ -972,15 +980,10 @@ int siw_post_send(struct ib_qp *base_qp, const struct ib_send_wr *wr,
 
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



