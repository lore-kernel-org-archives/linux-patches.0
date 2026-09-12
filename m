Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FCA32B125;
	Sat, 12 Sep 2026 16:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230210; cv=none; b=bZPgJyLEgMP4WP3p2Mim6IjAOknhfMuh6M41gWGOu+CGFsG3rdwUjS4kx+FHZGt+QI5hHhC5JBkEm+ceb6eTvOdi4H8vMufEa0W2OhPC9pKQRp5AMwn9L27nSRLMPr8solGCSinJ0l+AQd2AGHRHPpHUJ0cpdnJXWScMumB9sTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230210; c=relaxed/simple;
	bh=r11rn8kVfP31hcsLkyhnNqiX0Hv4i6nEIlQ8/1LzYTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e41XYJ6FUFF1zAZXIs4KXlhjVJyeugNiarRoxEC/OjdpAeZRV3P4fq7LKBvnZeAU5JQXrGkMahcwBFAIakCXY/nzzpFteSp/Uv806iSCwe9SmwIbKa57ScF7Zt4u8Thq4zX8e2q6qyWWAOCbmqi5EcvfeCfe/DpC/JZpfONzgDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9z1Qzqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9z1Qzqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721E61F000FF;
	Sat, 12 Sep 2026 16:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230209;
	bh=Kih0EuN5CeU3IcJrz8YUYAtN7k/bPPf+iqAqJGcVECA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9z1Qzqf1tGgChsXXo7MW88bSPvgjrDMrGrlgkfnJr7etChLD8/+csw/9WTHewMwZ
	 8aP1KBoIeEmatomrdypKRVD2nWQMJII+5WNQEo1amSuKEV+OjwVfL7hUQ33jd+JKhb
	 gkeblfXDq/bMy8tJGsFWUzcg4CMeQxwQewcqz9wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0748/1191] nvme-fc: unmap cmd_iu DMA on rsp_iu mapping failure in init_request
Date: Sat, 12 Sep 2026 08:57:56 +0200
Message-ID: <20260912065605.079117652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2a7bc6017e17b..a98c1e59a6502 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2119,9 +2119,15 @@ __nvme_fc_init_request(struct nvme_fc_ctrl *ctrl,
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



