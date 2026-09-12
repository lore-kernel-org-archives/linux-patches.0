Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E033642AF86;
	Sat, 12 Sep 2026 10:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208514; cv=none; b=pJYGiOOByIbw33VRWAWTMATGmQRoh7P3VCQqdu+jRoirIg0fPyG87AMNrnlFsqJUvBKXaRiRsOY5YaNGE8qGqBrlhQNWL1ruegkpgDkVvejzlwgaa0shDDyIE5zY6QawGtW2DImZE5+VTqjlPSnyBt5VON8LAP+rsZUrlcUlN5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208514; c=relaxed/simple;
	bh=6Vj/XnPa/es/lcG0LcfZheYycc0boYAdfTtAMiO2MCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9ojrQ/6y8vWGphM3cbJK6LQGZM09j6/FCBS4qL6gpHgPJyDPs1tmkuKEatFVz4Wz26t/nzXHHEVACzFy+P0bzO2gUWIo/WgGOuwa6LxX7xmkBA2zcQRJfqEvSLbpuTfYx4QRNm6XY5epJmM7pBpuLcS97EXj/TGnIlQUG2NCMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHp210Bu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHp210Bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB77D1F00893;
	Sat, 12 Sep 2026 10:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208505;
	bh=feTkeq6dw+nJlDHrDQGHypjYeWNsu8gxg9ODv8r+KPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHp210Buje5ZQIbw2lQ2ZIi7/1pW2TiWI9M/4fL3KiPTVkSsPtKGVKdnGYjg4facu
	 582hfQ3z/+eEB9Y/Es1F6y/Ln1z4YrSO2cNCLJ1zAGwbxvuMW1ciscsqZUeTN64OAV
	 0LkmV9GfIL/XYu6S08KZFXLHOJg+U8SzAFvQb6/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0630/1518] nvme-fc: unmap cmd_iu DMA on rsp_iu mapping failure in init_request
Date: Sat, 12 Sep 2026 08:46:39 +0200
Message-ID: <20260912065637.682801776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit f49d0c3a8d56a7cda1628ae17341a4a42063563c ]

__nvme_fc_init_request() maps cmd_iu and then rsp_iu for DMA. If the
rsp_iu mapping fails, the original code only recorded the error and fell
through: it left the already-mapped cmd_iu unmapped and still marked the
op as FCPOP_STATE_IDLE before returning. Since blk-mq does not call
.exit_request() when .init_request() fails, the cmd_iu mapping is leaked
for every op whose rsp_iu mapping fails.

Jump to an error path on rsp_iu mapping failure that unmaps cmd_iu and
returns the error without marking the op idle, so it stays in the
FCPOP_STATE_UNINIT state set by the initial memset().

Fixes: e399441de911 ("nvme-fabrics: Add host support for FC transport")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index bdfbd5701ba60..5a6ef2d1830e3 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2098,9 +2098,15 @@ __nvme_fc_init_request(struct nvme_fc_ctrl *ctrl,
 		dev_err(ctrl->dev,
 			"FCP Op failed - rspiu dma mapping failed.\n");
 		ret = -EFAULT;
+		goto out_unmap;
 	}
 
 	atomic_set(&op->state, FCPOP_STATE_IDLE);
+	return 0;
+
+out_unmap:
+	fc_dma_unmap_single(ctrl->lport->dev, op->fcp_req.cmddma,
+			sizeof(op->cmd_iu), DMA_TO_DEVICE);
 out_on_error:
 	return ret;
 }
-- 
2.53.0



