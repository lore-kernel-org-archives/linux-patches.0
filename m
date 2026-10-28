Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210435;
	b=zhnAylN0gypa7mwTDw6FsshkLzxxfYLfifXEwsBIx/T2Miv4mxJ9YWyhf/1/8MVN0YE+
	 cw/qUG6l84VT+s3HskQSz8L6vFoIwUk7C8vESNH2hzb87R2FsJmeDLJ5SOBWLRD4YQih+
	 uuI2VhA7L9wFlsoO6Bo4yyIu8S1OxRrH2naHLO7t13d5Qr0GYf5XISOnRWApqjFywnVLT
	 WoqkYgrcNTAoo1LD+mxNRlRXOrnhfM+UUjlDb1BT9FuGez91sqahjSiS9gK+r1Ip+2aME
	 xl0kwpeykA6yIXP6oGj38hNV3yiwC60qqA0LVq9LSP+GWFZdbQ1P22pdDww5n2EoFGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MAKvQv/QkNutGt56Ay1Z1S7udbvGWzcOt1N66O0z9/M=;
	b=0sj8qdp91MJHTSd1aS8xpalLSiGqojo+G8st+enSV77RWMW5cmbEbCIewUmYwhHF10JM
	 ZncOalZI5GSDhBVPzXNzN1upv2dK4d1WdOTbYVV9T6Y9wNyz3+b33YKo9MHGZ5kXOeHKG
	 7O4XzNtOvsoudcv6goJkanMQ+TtJ9vXbrK7OHORK650qpptlBKW4Y0/kha4+hLMLhpJM+
	 UpgmrAmuh8rO2Dy3g25opkZoI76/c6M72o5xOzgXZ92BVO75L5rc3d9MRVTh5SYhQ3QNg
	 J911MVAMZ6OKbA4lZ1IZAY+FZz0VyTB+ooVDkWUXBi09LsTKYxJKsb86/PSgl1AclnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfcs7L91;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EDE606A31C;
	Wed, 28 Oct 2026 18:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfcs7L91
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743181F01825;
	Wed, 28 Oct 2026 18:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210435;
	bh=MAKvQv/QkNutGt56Ay1Z1S7udbvGWzcOt1N66O0z9/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfcs7L91mo8hntOCOPJYP2jYVIzb++qLj/K+9Q/k++6e6tqxbDrwhp+sXfHHFHQ+b
	 +7GLUEQp0waaeNnXQAIBnz/Nchz1TDN4ywQQVbpgH5oEPTql4aPWm3LyK4dYopPW3d
	 pGIQrdXBnsV+3gyGIbjvSD5ITHeQJSo/msXYonHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/571] scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]
Date: Wed, 28 Oct 2026 17:52:52 +0100
Message-ID: <20261028170008.619727470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 4cf38dd9465736141263ebb63375868311a0ec81 ]

The FC BSG transport allocates job->request via memdup_user() using the
exact user-supplied request_len. For FC_BSG_HST_VENDOR,
fc_bsg_host_dispatch() only guarantees request_len covers msgcode and
vendor_id; it does not account for the vendor_cmd[] flexible array.

qla2xxx then reads the command selector vendor_cmd[0] and, in several
sub-handlers, vendor_cmd[1]/[2] or structures overlaid on the vendor
command area without verifying request_len. A caller holding
CAP_SYS_RAWIO can submit a short request whose vendor_id matches the
host, triggering out-of-bounds heap reads (KASAN-detectable, and able to
mis-select a command or panic).

Add a central guard in qla2x00_process_vendor_specific() so the selector
is always in bounds, restrict the early vendor_cmd[0] read in
qla24xx_bsg_request() to sufficiently long vendor messages, and add
request_len checks to the sub-handlers that read further:
qla24xx_proc_fcp_prio_cfg_cmd(), qla2x00_process_loopback(),
qla84xx_reset(), qla84xx_updatefw(), qla2x00_read_optrom(),
qla2x00_update_optrom(), qlafx00_mgmt_cmd() and
qla28xx_validate_flash_image().

Fixes: 01e0e15c8b3b ("scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-31-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ adapted hunks to the existing OPTROM helper and absence of qla28xx_validate_flash_image(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 45 ++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 27a97d254e33a..b2ab0e3db3352 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -158,6 +158,12 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 		goto exit_fcp_prio_cfg;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t)) {
+		ret = -EINVAL;
+		goto exit_fcp_prio_cfg;
+	}
+
 	/* Get the sub command */
 	oper = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
@@ -756,6 +762,10 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 		return -EIO;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 3 * sizeof(uint32_t))
+		return -EINVAL;
+
 	memset(&elreq, 0, sizeof(elreq));
 
 	elreq.req_sg_cnt = dma_map_sg(&ha->pdev->dev,
@@ -988,6 +998,10 @@ qla84xx_reset(struct bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	flag = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 	rval = qla84xx_reset_chip(vha, flag == A84_ISSUE_RESET_DIAG_FW);
@@ -1032,6 +1046,10 @@ qla84xx_updatefw(struct bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	if (!sg_cnt) {
@@ -1482,6 +1500,10 @@ qla2x00_read_optrom(struct bsg_job *bsg_job)
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	if (ha->flags.nic_core_reset_hdlr_active)
 		return -EBUSY;
 
@@ -1519,6 +1541,10 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	mutex_lock(&ha->optrom_mutex);
 	rval = qla2x00_optrom_setup(bsg_job, vha, 1);
 	if (rval) {
@@ -2010,6 +2036,11 @@ qlafx00_mgmt_cmd(struct bsg_job *bsg_job)
 	struct fc_port *fcport;
 	char  *type = "FC_BSG_HST_FX_MGMT";
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + sizeof(uint32_t) +
+	    sizeof(struct qla_mt_iocb_rqst_fx00))
+		return -EINVAL;
+
 	/* Copy the IOCB specific information */
 	piocb_rqst = (struct qla_mt_iocb_rqst_fx00 *)
 	    &bsg_request->rqst_data.h_vendor.vendor_cmd[1];
@@ -2812,6 +2843,13 @@ qla2x00_process_vendor_specific(struct scsi_qla_host *vha, struct bsg_job *bsg_j
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + sizeof(uint32_t)) {
+		ql_log(ql_log_warn, vha, 0x7000,
+		       "BSG request too small for vendor cmd.\n");
+		return -EINVAL;
+	}
+
 	ql_dbg(ql_dbg_edif, vha, 0x911b, "%s FC_BSG_HST_VENDOR cmd[0]=0x%x\n",
 	    __func__, bsg_request->rqst_data.h_vendor.vendor_cmd[0]);
 
@@ -2931,8 +2969,11 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
 	}
 
 	/* Disable port will bring down the chip, allow enable command */
-	if (bsg_request->rqst_data.h_vendor.vendor_cmd[0] == QL_VND_MANAGE_HOST_PORT ||
-	    bsg_request->rqst_data.h_vendor.vendor_cmd[0] == QL_VND_GET_HOST_STATS)
+	if (bsg_request->msgcode == FC_BSG_HST_VENDOR &&
+	    bsg_job->request_len >=
+		sizeof(struct fc_bsg_request) + sizeof(uint32_t) &&
+	    (bsg_request->rqst_data.h_vendor.vendor_cmd[0] == QL_VND_MANAGE_HOST_PORT ||
+	     bsg_request->rqst_data.h_vendor.vendor_cmd[0] == QL_VND_GET_HOST_STATS))
 		goto skip_chip_chk;
 
 	if (vha->hw->flags.port_isolated) {
-- 
2.53.0



