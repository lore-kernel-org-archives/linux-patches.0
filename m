Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF7032470A;
	Mon, 23 Mar 2026 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277526; cv=none; b=K6fNwgyqBJb8ircE4zeEpuaHlOB2lJEkZt2SPLEsqieKRclM02IXJv6F73iLqkSbzc6VFFFw8J7onbfSP+553mitxpgA0wzO4jhdOBq3Ik/kXA/jXHV2N1tENXwY9Jx71mfFBChX739PLTN4Zv9gAKQkdV3wIQMH523VaL/Cbt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277526; c=relaxed/simple;
	bh=eC3VCevqMfUYeVUIsaj/nkwg+pazx4XZrXK0uyX4JtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXdMpkGBSBFyMdUJlY6chrMCC6VicghjTFHlx8wNa9b+6ajUu3MpHd1OMZKi8RDmmWYS5SOlAghuLeQDkQlOpiXeHfJiwqDSYsC3vG8ZXHHmcpkGrvZ4XYkEMqKuspncq24IQ3Q713y2QZyZQVCBrVipWU+Bi3ZFiSQ4MQUpYsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqUgHoJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqUgHoJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0549C4CEF7;
	Mon, 23 Mar 2026 14:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277526;
	bh=eC3VCevqMfUYeVUIsaj/nkwg+pazx4XZrXK0uyX4JtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqUgHoJULZjT8BKC9j/ZvULayUz0fy4cAhxaT8FmcghXkjtP6/MMcgODPTdShklGN
	 hjgrcUe2uqqUSrohciKxDkw/9uMAhfuSA8dOwqxYUc9ZrkMv/ExdvjiR4d1cX6lio+
	 tRH88bFzCwbVbmsg1Xj/dQDzeLCAWpoAuZhm56UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wu <yong.wu@mediatek.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/481] memory: mtk-smi: fix device leaks on common probe
Date: Mon, 23 Mar 2026 14:40:00 +0100
Message-ID: <20260323134525.690519193@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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
index c9c444d4a64ab..1326119288c98 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -563,6 +563,7 @@ static int mtk_smi_larb_probe(struct platform_device *pdev)
 err_pm_disable:
 	pm_runtime_disable(dev);
 	device_link_remove(dev, larb->smi_common_dev);
+	put_device(larb->smi_common_dev);
 	return ret;
 }
 
@@ -795,6 +796,7 @@ static void mtk_smi_common_remove(struct platform_device *pdev)
 	if (common->plat->type == MTK_SMI_GEN2_SUB_COMM)
 		device_link_remove(&pdev->dev, common->smi_common_dev);
 	pm_runtime_disable(&pdev->dev);
+	put_device(common->smi_common_dev);
 }
 
 static int __maybe_unused mtk_smi_common_resume(struct device *dev)
-- 
2.51.0



