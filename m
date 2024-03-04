Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618EE1C6AB;
	Mon,  4 Mar 2024 21:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588573; cv=none; b=itCCdrE817FPtMqFQ6pt7jJs1w6rBLZ65MlrlwDeEBxXsIkIQkPLiuJFi2wds08UQh2u8HhkB4G7UAaIP4rPXN8KnrfkX6mFJ1e+DocveNjmrz/OcTD2AyRJdxBEFnVeUR3Vp8fOdCyf++UpguB+B0remCm6c4exACbf8ONh/6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588573; c=relaxed/simple;
	bh=tVsRB7KDkvgpr0dcPhxPGobLQm4fv95hL5yVbDb/qi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=de1Nqz79yoZ+EjF4xiI2et6LfACO2Ru/ss4+YcHeS1rf8EL+spm5DwhXAc9MtQ38Yy/OVXdBRBiR2ZQVfWWp7Ouk96oouWovzm79PA6iW57zRrtTNSIcc7GO4O92sYQgWUarUsDdrOh6VzR6WWrsX9XDJHiY4ZNO2T31W0pG9Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obZ3HxrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obZ3HxrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9966FC433F1;
	Mon,  4 Mar 2024 21:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588572;
	bh=tVsRB7KDkvgpr0dcPhxPGobLQm4fv95hL5yVbDb/qi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obZ3HxrZvC7KWUjsQvwFxv31uBDAwb8VGnRsm5d1I3jAKwBkNHw067gbQwhqmpXz2
	 PbUhX7QQLwcqBtNE+BHvsSOvqkG6tkW8kSdL7UzwLcmJuEHPbwCo1kgL/XO2rxpT33
	 48csXKu7L0NhCN8lgZxhVU37zvreuo6z3NdB02iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/215] scsi: core: Add struct for args to execution functions
Date: Mon,  4 Mar 2024 21:21:07 +0000
Message-ID: <20240304211557.139702907@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit d0949565811f0896c1c7e781ab2ad99d34273fdf ]

Move the SCSI execution functions to use a struct for passing in optional
args. This commit adds the new struct, temporarily converts scsi_execute()
and scsi_execute_req() ands a new helper, scsi_execute_cmd(), which takes
the scsi_exec_args struct.

There should be no change in behavior. We no longer allow users to pass in
any request->rq_flags value, but they were only passing in RQF_PM which we
do support by allowing users to pass in the BLK_MQ_REQ flags used by
blk_mq_alloc_request().

Subsequent commits will convert scsi_execute() and scsi_execute_req() users
to the new helpers then remove scsi_execute() and scsi_execute_req().

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 321da3dc1f3c ("scsi: sd: usb_storage: uas: Access media prior to querying device properties")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c    | 52 ++++++++++++++++++--------------------
 include/scsi/scsi_device.h | 51 +++++++++++++++++++++++++++----------
 2 files changed, 62 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5c5954b78585e..edd296f950a33 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -185,39 +185,37 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
-
 /**
- * __scsi_execute - insert request and wait for the result
- * @sdev:	scsi device
+ * scsi_execute_cmd - insert request and wait for the result
+ * @sdev:	scsi_device
  * @cmd:	scsi command
- * @data_direction: data direction
+ * @opf:	block layer request cmd_flags
  * @buffer:	data buffer
  * @bufflen:	len of buffer
- * @sense:	optional sense buffer
- * @sshdr:	optional decoded sense header
  * @timeout:	request timeout in HZ
  * @retries:	number of times to retry request
- * @flags:	flags for ->cmd_flags
- * @rq_flags:	flags for ->rq_flags
- * @resid:	optional residual length
+ * @args:	Optional args. See struct definition for field descriptions
  *
  * Returns the scsi_cmnd result field if a command was executed, or a negative
  * Linux error code if we didn't get that far.
  */
-int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
-		 int timeout, int retries, blk_opf_t flags,
-		 req_flags_t rq_flags, int *resid)
+int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
+		     blk_opf_t opf, void *buffer, unsigned int bufflen,
+		     int timeout, int retries,
+		     const struct scsi_exec_args *args)
 {
+	static const struct scsi_exec_args default_args;
 	struct request *req;
 	struct scsi_cmnd *scmd;
 	int ret;
 
-	req = scsi_alloc_request(sdev->request_queue,
-			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
-			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
+	if (!args)
+		args = &default_args;
+	else if (WARN_ON_ONCE(args->sense &&
+			      args->sense_len != SCSI_SENSE_BUFFERSIZE))
+		return -EINVAL;
+
+	req = scsi_alloc_request(sdev->request_queue, opf, args->req_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -232,8 +230,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	scmd->allowed = retries;
 	req->timeout = timeout;
-	req->cmd_flags |= flags;
-	req->rq_flags |= rq_flags | RQF_QUIET;
+	req->rq_flags |= RQF_QUIET;
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
@@ -249,20 +246,21 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= bufflen))
 		memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);
 
-	if (resid)
-		*resid = scmd->resid_len;
-	if (sense && scmd->sense_len)
-		memcpy(sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
-	if (sshdr)
+	if (args->resid)
+		*args->resid = scmd->resid_len;
+	if (args->sense)
+		memcpy(args->sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+	if (args->sshdr)
 		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
-				     sshdr);
+				     args->sshdr);
+
 	ret = scmd->result;
  out:
 	blk_mq_free_request(req);
 
 	return ret;
 }
-EXPORT_SYMBOL(__scsi_execute);
+EXPORT_SYMBOL(scsi_execute_cmd);
 
 /*
  * Wake up the error handler if necessary. Avoid as follows that the error
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d2751ed536df2..b407807cc6695 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -479,28 +479,51 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
-extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-			int data_direction, void *buffer, unsigned bufflen,
-			unsigned char *sense, struct scsi_sense_hdr *sshdr,
-			int timeout, int retries, blk_opf_t flags,
-			req_flags_t rq_flags, int *resid);
+
+/* Optional arguments to scsi_execute_cmd */
+struct scsi_exec_args {
+	unsigned char *sense;		/* sense buffer */
+	unsigned int sense_len;		/* sense buffer len */
+	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
+	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
+	int *resid;			/* residual length */
+};
+
+int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
+		     blk_opf_t opf, void *buffer, unsigned int bufflen,
+		     int timeout, int retries,
+		     const struct scsi_exec_args *args);
+
 /* Make sure any sense buffer is the correct size. */
-#define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,	\
-		     sshdr, timeout, retries, flags, rq_flags, resid)	\
+#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
+		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
+		     _resid)						\
 ({									\
-	BUILD_BUG_ON((sense) != NULL &&					\
-		     sizeof(sense) != SCSI_SENSE_BUFFERSIZE);		\
-	__scsi_execute(sdev, cmd, data_direction, buffer, bufflen,	\
-		       sense, sshdr, timeout, retries, flags, rq_flags,	\
-		       resid);						\
+	scsi_execute_cmd(_sdev, _cmd, (_data_dir == DMA_TO_DEVICE ?	\
+			 REQ_OP_DRV_OUT : REQ_OP_DRV_IN) | _flags,	\
+			 _buffer, _bufflen, _timeout, _retries,	\
+			 &(struct scsi_exec_args) {			\
+				.sense = _sense,			\
+				.sshdr = _sshdr,			\
+				.req_flags = _rq_flags & RQF_PM  ?	\
+						BLK_MQ_REQ_PM : 0,	\
+				.resid = _resid,			\
+			 });						\
 })
+
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
 	int retries, int *resid)
 {
-	return scsi_execute(sdev, cmd, data_direction, buffer,
-		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
+	return scsi_execute_cmd(sdev, cmd,
+				data_direction == DMA_TO_DEVICE ?
+				REQ_OP_DRV_OUT : REQ_OP_DRV_IN, buffer,
+				bufflen, timeout, retries,
+				&(struct scsi_exec_args) {
+					.sshdr = sshdr,
+					.resid = resid,
+				});
 }
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
-- 
2.43.0



