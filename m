Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB861242D65;
	Sat, 12 Sep 2026 12:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216402; cv=none; b=JVdLgvi7I8S85CEr+Vx1/0ASBvh3thC+MVVs6LoSkRykKp/jPOelp84lJ+hFDeusc2h6Kv8z8bVal44ohlr/bAHkMOpqGZ4s4+GVfCPJD2nfmJ0b3yU02htfg0HsjwvOBSXpv8+bRJKQhjNeUkWh+rKjZ1Sejto2Ash1AGLqlHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216402; c=relaxed/simple;
	bh=fVZngn/TGDVCppF5q+X4AO47E2GjUWDbNfX84i1503U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fiv4XiNgx5/CuWKjLZUEth5wA8VzdnSJ7G4pkynIMAkFEnZ/FBD3uhBYecAv9w2mitXKDIfuYWSo2D0pcKjGMMXw2nw00ajaXRbN7oBQuc+BmHX2PSLoaTYL3WpixuiI5kchNCXjs8yQCy7qFg767i777J2gjOLj/+0o/Tcw81c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuQkPQsD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuQkPQsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD511F00893;
	Sat, 12 Sep 2026 12:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216401;
	bh=/8kvGRor0x2nfEVcNAq7gGGW8s+tn90ZdqWmaSF1G7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TuQkPQsDwdEOPCJ2XNUETT6uXtSAYF977c2acGgq5QwSBI3l6keqzzclD1agjuiKJ
	 XHV8DhqlBsjQcM0fSE89BbuOyuLEAJ9l3f3DlxWcuwFd/fHIUwClm/8KhDWEyOK06n
	 R2QY0nfr0aaBgR2pFw4PQ0NOLPfTJ3lxSFkAm0uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0728/1376] nvme-fc: unmap cmd_iu DMA on rsp_iu mapping failure in init_request
Date: Sat, 12 Sep 2026 08:52:34 +0200
Message-ID: <20260912065623.773167735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2bee5873d1558..fd0d99c0f97d9 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2092,9 +2092,15 @@ __nvme_fc_init_request(struct nvme_fc_ctrl *ctrl,
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



