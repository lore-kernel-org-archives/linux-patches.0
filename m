Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51AA3C36;
	Tue, 23 Jan 2024 00:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969584; cv=none; b=KiRD3XhTX3nDwqODs7RqRPSfe2epOB+RnunBtbxAyfvw4z8xbWB2I39lHzVyhwX4f1EmUXxZRHwEBg7esQ29xsVp7t5LtFp/JhJW6qVy0niNCuQ61tcJowBlXikPLcdEad46Q96fgQG/Szsi7EVme2qc6oG7Zx2pn3sbx0zQfaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969584; c=relaxed/simple;
	bh=pCJirN7Ku46GIR77SkglHvRa2qHg4j1bj3bOMvHpC38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4FfB/lztzo+A4fpZJxL97Dtzsd9PJnbGYWr69WcjEeyznQbW5UOUFc7DrKSWCeV6zGI7sUQKh0eatW5IiO7fmt+smhjd2kVIZvqJWABiWRyzFffljdILlDBjRVi2y5CB4MsEApyqKFIWJzaJD/6tkcPdq7KC6GwdoLyZZTffmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIxmb+h2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIxmb+h2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9D8C43390;
	Tue, 23 Jan 2024 00:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969583;
	bh=pCJirN7Ku46GIR77SkglHvRa2qHg4j1bj3bOMvHpC38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIxmb+h2hJuOlrbQLDPpwy/cGaldmsKrocjqJmY4N1BIWl7BMoIx7OzM9YnNRxZjG
	 k9de8mIhkloJrM0D9bAwRSCMPKYnqHteulSkbgLMIKTbdC+vR7SOCDOwrWFgyX9lgj
	 8adYRxqc1zF5N8Px1wwrP5b8TtSUfuINbJpJc7X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Curtis Klein <curtis.klein@hpe.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 337/641] watchdog: set cdev owner before adding
Date: Mon, 22 Jan 2024 15:54:01 -0800
Message-ID: <20240122235828.458839542@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 15df74e11a59..e2bd266b1b5b 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1073,6 +1073,7 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 
 	/* Fill in the data structures */
 	cdev_init(&wd_data->cdev, &watchdog_fops);
+	wd_data->cdev.owner = wdd->ops->owner;
 
 	/* Add the device */
 	err = cdev_device_add(&wd_data->cdev, &wd_data->dev);
@@ -1087,8 +1088,6 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 		return err;
 	}
 
-	wd_data->cdev.owner = wdd->ops->owner;
-
 	/* Record time of most recent heartbeat as 'just before now'. */
 	wd_data->last_hw_keepalive = ktime_sub(ktime_get(), 1);
 	watchdog_set_open_deadline(wd_data);
-- 
2.43.0



