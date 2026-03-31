Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75543D8114;
	Tue, 31 Mar 2026 16:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975482; cv=none; b=ozqEKLpEZcUMdMmaf1x0lzgtbKG627/zqXWCgfwTOAl6Ag8KAZYZ6HyGY+Ej4fJOHeCa8LzK6OXx1fsBM2YQRbEauicXj3ZqFmURiYHaSest1aRHdk5JkLuXl2Jx9kusIZN1QvxqR+WWQNlSJOKmFGGepGyMykPQ56jz9vdVT8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975482; c=relaxed/simple;
	bh=ovO09AaXd2SCV5f4LLETWlEmAvHtm6xE+TvlQEEEvD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isI05U1KWxRyuMUFhLPttC44KbGACE1Ii7h/qkafdubjWIYcWvODNJzvTH4J0MjKZNQhldpwlL0lR1WX9zyFxEEtDJc9ZypiuCcdSOvJbmMcRQTUPn1nTV6PngV6xCmSE+tUoBLDCE2cSmhSJ/EuqPVDrYYPCRmlIUg7WOmLbM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPObUs/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPObUs/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A5EC19423;
	Tue, 31 Mar 2026 16:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975482;
	bh=ovO09AaXd2SCV5f4LLETWlEmAvHtm6xE+TvlQEEEvD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPObUs/GXDi64LyfQOL0XYJTKy3PxH1Wxyv3fFproZr9BKlwDejS76AMMUKwwjvr9
	 RY8aKhKnEXEJzFJdooNpCRwyORI1yP6DBDh4LdMpIJAT+J+JYRI5E0xYaL4DZ4WR8x
	 XLMcusr4b9F2rT0kspNcEB9coEB6u0gzSgB6i5iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 313/342] dmaengine: idxd: Fix crash when the event log is disabled
Date: Tue, 31 Mar 2026 18:22:26 +0200
Message-ID: <20260331161810.441933519@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 52d2edea0d63c935e82631e4b9e4a94eccf97b5b ]

If reporting errors to the event log is not supported by the hardware,
and an error that causes Function Level Reset (FLR) is received, the
driver will try to restore the event log even if it was not allocated.

Also, only try to free the event log if it was properly allocated.

Fixes: 6078a315aec1 ("dmaengine: idxd: Add idxd_device_config_save() and idxd_device_config_restore() helpers")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-2-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 3 +++
 drivers/dma/idxd/init.c   | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index c2cdf41b6e576..f9e49c5545f65 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -830,6 +830,9 @@ static void idxd_device_evl_free(struct idxd_device *idxd)
 	struct device *dev = &idxd->pdev->dev;
 	struct idxd_evl *evl = idxd->evl;
 
+	if (!evl)
+		return;
+
 	gencfg.bits = ioread32(idxd->reg_base + IDXD_GENCFG_OFFSET);
 	if (!gencfg.evl_en)
 		return;
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 2acc34b3daff8..449424242631d 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -962,7 +962,8 @@ static void idxd_device_config_restore(struct idxd_device *idxd,
 
 	idxd->rdbuf_limit = idxd_saved->saved_idxd.rdbuf_limit;
 
-	idxd->evl->size = saved_evl->size;
+	if (idxd->evl)
+		idxd->evl->size = saved_evl->size;
 
 	for (i = 0; i < idxd->max_groups; i++) {
 		struct idxd_group *saved_group, *group;
-- 
2.53.0



