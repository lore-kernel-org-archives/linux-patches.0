Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD60013FD86;
	Wed, 19 Feb 2025 09:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956213; cv=none; b=IaNF6yFp+sr86EfNXS6pW5jWhn/eADMPD2txsk39iXdl0H/wxYoReCxi5tsqZ5SQnW3VnN2DsYUIiiuO3SWpiXp1xQ61Sh8d6yCF1YkMJG6jfuwnXtJG6u6wUNCffJGS7weGHNUfjqJNtgXHHQdkxq1yQ0OoSbk3CKmxd7So390=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956213; c=relaxed/simple;
	bh=ncKzvr9jyKwMCoKVRWOKuqtlffOVUqM20zNzzPDfbSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mz8RXX+m67xRoxNN9Y9WbvFE0gxPdwZS1gurReWZVM1gr3s+y62Lkt9A6/Vqq2fBt07Q9860ZisDJ+u4qYDZocim121Dyv4W3vEZv35bFFKRPxpmNqb2dgde/fH8BzyviXY2Pa3kcZujEzyAkBKGm2d6g+2LmUMcqvB722a+VrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZ/VCa17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZ/VCa17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D3BC4CED1;
	Wed, 19 Feb 2025 09:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956212;
	bh=ncKzvr9jyKwMCoKVRWOKuqtlffOVUqM20zNzzPDfbSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZ/VCa171j5ep3L2IQmNyzHNW2xP6DIGwHBQy2pt2flYtcMaqiMXKlWyi1z1G8PH3
	 FYrcjZf6Cgg7kAlSfIGwA1gTMJqU4dsZ9s17g3WApoo0nsLFzri+ALnGYq6ooYf2KT
	 IKLdKmataWB7bWjK8EQvcCjvKyCyGhgnW2WJiC+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Will McVicker <willmcvicker@google.com>,
	Pankaj Dubey <pankaj.dubey@samsung.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/578] mfd: syscon: Fix race in device_node_get_regmap()
Date: Wed, 19 Feb 2025 09:21:20 +0100
Message-ID: <20250219082655.878496617@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 805f7aaf7fee14a57b56af01d270edf6c10765e8 ]

It is possible for multiple, simultaneous callers calling
device_node_get_regmap() with the same node to fail to find an entry in
the syscon_list. There is a period of time while the first caller is
calling of_syscon_register() that subsequent callers also fail to find
an entry in the syscon_list and then call of_syscon_register() a second
time.

Fix this by keeping the lock held until after of_syscon_register()
completes and adds the node to syscon_list. Convert the spinlock to a
mutex as many of the functions called in of_syscon_register() such as
kzalloc() and of_clk_get() may sleep.

Fixes: bdb0066df96e ("mfd: syscon: Decouple syscon interface from platform devices")
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Will McVicker <willmcvicker@google.com>
Tested-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Link: https://lore.kernel.org/r/20241217-syscon-fixes-v2-1-4f56d750541d@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/syscon.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index cc7b07882fee4..8302cd63a73d0 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -15,6 +15,7 @@
 #include <linux/io.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
@@ -26,7 +27,7 @@
 
 static struct platform_driver syscon_driver;
 
-static DEFINE_SPINLOCK(syscon_list_slock);
+static DEFINE_MUTEX(syscon_list_lock);
 static LIST_HEAD(syscon_list);
 
 struct syscon {
@@ -51,6 +52,8 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_clk)
 	struct regmap_config syscon_config = syscon_regmap_config;
 	struct resource res;
 
+	WARN_ON(!mutex_is_locked(&syscon_list_lock));
+
 	struct syscon *syscon __free(kfree) = kzalloc(sizeof(*syscon), GFP_KERNEL);
 	if (!syscon)
 		return ERR_PTR(-ENOMEM);
@@ -131,9 +134,7 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_clk)
 	syscon->regmap = regmap;
 	syscon->np = np;
 
-	spin_lock(&syscon_list_slock);
 	list_add_tail(&syscon->list, &syscon_list);
-	spin_unlock(&syscon_list_slock);
 
 	return_ptr(syscon);
 
@@ -152,7 +153,7 @@ static struct regmap *device_node_get_regmap(struct device_node *np,
 {
 	struct syscon *entry, *syscon = NULL;
 
-	spin_lock(&syscon_list_slock);
+	mutex_lock(&syscon_list_lock);
 
 	list_for_each_entry(entry, &syscon_list, list)
 		if (entry->np == np) {
@@ -160,11 +161,11 @@ static struct regmap *device_node_get_regmap(struct device_node *np,
 			break;
 		}
 
-	spin_unlock(&syscon_list_slock);
-
 	if (!syscon)
 		syscon = of_syscon_register(np, check_clk);
 
+	mutex_unlock(&syscon_list_lock);
+
 	if (IS_ERR(syscon))
 		return ERR_CAST(syscon);
 
@@ -195,7 +196,7 @@ int of_syscon_register_regmap(struct device_node *np, struct regmap *regmap)
 		return -ENOMEM;
 
 	/* check if syscon entry already exists */
-	spin_lock(&syscon_list_slock);
+	mutex_lock(&syscon_list_lock);
 
 	list_for_each_entry(entry, &syscon_list, list)
 		if (entry->np == np) {
@@ -208,12 +209,12 @@ int of_syscon_register_regmap(struct device_node *np, struct regmap *regmap)
 
 	/* register the regmap in syscon list */
 	list_add_tail(&syscon->list, &syscon_list);
-	spin_unlock(&syscon_list_slock);
+	mutex_unlock(&syscon_list_lock);
 
 	return 0;
 
 err_unlock:
-	spin_unlock(&syscon_list_slock);
+	mutex_unlock(&syscon_list_lock);
 	kfree(syscon);
 	return ret;
 }
-- 
2.39.5



