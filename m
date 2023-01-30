Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F1328EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A5CC433EF;
	Mon, 30 Jan 2023 14:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087315;
	bh=bXjbyUsvr/NuB9rjNJzTi5gu5fIcnfr1NGjHq9vU8KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GWKTGyUdHA0A6lcCdm7nJWxAMvicCZH4wpZfxynKZYMWbByVOMRGVWdJzSz3xpNA
	 vGMdQeIFe81Z7FOgWilc0m/se08QsrBix2AO6QoxzIUvcmkfdJsuJcPe8uk9B5MXTG
	 SfkYCpgG8JbJ45JmQO+dWhvvvGB2r7NU03QNxYUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/313] thermal: core: call put_device() only after device_register() fails
Date: Mon, 30 Jan 2023 14:49:32 +0100
Message-Id: <20230130134343.028190499@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 6c54b7bc8a31ce0f7cc7f8deef05067df414f1d8 ]

put_device() shouldn't be called before a prior call to
device_register(). __thermal_cooling_device_register() doesn't follow
that properly and needs fixing. Also
thermal_cooling_device_destroy_sysfs() is getting called unnecessarily
on few error paths.

Fix all this by placing the calls at the right place.

Based on initial work done by Caleb Connolly.

Fixes: 4748f9687caa ("thermal: core: fix some possible name leaks in error paths")
Fixes: c408b3d1d9bb ("thermal: Validate new state in cur_state_store()")
Reported-by: Caleb Connolly <caleb.connolly@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Frank Rowand <frowand.list@gmail.com>
Reviewed-by: Yang Yingliang <yangyingliang@huawei.com>
Tested-by: Caleb Connolly <caleb.connolly@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 449e60c4a1b6..1eae4ec719a8 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -893,15 +893,20 @@ __thermal_cooling_device_register(struct device_node *np,
 	cdev->devdata = devdata;
 
 	ret = cdev->ops->get_max_state(cdev, &cdev->max_state);
-	if (ret)
-		goto out_kfree_type;
+	if (ret) {
+		kfree(cdev->type);
+		goto out_ida_remove;
+	}
 
 	thermal_cooling_device_setup_sysfs(cdev);
+
 	ret = dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
 	if (ret) {
+		kfree(cdev->type);
 		thermal_cooling_device_destroy_sysfs(cdev);
-		goto out_kfree_type;
+		goto out_ida_remove;
 	}
+
 	ret = device_register(&cdev->device);
 	if (ret)
 		goto out_kfree_type;
@@ -927,6 +932,8 @@ __thermal_cooling_device_register(struct device_node *np,
 	thermal_cooling_device_destroy_sysfs(cdev);
 	kfree(cdev->type);
 	put_device(&cdev->device);
+
+	/* thermal_release() takes care of the rest */
 	cdev = NULL;
 out_ida_remove:
 	ida_free(&thermal_cdev_ida, id);
-- 
2.39.0



