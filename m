Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1993303A0D;
	Sat, 17 Oct 2026 16:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256002; cv=none; b=huNis8PKjH8fsDRf4fDmE9k3fAkKpG2JmLfK8HztFmrMOn5DU2O6MuJN3FVxJ620x7DN3ZyoTs/3lIAGomLTuY9cC38wwY99UAi3+WAoW+romrpgeG++gwueXppcGTP9yOd8vDl8jTg76fcA5SrJixcorCH7Aplk1xNPgLpgEII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256002; c=relaxed/simple;
	bh=TYeAodApzjdQ5xJMFBgr+Tyw5BOq91YI4GTgI99ff1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcCegmqNghE/wWzi59OUZ+qEH84uuTR+sdpQ06ByY/AdojPuWgStrRNP8LHYjbhPR5L0aGh77zWEbWnfIhB/XwJwbvpCU55lo3kwfUNLw2uwGLc0cXSwgSpLOqEloYCzBRdm3Qr+Ajlu3ZklH3J2VPU4677a9Y9IVs6wO8luKaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rz121R3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rz121R3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DE51F000C4;
	Sat, 17 Oct 2026 16:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256001;
	bh=wUd/os8iTv2hxxUKgve+JBFBkuHI2TvKDrw+gyK2NIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rz121R3e/9TGLmRwrUeWQa++k99VLhSJttJQ8QrjJsHFCsbGEYW+e5seQUUpeW5L8
	 Z1+HONJG6KIgdt4a9bDeYW+7T04BxJFWopDGGv9EN7ZsxnPkCVgG68n3nweeBhpg0d
	 +uRSO/t5I9tUqB+1REeZMpJ8Moa7lDJ+7WLaxiEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0092/1674] scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error path
Date: Sat, 17 Oct 2026 17:39:24 +0200
Message-ID: <20261017160433.507733213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 6d90f0feb929f6c0f3010f9af4747c7230b75993 ]

When qla2x00_mem_alloc() fails, qla2x00_probe_one() jumps to
probe_hw_failed and calls qla2x00_mem_free(). Several error labels in
qla2x00_mem_alloc() freed adapter members (elsrej.c, purex_dma_pool,
flt, sfp_data, loop_id_map, async_pd, sf_init_cb, ex_init_cb, npiv_info)
but left the pointers dangling. qla2x00_mem_free() then freed them a
second time. Worse, for the dma_pool members it issued
dma_pool_free(ha->s_dma_pool, ...) after s_dma_pool had already been
destroyed and set to NULL at fail_s_dma_pool, dereferencing a NULL pool.

Clear each freed pointer (and its DMA handle) in the error labels so the
subsequent qla2x00_mem_free() skips them.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-13-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ adjusted cleanup context for the missing fail_flt_data block. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ec165cd640336..33395b471e8ba 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4480,25 +4480,40 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 fail_lsrjt:
 	dma_free_coherent(&ha->pdev->dev, ha->elsrej.size,
 			  ha->elsrej.c, ha->elsrej.cdma);
+	ha->elsrej.c = NULL;
+	ha->elsrej.cdma = 0;
 fail_elsrej:
 	dma_pool_destroy(ha->purex_dma_pool);
+	ha->purex_dma_pool = NULL;
 fail_flt:
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
 	    ha->flt, ha->flt_dma);
+	ha->flt = NULL;
+	ha->flt_dma = 0;
 
 fail_flt_buffer:
 	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
 	    ha->sfp_data, ha->sfp_data_dma);
+	ha->sfp_data = NULL;
+	ha->sfp_data_dma = 0;
 fail_sfp_data:
 	kfree(ha->loop_id_map);
+	ha->loop_id_map = NULL;
 fail_loop_id_map:
 	dma_pool_free(ha->s_dma_pool, ha->async_pd, ha->async_pd_dma);
+	ha->async_pd = NULL;
+	ha->async_pd_dma = 0;
 fail_async_pd:
 	dma_pool_free(ha->s_dma_pool, ha->sf_init_cb, ha->sf_init_cb_dma);
+	ha->sf_init_cb = NULL;
+	ha->sf_init_cb_dma = 0;
 fail_sf_init_cb:
 	dma_pool_free(ha->s_dma_pool, ha->ex_init_cb, ha->ex_init_cb_dma);
+	ha->ex_init_cb = NULL;
+	ha->ex_init_cb_dma = 0;
 fail_ex_init_cb:
 	kfree(ha->npiv_info);
+	ha->npiv_info = NULL;
 fail_npiv_info:
 	dma_free_coherent(&ha->pdev->dev, ((*rsp)->length + 1) *
 		sizeof(response_t), (*rsp)->ring, (*rsp)->dma);
-- 
2.53.0



