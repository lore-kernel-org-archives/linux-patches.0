Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707BD26AC3;
	Fri,  4 Sep 2026 05:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499691; cv=none; b=tFApNpVprWtUhgVoK2NtJ0gW5Ezzsai/jmzB5rkLiZzZBgJK3hcI7aJXqmgN7FND5+vzlhkAEWr5UkGOsYZB5FvmWHCvh9PM6iGw3inG8SzY2ocFxO/6Q8Ds3gIiyDk2vYX3vo/YUaY8+9Iy/Vl4Lwfk0p2rqBmv0cIQeBD1Ruk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499691; c=relaxed/simple;
	bh=8BYqu7kexVhH93/EzpUblUiRWp6+s/VYCFsnv0mJZvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+lm2zgVpv0t5NfrLCU3lZEdRsmvzApi+38vdLOdvHjI1vjZaUW3GXrpO9XQNUkqBqO0JHoQMGyWSAZg/wTZecafL68DkaaodjIkVeevy35SLKDkd943+X9gYLhdTzIdVqADLBy/9SxaydHVo1OE0WPvuAuaWjI2VoUcmuRao4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tznZ5Xld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tznZ5Xld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D9D1F00A3D;
	Fri,  4 Sep 2026 05:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499689;
	bh=RsMcnIBbfNHngvAIAZCr/E7kGrKJFUH7m2Tcr26Sjnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tznZ5XldEARri3qhhXx46W5XxPjojcrRiXgH6Ftyl2ZZtHKeyPVw6zBNKvNgqnzn0
	 whv6E8USpofOPweo5vvtEvbRVtax1aEVYjZqOx343nM2ZTRGk9sd8EBFNNSXawn7T5
	 VEDdcsNpWL8sy7CmYEUHuajz5LWKS2Y40moXrZYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.2 507/713] power: supply: qcom_battmgr: fix use-after-free
Date: Fri,  4 Sep 2026 06:57:55 +0200
Message-ID: <20260904045815.187276653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 4e40befedfc8ed86f44e1f81df92d13c149c9f8d upstream.

qcom_battmgr_pdr_notify() queues enable_work when the PMIC GLINK service
comes up, and the worker recovers battmgr through container_of() to issue
firmware requests. The PMIC GLINK client stays on the client list until
its devres release action runs, so a PDR notification can keep queueing
the work, and a pending or running worker can access battmgr after devres
frees it.

Make enable_work device-managed with devm_work_autocancel(), registered
before the PMIC GLINK client is allocated. The devres cleanup then
releases the client first, so no further notification can queue the work,
and cancels the work before battmgr is freed.

This issue was found by an in-house static analysis tool.

Fixes: 29e8142b5623 ("power: supply: Introduce Qualcomm PMIC GLINK power supply")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260731022006.317192-1-fanwu01@zju.edu.cn
Link: https://patch.msgid.link/20260801051923.354496-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/qcom_battmgr.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -5,6 +5,7 @@
  * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 #include <linux/auxiliary_bus.h>
+#include <linux/devm-helpers.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/nvmem-consumer.h>
@@ -1648,7 +1649,6 @@ static int qcom_battmgr_probe(struct aux
 	psy_cfg_supply.supplied_to = qcom_battmgr_battery;
 	psy_cfg_supply.num_supplicants = 1;
 
-	INIT_WORK(&battmgr->enable_work, qcom_battmgr_enable_worker);
 	mutex_init(&battmgr->lock);
 	init_completion(&battmgr->ack);
 
@@ -1711,6 +1711,11 @@ static int qcom_battmgr_probe(struct aux
 					     "failed to register wireless charing power supply\n");
 	}
 
+	ret = devm_work_autocancel(dev, &battmgr->enable_work,
+				   qcom_battmgr_enable_worker);
+	if (ret)
+		return ret;
+
 	battmgr->client = devm_pmic_glink_client_alloc(dev, PMIC_GLINK_OWNER_BATTMGR,
 						       qcom_battmgr_callback,
 						       qcom_battmgr_pdr_notify,


