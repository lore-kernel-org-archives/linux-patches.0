Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC5047045A;
	Sat, 12 Sep 2026 11:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214046; cv=none; b=tnR8Z1QqQqWxwDKJjHrqK3/irN2EEQ3pi/YGLL9pUSacYv6GF/kA/pAbfoqYiO8CGXCBicafuSh3iDHEYBa35eGFz3ztEBfdCs3nKeSG+3WKLjd0gMjYb75uQMVb8lYqgooByzF7UsTcQqb8H8xu0dldL5J+IoVdFhrMsvPo7LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214046; c=relaxed/simple;
	bh=innd4M09cfGFUKIAE4mWvAxPlOa/2Sjv178QGJxnYOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwXYOphe4Aq4qMdhKTSDgNbVWGAHuc8qGaL9NlmuT9dXQI5iCxGkYzHo7yXjgYePxEw4hoz6WjmS3zZUQPssu+BUv/fr6tiYb+wgySlANvHO6ZmDiTPa/mzVOKyDp/x7U+pT9Ju6SnA0q+QLQEicANwDx+aUNqMkI6ygU6+rukU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNAQjXA7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNAQjXA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966181F0089A;
	Sat, 12 Sep 2026 11:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214040;
	bh=XgwzhQlov37FPxyp0+Ni27eJ+H04LF6/zXwaTfrtOOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNAQjXA7tdrD47Rhn0dyUlskAnDsUoEcJkah20R/buJQ2TfOMhB5T32zmqgRWNhXq
	 oUwUl7nx1GdThgJip0SOLLqaXBYyaGKNsTyHYTeSWJsdz99gP1Xdaf7FCVaTo+2Wgp
	 MGVbTn/iT2hWrM6F6W3RLwMxUO2v27MYzvAoGY8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.12 0246/1376] scsi: qla2xxx: Zero-init bsg stack buffers to avoid info leak
Date: Sat, 12 Sep 2026 08:44:32 +0200
Message-ID: <20260912065613.023901067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


