Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3A82F44;
	Thu, 12 Dec 2024 17:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023284; cv=none; b=MQ3Y+2tWqS5ygOGye9yuzcklGsS8qBlUMqzvtAE1IYbmIzdokicLcCrBOErFxTZe5IKv6/cudEGaUfgZotH+XQ0HwclbB7kticzHf8n5DovuqLHeLGlbAZhScEZwn6DQcZ120IgLHhRSJ1Bccya1fOM4mLGwOe9l8vyEqW8MF2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023284; c=relaxed/simple;
	bh=rRh5oBnR9t95VW+7TWamTONGSSZp3DveQnNNHinv8AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEWWSFnkuKh19FaZr6/FymbhBn5yXCzWxVHxsbUWC9OqIzqllZg03tp5aaEOz4IfgtQMXCdgvs8IleQCVN8u6T5H9IXOAbgsL879Np7JePojf0Vi670fzYMq3YtOnofXHPHkbJIxtXDTC176nPwtDNHH5TfrPckqQW/MySuUZhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSFFaDZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSFFaDZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FB8C4CECE;
	Thu, 12 Dec 2024 17:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023283;
	bh=rRh5oBnR9t95VW+7TWamTONGSSZp3DveQnNNHinv8AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSFFaDZ7YRwAmSh2iD/KpXJMphSOc+rRdp6IOcHb/u2jR2mArTdXMKLrGYESymrwz
	 vsJ95S5uoTc5CyF/FdyuT8AlCpXJL77w8XIWwISP1McmNatU22ZTRCN4o5Oevxixjx
	 8bS43upjaLgjBLBoHNv4Mw6XbHwV+sl+LKszetQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 454/565] scsi: qla2xxx: Fix NVMe and NPIV connect issue
Date: Thu, 12 Dec 2024 16:00:49 +0100
Message-ID: <20241212144329.669962861@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -515,6 +515,7 @@ qla24xx_create_vhost(struct fc_vport *fc
 		return(NULL);
 	}
 
+	vha->irq_offset = QLA_BASE_VECTORS;
 	host = vha->host;
 	fc_vport->dd_data = vha;
 	/* New host info */


