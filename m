Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCBA217F26;
	Thu, 12 Dec 2024 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016081; cv=none; b=X29Ww8rYTRQPVTlXjrGDLEOYPmUkTIcoCeeBfI3/PWJe3dHLeHQ2oYEAi6Y+kjPkkSYrw1QUSTCjHavfCtHeKj1h0NDsazTG2ffRmwFWt/WnLVfxRt1676xix13tjVNML/RLTjgQ6W7qMbxF0m8+lEmKVkaysHvUNoXgGmdmqKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016081; c=relaxed/simple;
	bh=IMYAPhrBHwVtW2QeybTLFIoTM9qqZB32gw5Vl1dX1zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyb0HZEIgcnjAVqCgPnKhk07iLyUrdRwQApubzytAzgBxKcqgQkobuHfMln85kR0rmQm6lpaiNG+chcsBeSDDbjDVuOQ5ZAsG4jkFjkqEebidin06jaF6036d5MPmItIZWQ5oCSla5np7VOUkRLfopjsDFxnJ/xmp0B/20heAZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcLO1JEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcLO1JEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA578C4CED7;
	Thu, 12 Dec 2024 15:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016081;
	bh=IMYAPhrBHwVtW2QeybTLFIoTM9qqZB32gw5Vl1dX1zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcLO1JEJMdX3GdYK8A8Ks2pb5BJ0QtZGp5JFzdJMXYeSls5mRRFlIKh2/blVBnx7m
	 7lKa35TwfY39aJf1YPV13T3N4yO5Zh1fjiRwwqYNKNS778Z6x25NfUv+C6XPUh/m8q
	 h+hmlmBFE2f9TRKn1qqXO0mS7StQlV56lstyv/hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/466] pmdomain: core: Fix error path in pm_genpd_init() when ida alloc fails
Date: Thu, 12 Dec 2024 15:54:25 +0100
Message-ID: <20241212144310.606798184@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 3e3b71d35a02cee4b2cc3d4255668a6609165518 ]

When the ida allocation fails we need to free up the previously allocated
memory before returning the error code. Let's fix this and while at it,
let's also move the ida allocation to genpd_alloc_data() and the freeing to
genpd_free_data(), as it better belongs there.

Fixes: 899f44531fe6 ("pmdomain: core: Add GENPD_FLAG_DEV_NAME_FW flag")
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Message-ID: <20241122134207.157283-3-ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/core.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/pmdomain/core.c b/drivers/pmdomain/core.c
index e330490d8d7c8..778ff187ac59e 100644
--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -2171,8 +2171,24 @@ static int genpd_alloc_data(struct generic_pm_domain *genpd)
 	}
 
 	genpd->gd = gd;
-	return 0;
+	device_initialize(&genpd->dev);
+
+	if (!genpd_is_dev_name_fw(genpd)) {
+		dev_set_name(&genpd->dev, "%s", genpd->name);
+	} else {
+		ret = ida_alloc(&genpd_ida, GFP_KERNEL);
+		if (ret < 0)
+			goto put;
 
+		genpd->device_id = ret;
+		dev_set_name(&genpd->dev, "%s_%u", genpd->name, genpd->device_id);
+	}
+
+	return 0;
+put:
+	put_device(&genpd->dev);
+	if (genpd->free_states == genpd_free_default_power_state)
+		kfree(genpd->states);
 free:
 	if (genpd_is_cpu_domain(genpd))
 		free_cpumask_var(genpd->cpus);
@@ -2183,6 +2199,8 @@ static int genpd_alloc_data(struct generic_pm_domain *genpd)
 static void genpd_free_data(struct generic_pm_domain *genpd)
 {
 	put_device(&genpd->dev);
+	if (genpd->device_id != -ENXIO)
+		ida_free(&genpd_ida, genpd->device_id);
 	if (genpd_is_cpu_domain(genpd))
 		free_cpumask_var(genpd->cpus);
 	if (genpd->free_states)
@@ -2271,20 +2289,6 @@ int pm_genpd_init(struct generic_pm_domain *genpd,
 	if (ret)
 		return ret;
 
-	device_initialize(&genpd->dev);
-
-	if (!genpd_is_dev_name_fw(genpd)) {
-		dev_set_name(&genpd->dev, "%s", genpd->name);
-	} else {
-		ret = ida_alloc(&genpd_ida, GFP_KERNEL);
-		if (ret < 0) {
-			put_device(&genpd->dev);
-			return ret;
-		}
-		genpd->device_id = ret;
-		dev_set_name(&genpd->dev, "%s_%u", genpd->name, genpd->device_id);
-	}
-
 	mutex_lock(&gpd_list_lock);
 	list_add(&genpd->gpd_list_node, &gpd_list);
 	mutex_unlock(&gpd_list_lock);
@@ -2325,8 +2329,6 @@ static int genpd_remove(struct generic_pm_domain *genpd)
 	genpd_unlock(genpd);
 	genpd_debug_remove(genpd);
 	cancel_work_sync(&genpd->power_off_work);
-	if (genpd->device_id != -ENXIO)
-		ida_free(&genpd_ida, genpd->device_id);
 	genpd_free_data(genpd);
 
 	pr_debug("%s: removed %s\n", __func__, dev_name(&genpd->dev));
-- 
2.43.0



