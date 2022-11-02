Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21747E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DB9C433C1;
	Wed,  2 Nov 2022 03:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358030;
	bh=BHVCI1s4jfu//S/5mEhJuYbR2oeP+GjX2FQp9S4wnOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQPPpBICF+jRKXMybE9R0STYoJL/DvNJ/bccwE8uam+y/l6/8SJuU4pU+kXaaQbW0
	 dTN7N/5YvpLEwKRQ0PoatBiuYaERVy+en1hgfOQMstuprXPRAF3ntxBPEF2FLTOGpd
	 ewqrSOXjzAIoK92E3WPoYVGf7mXEmY/rEFPntoHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 030/132] scsi: qla2xxx: Use transport-defined speed mask for supported_speeds
Date: Wed,  2 Nov 2022 03:32:16 +0100
Message-Id: <20221102022100.426121554@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manish Rangankar <mrangankar@marvell.com>

commit 0b863257c17c5f57a41e0a48de140ed026957a63 upstream.

One of the sysfs values reported for supported_speeds was not valid (20Gb/s
reported instead of 64Gb/s).  Instead of driver internal speed mask
definition, use speed mask defined in transport_fc for reporting
host->supported_speeds.

Link: https://lore.kernel.org/r/20220927115946.17559-1-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -3318,11 +3318,34 @@ struct fc_function_template qla2xxx_tran
 	.bsg_timeout = qla24xx_bsg_timeout,
 };
 
+static uint
+qla2x00_get_host_supported_speeds(scsi_qla_host_t *vha, uint speeds)
+{
+	uint supported_speeds = FC_PORTSPEED_UNKNOWN;
+
+	if (speeds & FDMI_PORT_SPEED_64GB)
+		supported_speeds |= FC_PORTSPEED_64GBIT;
+	if (speeds & FDMI_PORT_SPEED_32GB)
+		supported_speeds |= FC_PORTSPEED_32GBIT;
+	if (speeds & FDMI_PORT_SPEED_16GB)
+		supported_speeds |= FC_PORTSPEED_16GBIT;
+	if (speeds & FDMI_PORT_SPEED_8GB)
+		supported_speeds |= FC_PORTSPEED_8GBIT;
+	if (speeds & FDMI_PORT_SPEED_4GB)
+		supported_speeds |= FC_PORTSPEED_4GBIT;
+	if (speeds & FDMI_PORT_SPEED_2GB)
+		supported_speeds |= FC_PORTSPEED_2GBIT;
+	if (speeds & FDMI_PORT_SPEED_1GB)
+		supported_speeds |= FC_PORTSPEED_1GBIT;
+
+	return supported_speeds;
+}
+
 void
 qla2x00_init_host_attr(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	u32 speeds = FC_PORTSPEED_UNKNOWN;
+	u32 speeds = 0, fdmi_speed = 0;
 
 	fc_host_dev_loss_tmo(vha->host) = ha->port_down_retry_count;
 	fc_host_node_name(vha->host) = wwn_to_u64(vha->node_name);
@@ -3332,7 +3355,8 @@ qla2x00_init_host_attr(scsi_qla_host_t *
 	fc_host_max_npiv_vports(vha->host) = ha->max_npiv_vports;
 	fc_host_npiv_vports_inuse(vha->host) = ha->cur_vport_count;
 
-	speeds = qla25xx_fdmi_port_speed_capability(ha);
+	fdmi_speed = qla25xx_fdmi_port_speed_capability(ha);
+	speeds = qla2x00_get_host_supported_speeds(vha, fdmi_speed);
 
 	fc_host_supported_speeds(vha->host) = speeds;
 }


