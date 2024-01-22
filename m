Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FA71420A5;
	Tue, 23 Jan 2024 00:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969451; cv=none; b=KNBirxBtjzHv+yfgSeL+eAlGfsIBpsvQ8AskmcjtxVfPEZTBW0pgkDjSrqEXO4jFa1b5tfW+3y2V4+A6Piyfq5bZgJj/GJeds+P4ae81SYSpsvJnOFjMNj5DB/a1OC5OkpioBrOAzMysFyiT+3hBchrfFRUpFd0rPs5nnKO64zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969451; c=relaxed/simple;
	bh=Erdy0CcfkIYRHT86T+PKyJH4DGwp4ITPjXPpthTOYYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCrMSRqDYWZrbflNOVzF0aF4TTABa7NmkFoudDAfl/HuGJGckORWyQzeWXyjDrh2EbPt80Y18M3Qkm6caeXPreWydFk51jV12CzptQP1EEct4a/eVw3neAqjj1LIYg1ASd9gRVQhqVfDO56A8cSsWpiCvKcL86opSrQ0EtU+fHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zf8myM7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zf8myM7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEECBC43390;
	Tue, 23 Jan 2024 00:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969451;
	bh=Erdy0CcfkIYRHT86T+PKyJH4DGwp4ITPjXPpthTOYYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zf8myM7NQ39v+UFPySLY4d080u/el//mur8dw1FppwXHRKFoUqhUxseorGTDotNMp
	 6vXK3LuVcP5bu9xZYouVN4dwrCVDz4vYxDdt7k1AKCCRXaqN1u2t2ayqMw0mVZnIDX
	 fzE3/r42ID1QACcwQb1wujLNibqHzJxN2PEyvNFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 255/641] media: mtk-jpeg: Remove cancel worker in mtk_jpeg_remove to avoid the crash of multi-core JPEG devices
Date: Mon, 22 Jan 2024 15:52:39 -0800
Message-ID: <20240122235825.890898027@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit d8212c5c87c143ca01b78f6bf61244af07e0058e ]

This patch reverts commit c677d7ae8314
("media: mtk-jpeg: Fix use after free bug due to uncanceled work").
The job_timeout_work is initialized only for
the single-core JPEG device so it will cause the crash for multi-core
JPEG devices.

Fix it by removing the cancel_delayed_work_sync function.

Fixes: c677d7ae8314 ("media: mtk-jpeg: Fix use after free bug due to uncanceled work")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
index 7194f88edc0f..60425c99a2b8 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1403,7 +1403,6 @@ static void mtk_jpeg_remove(struct platform_device *pdev)
 {
 	struct mtk_jpeg_dev *jpeg = platform_get_drvdata(pdev);
 
-	cancel_delayed_work_sync(&jpeg->job_timeout_work);
 	pm_runtime_disable(&pdev->dev);
 	video_unregister_device(jpeg->vdev);
 	v4l2_m2m_release(jpeg->m2m_dev);
-- 
2.43.0



