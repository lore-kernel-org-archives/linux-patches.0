Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46A61D86FF;
	Tue, 11 Nov 2025 01:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824228; cv=none; b=aoPuCoiX2Qnc5BkM7E9irbpiXow3c+otLExO0F4ppHlUJBV2PHOO6JJaGnVk9FVTCdgvj5q0TXnHoqN5qdvpc/TDF38lyew7ZN06itfEsoGon7xehkN8aZIBQ2v0fAnrYZ2VtiEFr9C40+xhY9C3vVt67y3+ELxfrr+G7wMKzac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824228; c=relaxed/simple;
	bh=YXH6aS2rQv2Ggmg7Dx2hLhr9zNpPxMot3LXgp0qu/5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkxpGTQEFQ+O2Q4B3MaEzMfERNWRuSstRLSEsA+oKyP01/6n+T0Ig1XZSfvyRcwkecB2p3n07zLRxI9GNgar2SD9MYJxxg+fVCyeCEAeFyF8f/+5XVCBH9wW2oGoEl+xBBoW0fck14DdtKyu+y6K034/vsejY+wpjHDmKbBMdoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpCVtwPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpCVtwPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62976C116B1;
	Tue, 11 Nov 2025 01:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824228;
	bh=YXH6aS2rQv2Ggmg7Dx2hLhr9zNpPxMot3LXgp0qu/5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpCVtwPA5f91PnFIoIprapaxrrnFPCmfCbPZwHn9Lqyyr9gKmhHTFgEpCdhTWFScS
	 VI7wMSlocujLbgUuoOUo7cckWOJyhCkkgOVfiitmSBBjJGU5IjyOKFujl9T9buePKX
	 WFKYYSDD1bKJEg/0U+griIry8XnuZ1A2WOiAsZ1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 466/849] serdev: Drop dev_pm_domain_detach() call
Date: Tue, 11 Nov 2025 09:40:36 +0900
Message-ID: <20251111004547.694322902@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit e3fa89f3a768a9c61cf1bfe86b939ab5f36a9744 ]

Starting with commit f99508074e78 ("PM: domains: Detach on
device_unbind_cleanup()"), there is no longer a need to call
dev_pm_domain_detach() in the bus remove function. The
device_unbind_cleanup() function now handles this to avoid
invoking devres cleanup handlers while the PM domain is
powered off, which could otherwise lead to failures as
described in the above-mentioned commit.

Drop the explicit dev_pm_domain_detach() call and rely instead
on the flags passed to dev_pm_domain_attach() to power off the
domain.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20250827101747.928265-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serdev/core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index d16c207a1a9b2..b33e708cb2455 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -399,15 +399,12 @@ static int serdev_drv_probe(struct device *dev)
 	const struct serdev_device_driver *sdrv = to_serdev_device_driver(dev->driver);
 	int ret;
 
-	ret = dev_pm_domain_attach(dev, PD_FLAG_ATTACH_POWER_ON);
+	ret = dev_pm_domain_attach(dev, PD_FLAG_ATTACH_POWER_ON |
+					PD_FLAG_DETACH_POWER_OFF);
 	if (ret)
 		return ret;
 
-	ret = sdrv->probe(to_serdev_device(dev));
-	if (ret)
-		dev_pm_domain_detach(dev, true);
-
-	return ret;
+	return sdrv->probe(to_serdev_device(dev));
 }
 
 static void serdev_drv_remove(struct device *dev)
@@ -415,8 +412,6 @@ static void serdev_drv_remove(struct device *dev)
 	const struct serdev_device_driver *sdrv = to_serdev_device_driver(dev->driver);
 	if (sdrv->remove)
 		sdrv->remove(to_serdev_device(dev));
-
-	dev_pm_domain_detach(dev, true);
 }
 
 static const struct bus_type serdev_bus_type = {
-- 
2.51.0



