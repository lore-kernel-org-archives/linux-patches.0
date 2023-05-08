Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E22615496
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38E7C433EF;
	Mon,  8 May 2023 10:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541923;
	bh=0Z6DdtMkGxTiNOX7sZiAy6z98nFMchSsQYeqYLcH8TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1eiTdOX8CrHBLLW9J1DqRAQDkPvkeB9Ii9sgEWiFo5zTXcX+ziGl4GGlOMV49c5a
	 Za43n+osRG7AuGrqdf2aqtvhnKXXd2r8qg71QXgJioooZm4E0MCEwHZ57LsoyBxIdk
	 NiMgwLQSnSSftL9AmlAPgjiDE2hxan3ZMX30PZMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfei Dong <yunfei.dong@mediatek.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 270/663] media: mediatek: vcodec: fix decoder disable pm crash
Date: Mon,  8 May 2023 11:41:36 +0200
Message-Id: <20230508094437.009489883@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yunfei Dong <yunfei.dong@mediatek.com>

[ Upstream commit 9d2f13fb47dcab6d094f34ecfd6a879a409722b3 ]

Can't call pm_runtime_disable when the architecture support sub device for
'dev->pm.dev' is NUll, or will get below crash log.

[   10.771551] pc : _raw_spin_lock_irq+0x4c/0xa0
[   10.771556] lr : __pm_runtime_disable+0x30/0x130
[   10.771558] sp : ffffffc01e4cb800
[   10.771559] x29: ffffffc01e4cb800 x28: ffffffdf082108a8
[   10.771563] x27: ffffffc01e4cbd70 x26: ffffff8605df55f0
[   10.771567] x25: 0000000000000002 x24: 0000000000000002
[   10.771570] x23: ffffff85c0dc9c00 x22: 0000000000000001
[   10.771573] x21: 0000000000000001 x20: 0000000000000000
[   10.771577] x19: 00000000000000f4 x18: ffffffdf2e9fbe18
[   10.771580] x17: 0000000000000000 x16: ffffffdf2df13c74
[   10.771583] x15: 00000000000002ea x14: 0000000000000058
[   10.771587] x13: ffffffdf2de1b62c x12: ffffffdf2e9e30e4
[   10.771590] x11: 0000000000000000 x10: 0000000000000001
[   10.771593] x9 : 0000000000000000 x8 : 00000000000000f4
[   10.771596] x7 : 6bff6264632c6264 x6 : 0000000000008000
[   10.771600] x5 : 0080000000000000 x4 : 0000000000000001
[   10.771603] x3 : 0000000000000008 x2 : 0000000000000001
[   10.771608] x1 : 0000000000000000 x0 : 00000000000000f4
[   10.771613] Call trace:
[   10.771617]  _raw_spin_lock_irq+0x4c/0xa0
[   10.771620]  __pm_runtime_disable+0x30/0x130
[   10.771657]  mtk_vcodec_probe+0x69c/0x728 [mtk_vcodec_dec 800cc929d6631f79f9b273254c8db94d0d3500dc]
[   10.771662]  platform_drv_probe+0x9c/0xbc
[   10.771665]  really_probe+0x13c/0x3a0
[   10.771668]  driver_probe_device+0x84/0xc0
[   10.771671]  device_driver_attach+0x54/0x78

Fixes: ba31a5b39400 ("media: mtk-vcodec: Remove mtk_vcodec_release_dec_pm")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
index 174a6eec2f549..42df901e8beb4 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
@@ -451,7 +451,8 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
 	if (IS_VDEC_LAT_ARCH(dev->vdec_pdata->hw_arch))
 		destroy_workqueue(dev->core_workqueue);
 err_res:
-	pm_runtime_disable(dev->pm.dev);
+	if (!dev->vdec_pdata->is_subdev_supported)
+		pm_runtime_disable(dev->pm.dev);
 err_dec_pm:
 	mtk_vcodec_fw_release(dev->fw_handler);
 	return ret;
-- 
2.39.2



