Received: from m15.mail.163.com (m15.mail.163.com [45.254.50.219])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE672F53
	for <patches@lists.linux.dev>; Sun, 15 Oct 2023 15:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="BCcvaaYN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=GugZB
	Yt/DBoe/lKBwdHjY8iHGCHeHLr6h2gjTub8LBk=; b=BCcvaaYNnTWZL/yY9kwBw
	JesHjMOHwtuXX49yj+vDcvPbuRLSiO8FXWYsA3n07MSMAygZCW0OQfYXYlNZFb60
	BSHMEzcYos94ABkxBGkn5E0HaaZiUegpMCgax9lBJ9oEhCUR7+FCKxZjZorfgtYM
	QTzt2im2gS9qenpRRslEuw=
Received: from leanderwang-LC4.localdomain (unknown [111.206.145.21])
	by zwqz-smtp-mta-g1-0 (Coremail) with SMTP id _____wDXf2qX+ytlt7uCAg--.63329S2;
	Sun, 15 Oct 2023 22:47:52 +0800 (CST)
From: Zheng Wang <zyytlz.wz@163.com>
To: stable@vger.kernel.org
Cc: hackerzheng666@gmail.com,
	sashal@kernel.org,
	gregkh@linuxfoundation.org,
	patches@lists.linux.dev,
	amergnat@baylibre.com,
	wenst@chromium.org,
	angelogioacchino.delregno@collabora.com,
	hverkuil-cisco@xs4all.nl,
	Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH] media: mtk-jpeg: Fix use after free bug due to uncanceled  work
Date: Sun, 15 Oct 2023 22:47:47 +0800
Message-Id: <20231015144747.729031-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXf2qX+ytlt7uCAg--.63329S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr18Zry7Aw4rtryxKw1kGrg_yoW8uF4Upr
	Z3K3yUurWUGF4vqr1UZ3W2vFyrGwn8ta1Sqr1fWw4Iv393Xr4kJr1FvFy0vFWIvr9rCFWf
	XF1rA348Gr4UZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zifWrAUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/xtbBzhoKU2I0a7fbcAAAss

This is a security bug that has been reported to google.
It affected all platforms on chrome-os. Please apply this
patch to 5.10.

Due to the directory structure change, the file path to
be patched is different from that in upstream.

[ Upstream commit c677d7ae83141d390d1253abebafa49c962afb52 ]

In mtk_jpeg_probe, &jpeg->job_timeout_work is bound with
mtk_jpeg_job_timeout_work. Then mtk_jpeg_dec_device_run
and mtk_jpeg_enc_device_run may be called to start the
work.

If we remove the module which will call mtk_jpeg_remove
to make cleanup, there may be a unfinished work. The
possible sequence is as follows, which will cause a
typical UAF bug.

Fix it by canceling the work before cleanup in the mtk_jpeg_remove

CPU0                  CPU1

                    |mtk_jpeg_job_timeout_work
mtk_jpeg_remove     |
  v4l2_m2m_release  |
    kfree(m2m_dev); |
                    |
                    | v4l2_m2m_get_curr_priv
                    |   m2m_dev->curr_ctx //use
Fixes: b2f0d2724ba4 ("[media] vcodec: mediatek: Add Mediatek JPEG Decoder Driver")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
index 227245ccaedc..753c7c7be358 100644
--- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -1447,6 +1447,7 @@ static int mtk_jpeg_remove(struct platform_device *pdev)
 {
 	struct mtk_jpeg_dev *jpeg = platform_get_drvdata(pdev);
 
+	cancel_delayed_work_sync(&jpeg->job_timeout_work);
 	pm_runtime_disable(&pdev->dev);
 	video_unregister_device(jpeg->vdev);
 	video_device_release(jpeg->vdev);
-- 
2.25.1

