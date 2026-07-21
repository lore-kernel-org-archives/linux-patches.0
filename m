Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8292135C684;
	Tue, 21 Jul 2026 21:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668862; cv=none; b=KRcrPzHbmKRWLNlxwrzimBK3d5laUYXmSNorTmjnrsshuQm2S99PkLh0llm/KXCuvOK2Qf+GiZNMAW4iExqFnFznvslUaveg+tvVA/xL0jwm1jE//feKH4NIcLN4oLwKCXlvQ4XRt0JV6ZCgnHfDlY8oZpV6gXMB9kEtfPAKJRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668862; c=relaxed/simple;
	bh=pEtXfL5TPmBOARsYHstJQYxTAahQXvss5V/tgpMLydE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrgUOzOyZW2rhFcigDxhGjf9OL7WJ754d5ZePxr/kDesWMl9lxZuixovtukpp+RdCXwTI2cy9ucdN/CqcYbZ1ZhwnpAwPuWLY5TXxvgi6FPFEfBS9p7EogunUoICCI8Tfdaj0+IuE+uWjV+j5yZRoE4dQm6A5Z/vhbcIUgd+/D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtvvKbgK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtvvKbgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5ED41F000E9;
	Tue, 21 Jul 2026 21:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668861;
	bh=nsjeXS3LZELfSQbJyWmwkWkqXZKso/wPp7dolpKMtyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VtvvKbgKHNKFXzJKMFVV7nQLOaxFZvuBPYH1sKgjKgbawvEqX7NwYvrLAV/yL1CUT
	 2Zk3x22uIm2ZPqVI/PC0tIC5XRuDT3DMy1/zrIZRSghuPBmQXWp++AZfjujmfgO5zk
	 kRVHgeuF0+zSravrJGENxAmeh5vJYwQU0y+2QCqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Paul Kocialkowski <paulk@sys-base.io>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0293/1067] media: cedrus: Fix failure to clean up hardware on probe failure
Date: Tue, 21 Jul 2026 17:14:54 +0200
Message-ID: <20260721152431.156756350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit f0a22f1d602ed499a192284de5e811a73421f0c7 ]

If V4L2 device fails to register, then SRAM still be claimed and as a
result driver will not be able to probe again.

 cedrus 1c0e000.video-codec: Failed to claim SRAM
 cedrus 1c0e000.video-codec: Failed to probe hardware
 cedrus 1c0e000.video-codec: probe with driver cedrus failed with error -16

cedrus_hw_remove undoes everything that was previously done by
cedrus_hw_probe, such as disabling runtime power management and
releasing the claimed SRAM and reserved memory region.

Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
Acked-by: Paul Kocialkowski <paulk@sys-base.io>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index d2419319afd72e..f73988e3b1e90b 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -472,7 +472,7 @@ static int cedrus_probe(struct platform_device *pdev)
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register V4L2 device\n");
-		return ret;
+		goto err_hw;
 	}
 
 	vfd = &dev->vfd;
@@ -533,6 +533,8 @@ static int cedrus_probe(struct platform_device *pdev)
 	v4l2_m2m_release(dev->m2m_dev);
 err_v4l2:
 	v4l2_device_unregister(&dev->v4l2_dev);
+err_hw:
+	cedrus_hw_remove(dev);
 
 	return ret;
 }
-- 
2.53.0



