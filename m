Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD4347ACD7;
	Sat, 12 Sep 2026 18:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239347; cv=none; b=YzEjZg6H3e/92Ke3l1nxN/+Htwc4JsE52mKBf7lpFqXnyPWaIESlSIQ+T7Yw7gXeC3/888CYnF0jYYDpeENZEptMAG6zf4B3Z7kzwK0epxCTfDjqtVi85gEIndEUOfBvWOU5wUDFFUwG+Umt/SDx3s73+TYYVXJuP0Y+e5SWMAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239347; c=relaxed/simple;
	bh=aXrRY4h7Ou3MGZLX7BUQ2YE+A/OUQ4FVfFdfUI1VAKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GII/RQHleSkMewvcrrj6wz38+zstYIrI01cyemRPgOtzZ+27XrOTTWOSRc6YcF1aY7OxxxDe/kb+FYlJhxlfYaZkJNcx9XdLoNh4JG1leXfd/NFkhn/LI7FtivDSDvKS46A2BanuIPVB6qHf0SkFuv7ryET32b/AUXHN4jYTY6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZExBaBN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZExBaBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B411F000FF;
	Sat, 12 Sep 2026 18:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239346;
	bh=7NcRRN1+Zfso1++avFv51wrDUhxM7UGFj7Ca6ozOrLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZExBaBN0zkAsVos9342JEUjjkY4zDqieqvZAsggcKXBsLqgQZfXlPb0xwQHQ56j8
	 rfWW5LqNuydehQP8p0s+iGkShfpNAUKWcd4TMLi0414v72yXR/hmjsbxjpfoCuRCwa
	 ZkZdOf9CsHbtY/D7vMe6ACevHJxw3WhJUw3xH7Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 629/935] nvme-fc: unmap cmd_iu DMA on rsp_iu mapping failure in init_request
Date: Sat, 12 Sep 2026 09:00:59 +0200
Message-ID: <20260912065541.268243064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cc58547a6d053..0336f971543b7 100644
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



