Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E06C23EAB2;
	Mon, 23 Mar 2026 14:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277624; cv=none; b=KvX+hjYdNmUTkuUMirg5CgtchA1lNINlxUejVE4wBOQKgNDFVaUZJN23cLFfKLKX9tW2Jmbqi4TYiNqlBI0r3J8kRDST/D3GopvNNEb0GPWrB9rElPZy6936tAuC1N63HTYnTAq8NK6pKWom3tzogYRfp3k8JkLm7v9omR3Ev1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277624; c=relaxed/simple;
	bh=YBrX3xypemxIqbHoGFXy10xrkFdh9vF/r7EePTnb0dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5J0vr58PtmSDw62iACLZxFV9vKSbbYhjh5oYOVpiwylj9lR3hFOAN94CX42M4rF7ey/j6vk3vdeqy8aDMUbzWGt2oqns2DL6Ahf27Adb9znpXo2cMVdy8cSnRxtM1DZvBX3CjNP7BKTHfRvYtOYvPMVTWhXAtySL9OXgc6cORs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjrVxfAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjrVxfAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FE5C2BC9E;
	Mon, 23 Mar 2026 14:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277623;
	bh=YBrX3xypemxIqbHoGFXy10xrkFdh9vF/r7EePTnb0dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vjrVxfARSFCr4pN1A8eF+IXTSIf50ShCERd/YMpfH2saMVJAiRr3wLa0JiWD7Rd39
	 Ue9eJvsW9iYWlD50e6o0mTeoey3MPDnSFQ5V7sGmkXwAcxRTQabT9E35c9GhzJJzFr
	 Ip8oF9GJdiIP0p1FkfWhC+zzuh9sWAJ3GCSaTDA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wu <yong.wu@mediatek.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/567] memory: mtk-smi: fix device leak on larb probe
Date: Mon, 23 Mar 2026 14:39:09 +0100
Message-ID: <20260323134534.500316779@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 668afd12e4c51..5ca197e15eb28 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -574,6 +574,7 @@ static void mtk_smi_larb_remove(struct platform_device *pdev)
 	device_link_remove(&pdev->dev, larb->smi_common_dev);
 	pm_runtime_disable(&pdev->dev);
 	component_del(&pdev->dev, &mtk_smi_larb_component_ops);
+	put_device(larb->smi_common_dev);
 }
 
 static int __maybe_unused mtk_smi_larb_resume(struct device *dev)
-- 
2.51.0



