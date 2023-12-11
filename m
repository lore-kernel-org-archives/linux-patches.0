Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AF4321B8;
	Mon, 11 Dec 2023 18:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Izz8to+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098E0C433C9;
	Mon, 11 Dec 2023 18:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321146;
	bh=vupaAYzXebBcU0NLJ9sY90OXGtjbDsTr1OnH0uPHr+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Izz8to+4gFd9p7ZWeeLaerUIJPPB0Uvf5DToeNl02i+wphWC1cJrnyq5p0NEL0Aif
	 T+od7s16QIGMrkIJhR/nr5cuni6fwH1il5qgdCBPhIW5RHwuAksRzu0+KEjl6Atq+q
	 3E6QG+wl+fSpcjy29XS1qzf6ipUt44NfthV4UtNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/141] coresight: etm4x: Remove bogous __exit annotation for some functions
Date: Mon, 11 Dec 2023 19:22:38 +0100
Message-ID: <20231211182030.853467640@linuxfoundation.org>
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

[ Upstream commit 348ddab81f7b0983d9fb158df910254f08d3f887 ]

etm4_platform_driver (which lives in ".data" contains a reference to
etm4_remove_platform_dev(). So the latter must not be marked with __exit
which results in the function being discarded for a build with
CONFIG_CORESIGHT_SOURCE_ETM4X=y which in turn makes the remove pointer
contain invalid data.

etm4x_amba_driver referencing etm4_remove_amba() has the same issue.

Drop the __exit annotations for the two affected functions and a third
one that is called by the other two.

For reasons I don't understand this isn't catched by building with
CONFIG_DEBUG_SECTION_MISMATCH=y.

Fixes: c23bc382ef0e ("coresight: etm4x: Refactor probing routine")
Fixes: 5214b563588e ("coresight: etm4x: Add support for sysreg only devices")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: James Clark <james.clark@arm.com>
Link: https://lore.kernel.org/all/20230929081540.yija47lsj35xtj4v@pengutronix.de/
Link: https://lore.kernel.org/r/20230929081637.2377335-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index e2cccd6ea1f1d..26d0d4485ae99 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -2041,7 +2041,7 @@ static void clear_etmdrvdata(void *info)
 	etmdrvdata[cpu] = NULL;
 }
 
-static void __exit etm4_remove_dev(struct etmv4_drvdata *drvdata)
+static void etm4_remove_dev(struct etmv4_drvdata *drvdata)
 {
 	etm_perf_symlink(drvdata->csdev, false);
 	/*
@@ -2064,7 +2064,7 @@ static void __exit etm4_remove_dev(struct etmv4_drvdata *drvdata)
 	coresight_unregister(drvdata->csdev);
 }
 
-static void __exit etm4_remove_amba(struct amba_device *adev)
+static void etm4_remove_amba(struct amba_device *adev)
 {
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(&adev->dev);
 
@@ -2072,7 +2072,7 @@ static void __exit etm4_remove_amba(struct amba_device *adev)
 		etm4_remove_dev(drvdata);
 }
 
-static int __exit etm4_remove_platform_dev(struct platform_device *pdev)
+static int etm4_remove_platform_dev(struct platform_device *pdev)
 {
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(&pdev->dev);
 
-- 
2.42.0



