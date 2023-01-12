Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2297749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A0BC433D2;
	Thu, 12 Jan 2023 14:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532289;
	bh=cVyPpOf6cwsLXhZx4Cf472KFLRstmpsQAq7CKedBvTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RKZPwFoKLa1x2PUhJYo66WK9+FrpvCkfp97mHW1dWWLLJiKArBaFsDzXDXpT5cI6
	 WOCO7J2PJt7n96wIgRuLhg/lTO8xzcXs2jC3x5qFRrx7BRlKwX3mJZU0nMadrrcEbC
	 rHUqxN3jFlFBhgoxgpH3zkNegC5o0bMJAlaVrPV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ezequiel Garcia <ezequiel@collabora.com>,
	Jacopo Mondi <jacopo+renesas@jmondi.org>,
	Helen Koike <helen.koike@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/783] media: exynos4-is: Use v4l2_async_notifier_add_fwnode_remote_subdev
Date: Thu, 12 Jan 2023 14:47:09 +0100
Message-Id: <20230112135529.444912132@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 3a2822bfe45c50abd9f76a8547a77a1f6a0e8c8d ]

The use of v4l2_async_notifier_add_subdev will be discouraged.
Drivers are instead encouraged to use a helper such as
v4l2_async_notifier_add_fwnode_remote_subdev.

This fixes a misuse of the API, as v4l2_async_notifier_add_subdev
should get a kmalloc'ed struct v4l2_async_subdev,
removing some boilerplate code while at it.

Use the appropriate helper v4l2_async_notifier_add_fwnode_remote_subdev,
which handles the needed setup, instead of open-coding it.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Helen Koike <helen.koike@collabora.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: f98a5c2e1c43 ("media: exynos4-is: don't rely on the v4l2_async_subdev internals")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/media-dev.c | 24 ++++++++++---------
 drivers/media/platform/exynos4-is/media-dev.h |  2 +-
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index a9a8f0433fb2..3d877c5ae290 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -401,6 +401,7 @@ static int fimc_md_parse_one_endpoint(struct fimc_md *fmd,
 	int index = fmd->num_sensors;
 	struct fimc_source_info *pd = &fmd->sensor[index].pdata;
 	struct device_node *rem, *np;
+	struct v4l2_async_subdev *asd;
 	struct v4l2_fwnode_endpoint endpoint = { .bus_type = 0 };
 	int ret;
 
@@ -418,10 +419,10 @@ static int fimc_md_parse_one_endpoint(struct fimc_md *fmd,
 	pd->mux_id = (endpoint.base.port - 1) & 0x1;
 
 	rem = of_graph_get_remote_port_parent(ep);
-	of_node_put(ep);
 	if (rem == NULL) {
 		v4l2_info(&fmd->v4l2_dev, "Remote device at %pOF not found\n",
 							ep);
+		of_node_put(ep);
 		return 0;
 	}
 
@@ -450,6 +451,7 @@ static int fimc_md_parse_one_endpoint(struct fimc_md *fmd,
 	 * checking parent's node name.
 	 */
 	np = of_get_parent(rem);
+	of_node_put(rem);
 
 	if (of_node_name_eq(np, "i2c-isp"))
 		pd->fimc_bus_type = FIMC_BUS_TYPE_ISP_WRITEBACK;
@@ -458,20 +460,19 @@ static int fimc_md_parse_one_endpoint(struct fimc_md *fmd,
 	of_node_put(np);
 
 	if (WARN_ON(index >= ARRAY_SIZE(fmd->sensor))) {
-		of_node_put(rem);
+		of_node_put(ep);
 		return -EINVAL;
 	}
 
-	fmd->sensor[index].asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-	fmd->sensor[index].asd.match.fwnode = of_fwnode_handle(rem);
+	asd = v4l2_async_notifier_add_fwnode_remote_subdev(
+		&fmd->subdev_notifier, of_fwnode_handle(ep), sizeof(*asd));
 
-	ret = v4l2_async_notifier_add_subdev(&fmd->subdev_notifier,
-					     &fmd->sensor[index].asd);
-	if (ret) {
-		of_node_put(rem);
-		return ret;
-	}
+	of_node_put(ep);
+
+	if (IS_ERR(asd))
+		return PTR_ERR(asd);
 
+	fmd->sensor[index].asd = asd;
 	fmd->num_sensors++;
 
 	return 0;
@@ -1377,7 +1378,8 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 
 	/* Find platform data for this sensor subdev */
 	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
-		if (fmd->sensor[i].asd.match.fwnode ==
+		if (fmd->sensor[i].asd &&
+		    fmd->sensor[i].asd->match.fwnode ==
 		    of_fwnode_handle(subdev->dev->of_node))
 			si = &fmd->sensor[i];
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 9447fafe23c6..a3876d668ea6 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -83,7 +83,7 @@ struct fimc_camclk_info {
  */
 struct fimc_sensor_info {
 	struct fimc_source_info pdata;
-	struct v4l2_async_subdev asd;
+	struct v4l2_async_subdev *asd;
 	struct v4l2_subdev *subdev;
 	struct fimc_dev *host;
 };
-- 
2.35.1



