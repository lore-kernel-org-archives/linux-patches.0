Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA38D1F7545;
	Tue,  3 Dec 2024 15:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238859; cv=none; b=o0IXHh6rMWPEqUY/HzvFk+rcgAPikstx0nRF34G7IF1MflHMSKm+M8w5HSGk1LOTrkfPZ7n/LjIpfo2Q8Doo5L1SM3dutYSynYlvbDY0oUi/u2vZgdK5F9ZGGQg84HE9X1R3UUkeTIDUCirrsNCFzq1nVquel+TwySP7WZeubvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238859; c=relaxed/simple;
	bh=5jN2OykoLIulofNRF/gugbBYzqKdl4cxjq/xmhFso9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fw3zGtAunSAjpXlDEPG8zjJTFcHLeHh2FVGaOkmjr3d6ksbvE2hKCq/C6FpEWpHX7UtqxQKlz2qDHNYqEa3T90rCvmIqMq+7lzKVnhB1Ct7A8xmnrf3cJ5GCfRvABLCVzWeqeu4V3/yqNv6ZMQkAXL+0Z36e7BfxkvTRTiGSswQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0gd+RsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0gd+RsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C6CC4CECF;
	Tue,  3 Dec 2024 15:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238859;
	bh=5jN2OykoLIulofNRF/gugbBYzqKdl4cxjq/xmhFso9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0gd+RsHWIz2SpysfAi1OxorvB6usuQCUlcluWoJJ9icdDiDA5J7MxHoFNNdNIr89
	 MViqluZeaT66fhe4M1V/tTSuOB2oBTcVcuWuqMpRVIj4+/qtbp1vofn2/J81/QzWkQ
	 c2q7b6QOtl19Eu7Vcq6UuCdPoJVqIlkaBEWa3Du8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 422/817] RDMA/rxe: Set queue pair cur_qp_state when being queried
Date: Tue,  3 Dec 2024 15:39:54 +0100
Message-ID: <20241203144012.358642779@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 775e6d3c8fda41083b16c26d05163fd69f029a62 ]

Same with commit e375b9c92985 ("RDMA/cxgb4: Set queue pair state when
 being queried"). The API for ib_query_qp requires the driver to set
cur_qp_state on return, add the missing set.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Link: https://patch.msgid.link/20241031092019.2138467-1-liujian56@huawei.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index d2f7b5195c19d..91d329e903083 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -775,6 +775,7 @@ int rxe_qp_to_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask)
 	 * Yield the processor
 	 */
 	spin_lock_irqsave(&qp->state_lock, flags);
+	attr->cur_qp_state = qp_state(qp);
 	if (qp->attr.sq_draining) {
 		spin_unlock_irqrestore(&qp->state_lock, flags);
 		cond_resched();
-- 
2.43.0



