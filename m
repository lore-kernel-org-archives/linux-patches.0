Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867D264CEB;
	Tue, 23 Jan 2024 00:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971588; cv=none; b=E1Zd5g8iCQDKX5Dt0x1IcOwccT3kukl8xuySZg8Lmlp8u31P8TzJ9H3JrGwgWvTfrLxhANqjLgYKQuHbiilwAK9wEcbqG0yWQzX36T2MHKAmQTfmKJF/Z37B5JB/GojMtt2Gp8mHaXL0pu41wjPk/rBzcaeeZIumywBMxd9A2bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971588; c=relaxed/simple;
	bh=lSekXoW4aDhmS5+IVDsZlejJb+iCAt1UNU4RLKhxhSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tH5NDJlpxEe9fkE5hEzVI6ByljZYMfBsdZBHq13E1OzyE8HNL9Gtn4A96KSXzC0FHdIFIUBxxKge3V/pUIqr8bpq/YOI8PyQEO1npWRalWp7tIUU8b66/L0D3D3gPNH2ZBgnxd1IoHz86TeK4+VTJXP7wsGK34u5rb6m21hpVE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qm1eOHOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qm1eOHOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32876C433C7;
	Tue, 23 Jan 2024 00:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971588;
	bh=lSekXoW4aDhmS5+IVDsZlejJb+iCAt1UNU4RLKhxhSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qm1eOHOuVQTNODaOK5PXzOMFUGqsECiNigFtDLrRxmhKGJ6zBhMQQYSq4NalqNgX5
	 MUkh3HZMnldg9GiHiVqJOGAkr2jY5qaEM1ZDaXwVt3rumSHbqV17oLmfhi/Wi4vWh+
	 iGzG0dRDLPRI2T8h0Ek8/OOgJjR8BGpzrFzGLO7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Curtis Klein <curtis.klein@hpe.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/286] watchdog: set cdev owner before adding
Date: Mon, 22 Jan 2024 15:58:08 -0800
Message-ID: <20240122235739.158631712@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f37255cd75fd..24d0470af81c 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1028,6 +1028,7 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 
 	/* Fill in the data structures */
 	cdev_init(&wd_data->cdev, &watchdog_fops);
+	wd_data->cdev.owner = wdd->ops->owner;
 
 	/* Add the device */
 	err = cdev_device_add(&wd_data->cdev, &wd_data->dev);
@@ -1042,8 +1043,6 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 		return err;
 	}
 
-	wd_data->cdev.owner = wdd->ops->owner;
-
 	/* Record time of most recent heartbeat as 'just before now'. */
 	wd_data->last_hw_keepalive = ktime_sub(ktime_get(), 1);
 	watchdog_set_open_deadline(wd_data);
-- 
2.43.0



