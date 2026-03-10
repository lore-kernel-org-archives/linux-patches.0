Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F1F3876B0;
	Tue, 10 Mar 2026 11:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141952; cv=none; b=pKlb/eZa8/7jObcKjBBks2SclFrNsIE0fBuNABXYiR4xV2Ny2n+XWdh7i85faBXE0d7MnyxOAKRdlZnKsUkXGBypoBOJhMmXq/8d2e2G4XxbJV3DYm9bQJKGKHJaZ7bOXv12gb9OYP7y+SPPBGFuOU6OccAvftRgGNnyq3n5boo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141952; c=relaxed/simple;
	bh=7mEMJvo5X8owgK7L/9oWkHE42x320z0Z8ypcbUH9IrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyTbILq7RNG7E3WUyG0o4Ahk4quJA9idAi5zjiMgcs+/bxV2bTz4xgclDwQZoDsLzxKDAoUMl9crA4qDqNfh9mDdLvafcxZ2pNXqr/o8iuFEtIbQb+TkBumJ0sr2C+12t+S1EWU1MB6eFaxTMMJgIw1vT07KNzDjvtpj4q2EU1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H6iCkM8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6iCkM8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A489C2BC86;
	Tue, 10 Mar 2026 11:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141951;
	bh=7mEMJvo5X8owgK7L/9oWkHE42x320z0Z8ypcbUH9IrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6iCkM8dFcZ9JwXYrKw8lRq4TCpTsDTZxUqx+njTiEjEaX5OMFg4jKiJ7TDsU7d9s
	 PaWlMTAClDUp0D/mDj7Q2Ivbp82iA1H2eluHaf5XomEroEV2uoTCQIQH4yiO6Cm2Mt
	 dJUDAKzPnJsWIGcTF36iY7WzvVl/4iGB4C5suynRTEx9r1wPcG3YCAQK96uBCZ8JA9
	 jx+w1WS8sku86QNZJL4QulJZi4sD1x+jpffZHPksufmyrI5PAECp9ICXRNmJ/jp9ua
	 MVfYipFM2sIn+6CNfvkvPiu3NMipI56ZBNpdxFQCW95Vfg4/FKgt1sbP0ZcF/Xmzkf
	 N3PtCR+hU9PJQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johan Hovold <johan@kernel.org>,
	Yong Wu <yong.wu@mediatek.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/314] memory: mtk-smi: fix device leak on larb probe
Date: Tue, 10 Mar 2026 07:15:34 -0400
Message-ID: <4a80c744a16c2c287f24b407a2889bd560561676.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 9dae65913b32d05dbc8ff4b8a6bf04a0e49a8eb6 ]

Make sure to drop the reference taken when looking up the SMI device
during larb probe on late probe failure (e.g. probe deferral) and on
driver unbind.

Fixes: cc8bbe1a8312 ("memory: mediatek: Add SMI driver")
Fixes: 038ae37c510f ("memory: mtk-smi: add missing put_device() call in mtk_smi_device_link_common")
Cc: stable@vger.kernel.org	# 4.6: 038ae37c510f
Cc: stable@vger.kernel.org	# 4.6
Cc: Yong Wu <yong.wu@mediatek.com>
Cc: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251121164624.13685-3-johan@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/mtk-smi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memory/mtk-smi.c b/drivers/memory/mtk-smi.c
index dd6150d200e89..3609bfd3c64be 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -685,6 +685,7 @@ static void mtk_smi_larb_remove(struct platform_device *pdev)
 	device_link_remove(&pdev->dev, larb->smi_common_dev);
 	pm_runtime_disable(&pdev->dev);
 	component_del(&pdev->dev, &mtk_smi_larb_component_ops);
+	put_device(larb->smi_common_dev);
 }
 
 static int __maybe_unused mtk_smi_larb_resume(struct device *dev)
-- 
2.51.0

