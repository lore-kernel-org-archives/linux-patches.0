Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E886327280A;
	Mon, 13 Apr 2026 16:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097118; cv=none; b=j/MM9MXSBfFG+o+O0aFMH/vRvOeLg087zxicTeq6mDrY+AJ6rGl772wffXqT5ldWsCZ+gyJZHJ/k1UiKz20lUXXjS0NiOA6JO5JlZIUPCKa/qT4ktp9IIeeAL3IZzz0XKHxh8SpST6Yw3gwufUMgdsndxz7yGzvsSrdJj5pb5Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097118; c=relaxed/simple;
	bh=kj/mkqil0dlX9mROmSW1jO4BJ2D6+nyT5tG/XYdsJeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkOntTOm07A6BKeot9kwWjzYxnnEVBRh00JpZYK3TlDEpxYMQ9SxX4hA96oh1ZdYpTtqBozO3zqd4wYjZDnK0K1dD5jUKNN7CU4EaE0eauW6+WfjovTtMeu4ZJ/59V9PzDGyGSazQYdqSg8wKF6We43uYkzomyXSDl3j4t/aDZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiuvZlni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiuvZlni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD6BC2BCAF;
	Mon, 13 Apr 2026 16:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097117;
	bh=kj/mkqil0dlX9mROmSW1jO4BJ2D6+nyT5tG/XYdsJeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiuvZlnij9G3arkMiHjsxpAcHHiSg75Biw84iTxbsr5vZ0GSPnLzjYGoQeM8qFkcI
	 qFZdk+zexMLZjQmQJYuRBdPX7xFjEaNYaHtMDTjPU4dzNvWON7MuT3acoi47Fl/2c6
	 O+tqI5bN3UhKjBw8+fBjtDyKimeOyF36Ji+VPn8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wu <yong.wu@mediatek.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/570] memory: mtk-smi: fix device leak on larb probe
Date: Mon, 13 Apr 2026 17:52:24 +0200
Message-ID: <20260413155830.910350968@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
index c317bcf49ebcd..ae01b396cb453 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -382,6 +382,7 @@ static void mtk_smi_larb_remove(struct platform_device *pdev)
 	device_link_remove(&pdev->dev, larb->smi_common_dev);
 	pm_runtime_disable(&pdev->dev);
 	component_del(&pdev->dev, &mtk_smi_larb_component_ops);
+	put_device(larb->smi_common_dev);
 }
 
 static int __maybe_unused mtk_smi_larb_resume(struct device *dev)
-- 
2.51.0



