Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210182;
	b=pVwEXGj6/Vy9PO66y64Oh93E2E9pIg52NrEa575mDNNSAUWQ+o26GB3B1g65UK6EfoOK
	 EYaSYnrOya2Ao4lSmVMVcdfG6QYekGfJGE4ymZdxKC9shfG4SKzd1VqC4Ei0Ptp8RZKFP
	 juUplrczNMR7TKoWX8v9umBFv5684JAoA4dJ3XvAv2IeOLtQNyfJsK64MJq5qIq/TqBht
	 YtJQ76He8gI2kE1NnLg4R/nVTbsdwGJnsCs3aTA3lpvjgHCzcpS6fJ5bpT0zRZ3T2nVyj
	 tUDPVA8knUymLoeFE/Ri0mxkbJ43Llx4a+ezaId6gtE7u/ypIBNVHYLkKFMPvWF2Q+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4cI8I8Ko1Rc3/o6cDIBq81W8zIeSZ+NeZoVz7FknoJc=;
	b=K65HWQcFNR28W71Ev0PhmxFaambusqp9IMii9jHKTbsPkGzbs3BYOYp6rGrpfeRwDRiM
	 cODSYBn1YK2VgfgI8M6/AK+e6XsnLcr26PLuPSOL46w1UTsYNG77DNrdulwwkc4kLjs5T
	 xHEMB/i1PAd/sutnyWbLqmSgYKczgL2fGWDtI6R0WOZuZAOQy0WnfJ0M9pAY0D3ZXGOA1
	 Rmf/YEvPgdOTWKsv21PE0WA2iNt2UpWYCOAIr4LsAcG0NBmiUr7MtfcJDNsNtcCgUdf/8
	 hX3L9VtsENfNjneyz4rmUlxEJ/RTFfxY/OAjEQMHfPjeTlAQ6EoG69FWmnT5kJWPnkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vq1L+JWU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34CA60A2633;
	Wed, 28 Oct 2026 17:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vq1L+JWU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F298F1F01825;
	Wed, 28 Oct 2026 17:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210181;
	bh=4cI8I8Ko1Rc3/o6cDIBq81W8zIeSZ+NeZoVz7FknoJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vq1L+JWUe609jyGlQJNBjlYiyWWYSDFo9qVvW4xa6e9ydk6YnJeeW4EScezYeCpEo
	 VDULMShBib9KrqbotHppO28K1xlgNLuWaJkqedeNj1f4NoBtUFhw94CLPj67DOpxCq
	 dN+IGtrzBpeepJwG9+gxLlqWbJn75URFhI5jcSQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Jhu <stanleyjhu@google.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/168] scsi: bsg: Pass reply_len to bsg_setup_queue() to fit UFS ARPMB replies
Date: Wed, 28 Oct 2026 18:00:34 +0100
Message-ID: <20261028165945.407203014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit ec6b083915e8146e147314a5f4f1285d07b57bfc ]

bsg-lib allocates a 96-byte (SCSI_SENSE_BUFFERSIZE) reply buffer per
job, but struct ufs_rpmb_reply is 104 bytes: a 40-byte struct
ufs_bsg_reply followed by a 64-byte EHS. When an Advanced RPMB command
returns an EHS, ufshcd_advanced_rpmb_req_handler() copies it right after
the 40-byte header and writes 8 bytes past the end of the buffer.

Let each BSG transport pass its reply buffer size to bsg_setup_queue()
and have ufs_bsg request sizeof(struct ufs_rpmb_reply), so the full
reply reaches user space. Other transports keep SCSI_SENSE_BUFFERSIZE.

Fixes: 6ff265fc5ef6 ("scsi: ufs: core: bsg: Add advanced RPMB support in ufs_bsg")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Link: https://patch.msgid.link/20261013132708.1669415-1-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ sashal: Adapted bsg_setup_queue() and its callers to the existing interface without a queue-limits parameter. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bsg-lib.c                     | 13 ++++++++++---
 drivers/scsi/mpi3mr/mpi3mr_app.c    |  2 +-
 drivers/scsi/scsi_transport_fc.c    |  5 +++--
 drivers/scsi/scsi_transport_iscsi.c |  3 ++-
 drivers/scsi/scsi_transport_sas.c   |  6 ++++--
 drivers/ufs/core/ufs_bsg.c          |  3 ++-
 include/linux/bsg-lib.h             |  3 ++-
 7 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index b3acdbdb6e7ea..5df816a0a58ee 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -23,11 +23,14 @@ struct bsg_set {
 	struct bsg_device	*bd;
 	bsg_job_fn		*job_fn;
 	bsg_timeout_fn		*timeout_fn;
+	unsigned int		reply_len;
 };
 
 static int bsg_transport_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 		bool open_for_write, unsigned int timeout)
 {
+	struct bsg_set *bset =
+		container_of(q->tag_set, struct bsg_set, tag_set);
 	struct bsg_job *job;
 	struct request *rq;
 	struct bio *bio;
@@ -50,7 +53,7 @@ static int bsg_transport_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	reply = job->reply;
 	memset(job, 0, sizeof(*job));
 	job->reply = reply;
-	job->reply_len = SCSI_SENSE_BUFFERSIZE;
+	job->reply_len = bset->reply_len;
 	job->dd_data = job + 1;
 
 	job->request_len = hdr->request_len;
@@ -301,9 +304,10 @@ static blk_status_t bsg_queue_rq(struct blk_mq_hw_ctx *hctx,
 static int bsg_init_rq(struct blk_mq_tag_set *set, struct request *req,
 		       unsigned int hctx_idx, unsigned int numa_node)
 {
+	struct bsg_set *bset = container_of(set, struct bsg_set, tag_set);
 	struct bsg_job *job = blk_mq_rq_to_pdu(req);
 
-	job->reply = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+	job->reply = kzalloc(bset->reply_len, GFP_KERNEL);
 	if (!job->reply)
 		return -ENOMEM;
 	return 0;
@@ -357,9 +361,11 @@ static const struct blk_mq_ops bsg_mq_ops = {
  * @job_fn: bsg job handler
  * @timeout: timeout handler function pointer
  * @dd_job_size: size of LLD data needed for each job
+ * @reply_len: size of the reply buffer needed for each job
  */
 struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
-		bsg_job_fn *job_fn, bsg_timeout_fn *timeout, int dd_job_size)
+		bsg_job_fn *job_fn, bsg_timeout_fn *timeout, int dd_job_size,
+		unsigned int reply_len)
 {
 	struct bsg_set *bset;
 	struct blk_mq_tag_set *set;
@@ -372,6 +378,7 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 
 	bset->job_fn = job_fn;
 	bset->timeout_fn = timeout;
+	bset->reply_len = reply_len;
 
 	set = &bset->tag_set;
 	set->ops = &bsg_mq_ops;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 27fcffa94713b..fdec01d4bcee3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1551,7 +1551,7 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 	}
 
 	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev),
-			mpi3mr_bsg_request, NULL, 0);
+			mpi3mr_bsg_request, NULL, 0, SCSI_SENSE_BUFFERSIZE);
 	if (IS_ERR(q)) {
 		ioc_err(mrioc, "%s: bsg registration failed\n",
 		    dev_name(bsg_dev));
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index fd827e30556b1..8d53a6717da81 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -4293,7 +4293,7 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 		 "fc_host%d", shost->host_no);
 
 	q = bsg_setup_queue(dev, bsg_name, fc_bsg_dispatch, fc_bsg_job_timeout,
-				i->f->dd_bsg_size);
+				i->f->dd_bsg_size, SCSI_SENSE_BUFFERSIZE);
 	if (IS_ERR(q)) {
 		dev_err(dev,
 			"fc_host%d: bsg interface failed to initialize - setup queue\n",
@@ -4324,7 +4324,8 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
 		return -ENOTSUPP;
 
 	q = bsg_setup_queue(dev, dev_name(dev), fc_bsg_dispatch_prep,
-				fc_bsg_job_timeout, i->f->dd_bsg_size);
+				fc_bsg_job_timeout, i->f->dd_bsg_size,
+				SCSI_SENSE_BUFFERSIZE);
 	if (IS_ERR(q)) {
 		dev_err(dev, "failed to setup bsg queue\n");
 		return PTR_ERR(q);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 22bec2453bac9..7cc99d213ce22 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1542,7 +1542,8 @@ iscsi_bsg_host_add(struct Scsi_Host *shost, struct iscsi_cls_host *ihost)
 		return -ENOTSUPP;
 
 	snprintf(bsg_name, sizeof(bsg_name), "iscsi_host%d", shost->host_no);
-	q = bsg_setup_queue(dev, bsg_name, iscsi_bsg_host_dispatch, NULL, 0);
+	q = bsg_setup_queue(dev, bsg_name, iscsi_bsg_host_dispatch, NULL, 0,
+			SCSI_SENSE_BUFFERSIZE);
 	if (IS_ERR(q)) {
 		shost_printk(KERN_ERR, shost, "bsg interface failed to "
 			     "initialize - no request queue\n");
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index ce69240accb28..edb9b853c938b 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -199,7 +199,8 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 
 	if (rphy) {
 		q = bsg_setup_queue(&rphy->dev, dev_name(&rphy->dev),
-				sas_smp_dispatch, NULL, 0);
+				sas_smp_dispatch, NULL, 0,
+				SCSI_SENSE_BUFFERSIZE);
 		if (IS_ERR(q))
 			return PTR_ERR(q);
 		rphy->q = q;
@@ -208,7 +209,8 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 
 		snprintf(name, sizeof(name), "sas_host%d", shost->host_no);
 		q = bsg_setup_queue(&shost->shost_gendev, name,
-				sas_smp_dispatch, NULL, 0);
+				sas_smp_dispatch, NULL, 0,
+				SCSI_SENSE_BUFFERSIZE);
 		if (IS_ERR(q))
 			return PTR_ERR(q);
 		to_sas_host_attrs(shost)->q = q;
diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 0043d69077b64..df31f89b9666f 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -256,7 +256,8 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
-	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), ufs_bsg_request, NULL, 0);
+	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), ufs_bsg_request, NULL, 0,
+			sizeof(struct ufs_rpmb_reply));
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
 		device_del(bsg_dev);
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 9e97ced2896df..1c6b057c6412c 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -65,7 +65,8 @@ struct bsg_job {
 void bsg_job_done(struct bsg_job *job, int result,
 		  unsigned int reply_payload_rcv_len);
 struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
-		bsg_job_fn *job_fn, bsg_timeout_fn *timeout, int dd_job_size);
+		bsg_job_fn *job_fn, bsg_timeout_fn *timeout, int dd_job_size,
+		unsigned int reply_len);
 void bsg_remove_queue(struct request_queue *q);
 void bsg_job_put(struct bsg_job *job);
 int __must_check bsg_job_get(struct bsg_job *job);
-- 
2.53.0



