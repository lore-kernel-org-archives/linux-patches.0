Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DA725C804;
	Mon, 17 Aug 2026 15:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978884; cv=none; b=ZwnD7Qrr0LCquvfLHye3BvGTL/ohgTXWRQqfO6Voo3JLmgwNrCUmC8llyyjO8AN54mmXDG4bewcksiwMOwhSI+nOHXr+lt4HcUzUKjrs0wyo5FlAvJ4yFp3NaAiQwR6trZJp1Z23/+hSHH0gHbdJPv8XHyE+hjXMnZ6hic2b89g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978884; c=relaxed/simple;
	bh=Y98jY7BRs5y2lj4QLPz0t7Zsy4oeJE1cKHpyG31tMmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOdXWnQqyHMmd1w9iRFkWzcYJRJ0JB+ZN6dYnbCtFzEDOEUFY+ujt7QzuxohBBCE6kdaYfjlYjxpNksbwmN983hE0c/4Moqxa38GE6RAz9zA8ziwMTRrEIvovCwmvQ78FAMhBzARxDqO9wKXAuhGbphbNsVDDwrX8h/Kp4SG/6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/LxR/li; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/LxR/li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092791F000E9;
	Mon, 17 Aug 2026 15:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978883;
	bh=z3lRVzBM0yry1yzdsfRpVB69GysmMaAA0vRVNWCuLk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/LxR/liVUcYfHIXLv3s7BYK+/z57APltcu7oaQZDQQGW7vrdU+KqSK06xnIJkcDL
	 NBYAytDsvorn85Jab7JXCocIXj12UcBlbuzn8tzIjlwm1seqw+KFMbbeNeQ0abvvMB
	 j5crOsT3Wvhfg92Tajc9bb03EyHNaB5dF6hCjTVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/609] RDMA/siw: Only check attrs->cap.max_send_wr in siw_create_qp
Date: Mon, 17 Aug 2026 15:25:30 +0200
Message-ID: <20260817132544.411767247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit 788bbf4c2fc6e0c35bae9ed5068f484272539d3e ]

We can just check max_send_wr here given both max_send_wr and
max_recv_wr are defined as u32 type, and we also need to ensure
num_sqe (derived from max_send_wr) shouldn't be zero.

Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20231113115726.12762-16-guoqing.jiang@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: bb27fcc67c42 ("RDMA/siw: publish QP after initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_verbs.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index dce86f5aee1f76..336702bcbfa9f8 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -336,11 +336,10 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 		goto err_atomic;
 	}
 	/*
-	 * NOTE: we allow for zero element SQ and RQ WQE's SGL's
-	 * but not for a QP unable to hold any WQE (SQ + RQ)
+	 * NOTE: we don't allow for a QP unable to hold any SQ WQE
 	 */
-	if (attrs->cap.max_send_wr + attrs->cap.max_recv_wr == 0) {
-		siw_dbg(base_dev, "QP must have send or receive queue\n");
+	if (attrs->cap.max_send_wr == 0) {
+		siw_dbg(base_dev, "QP must have send queue\n");
 		rv = -EINVAL;
 		goto err_atomic;
 	}
@@ -360,21 +359,14 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	if (rv)
 		goto err_atomic;
 
-	num_sqe = attrs->cap.max_send_wr;
-	num_rqe = attrs->cap.max_recv_wr;
 
 	/* All queue indices are derived from modulo operations
 	 * on a free running 'get' (consumer) and 'put' (producer)
 	 * unsigned counter. Having queue sizes at power of two
 	 * avoids handling counter wrap around.
 	 */
-	if (num_sqe)
-		num_sqe = roundup_pow_of_two(num_sqe);
-	else {
-		/* Zero sized SQ is not supported */
-		rv = -EINVAL;
-		goto err_out_xa;
-	}
+	num_sqe = roundup_pow_of_two(attrs->cap.max_send_wr);
+	num_rqe = attrs->cap.max_recv_wr;
 	if (num_rqe)
 		num_rqe = roundup_pow_of_two(num_rqe);
 
-- 
2.53.0



