Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2952C13AF4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE08C433EF;
	Mon,  8 May 2023 10:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541883;
	bh=A/G/qIIkVXdZxnyHqJNtSfAfP5uBuVotfaZ4wm5O3TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7T804NVxuSiBNkJuDKXEuAz/pKNIkkLKaBaGn8zbD+y2lfnC3UnzAf9Eul1/dzPX
	 oif2VYDOfQGlFeo7/tjqor9SNF4gIvUINdYmWZ5psutCv1MRb606Nrv1i/Nk8X6464
	 3o/5wWDOiFdWxPS4f5J0eeW/nYy4HHlMKcDrbAI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 258/663] media: rcar_fdp1: Convert to platform remove callback returning void
Date: Mon,  8 May 2023 11:41:24 +0200
Message-Id: <20230508094436.624042806@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 0e82d3715fd208de567b8e4307fbf91ae5e57db4 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: c766c90faf93 ("media: rcar_fdp1: Fix refcount leak in probe and remove function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/renesas/rcar_fdp1.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/renesas/rcar_fdp1.c b/drivers/media/platform/renesas/rcar_fdp1.c
index 37ecf489d112e..d80b3214dfae1 100644
--- a/drivers/media/platform/renesas/rcar_fdp1.c
+++ b/drivers/media/platform/renesas/rcar_fdp1.c
@@ -2396,7 +2396,7 @@ static int fdp1_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int fdp1_remove(struct platform_device *pdev)
+static void fdp1_remove(struct platform_device *pdev)
 {
 	struct fdp1_dev *fdp1 = platform_get_drvdata(pdev);
 
@@ -2404,8 +2404,6 @@ static int fdp1_remove(struct platform_device *pdev)
 	video_unregister_device(&fdp1->vfd);
 	v4l2_device_unregister(&fdp1->v4l2_dev);
 	pm_runtime_disable(&pdev->dev);
-
-	return 0;
 }
 
 static int __maybe_unused fdp1_pm_runtime_suspend(struct device *dev)
@@ -2441,7 +2439,7 @@ MODULE_DEVICE_TABLE(of, fdp1_dt_ids);
 
 static struct platform_driver fdp1_pdrv = {
 	.probe		= fdp1_probe,
-	.remove		= fdp1_remove,
+	.remove_new	= fdp1_remove,
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.of_match_table = fdp1_dt_ids,
-- 
2.39.2



