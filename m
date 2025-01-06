Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B9518B46A;
	Mon,  6 Jan 2025 15:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177715; cv=none; b=EdZhFhfoyVG+JfeBsWKS2Qw73LqeiuOZYVTIVNzSmapG8lgocCOQvCC/IhbkMzYedu2Fvdkni2JocSkFvL9R3pgCUFT8MBu/4Twb8a4ZzAfQPi+jLBqjy4skZA4FupbwNumRcmCZU6JEsqc3Rd/IRBB4auMmTfb8jxIwlPOlXkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177715; c=relaxed/simple;
	bh=oIWvipO4yqxBocHLCrOHzRW5vvIpeR/xgqrqJW9LwO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlfjgFP6s8WHyJNiymuC7WD9HXCGnk9YXsEQc06W427U4VU+upMhCPeRB0OV/UJJf2M71UYjIKGg4NY+wbw8jkKc/E5A9k071/x2PKvTeQcNJwx6GpFkyPFS9QOWi1GF4eUAnhWEYGGdDrkbXO7SK5TYy8ONzWr6+oT48C1isdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6GYdU91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6GYdU91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FCBC4CED2;
	Mon,  6 Jan 2025 15:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177715;
	bh=oIWvipO4yqxBocHLCrOHzRW5vvIpeR/xgqrqJW9LwO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6GYdU91p5gSN8kdjdksJ4VVskOOjCVxImDljAAFE8+ZspoCkwa/SFd1hEJTCTd08
	 b+kQgiiMlR665pCS4Vl0ra62/Ibt1txTRPTL7pbGw3E2nlyZfLW9549Wkt+Hj35IVm
	 hkDsclS+baDEWZlA9PFFchRBoWSbv3xC2NweI8B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/156] RDMA/bnxt_re: Fix max SGEs for the Work Request
Date: Mon,  6 Jan 2025 16:15:01 +0100
Message-ID: <20250106151142.317719843@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 79d330fbdffd8cee06d8bdf38d82cb62d8363a27 ]

Gen P7 supports up to 13 SGEs for now. WQE software structure
can hold only 6 now. Since the max send sge is reported as
13, the stack can give requests up to 13 SGEs. This is causing
traffic failures and system crashes.

Use the define for max SGE supported for variable size. This
will work for both static and variable WQEs.

Fixes: 227f51743b61 ("RDMA/bnxt_re: Fix the max WQE size for static WQE support")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241204075416.478431-2-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index f55958e5fddb..d8c71c024613 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -114,7 +114,6 @@ struct bnxt_qplib_sge {
 	u32				size;
 };
 
-#define BNXT_QPLIB_QP_MAX_SGL	6
 struct bnxt_qplib_swq {
 	u64				wr_id;
 	int				next_idx;
@@ -154,7 +153,7 @@ struct bnxt_qplib_swqe {
 #define BNXT_QPLIB_SWQE_FLAGS_UC_FENCE			BIT(2)
 #define BNXT_QPLIB_SWQE_FLAGS_SOLICIT_EVENT		BIT(3)
 #define BNXT_QPLIB_SWQE_FLAGS_INLINE			BIT(4)
-	struct bnxt_qplib_sge		sg_list[BNXT_QPLIB_QP_MAX_SGL];
+	struct bnxt_qplib_sge		sg_list[BNXT_VAR_MAX_SGE];
 	int				num_sge;
 	/* Max inline data is 96 bytes */
 	u32				inline_len;
-- 
2.39.5



