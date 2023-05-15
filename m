Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3E9FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43326C433D2;
	Mon, 15 May 2023 17:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173330;
	bh=MdhVzwajEur6aJFWe8xhiBW8QYRN2udYfPayZRdhSPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWUkV5atTMWVv4HFUX3Iye3Ppt4DcUWCDSvNMOnCTZ15hEBKvYUhzOcG1frWjCTuk
	 qvy8zfPzQoeUpo677ODnbJ5CDTiu0P/FScKsHHFXZ+kqIXmLFowRu8QHUWLELo7+rp
	 Ki8V6+rqMBYWC3uU1cK+cjlyQzMyQfbAubxdHHY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/282] media: rcar_fdp1: fix pm_runtime_get_sync() usage count
Date: Mon, 15 May 2023 18:27:17 +0200
Message-Id: <20230515161724.014833270@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 45e75a8c6fa455a5909ac04db76a4b15d6bb8368 ]

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.
Replace it by the new pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter, avoiding
a potential PM usage counter leak.

Also, right now, the driver is ignoring any troubles when
trying to do PM resume. So, add the proper error handling
for the code.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: c766c90faf93 ("media: rcar_fdp1: Fix refcount leak in probe and remove function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar_fdp1.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index d6eee66c8dd49..9caddc8387b46 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -2139,7 +2139,9 @@ static int fdp1_open(struct file *file)
 	}
 
 	/* Perform any power management required */
-	pm_runtime_get_sync(fdp1->dev);
+	ret = pm_runtime_resume_and_get(fdp1->dev);
+	if (ret < 0)
+		goto error_pm;
 
 	v4l2_fh_add(&ctx->fh);
 
@@ -2149,6 +2151,8 @@ static int fdp1_open(struct file *file)
 	mutex_unlock(&fdp1->dev_mutex);
 	return 0;
 
+error_pm:
+       v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 error_ctx:
 	v4l2_ctrl_handler_free(&ctx->hdl);
 	kfree(ctx);
@@ -2356,7 +2360,9 @@ static int fdp1_probe(struct platform_device *pdev)
 
 	/* Power up the cells to read HW */
 	pm_runtime_enable(&pdev->dev);
-	pm_runtime_get_sync(fdp1->dev);
+	ret = pm_runtime_resume_and_get(fdp1->dev);
+	if (ret < 0)
+		goto disable_pm;
 
 	hw_version = fdp1_read(fdp1, FD1_IP_INTDATA);
 	switch (hw_version) {
@@ -2385,6 +2391,9 @@ static int fdp1_probe(struct platform_device *pdev)
 
 	return 0;
 
+disable_pm:
+	pm_runtime_disable(fdp1->dev);
+
 release_m2m:
 	v4l2_m2m_release(fdp1->m2m_dev);
 
-- 
2.39.2



