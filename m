Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55423477E21;
	Sat, 12 Sep 2026 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228449; cv=none; b=rsPI1iNcKqaNcp9tG1AQwcSnzjcSst5ZDjpJPjWaCcAAAANJunUUBVwGD1Mrd2TNGockJ+YGIr+Ysd0LQFsWNpmx90p6jUTLtmFJCKa9uv3q+EFHYNWHaMPPaFNqscFBaJzveaFP2aa5eZu7L/p/XmCW7qvpOoymat5sb0kCIVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228449; c=relaxed/simple;
	bh=kl7qmvhfa2tkmNx4CslMaN+dNgNMN+JV4sDZSiHkgZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLa/MlOCPdFY0mCZ9hvy0rCTyXczojC6Me/OsZC0RMNzBfSacBSUyQJ67jLgNHJ1uysjHk8eaMNU1Hlw0BjQSxZ3Z4Thk/bys8OjBwUJEiArO3xo01OQGqu/JqaUtL/rgaJN+09fIlVw4xpqBaHQtAcP84SoI+V6Y/nCcc64s90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uzwCu1q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uzwCu1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C653B1F000FF;
	Sat, 12 Sep 2026 15:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228446;
	bh=u+U61mLkYRDbVh6/abHsyHjdQD4cCTswjIdBEfIqVS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0uzwCu1qM/gRGTH+9Rh8yBnpbj9NHpB76z7P2VJ8G1CGkCRKXwa3KujyUjRVG81V9
	 SGDFvnVewLgnDQM0xSTCGmFivuUXryO05Dlm9cH0TGSxOH2G10dKdnxccWNv/vj7SV
	 lwhx/TsxjvhNFfE4p0/QN8ctqtTUizP/rwlXvrOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 0388/1191] scsi: qla2xxx: Zero SFP DMA buffer in FRU/I2C bsg handlers
Date: Sat, 12 Sep 2026 08:51:56 +0200
Message-ID: <20260912065556.953341149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit b47d4a1547d9ef21b2e9d1a739fe2204d4be05dc upstream.

The FRU and I2C bsg handlers stage their transfer in a DMA_POOL_SIZE
(256-byte) bounce buffer obtained from dma_pool_alloc(), which does not
zero the allocation. They initialize only a few leading bytes before
handing the buffer to qla2x00_write_sfp().

qla2x00_write_sfp() can override the transfer length with a user-supplied
value:

	if (len == 1)
		opt |= BIT_0;
	if (opt & BIT_0)
		len = *sfp;

*sfp is the first byte of the (user-controlled) payload, so len can grow
up to 255. The device then DMA-reads len bytes from the 256-byte pool
buffer. Since only a small prefix was written
(e.g. MAX_FRU_SIZE == 36 bytes for a FRU version, one byte for a FRU
status register), the hardware reads past the initialized region and
writes up to ~219 bytes of stale DMA-pool heap memory to the device
flash.

Allocate the buffer with dma_pool_zalloc() in all five FRU/I2C handlers
so any bytes beyond the initialized data are zero rather than stale heap
contents.

Fixes: 697a4bc69159 ("[SCSI] qla2xxx: Provide method for updating I2C attached VPD.")
Fixes: 9ebb5d9c69f1 ("[SCSI] qla2xxx: Add I2C BSG interface.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-32-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1565,7 +1565,7 @@ qla2x00_update_fru_versions(struct bsg_j
 	struct qla_image_version *image;
 	uint32_t count;
 	dma_addr_t sfp_dma;
-	void *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	void *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -1616,7 +1616,7 @@ qla2x00_read_fru_status(struct bsg_job *
 	uint8_t bsg[DMA_POOL_SIZE];
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -1667,7 +1667,7 @@ qla2x00_write_fru_status(struct bsg_job
 	uint8_t bsg[DMA_POOL_SIZE];
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -1714,7 +1714,7 @@ qla2x00_write_i2c(struct bsg_job *bsg_jo
 	uint8_t bsg[DMA_POOL_SIZE];
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -1760,7 +1760,7 @@ qla2x00_read_i2c(struct bsg_job *bsg_job
 	uint8_t bsg[DMA_POOL_SIZE];
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =


