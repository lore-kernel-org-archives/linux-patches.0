Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E0247CC70;
	Sat, 28 Feb 2026 17:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301299; cv=none; b=Gq/xchz4lyF/FtpPDtMCMpYh2XsUs/xpJIGkDb7yhoDhWmRgvKydiEp2dc9eiRlOWlU4AOaQuL8bKWOSc8I5cubY4ftNIVGGZ5Lc8UnE4tm4sHNzibT7o1Sm/EGqpXlOXzeGZcnRQvYMQUucPgx4zR6oAEPBvzEXcbx00n2oYJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301299; c=relaxed/simple;
	bh=uDhIBphmjVucBZEpMpnFI3pSvL0pshqOZ7AL5MqU1Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsbGpmBbWj41dvUDyEuWNopssrxvEV2/hWeFYuuAmt0lYPSDULuMmWwDDX6O0DiSZeNjCcrdAupFY8e/gB1wNwe547BU6dUFLUOZs5V7UWtBiay9E2Q2qhVJepoM5zFogxJlYi9rV4Brffk7AQtJYVKAO6yriryacaypqYkbpz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hi9b0RKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hi9b0RKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36DFC116D0;
	Sat, 28 Feb 2026 17:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301299;
	bh=uDhIBphmjVucBZEpMpnFI3pSvL0pshqOZ7AL5MqU1Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hi9b0RKsNqkM07yftwt43uX07z/Tlm+JExz8UDX+AZYDQZFjVPRUrgxZX4VNjSjyQ
	 fKitxAuYugNcBNk2NQ8m+kOsDYfRt3NZCWK7SLFm2odfZqpgHoALqtpAZYEHTvSqi6
	 SM5Vb126LDgjdjJ90usgJOpsug5eZin7Xr/fx8vE0Ow2zrvig87h673FuyFgwASteO
	 Natp5npnL3w976J/GURe2VaHNEP19G6FnlYIOvBEYCWBHK+Y1PPzA9PlzlIh9osy6u
	 ME/bGLNEu5LPGGDoDAn523oaK8kt4iJShgAXXnMvrsWmBc3IXtTHMoXFH3wv4X4CFM
	 igTMHHN3HK2IA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haoxiang Li <haoxiang_li2024@163.com>,
	stable@vger.kernel.org,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 484/752] media: mtk-mdp: Fix a reference leak bug in mtk_mdp_remove()
Date: Sat, 28 Feb 2026 12:43:15 -0500
Message-ID: <20260228174750.1542406-484-sashal@kernel.org>
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

[ Upstream commit f128bab57b8018e526b7eda854ca20069863af47 ]

In mtk_mdp_probe(), vpu_get_plat_device() increases the reference
count of the returned platform device. Add platform_device_put()
to prevent reference leak.

Fixes: c8eb2d7e8202 ("[media] media: Add Mediatek MDP Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/mdp/mtk_mdp_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mediatek/mdp/mtk_mdp_core.c b/drivers/media/platform/mediatek/mdp/mtk_mdp_core.c
index f78fa30f18648..8432833814f31 100644
--- a/drivers/media/platform/mediatek/mdp/mtk_mdp_core.c
+++ b/drivers/media/platform/mediatek/mdp/mtk_mdp_core.c
@@ -254,6 +254,7 @@ static void mtk_mdp_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 	vb2_dma_contig_clear_max_seg_size(&pdev->dev);
+	platform_device_put(mdp->vpu_dev);
 	mtk_mdp_unregister_m2m_device(mdp);
 	v4l2_device_unregister(&mdp->v4l2_dev);
 
-- 
2.51.0

