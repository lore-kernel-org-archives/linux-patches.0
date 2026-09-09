Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFCF3BFAEE;
	Wed,  9 Sep 2026 14:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964227; cv=none; b=mUECbScTc7wJ3fu++790FP4we63cZ8eLI9ERWNGEpzPBnOlNRFX7huonFWXMnc1CgSywCSfwI0Y8VnlBBacZeTH9H9ExpajzHeyaIB55UDzGQUJmtxloBn7BVU2srsChqgF1p2LFngnNhDsESRp6Ba54e6l5OBZzeS3ae35YDdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964227; c=relaxed/simple;
	bh=YiZEeLj9rT+8ZS3pT5HX3iQlmgDBDpVLu8BTJ6ONGAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYKYxH9VJFGiZew6K+P9UNNJ3EO0+mQZE4j1rrUe2w6bLAPxTv9j+ASxEpSWRpjW//+SlQiT1uOpL55juO+JDfxPnAUzI+ureeuwDsyKUGdMUrcmwiux7gmsOiUUJ32GTHosX+fxLrPd1na5te0mw4V/1P6iZqinW3fbI8mzdls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcfOAOIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcfOAOIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1B01F00A3A;
	Wed,  9 Sep 2026 14:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964226;
	bh=Xp7Gz0OqMgHssSspVPniRGwhw8cOo3X1hw/9Ni4sIDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcfOAOILlq9tXyy2Wn6mfJa8LuAX/vWDtxK5zUwK7HaOOrqwU1eK3XfdvE+na24eC
	 pful+9gTs5fl+pJ7e1uGH2/kInNl0QOX1R6kKDU0NMHh8uj//L1NOzsf+4DIglguoQ
	 f6Cby7L9G1T1NqE18pVy4dnsPFCMaeSuqKLsAZq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 349/583] scsi: qla2xxx: Zero-init bsg stack buffers to avoid info leak
Date: Wed,  9 Sep 2026 15:40:34 +0200
Message-ID: <20260909134250.076934267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

commit b93d3bb3afe1b44489927de1eb4e66e8536a5935 upstream.

Several bsg handlers stage their request/reply in an uninitialized 256-byte
on-stack buffer (uint8_t bsg[DMA_POOL_SIZE]) and fill it via
sg_copy_to_buffer(), which only copies as many bytes as the user-supplied
request payload. When the request is shorter than the structure, the
remainder of the buffer is left holding stale stack data.

qla2x00_read_fru_status() and qla2x00_read_i2c() then copy the full
structure back to the reply payload with sg_copy_from_buffer(), leaking the
uninitialized stack bytes to user space. The write/update paths do not copy
the buffer back, but can feed uninitialized fields to the device.

Zero the stack buffer at declaration in all five handlers, mirroring the
heap kzalloc() approach, so short requests can no longer expose stale
memory.

Fixes: 697a4bc69159 ("[SCSI] qla2xxx: Provide method for updating I2C attached VPD.")
Fixes: 9ebb5d9c69f1 ("[SCSI] qla2xxx: Add I2C BSG interface.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-30-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1560,7 +1560,7 @@ qla2x00_update_fru_versions(struct bsg_j
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_image_version_list *list = (void *)bsg;
 	struct qla_image_version *image;
 	uint32_t count;
@@ -1620,7 +1620,7 @@ qla2x00_read_fru_status(struct bsg_job *
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
@@ -1671,7 +1671,7 @@ qla2x00_write_fru_status(struct bsg_job
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
@@ -1718,7 +1718,7 @@ qla2x00_write_i2c(struct bsg_job *bsg_jo
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
@@ -1770,7 +1770,7 @@ qla2x00_read_i2c(struct bsg_job *bsg_job
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
-	uint8_t bsg[DMA_POOL_SIZE];
+	uint8_t bsg[DMA_POOL_SIZE] = {};
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
 	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);


