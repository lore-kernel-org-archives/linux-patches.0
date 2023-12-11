Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47F653801;
	Mon, 11 Dec 2023 18:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtO+fZbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E40C433C8;
	Mon, 11 Dec 2023 18:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321116;
	bh=c4HjyXyNJ0I7HR9YSANUF2DvITzN1NGWT3svfif9flI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtO+fZbrzPoP854hpvxDilW5PboIRz3pkpu8rJZu+EPbjimcTC/d7k6XWiKcG9HOG
	 5D4+sQqg2amz5tmQJirCHqh1h6aMzt57WQYcdgxVEqwcuxqsNFILAva3A6VhZ0MtSM
	 EheITZ8e1eGMcV9G3EGpucecfSvYKXWZKUyVEThY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/141] coresight: etm4x: Make etm4_remove_dev() return void
Date: Mon, 11 Dec 2023 19:22:37 +0100
Message-ID: <20231211182030.804119885@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit c5f231f1a7e18d28e02b282d33541d31358360e4 ]

etm4_remove_dev() returned zero unconditionally. Make it return void
instead, which makes it clear in the callers that there is no error to
handle. Simplify etm4_remove_platform_dev() accordingly.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230518201629.260672-1-u.kleine-koenig@pengutronix.de
Stable-dep-of: 348ddab81f7b ("coresight: etm4x: Remove bogous __exit annotation for some functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 2b22343918d69..e2cccd6ea1f1d 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -2041,7 +2041,7 @@ static void clear_etmdrvdata(void *info)
 	etmdrvdata[cpu] = NULL;
 }
 
-static int __exit etm4_remove_dev(struct etmv4_drvdata *drvdata)
+static void __exit etm4_remove_dev(struct etmv4_drvdata *drvdata)
 {
 	etm_perf_symlink(drvdata->csdev, false);
 	/*
@@ -2062,8 +2062,6 @@ static int __exit etm4_remove_dev(struct etmv4_drvdata *drvdata)
 
 	cscfg_unregister_csdev(drvdata->csdev);
 	coresight_unregister(drvdata->csdev);
-
-	return 0;
 }
 
 static void __exit etm4_remove_amba(struct amba_device *adev)
@@ -2076,13 +2074,12 @@ static void __exit etm4_remove_amba(struct amba_device *adev)
 
 static int __exit etm4_remove_platform_dev(struct platform_device *pdev)
 {
-	int ret = 0;
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(&pdev->dev);
 
 	if (drvdata)
-		ret = etm4_remove_dev(drvdata);
+		etm4_remove_dev(drvdata);
 	pm_runtime_disable(&pdev->dev);
-	return ret;
+	return 0;
 }
 
 static const struct amba_id etm4_ids[] = {
-- 
2.42.0



