Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB772F531B;
	Sat, 12 Sep 2026 12:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215484; cv=none; b=dvuiAzim5W3cwP0n6Ne7MIoF77lSuBch+IFowbk1lk2GcxzQ9D44XGL2ofPthHSMHtnxFeTvGigBGvhfaY04mpCIe7YtzWrwAj2A8a5wrFT4W1PUjDqGhtO7XW+JbR+sQH7e/i6fHKDkgDMMfSusRN+b1JClwh4vbhsvFzEXeGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215484; c=relaxed/simple;
	bh=M/z/KqXDJz/svVddtX7sI2yzc+ICbA31iyOhouJGuJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeJEXjPSMFUeppHrFwMq0g/G5JcJuh6xwXALjuIPhwn2UIzUdwpiPL6pb36Yx18z61Hr3GyKMlmhJBxeJhql2IQjTP4pkah81ZV2JDnxvIcmq3jH2grsn4RiYLl1DZeQZo0G+Slil/5a/3coHka5yeruyV2Zj58XxSgevBlGz0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQyVKZdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQyVKZdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836491F000FF;
	Sat, 12 Sep 2026 12:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215483;
	bh=3sl1DXOnoYGvVdijsfUxs0m+dfm2Xo89HYQO/+if79Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQyVKZdZOOl/7XyP10vko26InT4kfNQJ/AABCE3XN+cCYRGbEmnsPst3tUNS4p7Os
	 7ejpX70lkcunzAm9F/MtnmuvAfuRe3EiJT5G9kVTxTf1nplhRBia/0VvEdKjIWq3X0
	 +mTvW1ZOtVqMlEyk5oaBDEj8Xw4Zepa6tPs2MCm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0541/1376] firmware: arm_scmi: Protect device request lookup with RCU
Date: Sat, 12 Sep 2026 08:49:27 +0200
Message-ID: <20260912065619.599167720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit e6a0e7a49d83e4fa4e1db68d74f99282eb97aa49 ]

The SCMI device request notifier looks up protocol OF nodes from the
active_protocols IDR. The IDR lookup can run concurrently with protocol
activation while probe is still registering protocols and creating their
SCMI devices.

Wrap the lookup in an RCU read-side critical section as required by the
IDR API for lockless readers.

Fixes: 53b8c25df708 ("firmware: arm_scmi: Add common notifier helpers")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-9-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 17f0a461cb96f..179005c64aa5c 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -31,6 +31,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/processor.h>
+#include <linux/rcupdate.h>
 #include <linux/refcount.h>
 #include <linux/slab.h>
 #include <linux/xarray.h>
@@ -2834,7 +2835,9 @@ static int scmi_device_request_notifier(struct notifier_block *nb,
 	struct scmi_device_id *id_table = data;
 	struct scmi_info *info = req_nb_to_scmi_info(nb);
 
+	rcu_read_lock();
 	np = idr_find(&info->active_protocols, id_table->protocol_id);
+	rcu_read_unlock();
 	if (!np)
 		return NOTIFY_DONE;
 
-- 
2.53.0



