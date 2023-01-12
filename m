Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0E3749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E540EC433F0;
	Thu, 12 Jan 2023 14:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532292;
	bh=mLAhZCyvp3JuBs7BDBiSZaCY0Vo/R5f6BkuNg0DQJK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COjzLF4BPuusukBNQHm+j7bUmxLkr0+1emV0KicHg7MlKQup9GjCPrGa4bYHhMLeY
	 nmm6kwLAOhHxhtKdx9cD+K3ag/tQYq8OFj7wRv1B0f2OI+8Dr06Lq5/7Lh/O7t8Cs0
	 qgRExEq+yupJc/eZf4gEWz8Dlc7JpjdgYW6NHjfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <djrscally@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/783] media: exynos4-is: dont rely on the v4l2_async_subdev internals
Date: Thu, 12 Jan 2023 14:47:10 +0100
Message-Id: <20230112135529.498171670@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit f98a5c2e1c4396488c27274ba82afc11725a4bcc ]

Commit 1f391df44607 ("media: v4l2-async: Use endpoints in
__v4l2_async_nf_add_fwnode_remote()") changed the data that is stored in
the v4l2_async_subdev internals from the fwnode pointer to the parent
device to the fwnode pointer to the matched endpoint. This broke the
sensor matching code, which relied on the particular fwnode data in the
v4l2_async_subdev internals. Fix this by simply matching the
v4l2_async_subdev pointer, which is already available there.

Reported-by: Daniel Scally <djrscally@gmail.com>
Fixes: fa91f1056f17 ("[media] exynos4-is: Add support for asynchronous subdevices registration")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Daniel Scally <djrscally@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/media-dev.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 3d877c5ae290..8603c578f55f 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1378,9 +1378,7 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 
 	/* Find platform data for this sensor subdev */
 	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
-		if (fmd->sensor[i].asd &&
-		    fmd->sensor[i].asd->match.fwnode ==
-		    of_fwnode_handle(subdev->dev->of_node))
+		if (fmd->sensor[i].asd == asd)
 			si = &fmd->sensor[i];
 
 	if (si == NULL)
-- 
2.35.1



