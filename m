Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9681FBE0;
	Mon, 11 Dec 2023 18:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzAMH8pf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE86C433CA;
	Mon, 11 Dec 2023 18:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319665;
	bh=RKN8yHQDSTuyJrlzsqraM/ulndCsCP1zkezaQojMiRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZzAMH8pfFUQapFXN7de3vbMb2e2ccfxjj15VN86oa+rzSoMf9RscCBSCpfYcHvT5J
	 SjC98C6Ef/TIc+pUz29K1P4c+6FWPls0HwRoQDvUWUsFN9YUHeH9Q+FNea/oWs9cKQ
	 uJRLalpX+NE8QkKFTV7bZ4SzyScqcncHjLO7bLOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 189/244] coresight: etm4x: Remove bogous __exit annotation for some functions
Date: Mon, 11 Dec 2023 19:21:22 +0100
Message-ID: <20231211182054.424388539@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 77b0271ce6eb9..34aee59dd1473 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -2224,7 +2224,7 @@ static void clear_etmdrvdata(void *info)
 	per_cpu(delayed_probe, cpu) = NULL;
 }
 
-static void __exit etm4_remove_dev(struct etmv4_drvdata *drvdata)
+static void etm4_remove_dev(struct etmv4_drvdata *drvdata)
 {
 	bool had_delayed_probe;
 	/*
@@ -2253,7 +2253,7 @@ static void __exit etm4_remove_dev(struct etmv4_drvdata *drvdata)
 	}
 }
 
-static void __exit etm4_remove_amba(struct amba_device *adev)
+static void etm4_remove_amba(struct amba_device *adev)
 {
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(&adev->dev);
 
@@ -2261,7 +2261,7 @@ static void __exit etm4_remove_amba(struct amba_device *adev)
 		etm4_remove_dev(drvdata);
 }
 
-static int __exit etm4_remove_platform_dev(struct platform_device *pdev)
+static int etm4_remove_platform_dev(struct platform_device *pdev)
 {
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(&pdev->dev);
 
-- 
2.42.0



