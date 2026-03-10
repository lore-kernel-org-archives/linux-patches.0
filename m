Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97D73876B0;
	Tue, 10 Mar 2026 11:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141951; cv=none; b=BpaJkxwtaqjMBQEHIZNyw2cDTg9/NOiOgN4bAuwKXEWxpKAWUniz9hRHtRY4wJi5hP0YDCFLkpiQts9NOLF7bG6mm3GaOL4DNYZ7/2sKJEGWwTm+Q9cfIPOGDvk4jLgn59MmTsTfkCa9VFzM20/2QuBNClVDFtFY3O+lwJ8qwBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141951; c=relaxed/simple;
	bh=FcnjzuTrYxOdD1uVVsCw+4SQEAEj0Gn+2o0dyJvm8ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oax4052rW59Hjz4ISqCBV6Eyvo2usntrCpfsLmIe8sgykG6kXhExUMAHrZ4LSlTPUY9ydlHeiOt3ZNw3daGjZNzKEnHxZQFcDPN7del/pRoP2CGsVeiIVUIUNXZQDJLxpsw1MKiNhUqltFZSw2Xp+k5MHQiGmojeAObkEO3qUto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0+LXLSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0+LXLSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11038C19423;
	Tue, 10 Mar 2026 11:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141950;
	bh=FcnjzuTrYxOdD1uVVsCw+4SQEAEj0Gn+2o0dyJvm8ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0+LXLSitLC0LQGwV9zNR/O/kbm47qIrLDzUcZZJK6j47qMDrK16WlMy/23Mh2nxF
	 R6b6Lz0pShj2VWXNrR174vBUCnjp4WZ/VEgbsTRhK+UX+KTyyRLS1lT5ER8kBnwqt3
	 6cTCZWw7nAV7NE/qFfNh26/x6N985xBOkeor3vozT+/KNdSGuOGLwV1KwxnFuPSlPo
	 92rrlV6lV0Km80sg74sJcM0y5DQ437t5QelqullYsWiO9cGreMb9ERNJPhHDQV2zp/
	 yLric7dLnhiH34mow40MdpgyCXgwsnVMsalw/XGAhTXBciRIIAYKNNUx2mcAon89to
	 HvelANCRQ8zag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johan Hovold <johan@kernel.org>,
	Yong Wu <yong.wu@mediatek.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/314] memory: mtk-smi: fix device leaks on common probe
Date: Tue, 10 Mar 2026 07:15:33 -0400
Message-ID: <a47cfcb49fafa83e9ef7e8007fde4d954b382798.1773141555.git.sashal@kernel.org>
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

[ Upstream commit 6cfa038bddd710f544076ea2ef7792fc82fbedd6 ]

Make sure to drop the reference taken when looking up the SMI device
during common probe on late probe failure (e.g. probe deferral) and on
driver unbind.

Fixes: 47404757702e ("memory: mtk-smi: Add device link for smi-sub-common")
Fixes: 038ae37c510f ("memory: mtk-smi: add missing put_device() call in mtk_smi_device_link_common")
Cc: stable@vger.kernel.org	# 5.16: 038ae37c510f
Cc: stable@vger.kernel.org	# 5.16
Cc: Yong Wu <yong.wu@mediatek.com>
Cc: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251121164624.13685-2-johan@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/mtk-smi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/memory/mtk-smi.c b/drivers/memory/mtk-smi.c
index 733e22f695ab7..dd6150d200e89 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -674,6 +674,7 @@ static int mtk_smi_larb_probe(struct platform_device *pdev)
 err_pm_disable:
 	pm_runtime_disable(dev);
 	device_link_remove(dev, larb->smi_common_dev);
+	put_device(larb->smi_common_dev);
 	return ret;
 }
 
@@ -917,6 +918,7 @@ static void mtk_smi_common_remove(struct platform_device *pdev)
 	if (common->plat->type == MTK_SMI_GEN2_SUB_COMM)
 		device_link_remove(&pdev->dev, common->smi_common_dev);
 	pm_runtime_disable(&pdev->dev);
+	put_device(common->smi_common_dev);
 }
 
 static int __maybe_unused mtk_smi_common_resume(struct device *dev)
-- 
2.51.0

