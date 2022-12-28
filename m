Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B06B1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82619C433EF;
	Wed, 28 Dec 2022 15:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240210;
	bh=Owd/TYjA3DOn82cbenvxj7kGkvaKUSErgAJJAk1ZdWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f67hmINTB2+yN5GA0RsrNWBrd/SGl5YLYE30Gs2mIu2qymOHv74IAD2adjbYlzPpb
	 ZyL16H4LCjHYJRRFH6Ecj9PnkgHbEhXo1Cjcw75bsQJXBQc62kEG5kdZbINs596Voy
	 I32d6YTSf1RCwhMfARB1KmOQopZoYNvK+YzKokis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0134/1073] thermal: core: fix some possible name leaks in error paths
Date: Wed, 28 Dec 2022 15:28:42 +0100
Message-Id: <20221228144331.672440560@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 4748f9687caaeefab8578285b97b2f30789fc4b4 ]

In some error paths before device_register(), the names allocated
by dev_set_name() are not freed. Move dev_set_name() front to
device_register(), so the name can be freed while calling
put_device().

Fixes: 1dd7128b839f ("thermal/core: Fix null pointer dereference in thermal_release()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 50d50cec7774..15fb5fa1b0f2 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -903,10 +903,6 @@ __thermal_cooling_device_register(struct device_node *np,
 	cdev->id = ret;
 	id = ret;
 
-	ret = dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
-	if (ret)
-		goto out_ida_remove;
-
 	cdev->type = kstrdup(type ? type : "", GFP_KERNEL);
 	if (!cdev->type) {
 		ret = -ENOMEM;
@@ -921,6 +917,11 @@ __thermal_cooling_device_register(struct device_node *np,
 	cdev->device.class = &thermal_class;
 	cdev->devdata = devdata;
 	thermal_cooling_device_setup_sysfs(cdev);
+	ret = dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
+	if (ret) {
+		thermal_cooling_device_destroy_sysfs(cdev);
+		goto out_kfree_type;
+	}
 	ret = device_register(&cdev->device);
 	if (ret)
 		goto out_kfree_type;
@@ -1241,10 +1242,6 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
 	tz->id = id;
 	strlcpy(tz->type, type, sizeof(tz->type));
 
-	result = dev_set_name(&tz->device, "thermal_zone%d", tz->id);
-	if (result)
-		goto remove_id;
-
 	if (!ops->critical)
 		ops->critical = thermal_zone_device_critical;
 
@@ -1267,6 +1264,11 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
 	/* A new thermal zone needs to be updated anyway. */
 	atomic_set(&tz->need_update, 1);
 
+	result = dev_set_name(&tz->device, "thermal_zone%d", tz->id);
+	if (result) {
+		thermal_zone_destroy_device_groups(tz);
+		goto remove_id;
+	}
 	result = device_register(&tz->device);
 	if (result)
 		goto release_device;
-- 
2.35.1



