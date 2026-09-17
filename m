Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234513AEF54;
	Thu, 17 Sep 2026 17:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666892; cv=none; b=HLq9w/ueONZjuDkxfVg4jujoZxxojcNVxR/ibkPBqLbzsh8XuOIRUh23hArS5zHdWxv4wKTjGxJwSu3Sv5bcINl8JhPcM3B9azpy8IRdl1JeRpahH/Vg5zMjtolpcQZjn727cMgESyM9lbjq1aCO03rT4mxo8fcyqNGqPvZyZs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666892; c=relaxed/simple;
	bh=NS1c9Q1eWAwOMiy4+J+pkBLFwqmKy2vlCkWptoAOfsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvyyALNVxZpDDf45BI1x5bZe5ur51O3+ng9D7/jJ7E91vT82sJCe2zO+jV0aazvi1/XRLMRwq+GjAx3dgQsQq7iy/mkh/ntXFRd3c5z3bza2mQ+2nPts313n163m5CkXqlAMyJ+yhOq2Ui5fD2N7texBYQLZ3Aqn//oI720KTvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emSWh1Vj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emSWh1Vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF6E1F00898;
	Thu, 17 Sep 2026 17:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666891;
	bh=IA5LQuKLVc2ujFWjyA1PNpvlCcCzoeEIFiY4/ph1FLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emSWh1VjmGtsx86gbjN5+nWHqwrzdqplADVvia1vKEB4i+ejneuDQv4NxtAiOCdJi
	 iH2pQ/J35L035pwfhskibm92EXb/pMbOleBBhvzeKLT4xszIMix7gnwyUbj9PuHzq6
	 9UWh76Ziqrp61LCDH0BosMiD9Ujr1cf15LpG7TgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1160/1250] scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error path
Date: Thu, 17 Sep 2026 16:15:55 +0100
Message-ID: <20260917151623.710349624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4486,25 +4486,40 @@ qla2x00_mem_alloc(struct qla_hw_data *ha
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


