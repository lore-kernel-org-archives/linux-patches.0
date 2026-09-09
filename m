Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13B4559CB4;
	Wed,  9 Sep 2026 13:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961797; cv=none; b=EbfmfEC/kN/EWeQIzaKiLXje8SeAGL5sr/wBp7OlEMyxlFCXQv0QdSji4FnVEqL3WeUzobK6OZMdxnn4AXfgNEntuRd6cWn4rwE5HCttpXVZiH6hAJnFQsSsMmB4Hg0Ty0d+ju472KopD5ui4an6tRbgM53+1f/b4MfoZC7L1x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961797; c=relaxed/simple;
	bh=yOqw5030D7LlpzR6yQCUOMwSjXrnejlTaZn9XP1b9Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXR1FYshLuOQwMqMjgw6tQex5edoao9GOV82eF9htG0QGbSBhAP/6mNleljToRSd3oZFshZiQKu5WR9jv1I244cYoQCxWRCte3NB1hzKSQ1/yOlVQsmrqVK/PUhbSaroQrDPLCXPXcprBYzCKBIAeF2zx8PusyoCk3UjUPFw7CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwwCNLHM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwwCNLHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385071F00A3A;
	Wed,  9 Sep 2026 13:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961795;
	bh=68DaZmEusISBmOq4SOLBq5X9FYOIJVsFCE5haXDRo1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wwwCNLHMfzLD0qADn268h0fE4IlQPiqmpKyltQUniY0T/ltwoS9QhwKXxTSpm/T1j
	 WPwqAEOpD8aec87NjXz3Sg583k08qTSUsbPDmUgr5W/9isEEAEQe5pi5Uwld3avBdG
	 K+Sq/+AIPQbBh5PG57GYx1yawiztgtuu/Sqd0o2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Chandelkar <rc@rexion.ai>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 069/556] scsi: bsg: Fix TOCTOU in io_uring passthrough command setup
Date: Wed,  9 Sep 2026 15:35:49 +0200
Message-ID: <20260909134232.889182152@linuxfoundation.org>
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

From: Rahul Chandelkar <rc@rexion.ai>

commit 4b3c5965fca99f62d31c963294bd5b23cc488e97 upstream.

scsi_bsg_uring_cmd() reads bsg_uring_cmd from the shared mmap'd SQE.
Userspace can change a field after we check it and before we use it.
request_len is the sharp case: it can grow past sizeof(scmd->cmnd) after
the bound check and overflow scmd->cmnd in copy_from_user().

READ_ONCE() the SQE fields we check or use into locals before use.

Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260527105931.3950913-1-rc@rexion.ai
Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
Co-developed-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20260817080730.967879-3-yangxiuwei@kylinos.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_bsg.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index b3c4b1063d6f..5eec248a77a6 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -77,12 +77,10 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct request *req,
 
 static int scsi_bsg_map_user_buffer(struct request *req,
 				    struct io_uring_cmd *ioucmd,
-				    unsigned int issue_flags, gfp_t gfp_mask)
+				    unsigned int issue_flags, gfp_t gfp_mask,
+				    bool is_write, u64 buf_addr,
+				    unsigned long buf_len)
 {
-	const struct bsg_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
-	bool is_write = cmd->dout_xfer_len > 0;
-	u64 buf_addr = is_write ? cmd->dout_xferp : cmd->din_xferp;
-	unsigned long buf_len = is_write ? cmd->dout_xfer_len : cmd->din_xfer_len;
 	struct iov_iter iter;
 	int ret;
 
@@ -105,21 +103,28 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 			       unsigned int issue_flags, bool open_for_write)
 {
 	struct scsi_bsg_uring_cmd_pdu *pdu = scsi_bsg_uring_cmd_pdu(ioucmd);
-	const struct bsg_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
+	const struct bsg_uring_cmd *cmd =
+		io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
 	struct scsi_cmnd *scmd;
 	struct request *req;
 	blk_mq_req_flags_t blk_flags = 0;
 	gfp_t gfp_mask = GFP_KERNEL;
+	u64 request = READ_ONCE(cmd->request);
+	u32 request_len = READ_ONCE(cmd->request_len);
+	u64 dout_xferp = READ_ONCE(cmd->dout_xferp);
+	u32 dout_xfer_len = READ_ONCE(cmd->dout_xfer_len);
+	u64 din_xferp = READ_ONCE(cmd->din_xferp);
+	u32 din_xfer_len = READ_ONCE(cmd->din_xfer_len);
 	int ret;
 
 	if (cmd->protocol != BSG_PROTOCOL_SCSI ||
 	    cmd->subprotocol != BSG_SUB_PROTOCOL_SCSI_CMD)
 		return -EINVAL;
 
-	if (!cmd->request || cmd->request_len == 0)
+	if (!request || request_len == 0)
 		return -EINVAL;
 
-	if (cmd->dout_xfer_len && cmd->din_xfer_len) {
+	if (dout_xfer_len && din_xfer_len) {
 		pr_warn_once("BIDI support in bsg has been removed.\n");
 		return -EOPNOTSUPP;
 	}
@@ -132,20 +137,20 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 		gfp_mask = GFP_NOWAIT;
 	}
 
-	req = scsi_alloc_request(q, cmd->dout_xfer_len ?
+	req = scsi_alloc_request(q, dout_xfer_len ?
 				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN, blk_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
 	scmd = blk_mq_rq_to_pdu(req);
-	if (cmd->request_len > sizeof(scmd->cmnd)) {
+	if (request_len > sizeof(scmd->cmnd)) {
 		ret = -EINVAL;
 		goto out_free_req;
 	}
-	scmd->cmd_len = cmd->request_len;
+	scmd->cmd_len = request_len;
 	scmd->allowed = SG_DEFAULT_RETRIES;
 
-	if (copy_from_user(scmd->cmnd, uptr64(cmd->request), cmd->request_len)) {
+	if (copy_from_user(scmd->cmnd, uptr64(request), request_len)) {
 		ret = -EFAULT;
 		goto out_free_req;
 	}
@@ -158,8 +163,14 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 	pdu->response_addr = cmd->response;
 	pdu->max_response_len = cmd->max_response_len;
 
-	if (cmd->dout_xfer_len || cmd->din_xfer_len) {
-		ret = scsi_bsg_map_user_buffer(req, ioucmd, issue_flags, gfp_mask);
+	if (dout_xfer_len || din_xfer_len) {
+		bool is_write = dout_xfer_len > 0;
+		u64 buf_addr = is_write ? dout_xferp : din_xferp;
+		unsigned long buf_len = is_write ? dout_xfer_len : din_xfer_len;
+
+		ret = scsi_bsg_map_user_buffer(req, ioucmd, issue_flags,
+					       gfp_mask, is_write, buf_addr,
+					       buf_len);
 		if (ret)
 			goto out_free_req;
 		pdu->bio = req->bio;
-- 
2.55.0



