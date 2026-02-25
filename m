Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D9A2FB08C;
	Wed, 25 Feb 2026 06:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002689; cv=none; b=Uc4JKx7BSkd7OQQa3b+HCEqg36R/AGAog3pFPhqPHuOjWAwAnJZ4nfssl8BfSX7mjQLPoehYRWvLrOhSE8QcrmmiVRbiL6W1Hs6gk76S7aC8UKYVcVQ0jwOYS4hIOInbDstc3/pGDjibphD2uYllT+VhRJ8UVz+O5lkTUHqXaEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002689; c=relaxed/simple;
	bh=tHlXKd9gYRlD9/UQzyVmytTOQssMZE94lIti6WLzReM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/w8cnNwsWhSKLx7cdx7KP5UXuNwrtAJqmHjljDPMqIp0kRmLqRYuT1ZGX17LbJp0elBg1LlXAWe6c4Ss4d3TPUct+DIxOUyRy0Nj5oPHoUd7eiENWj2WKjTMh6hAXvHQlJcu1NEFtgkpuz6CsXkvX6Llu+f7Ogd9TbZBwiuSoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFAl2Tf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFAl2Tf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB29CC19425;
	Wed, 25 Feb 2026 06:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002689;
	bh=tHlXKd9gYRlD9/UQzyVmytTOQssMZE94lIti6WLzReM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFAl2Tf2ER+43mjdH6r3o81GyyWSe9iQ89IgGZnQ8bgv7YJy86Gd8E9AYQHAdy5p0
	 z6JPcLghwl1AYXRCPE0xlUylcUB9DjLJwTqmxkjAWcS95lq85CyvIZqSyE+b+K5W/D
	 quO+MOc+GE9e0eMspXZCM2m2uTeqBhoghsGqZ/2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Javier Rodriguez Barbarin <dev-josejavier.rodriguez@duagon.com>,
	Johannes Thumshirn <morbidrsa@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 482/641] mcb: fix incorrect sanity check
Date: Tue, 24 Feb 2026 17:23:28 -0800
Message-ID: <20260225012400.201183724@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Javier Rodriguez Barbarin <dev-josejavier.rodriguez@duagon.com>

[ Upstream commit bc2e4bc952e26dd93b978588219044bd8b24237b ]

__mcb_register_driver() makes some sanity checks over mcb_driver
to check if .probe and .remove callbacks are set.  However, since commit
3bd13ae04ccc ("gpio: menz127: simplify error path and remove remove()")
removed the .remove callback from menz127-gpio.c, not all mcb device
drivers implement .remove callback.

Remove .remove check to ensure all mcb device drivers can be loaded.

Signed-off-by: Jose Javier Rodriguez Barbarin <dev-josejavier.rodriguez@duagon.com>
Fixes: 3bd13ae04ccc ("gpio: menz127: simplify error path and remove remove()")
[ jth: added statement about menz127-gpio.c ]
Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
Link: https://patch.msgid.link/16fb55bd59d9c1d2ce2443f41d4dec2048f9a8ec.1768562302.git.jth@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mcb/mcb-core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mcb/mcb-core.c b/drivers/mcb/mcb-core.c
index c1367223e71a0..3d487d75c483d 100644
--- a/drivers/mcb/mcb-core.c
+++ b/drivers/mcb/mcb-core.c
@@ -85,7 +85,8 @@ static void mcb_remove(struct device *dev)
 	struct mcb_device *mdev = to_mcb_device(dev);
 	struct module *carrier_mod;
 
-	mdrv->remove(mdev);
+	if (mdrv->remove)
+		mdrv->remove(mdev);
 
 	carrier_mod = mdev->dev.parent->driver->owner;
 	module_put(carrier_mod);
@@ -176,13 +177,13 @@ static const struct device_type mcb_carrier_device_type = {
  * @owner: The @mcb_driver's module
  * @mod_name: The name of the @mcb_driver's module
  *
- * Register a @mcb_driver at the system. Perform some sanity checks, if
- * the .probe and .remove methods are provided by the driver.
+ * Register a @mcb_driver at the system. Perform a sanity check, if
+ * .probe method is provided by the driver.
  */
 int __mcb_register_driver(struct mcb_driver *drv, struct module *owner,
 			const char *mod_name)
 {
-	if (!drv->probe || !drv->remove)
+	if (!drv->probe)
 		return -EINVAL;
 
 	drv->driver.owner = owner;
-- 
2.51.0



