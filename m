Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6377956E04E;
	Wed,  9 Sep 2026 14:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962804; cv=none; b=YxSyYzLbH9Kvp+dmdhed+5kKrMFL0RiGHhwcGeb5FLsWWtasQi7Eqr5PZe3XO13N0PYfokQeeOYFf2uetAhNFTkGwMbqNLUYSyMsfmcQDsVeKjB8B84leXp34Usb6NtsxbcNYXQbg5HDrFnQ5Y1XedQBUYg8Kj0o+IQUj6JgHk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962804; c=relaxed/simple;
	bh=y0JI5jhXccVYaRrNVCeBSELiiJsCcZVOonikcUiAeck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqxXSfahHSKfYMSbmqAB4U7QGNGukxJzTyEjNKy6nzbQkArJ9eob84sUAIHXxNqz8LkGU5vok9jzgEObKiAM3//X+QpzUdqeEZFdUVHPWxPYRCbKZZsg6g6iFn1qThbH/CZFtQHAU3Mdwr5FdCYmIxz2I0gz+5w0nxwQDqewwGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g23A2Y/R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g23A2Y/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E281F00A3A;
	Wed,  9 Sep 2026 14:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962803;
	bh=Wu/qYDICvY/3vZu5KzuAN3qT1NbSEYrBIsu8vyHv+to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g23A2Y/RT9wDjvJlpQC89aWxmYZrr4WJV38XkN7Yomo+cQA6OLZEKdQLvylcB6HSg
	 7467oMtsLkzbq/JemKknQawh+wZmj5tHV6gQOtHJE/ZE3DsJr5nwxDi/O6a8kLOflu
	 FVHD+n43L5Ntcfb6zxihw4sIPrsaYrO3uwILH8hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 416/556] scsi: qla2xxx: Zero SFP DMA buffer in FRU/I2C bsg handlers
Date: Wed,  9 Sep 2026 15:41:36 +0200
Message-ID: <20260909134245.238123544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1567,7 +1567,7 @@ qla2x00_update_fru_versions(struct bsg_j
 	struct qla_image_version *image;
 	uint32_t count;
 	dma_addr_t sfp_dma;
-	void *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	void *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -1618,7 +1618,7 @@ qla2x00_read_fru_status(struct bsg_job *
 	uint8_t bsg[DMA_POOL_SIZE];
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -1669,7 +1669,7 @@ qla2x00_write_fru_status(struct bsg_job
 	uint8_t bsg[DMA_POOL_SIZE];
 	struct qla_status_reg *sr = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -1716,7 +1716,7 @@ qla2x00_write_i2c(struct bsg_job *bsg_jo
 	uint8_t bsg[DMA_POOL_SIZE];
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
@@ -1762,7 +1762,7 @@ qla2x00_read_i2c(struct bsg_job *bsg_job
 	uint8_t bsg[DMA_POOL_SIZE];
 	struct qla_i2c_access *i2c = (void *)bsg;
 	dma_addr_t sfp_dma;
-	uint8_t *sfp = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
+	uint8_t *sfp = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
 
 	if (!sfp) {
 		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =


