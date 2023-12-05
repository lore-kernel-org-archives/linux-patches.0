Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B5279F2;
	Tue,  5 Dec 2023 03:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLyw+wKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DF5C433C8;
	Tue,  5 Dec 2023 03:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747623;
	bh=n7ToIbmpFN9PedNxKgcYFQiWgYZnSnHexbSNqNe9+D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLyw+wKl/TC0TdROfIt8nyFfxpRa5YKSmbVqFA+3+7Jq0JpMZAH3X7OLZGzLqvv9f
	 wqpI76hghBqJZqPEr6dvpVp7aiacJ+pEeNZPR4a2WuaplJH2Zw5DvyqhUic9FPLR0t
	 2+7NgV2eKFwc2ykQ1iB9Eg9B4d2bJkDyAEZGT8vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Saravana Kannan <saravanak@google.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	James Clark <james.clark@arm.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>
Subject: [PATCH 5.10 135/135] driver core: Release all resources during unbind before updating device links
Date: Tue,  5 Dec 2023 12:17:36 +0900
Message-ID: <20231205031539.384519460@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravana Kannan <saravanak@google.com>

commit 2e84dc37920012b458e9458b19fc4ed33f81bc74 upstream.

This commit fixes a bug in commit 9ed9895370ae ("driver core: Functional
dependencies tracking support") where the device link status was
incorrectly updated in the driver unbind path before all the device's
resources were released.

Fixes: 9ed9895370ae ("driver core: Functional dependencies tracking support")
Cc: stable <stable@kernel.org>
Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Closes: https://lore.kernel.org/all/20231014161721.f4iqyroddkcyoefo@pengutronix.de/
Signed-off-by: Saravana Kannan <saravanak@google.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: James Clark <james.clark@arm.com>
Acked-by: "Rafael J. Wysocki" <rafael@kernel.org>
Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231018013851.3303928-1-saravanak@google.com
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1187,8 +1187,6 @@ static void __device_release_driver(stru
 		else if (drv->remove)
 			drv->remove(dev);
 
-		device_links_driver_cleanup(dev);
-
 		devres_release_all(dev);
 		arch_teardown_dma_ops(dev);
 		kfree(dev->dma_range_map);
@@ -1200,6 +1198,8 @@ static void __device_release_driver(stru
 		pm_runtime_reinit(dev);
 		dev_pm_set_driver_flags(dev, 0);
 
+		device_links_driver_cleanup(dev);
+
 		klist_remove(&dev->p->knode_driver);
 		device_pm_check_callbacks(dev);
 		if (dev->bus)


