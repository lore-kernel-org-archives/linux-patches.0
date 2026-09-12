Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F0138F656;
	Sat, 12 Sep 2026 19:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242820; cv=none; b=vDGLNBaN7FgJL9ami3l6xgGGdDCJSWPciVG1N/+FzfCw1CfEf+oJ6iwiP2J6XNEq/hO+HYEyAjhGGbQHkM1EBSML+hNVcjQc5zK0FRumGBE3lnlv7x5BPkI3qiC6vwSGFtySm2LQz0BdTxSg9eNt2Z6SLJ/n6UM4yanOT6WlAUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242820; c=relaxed/simple;
	bh=frdwh2KNOVxAyjV4OcE4xAeZuAnFIB7kvEe5Zi9O+qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcsKoCLBhm0iX0/RaOwp+dPMh7by/ueoy0qi++/c7uKUSzDvVbbfuFMssxJuCa9FzAyRt9NN15oWasaDsrah1yub9HqR7C7FUVzCD/Nbbx163UxEB6OJhVrMbdmtlZxumcqwAOTzbI7Jd2tj+9eVQcp/Q01juwQjnlDTM8sh9Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9KzNU12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9KzNU12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E039F1F000FF;
	Sat, 12 Sep 2026 19:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242819;
	bh=9VnjNLMvLUwvjXkx5awZ69jzd07C1CITSI4/Iza8XoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9KzNU12H4AoETLlv000c4zYNUNLU+FYsZaLf/7hJ8xPkKz+CE1JrfjWB7yTel9gO
	 l8f3aZh5Qrcdo7ZYlAdsCYu9W4stSQINxdnabZuQbw9gXiJzf65gJTPxKlBDOYh0Eu
	 dxK1xqe7KElaEe0/NqqhYkiQeD6+ygS294YQBqWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 539/798] nvme-fc: unmap cmd_iu DMA on rsp_iu mapping failure in init_request
Date: Sat, 12 Sep 2026 09:02:47 +0200
Message-ID: <20260912065529.482750112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2eeba1d254d9a..b561a7be98e3c 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2100,9 +2100,15 @@ __nvme_fc_init_request(struct nvme_fc_ctrl *ctrl,
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



