Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796525F54F;
	Tue, 23 Jan 2024 01:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974422; cv=none; b=tpLzWOIMZipSFGZ+++5L6KDekXo8yPTFRMHJekgk7vNTbZqCd14drzbDLINiFvYfmg4IjeOhIyCPYXYsNZYtdl+SEw571cQlaC5jq4A28L+c8PHvnlTi61ESTEJc4h4C3i7lM3dtIIPxi/Q13bNk9UaU9Kxqxbkr6QoVRaOOPQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974422; c=relaxed/simple;
	bh=3XmD3dXSmcgjJsw+Of9PU1fTrrdAAht5DpgiqskDWlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Un1h5kvzzXq923WmPmCaQXy4zkE0QvGuYYmEKEsy2d+pPayXqCsjH3xkg5jZK3qDE9hDUWRxdhR8NvKs6+HUolLygaZjAtx6ThfzPPkAot91AJaJhKGjvuZfuAI0tfhMwyzBXeMVA6OLMMZL0b1U/XdX6q6QPvaDwNIHdsoMvRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwgTVVdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwgTVVdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B618C43399;
	Tue, 23 Jan 2024 01:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974422;
	bh=3XmD3dXSmcgjJsw+Of9PU1fTrrdAAht5DpgiqskDWlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwgTVVdSRB6d93CdOoDHyS1OIVCQIx1hc90noDHzgntu8VokqV/6zYZocJEXQ2hF6
	 dtHKVbFEn3yO+Wo0il85PfPqEvXJjHZCA42B+Knwhs3RblMietVRUKmWAe8p+Hc1mw
	 l1AZO2rTJiJuhpMHAAyY4/KG7Buj/cNL6xDnZeW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Curtis Klein <curtis.klein@hpe.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 219/374] watchdog: set cdev owner before adding
Date: Mon, 22 Jan 2024 15:57:55 -0800
Message-ID: <20240122235752.272063232@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Curtis Klein <curtis.klein@hpe.com>

[ Upstream commit 38d75297745f04206db9c29bdd75557f0344c7cc ]

When the new watchdog character device is registered, it becomes
available for opening. This creates a race where userspace may open the
device before the character device's owner is set. This results in an
imbalance in module_get calls as the cdev_get in cdev_open will not
increment the reference count on the watchdog driver module.

This causes problems when the watchdog character device is released as
the module loader's reference will also be released. This makes it
impossible to open the watchdog device later on as it now appears that
the module is being unloaded. The open will fail with -ENXIO from
chrdev_open.

The legacy watchdog device will fail with -EBUSY from the try_module_get
in watchdog_open because it's module owner is the watchdog core module
so it can still be opened but it will fail to get a refcount on the
underlying watchdog device driver.

Fixes: 72139dfa2464 ("watchdog: Fix the race between the release of watchdog_core_data and cdev")
Signed-off-by: Curtis Klein <curtis.klein@hpe.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20231205190522.55153-1-curtis.klein@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 5eec84fa6517..d3b5aa87c141 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1035,6 +1035,7 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 
 	/* Fill in the data structures */
 	cdev_init(&wd_data->cdev, &watchdog_fops);
+	wd_data->cdev.owner = wdd->ops->owner;
 
 	/* Add the device */
 	err = cdev_device_add(&wd_data->cdev, &wd_data->dev);
@@ -1049,8 +1050,6 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 		return err;
 	}
 
-	wd_data->cdev.owner = wdd->ops->owner;
-
 	/* Record time of most recent heartbeat as 'just before now'. */
 	wd_data->last_hw_keepalive = ktime_sub(ktime_get(), 1);
 	watchdog_set_open_deadline(wd_data);
-- 
2.43.0



