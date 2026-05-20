Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9432533B969;
	Wed, 20 May 2026 16:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296206; cv=none; b=KOqBXSRl7hzAOyLa1/dWMaT8u2PBGJSnwrTdqt4BDkMVlfLzEN/0NLMC2B+P6pNd+/9fyxruulqsyYIrYgKi7sLC5nzJmQKJ6Buo1h7vvLYv3R8lmSPPmOxflw6bUzud59U57c67017vd9Nu8InNXBKQPa5r3kOmHoC9mj7rVcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296206; c=relaxed/simple;
	bh=KEio4HCbtTPXvKtJr44eaik2Pk8QC7Ici/7kMMzWLYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKua3Csx0WFRnvrDu8EYwJrBkv+5kd2g9bAWJEqFbSxvQflT9nrjD1S+c4WbcC1sqUhRkoJ8KxHWQGgn2DmSD33heHni/cREYF9Dnc/GP0Ag24yIEG7P4BLeugLMIDenhpkzgUyhsywfUamQbndV4T7mMg2CDbOFAD1NvasXZYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+4OmOSD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+4OmOSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11E91F000E9;
	Wed, 20 May 2026 16:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296205;
	bh=9KTyugGG58Ds75wF0qytm7tq2S2BzfD+bdqkBTATUJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+4OmOSDWO2wwO5SZbArbQjdjPmV5EL9nTUqK+a5dhpH/L5U74z03OfnZOHYFjk4i
	 oGSErWhF1slIK/uV3ivVsUAdSmQfgCPoj8t0JHFrmCFlmdvqGdq6GbrT8zR5Dqxhij
	 N6c0VmvhLo0l0/CUGwAfrA8L+NtUwJ2yqp1cbD3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0711/1146] scsi: qla2xxx: Add support to report MPI FW state
Date: Wed, 20 May 2026 18:16:01 +0200
Message-ID: <20260520162204.278797203@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 0e124af675ebabddacfeb0958abd443265dddf13 ]

MPI firmware state was returned as 0.  Get MPI FW state to proceed with
flash image validation.

A new sysfs node 'mpi_fw_state' is added to report MPI firmware state:

    /sys/class/scsi_host/hostXX/mpi_fw_state

Fixes: d74181ca110e ("scsi: qla2xxx: Add bsg interface to support firmware img validation")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260305093337.2007205-1-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 62 ++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_init.c |  2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |  9 +++++
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2e584a8bf66b2..6a05ce195aa05 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1638,7 +1638,7 @@ qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	int rval = QLA_FUNCTION_FAILED;
-	uint16_t state[6];
+	uint16_t state[16];
 	uint32_t pstate;
 
 	if (IS_QLAFX00(vha->hw)) {
@@ -2402,6 +2402,63 @@ qla2x00_dport_diagnostics_show(struct device *dev,
 	    vha->dport_data[0], vha->dport_data[1],
 	    vha->dport_data[2], vha->dport_data[3]);
 }
+
+static ssize_t
+qla2x00_mpi_fw_state_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	int rval = QLA_FUNCTION_FAILED;
+	u16 state[16];
+	u16 mpi_state;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!(IS_QLA27XX(ha) || IS_QLA28XX(ha)))
+		return scnprintf(buf, PAGE_SIZE,
+				"MPI state reporting is not supported for this HBA.\n");
+
+	memset(state, 0, sizeof(state));
+
+	mutex_lock(&vha->hw->optrom_mutex);
+	if (qla2x00_chip_is_down(vha)) {
+		mutex_unlock(&vha->hw->optrom_mutex);
+		ql_dbg(ql_dbg_user, vha, 0x70df,
+		       "ISP reset is in progress, failing mpi_fw_state.\n");
+		return -EBUSY;
+	} else if (vha->hw->flags.eeh_busy) {
+		mutex_unlock(&vha->hw->optrom_mutex);
+		ql_dbg(ql_dbg_user, vha, 0x70ea,
+		       "HBA in PCI error state, failing mpi_fw_state.\n");
+		return -EBUSY;
+	}
+
+	rval = qla2x00_get_firmware_state(vha, state);
+	mutex_unlock(&vha->hw->optrom_mutex);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_user, vha, 0x70eb,
+		       "MB Command to retrieve MPI state failed (%d), failing mpi_fw_state.\n",
+				rval);
+		return -EIO;
+	}
+
+	mpi_state = state[11];
+
+	if (!(mpi_state & BIT_15))
+		return scnprintf(buf, PAGE_SIZE,
+				 "MPI firmware state reporting is not supported by this firmware. (0x%02x)\n",
+				mpi_state);
+
+	if (!(mpi_state & BIT_8))
+		return scnprintf(buf, PAGE_SIZE,
+				 "MPI firmware is disabled. (0x%02x)\n",
+				mpi_state);
+
+	return scnprintf(buf, PAGE_SIZE,
+			 "MPI firmware is enabled, state is %s. (0x%02x)\n",
+			 mpi_state & BIT_9 ? "active" : "inactive",
+			 mpi_state);
+}
+
 static DEVICE_ATTR(dport_diagnostics, 0444,
 	   qla2x00_dport_diagnostics_show, NULL);
 
@@ -2469,6 +2526,8 @@ static DEVICE_ATTR(port_speed, 0644, qla2x00_port_speed_show,
     qla2x00_port_speed_store);
 static DEVICE_ATTR(port_no, 0444, qla2x00_port_no_show, NULL);
 static DEVICE_ATTR(fw_attr, 0444, qla2x00_fw_attr_show, NULL);
+static DEVICE_ATTR(mpi_fw_state, 0444, qla2x00_mpi_fw_state_show, NULL);
+
 
 static struct attribute *qla2x00_host_attrs[] = {
 	&dev_attr_driver_version.attr.attr,
@@ -2517,6 +2576,7 @@ static struct attribute *qla2x00_host_attrs[] = {
 	&dev_attr_qlini_mode.attr,
 	&dev_attr_ql2xiniexchg.attr,
 	&dev_attr_ql2xexchoffld.attr,
+	&dev_attr_mpi_fw_state.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 730c42b1a7b9d..e746c9274cded 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4914,7 +4914,7 @@ qla2x00_fw_ready(scsi_qla_host_t *vha)
 	unsigned long	wtime, mtime, cs84xx_time;
 	uint16_t	min_wait;	/* Minimum wait time if loop is down */
 	uint16_t	wait_time;	/* Wait time if loop is coming ready */
-	uint16_t	state[6];
+	uint16_t	state[16];
 	struct qla_hw_data *ha = vha->hw;
 
 	if (IS_QLAFX00(vha->hw))
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0d598be6f3eab..44e310f1a3708 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2268,6 +2268,13 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 		mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	else
 		mcp->in_mb = MBX_1|MBX_0;
+
+	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		mcp->mb[12] = 0;
+		mcp->out_mb |= MBX_12;
+		mcp->in_mb |= MBX_12;
+	}
+
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -2280,6 +2287,8 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 		states[3] = mcp->mb[4];
 		states[4] = mcp->mb[5];
 		states[5] = mcp->mb[6];  /* DPORT status */
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
+			states[11] = mcp->mb[12]; /* MPI state. */
 	}
 
 	if (rval != QLA_SUCCESS) {
-- 
2.53.0



