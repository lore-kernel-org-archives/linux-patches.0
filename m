Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD053F1655;
	Thu, 12 Mar 2026 20:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346442; cv=none; b=qxZyhqkMqauMtRGHR6OJ77BlhT7DvQc93swouqLM5cAKFf1+BGul0Yp8QFNff5e9OJjadpDYw/JhAs7NK65b2qGmpdHr3+50J7VZEEJjXjWr/Pxkl/wIxYa17nA9JgR0gBc4yB+ANrHoc/7R3cx5qoTwiWx1unH1MK3WV+ysypw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346442; c=relaxed/simple;
	bh=nJeU29KLwW+SVg4ksDz51Uhb8Ij9QO+QplOe28cQLqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udozjhJsGxI7Hx6mY+DtDoG//0hRksPSFBLnlBPbK9PqQPnED3f2us7KR7SPblqVpy7iCNWuDgbCTMPZhkyZj6NyaLqH5rUoLeK9PEskxybpnJ4SZHnG1Mjg/CmlNIimbyOlBQ+/Y4rg06PF/QiIRiOhG66EdiKniA1qBDKad68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQ0ws5vk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQ0ws5vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F64C4CEF7;
	Thu, 12 Mar 2026 20:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346441;
	bh=nJeU29KLwW+SVg4ksDz51Uhb8Ij9QO+QplOe28cQLqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQ0ws5vkx/eOpI2UnfXWOpF2xBVf6Ui5nB9UhuEhzyKBVInFf0izT0ZiC5wXsueBm
	 SeN2ExpjzLDauRbBdwvMk1cQnrCIFQRcVwv+9kUbicpfvi4GvxtNSLNjBVXEccRPAs
	 tfP+jOKUTLSV7Jumqjl8OWxp5XZ2iWoOTcKBxWl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wu <yong.wu@mediatek.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/265] memory: mtk-smi: fix device leaks on common probe
Date: Thu, 12 Mar 2026 21:07:09 +0100
Message-ID: <20260312201019.716775165@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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
index 2bc034dff691b..1bce32bed9a1f 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -564,6 +564,7 @@ static int mtk_smi_larb_probe(struct platform_device *pdev)
 err_pm_disable:
 	pm_runtime_disable(dev);
 	device_link_remove(dev, larb->smi_common_dev);
+	put_device(larb->smi_common_dev);
 	return ret;
 }
 
@@ -799,6 +800,7 @@ static void mtk_smi_common_remove(struct platform_device *pdev)
 	if (common->plat->type == MTK_SMI_GEN2_SUB_COMM)
 		device_link_remove(&pdev->dev, common->smi_common_dev);
 	pm_runtime_disable(&pdev->dev);
+	put_device(common->smi_common_dev);
 }
 
 static int __maybe_unused mtk_smi_common_resume(struct device *dev)
-- 
2.51.0



