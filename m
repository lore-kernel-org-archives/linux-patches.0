Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2C64A3401;
	Sat, 28 Feb 2026 17:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301298; cv=none; b=c3lEmEoY0jDi8yvbSvNYYPODvmkQLgk+i/Q5szJTACzdAAHmxCbVasG/Ma73sU0Rgvsgt0J0Dl6Kj/wg9nCcK8h8jwt02URCmD6MSHGJJ4kqWa/W10Cw9ZZhlVfh/6isbMLo3Wf9t3vbeTLwBP5dewpzKuogtK0EeEmVdV8A3fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301298; c=relaxed/simple;
	bh=5if/RWMvFd/l30E/2EEFXgocpt+vp6WLqSuHhSUwgdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYVXBAZPsEg4HCRk5rL7uYapmbi5ZP5QQX2NvI/LZvsbRr5P4jNrCupJ0evi8eLlnPEf9o9/e9oPqDqUgNE5qy1E7dsvOv75vAT94ECqae41THprsX7iWV/TsS/ofYGEhLybm7L6c3xrh4zspGLBpec1heGyx+SkqAQhzHhqWhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FNEyh4/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FNEyh4/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AFDC116D0;
	Sat, 28 Feb 2026 17:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301298;
	bh=5if/RWMvFd/l30E/2EEFXgocpt+vp6WLqSuHhSUwgdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNEyh4/rCStN/WD9iw/oY4Pnsr97UwLiTu6qgxREKbvCaSUG3Pm+9r8IL5ychczH/
	 iBLB7w5BWfgZsYEvCElV9YhO6qkCl5vEu6yjeX+HJgqoYys7nW4PdHw23CRPJWLN50
	 w7UzBfg8muH+6gQNCKTuzxGEK1Nv9kUJj7ByKNqA4jsIf95S03t219/bGczccOPtNt
	 fSEF28QHcwLV3QPLmvZXoyuNPYwDcltcL/8frfas84HyREfiTCum7fFZGKPN750FMt
	 5SkgCprRURvxgXskXyb0pP/6W4K6p+atzM6X0jH8K+m8mbyva+ZGI4NQhgxVFSI5AV
	 xN/j3bvllYmBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haoxiang Li <haoxiang_li2024@163.com>,
	stable@vger.kernel.org,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 483/752] media: mtk-mdp: Fix error handling in probe function
Date: Sat, 28 Feb 2026 12:43:14 -0500
Message-ID: <20260228174750.1542406-483-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 8a8a3232abac5b972058a5f2cb3e33199d2a8648 ]

Add mtk_mdp_unregister_m2m_device() on the error handling path to prevent
resource leak.

Add check for the return value of vpu_get_plat_device() to prevent null
pointer dereference. And vpu_get_plat_device() increases the reference
count of the returned platform device. Add platform_device_put() to
prevent reference leak.

Fixes: c8eb2d7e8202 ("[media] media: Add Mediatek MDP Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/mediatek/mdp/mtk_mdp_core.c   | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mediatek/mdp/mtk_mdp_core.c b/drivers/media/platform/mediatek/mdp/mtk_mdp_core.c
index 80fdc6ff57e0e..f78fa30f18648 100644
--- a/drivers/media/platform/mediatek/mdp/mtk_mdp_core.c
+++ b/drivers/media/platform/mediatek/mdp/mtk_mdp_core.c
@@ -194,11 +194,17 @@ static int mtk_mdp_probe(struct platform_device *pdev)
 	}
 
 	mdp->vpu_dev = vpu_get_plat_device(pdev);
+	if (!mdp->vpu_dev) {
+		dev_err(&pdev->dev, "Failed to get vpu device\n");
+		ret = -ENODEV;
+		goto err_vpu_get_dev;
+	}
+
 	ret = vpu_wdt_reg_handler(mdp->vpu_dev, mtk_mdp_reset_handler, mdp,
 				  VPU_RST_MDP);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register reset handler\n");
-		goto err_m2m_register;
+		goto err_reg_handler;
 	}
 
 	platform_set_drvdata(pdev, mdp);
@@ -206,7 +212,7 @@ static int mtk_mdp_probe(struct platform_device *pdev)
 	ret = vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to set vb2 dma mag seg size\n");
-		goto err_m2m_register;
+		goto err_reg_handler;
 	}
 
 	pm_runtime_enable(dev);
@@ -214,6 +220,12 @@ static int mtk_mdp_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_reg_handler:
+	platform_device_put(mdp->vpu_dev);
+
+err_vpu_get_dev:
+	mtk_mdp_unregister_m2m_device(mdp);
+
 err_m2m_register:
 	v4l2_device_unregister(&mdp->v4l2_dev);
 
-- 
2.51.0

