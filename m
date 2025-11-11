Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7242324466D;
	Tue, 11 Nov 2025 01:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825153; cv=none; b=plDm/TxLkUtR9iFxhGHLx9PJ4CLmAJ+4IheGJ4r79iCR3LE1NHkNQSqsdafc2SIdegWKGxuN7JwWQtITyU21N4LO/o1SKlgO75cinTNhctWXOH/IemH73iV0ymHxKz8dLW8H7GHmGxO73Ktp6gr8Rr2TY8BQ969sZlX9Esc3S7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825153; c=relaxed/simple;
	bh=0Lx2R2ttZHK343mDHxCzAqj5Kzg97JVf+DyM6kJCKbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bM09sRn/JphuJVWaQBdVtTa6Zox0BHtPI6C60KYFBh0vgz42yvkSphO1SEHjBB4jKQ8c5sd5/4v/IJj1rt0UtNlErLDuMXTqbUw/dKFzFPEAJUwO4iuE8ix8Yt8UoaZvJIrBZ9sV+b1i0JyU7/UxmlIXH7akZ2hXOTAqfHrahrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fk02Mlbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fk02Mlbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D932AC16AAE;
	Tue, 11 Nov 2025 01:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825153;
	bh=0Lx2R2ttZHK343mDHxCzAqj5Kzg97JVf+DyM6kJCKbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fk02Mlbc2Rl+ua06AktrteXyzLOHfcK8GSzUsuUjSgdN2pUvQBNI2XhDjJzuWKbw+
	 y7SdNhYJKDfgzz7F8/y76gX4EeAVHgVNiPXj3z3hNl95ocriL3OcdioS3m7jIzT7qE
	 wdeycTevbEXzLokpo4fRIE9hAYLtN0j3kpwOBQKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YanLong Dai <daiyanlong@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 683/849] RDMA/bnxt_re: Fix a potential memory leak in destroy_gsi_sqp
Date: Tue, 11 Nov 2025 09:44:13 +0900
Message-ID: <20251111004552.935345741@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YanLong Dai <daiyanlong@kylinos.cn>

[ Upstream commit 88de89f184661ebb946804a5abdf2bdec7f0a7ab ]

The current error handling path in bnxt_re_destroy_gsi_sqp() could lead
to a resource leak. When bnxt_qplib_destroy_qp() fails, the function
jumps to the 'fail' label and returns immediately, skipping the call
to bnxt_qplib_free_qp_res().

Continue the resource teardown even if bnxt_qplib_destroy_qp() fails,
which aligns with the driver's general error handling strategy and
prevents the potential leak.

Fixes: 8dae419f9ec73 ("RDMA/bnxt_re: Refactor queue pair creation code")
Signed-off-by: YanLong Dai <daiyanlong@kylinos.cn>
Link: https://patch.msgid.link/20250924061444.11288-1-daiyanlong@kylinos.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 260dc67b8b87c..12fee23de81e7 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -911,7 +911,7 @@ void bnxt_re_unlock_cqs(struct bnxt_re_qp *qp,
 	spin_unlock_irqrestore(&qp->scq->cq_lock, flags);
 }
 
-static int bnxt_re_destroy_gsi_sqp(struct bnxt_re_qp *qp)
+static void bnxt_re_destroy_gsi_sqp(struct bnxt_re_qp *qp)
 {
 	struct bnxt_re_qp *gsi_sqp;
 	struct bnxt_re_ah *gsi_sah;
@@ -931,10 +931,9 @@ static int bnxt_re_destroy_gsi_sqp(struct bnxt_re_qp *qp)
 
 	ibdev_dbg(&rdev->ibdev, "Destroy the shadow QP\n");
 	rc = bnxt_qplib_destroy_qp(&rdev->qplib_res, &gsi_sqp->qplib_qp);
-	if (rc) {
+	if (rc)
 		ibdev_err(&rdev->ibdev, "Destroy Shadow QP failed");
-		goto fail;
-	}
+
 	bnxt_qplib_free_qp_res(&rdev->qplib_res, &gsi_sqp->qplib_qp);
 
 	/* remove from active qp list */
@@ -949,10 +948,6 @@ static int bnxt_re_destroy_gsi_sqp(struct bnxt_re_qp *qp)
 	rdev->gsi_ctx.gsi_sqp = NULL;
 	rdev->gsi_ctx.gsi_sah = NULL;
 	rdev->gsi_ctx.sqp_tbl = NULL;
-
-	return 0;
-fail:
-	return rc;
 }
 
 /* Queue Pairs */
-- 
2.51.0



