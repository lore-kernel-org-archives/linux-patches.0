Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286EC40242B;
	Thu, 12 Mar 2026 20:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346446; cv=none; b=Ael0XIlZrGmlcl/PdlmkFiv+h+n6/d+L05tLaOJA8oz1hUcPL+XWLqnXZfzEap2TcNKCpat9bhk825vA/PZuw5PScDW1+vupkFKcpc5WQsM2B5k3UOs9rXYcar1jdZJYon279NJswfPBGNt9XLmODDzujl+bLY9suD8vG8aNEvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346446; c=relaxed/simple;
	bh=1gAFAwsmn++xyHJVkPvyJK3eLO4a/TUdYauFWjl/snM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TM14kGnI+mKLJxmUOx/s+vbSLZfeU50RDZ4fXVgT2zvR5d6j5KmEZIWqTW6JbxHYx3cCRdcwdLi/iwumBukIaZz2u/zN+Bb2YOuYWSx865QMopPhdRdu8iwlh8kDTSi+r2iqmWfzfWWU2jPNtC+vYLK2JkBPR1DLlPjbScUAo0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ftc+Y/Xx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ftc+Y/Xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721C3C4CEF7;
	Thu, 12 Mar 2026 20:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346446;
	bh=1gAFAwsmn++xyHJVkPvyJK3eLO4a/TUdYauFWjl/snM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ftc+Y/XxDqBDoCX8bIx9ooCMp3UvegoXyLOqC2x0B8xaesEmSQuzm48TKWCGfxRJU
	 xG4Q1kI8TX4wZQZtoXZzmLCgfRMcfvMpZsjDbJbkENaPO8VDvmG9iiCTFFdvppkmBP
	 pevzqRwk0/4V6xGKLpY2BocSifP0NVHJ68NZKCQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wu <yong.wu@mediatek.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/265] memory: mtk-smi: fix device leak on larb probe
Date: Thu, 12 Mar 2026 21:07:10 +0100
Message-ID: <20260312201019.755308931@linuxfoundation.org>
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
index 1bce32bed9a1f..2d7f7cc5bfa9c 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -575,6 +575,7 @@ static void mtk_smi_larb_remove(struct platform_device *pdev)
 	device_link_remove(&pdev->dev, larb->smi_common_dev);
 	pm_runtime_disable(&pdev->dev);
 	component_del(&pdev->dev, &mtk_smi_larb_component_ops);
+	put_device(larb->smi_common_dev);
 }
 
 static int __maybe_unused mtk_smi_larb_resume(struct device *dev)
-- 
2.51.0



