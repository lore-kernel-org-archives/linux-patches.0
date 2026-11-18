Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040460;
	b=yEe3Sbioj/GtVnHlQOtZlFDTCmiPxqxCMgefdXCPPirtIMCixQveNwlrzHKydAp4IuFg
	 wu/R6udggERZbIXgIyWdgMQ+7/KbNwgAdngfkLSdf0r+2ZoHg/6YgUZzRo1IJOL1sn+9s
	 JaFtsaMZg4M6+0o70CSSfJrQ6VdTYIc2PIB1rNV1UOhb0XvIn2rjg3bABcCfMdspTrU65
	 ahkGeg9Xo997ZYTzVxLwq8meg9bTdZoplP0vN//McWCcvBsXypFzjSIIn6SY7hx6YkNOV
	 34N68T6w/IpndIrr6lP1NCsPPLQayJ66twPrRpVRNxyYtZjhI3JlA9LYVJrYqy7uvow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G+AuTbL0KPmpFBaSj1wIeivOgJawfOpWuPK55AyLrbY=;
	b=tolbXhFiQE4Dt766qFKphNw/c9SwuBAGqHzyZnVsz/70XZbXg0aWSvREvUNJt9ua5DSv
	 sNtHLq7gf2JB1pzJgdnRIbjGD1Itlk/SbXUTaNupXrHLZuKOjteNVz0n+dYpEepcJmACY
	 4FW+FLQMtZ5jv0I2NVEXmXL521cc/jAcTvVD7ngKyyisnxywhYBujywW1CwC+zQ7fsstL
	 m0ozfwMZtDk/ISeLsQhyolZ2FD1NbsEsqKTt1NvZ3iOwYePNPkDKEPnhyRQeVaXTNAMut
	 GvC3fRctxhXiI7k43WumqA5G6DJyV+InM+y0fdISikl9qTRmTXgYhBw5EVn9D272EVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlxHoavu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67E5606A32A;
	Wed, 18 Nov 2026 22:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlxHoavu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332641F000C4;
	Wed, 18 Nov 2026 22:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040460;
	bh=G+AuTbL0KPmpFBaSj1wIeivOgJawfOpWuPK55AyLrbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PlxHoavuLaZKKNIO05Vvgl9F2T/PLyM2C7TMPhFNsytl09A4nirruJW3DRgDCkQmW
	 RR17+XPzKjHt7qoAoYXtZSORMsHmePYkWRP6I+vI5dL0B71cdZ89GNs5rsR1+UNeIC
	 rN3lFSZer++KcSY4RVJo7seT0YJUSL1PDdt/VC9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2448/3318] RDMA/bnxt_re: Validate SRQ max_sge at create time
Date: Wed, 18 Nov 2026 15:51:10 +0100
Message-ID: <20261118150434.882106116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 1894ed9a664d19c190ce1bd2146759efbae77e4b ]

bnxt_re_create_srq() stored attr.max_sge into srq->qplib_srq.max_sge
unvalidated, which defeats the num_sge check in
bnxt_re_post_srq_recv() since that check compares against this same
attacker-chosen value. Reject max_sge > dev_attr->max_srq_sges at
create time, and clamp dev_attr->max_srq_sges to BNXT_STATIC_MAX_SGE
since SRQ WQEs use the fixed-size SGE array.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++++++
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 1c20e964b0fe2..3007733e6036d 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1753,6 +1753,14 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 		goto exit;
 	}
 
+	if (srq_init_attr->attr.max_sge > dev_attr->max_srq_sges) {
+		ibdev_err(&rdev->ibdev,
+			  "Create SRQ failed - max_sge %d exceeds supported %d",
+			  srq_init_attr->attr.max_sge, dev_attr->max_srq_sges);
+		rc = -EINVAL;
+		goto exit;
+	}
+
 	if (srq_init_attr->srq_type != IB_SRQT_BASIC) {
 		rc = -EOPNOTSUPP;
 		goto exit;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 0b713c1821c3b..31322747b94d4 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -159,7 +159,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 
 	attr->max_srq = le16_to_cpu(sb->max_srq);
 	attr->max_srq_wqes = le32_to_cpu(sb->max_srq_wr) - 1;
-	attr->max_srq_sges = sb->max_srq_sge;
+	attr->max_srq_sges = min_t(u32, sb->max_srq_sge, BNXT_STATIC_MAX_SGE);
 	attr->max_pkey = 1;
 	attr->max_inline_data = attr->max_qp_sges * sizeof(struct sq_sge);
 	if (!bnxt_qplib_is_chip_gen_p7(rcfw->res->cctx))
-- 
2.53.0



