Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048919;
	b=z3WSX51Vq+nc4tRM/xaWYeYLfqBepWcZIwiyDrpRZZC+cR2DDGD0mDGcaEE7DBhTYIYu
	 K+gHmj33C9axsFYdHZAflSHJEvKpeBh89kC+b/JcBLkDiFAKfFi8tEMVAYdcLZFjwEc+0
	 RlFea4bV0E9SXeRBD6s/fwDkmqQhVId7sB9hxtYPFxGtwaldS4YOhvP7xxItweYrh1GlZ
	 M2prqeh3XeZ0IveUBTp5RZmWgg3rVBiL+gM/z+fb5sqdHO8Bv78cuRbV6w9CDuDKqKm6U
	 XVonqoD5YwufxnZTE83PPpLH4C20hwoiir7Thtq1NuHoTCi01VWjl+AX4w032HhmBug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8dr5Dcz9qiXmJ+HceSUszhy6t7XJwOGRJJcfgiCBy+A=;
	b=leND/g1lYJkCr1YKO483+ToYvBtGiIFM+4gjYkQVm6sM3PwkniWZeKt7d0xbYunAwiR2
	 LIHeOl1F/s0a8sKOTyoSac4UezetGal+GMiSUEETTnCux8QgJjJhg7fUSQyqGKZhmiz/S
	 jRXKwJR0i5dKyaecXhkOL8evfuO46BgSK64C9c0az/Flu6WkLkEIX7wPIzhR/CTthKJ+H
	 hl+eUSQ4D8t3Q8J6O/O+C4TzqiBEBuTvUMB+6Q3z76gtljjzc5EZ41SUmzM7FdacbKGtA
	 KOdO/rwMGYIfAD1gc0OVcvCVMsokl+b3XSEV57WeG5K5vUsh67XETQXIuvYf8cfRHmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDAL8aJ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C82F606A31C;
	Thu, 19 Nov 2026 00:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDAL8aJ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C7E1F000C4;
	Thu, 19 Nov 2026 00:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048918;
	bh=8dr5Dcz9qiXmJ+HceSUszhy6t7XJwOGRJJcfgiCBy+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDAL8aJ425XkrgOLzdCCVE/T4SO2+/cDTGzzwiNpUWexOWKCjbgV2+YFQS5nx5FFl
	 1PgJUnTS9SSxAJ1hTKk35zHL3qpt052DO2ayG5KSdnWHli4JMH5wU431aqaZeJySAg
	 yyVsjivw0xKna4GPWrfudpdzGVL1TZhzaNcPMQYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2126/2857] RDMA/bnxt_re: Detect wrong sge_len passed for inline
Date: Wed, 18 Nov 2026 15:52:40 +0100
Message-ID: <20261118150317.948542666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 81551ece0864c346080d241719d458c93f0e7fc9 ]

Avoid handling wrong sge_len by adding extra check
to see if the passed length is more than the inline
size supported.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 3a63582df7f93..34548929520a9 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2520,8 +2520,9 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
 				wr->sg_list[i].addr;
 		sge_len = wr->sg_list[i].length;
 
-		if ((sge_len + wqe->inline_len) >
-		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH) {
+		if (sge_len > BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH ||
+		    ((sge_len + wqe->inline_len) >
+		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH)) {
 			ibdev_err(&rdev->ibdev,
 				  "Inline data size requested > supported value");
 			return -EINVAL;
-- 
2.53.0



