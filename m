Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FACF355031;
	Tue,  6 Jan 2026 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721799; cv=none; b=Ywoi/ABa2fYvf5zGLgAB+IGZ/XiiiSgyjpYJ7mvqWto9tT3xZA/Y7+UP/vpamQ/YPsbRW0yTE7qYGz4rD0jE4OLK3ISJim1kaCwZLzIXrB6fjalEKp2JN81y5rhn/RpbwBEOT7psHAG2FZHMNH7IHLMK2sgDrIg0+0MJmImq+ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721799; c=relaxed/simple;
	bh=gkwTfbvinZP53c6Mvr03g5cSpfRtl0k7RFixa1VKAvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XivnK7rjiUM8Q75qFRKrg5k1QouFvV66hNTgk5lVhm8yqUn6/Rm+JNSlmj8bd/f538YY6Td9PHnCie3cXAb71IgWIZO3Sme85RdMZwBtIFHDF5wQXjBNFnDmbPaEXZibHEmxPjkdIKILb6r0/5axU3d29sD5BXAJQNNUAEUpmus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJjR9NMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJjR9NMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0ACCC19423;
	Tue,  6 Jan 2026 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721799;
	bh=gkwTfbvinZP53c6Mvr03g5cSpfRtl0k7RFixa1VKAvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJjR9NMWGkLOi3OWLXNgNaaMGKovH6TxuZSa7nwtBQxMsO20cSrCE1hBEPoAm9e62
	 4mUS/ZkJiNIZPIEL95AptU/Yq+h5WuFQ9WtLN5ZebPzj2KVdfOn/DTNpS3JFeQ19GL
	 rRyTAehahZLW5aGqSHjVj3Ew5h/K+bKaDmOj5WwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingying Zheng <zhengyingying@sangfor.com.cn>,
	Ding Hui <dinghui@sangfor.com.cn>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/312] RDMA/bnxt_re: Fix OOB write in bnxt_re_copy_err_stats()
Date: Tue,  6 Jan 2026 18:02:29 +0100
Message-ID: <20260106170550.558027547@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ding Hui <dinghui@sangfor.com.cn>

[ Upstream commit 9b68a1cc966bc947d00e4c0df7722d118125aa37 ]

Commit ef56081d1864 ("RDMA/bnxt_re: RoCE related hardware counters
update") added three new counters and placed them after
BNXT_RE_OUT_OF_SEQ_ERR.

BNXT_RE_OUT_OF_SEQ_ERR acts as a boundary marker for allocating hardware
statistics with different num_counters values on chip_gen_p5_p7 devices.

As a result, BNXT_RE_NUM_STD_COUNTERS are used when allocating
hw_stats, which leads to an out-of-bounds write in
bnxt_re_copy_err_stats().

The counters BNXT_RE_REQ_CQE_ERROR, BNXT_RE_RESP_CQE_ERROR, and
BNXT_RE_RESP_REMOTE_ACCESS_ERRS are applicable to generic hardware, not
only p5/p7 devices.

Fix this by moving these counters before BNXT_RE_OUT_OF_SEQ_ERR so they
are included in the generic counter set.

Fixes: ef56081d1864 ("RDMA/bnxt_re: RoCE related hardware counters update")
Reported-by: Yingying Zheng <zhengyingying@sangfor.com.cn>
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Link: https://patch.msgid.link/20251208072110.28874-1-dinghui@sangfor.com.cn
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Tested-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/hw_counters.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/hw_counters.h b/drivers/infiniband/hw/bnxt_re/hw_counters.h
index 09d371d442aa..cebec033f4a0 100644
--- a/drivers/infiniband/hw/bnxt_re/hw_counters.h
+++ b/drivers/infiniband/hw/bnxt_re/hw_counters.h
@@ -89,6 +89,9 @@ enum bnxt_re_hw_stats {
 	BNXT_RE_RES_SRQ_LOAD_ERR,
 	BNXT_RE_RES_TX_PCI_ERR,
 	BNXT_RE_RES_RX_PCI_ERR,
+	BNXT_RE_REQ_CQE_ERROR,
+	BNXT_RE_RESP_CQE_ERROR,
+	BNXT_RE_RESP_REMOTE_ACCESS_ERRS,
 	BNXT_RE_OUT_OF_SEQ_ERR,
 	BNXT_RE_TX_ATOMIC_REQ,
 	BNXT_RE_TX_READ_REQ,
@@ -110,9 +113,6 @@ enum bnxt_re_hw_stats {
 	BNXT_RE_TX_CNP,
 	BNXT_RE_RX_CNP,
 	BNXT_RE_RX_ECN,
-	BNXT_RE_REQ_CQE_ERROR,
-	BNXT_RE_RESP_CQE_ERROR,
-	BNXT_RE_RESP_REMOTE_ACCESS_ERRS,
 	BNXT_RE_NUM_EXT_COUNTERS
 };
 
-- 
2.51.0



