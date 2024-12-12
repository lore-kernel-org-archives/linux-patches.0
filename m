Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBC521660C;
	Thu, 12 Dec 2024 15:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016148; cv=none; b=Y4L21+dZFH1jf9/wGepvgm2fjU11Xq4Z0t4JeqnYxYdhb27GYo5IRNZnpUbHTp/Ftqiah0oGIL0WW+JkbZXHVGBmpmx2yuFsjER9oksc0gOhecoW5+cplsQy97O+tUIm4UUmeh5vvdQiFSvoKx1fn5o5jvZKYafjEuRpZlYmWF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016148; c=relaxed/simple;
	bh=FR7PI+MSJSPhE0pLxnJjH2RA6DHsUNilWXOLKwTzTnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMbptd15nSh8nL/DprKnIBviAo00ScjQZFL9vZO5fqnoDroL3MxHKPYQmPEur/aYeVK+mUhkxfq5SRY9iC5r17Hr3P66sjECEkpTpFwXrKcF+afEl0BeN9G72+upFCYekwb86sySd4WJecwp2eRZGPbGnHZAftDV3b5AR23C0s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ABgqG3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ABgqG3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A544C4CECE;
	Thu, 12 Dec 2024 15:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016148;
	bh=FR7PI+MSJSPhE0pLxnJjH2RA6DHsUNilWXOLKwTzTnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ABgqG3ylf+0uSfc8lerIqJK2n+TZblmjtQjeHI7Dk7t6IHxK18VpAL4w/bZq1325
	 apqsOT1LuTd1AoTpOZcoDYEOG3Bl1FjnuNynJxYRaqt7nOR7JUmkzdNK5e9xHUZTKg
	 kSamdz1xw8rWx/K/Za6e0vdcq5kGk7XNFrM9DwNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 146/466] scsi: qla2xxx: Fix NVMe and NPIV connect issue
Date: Thu, 12 Dec 2024 15:55:15 +0100
Message-ID: <20241212144312.564804171@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quinn Tran <qutran@marvell.com>

commit 4812b7796c144f63a1094f79a5eb8fbdad8d7ebc upstream.

NVMe controller fails to send connect command due to failure to locate
hw context buffer for NVMe queue 0 (blk_mq_hw_ctx, hctx_idx=0). The
cause of the issue is NPIV host did not initialize the vha->irq_offset
field.  This field is given to blk-mq (blk_mq_pci_map_queues) to help
locate the beginning of IO Queues which in turn help locate NVMe queue
0.

Initialize this field to allow NVMe to work properly with NPIV host.

 kernel: nvme nvme5: Connect command failed, errno: -18
 kernel: nvme nvme5: qid 0: secure concatenation is not supported
 kernel: nvme nvme5: NVME-FC{5}: create_assoc failed, assoc_id 2e9100 ret 401
 kernel: nvme nvme5: NVME-FC{5}: reset: Reconnect attempt failed (401)
 kernel: nvme nvme5: NVME-FC{5}: Reconnect attempt in 2 seconds

Cc: stable@vger.kernel.org
Fixes: f0783d43dde4 ("scsi: qla2xxx: Use correct number of vectors for online CPUs")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20241115130313.46826-6-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -506,6 +506,7 @@ qla24xx_create_vhost(struct fc_vport *fc
 		return(NULL);
 	}
 
+	vha->irq_offset = QLA_BASE_VECTORS;
 	host = vha->host;
 	fc_vport->dd_data = vha;
 	/* New host info */


