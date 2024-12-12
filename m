Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4431223C7B;
	Thu, 12 Dec 2024 17:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025692; cv=none; b=ruJx07MjeU8qejfli54VsaJiXyOd2AG9Wpct1yX8eHy4eVoNBMSpOCDFlIinahqK0BCeIryIP8x7MOe23/g94qMmfRR6T7XSvV2hK3LaDJWxlIjVKo3PAsXGNKriDHHkyaKSV5e97U1rCDUQ0f3ckRTV9IQgBTz4q+2Yfp3+wW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025692; c=relaxed/simple;
	bh=Wpct2XvaFJrUGqJfZTWxBHk9EOgPOy7Qs1hQPSk/g+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uyc6Zw2iiGjLtsdEWdQ/o9q2IHB/gQEIQeysK1AY/zJUQQbo4+MKRigpdx89JQeydw1ngA8xEcjyZQ4rzqKQnzezUU4s12U0NaGVflCRrBsGTmUQoxsIwgwEsiHlx34izntM8DqmnG6k8QhUMHZrRkOkXiBdL/OYS9w7AZBn+9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oegu7QfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oegu7QfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B17C4CEDE;
	Thu, 12 Dec 2024 17:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025692;
	bh=Wpct2XvaFJrUGqJfZTWxBHk9EOgPOy7Qs1hQPSk/g+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oegu7QfIw3reWQQNHTacecLhoOOUi2RoidF9/u/vY2/5H0pwrJxiIusC/mp2tezEU
	 P/cPaoPNb/G8T7TbdWwd0cT2CeGC0GCCnZyztHAwYpB9keFomN4BAJRV1kYEqej5EU
	 CZtlPk4OStsN94rMGJJDSZ3Y/WUIMLgUXk+b+4Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 256/321] scsi: qla2xxx: Fix NVMe and NPIV connect issue
Date: Thu, 12 Dec 2024 16:02:54 +0100
Message-ID: <20241212144240.078725474@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -492,6 +492,7 @@ qla24xx_create_vhost(struct fc_vport *fc
 		return(NULL);
 	}
 
+	vha->irq_offset = QLA_BASE_VECTORS;
 	host = vha->host;
 	fc_vport->dd_data = vha;
 	/* New host info */


