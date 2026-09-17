Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4B04F3921;
	Thu, 17 Sep 2026 16:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660833; cv=none; b=enYLTgU9vy1WX66QdhlO81HqTkxSd6Z5F/NZjaqEkkppGKWNPYQGjLUrY0ITEiUkBul1rRrTACs3oWWv2xlNR8GGNYStk8gNq9HURg6JXO8iY0PO0TyoEA5I1y134kP80iI3EPJrFiVSUofQv+mTSsdvMPDxZHoaD0aMruAPMqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660833; c=relaxed/simple;
	bh=fQ0BfkiHWxkMnq7+ZbggYk1XYt24EtMc8QbeQoFI1Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5kTOyPP3ufh2VbV/QN44ADdemFR0n+MaFyoDcUB8qv8RRMqT6Gab4h8puYr4YhHQ1FhcIRQL4VD7TRc/4wVgZjOQou9vJ+O9GuVox7C8nEWjpeo8bc6MTg6jmXE4F/gdBKWl2EWwlezHwHeMV0RQ1MqxYJ3UOM/8GOA1xI4Fb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkBHAwAH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkBHAwAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCFB1F000FF;
	Thu, 17 Sep 2026 16:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660832;
	bh=mGXpg4WcsbGdVIWz1++5jBM2qY7QnmJN36DfIztAQvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MkBHAwAH1N9ezYoC0pOl9mZE/0m3NM9N1vs2ZukvJ5F6KhXXfl/JtVUBP+2EbyZEJ
	 XqB92fpdJwEA7txmCWvQPcIk/VpKSDw3yUb2FbHQgRZhMhTLP11j+brdZKh30MGR4O
	 hCeav44hxUtmiJjXpa0O14CH/PlFHQwEfV/lFeUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 723/733] scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]
Date: Thu, 17 Sep 2026 16:17:11 +0100
Message-ID: <20260917151410.973296811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
[ omitted OPTROM start declaration and assignment changes because qla2x00_optrom_setup() still reads vendor_cmd[1] internally. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   49 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -160,6 +160,12 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg
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
 
@@ -758,6 +764,10 @@ qla2x00_process_loopback(struct bsg_job
 		return -EIO;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 3 * sizeof(uint32_t))
+		return -EINVAL;
+
 	memset(&elreq, 0, sizeof(elreq));
 
 	elreq.req_sg_cnt = dma_map_sg(&ha->pdev->dev,
@@ -990,6 +1000,10 @@ qla84xx_reset(struct bsg_job *bsg_job)
 		return -EINVAL;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	flag = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 
 	rval = qla84xx_reset_chip(vha, flag == A84_ISSUE_RESET_DIAG_FW);
@@ -1034,6 +1048,10 @@ qla84xx_updatefw(struct bsg_job *bsg_job
 		return -EINVAL;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	if (!sg_cnt) {
@@ -1484,6 +1502,10 @@ qla2x00_read_optrom(struct bsg_job *bsg_
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	if (ha->flags.nic_core_reset_hdlr_active)
 		return -EBUSY;
 
@@ -1521,6 +1543,10 @@ qla2x00_update_optrom(struct bsg_job *bs
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	mutex_lock(&ha->optrom_mutex);
 	rval = qla2x00_optrom_setup(bsg_job, vha, 1);
 	if (rval) {
@@ -2012,6 +2038,11 @@ qlafx00_mgmt_cmd(struct bsg_job *bsg_job
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
@@ -2925,6 +2956,13 @@ qla2x00_process_vendor_specific(struct s
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
 
@@ -3056,8 +3094,11 @@ qla24xx_bsg_request(struct bsg_job *bsg_
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
@@ -3366,6 +3407,10 @@ static int qla28xx_validate_flash_image(
 	if (!IS_QLA28XX(ha) || vha->vp_idx != 0)
 		return -EPERM;
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t))
+		return -EINVAL;
+
 	mutex_lock(&ha->optrom_mutex);
 	rval = qla28xx_do_validate_flash_image(bsg_job, &state);
 	if (rval)


