Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4833624A5;
	Sat, 12 Sep 2026 10:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207299; cv=none; b=oN5RYJYI1l7I/VfjBq4VxJ9+cvbAC5mBvCA76q+kzYFyHEO9LpKPsNt3CN6gRjMAYI6NMsmzHdIns/hi7edP4/tP1NeaQIt52OgweResp2jV8VCPWdd6SlPq8SSqaAWqmUXkavf+x6mIxMau0IfaAJ3G+63G9j45sFYu8rOx5ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207299; c=relaxed/simple;
	bh=tl59N9/QAlGlXRrKjjwn+U5fo+0cIv3XPlDwV990JU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMokVMI+mXDsWbHoVCkCVZfxbRl61kYFRpIjNxO6B+ngHkaBbouEe5aPQ1qT4gchUt1D45b/KT+sLi2N/gIpEJKhHCjfQiBtcNz4jSrEIiAIMab/bMVH/+AZJdBRfOissMOTR6nYptGnTAgTKvfXLXnfRdUDBeP/r9PcB/EH+Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBuhnnFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBuhnnFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251951F000FF;
	Sat, 12 Sep 2026 10:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207298;
	bh=VXy4E+XUloR4R6qd5HbPj+si23Gp10wxixRo1EqZ+4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBuhnnFwvirqHh4MfMlIO2x9/IcjeJR4lwtdlhB2ClGqIObEzcXeaXax1/hsMc4so
	 VTnI1+oBhB0fYHG/hsWsDrVO4s47+B0wi3ehbxp7nqw1U0yqtVYmjMuw03lkrKRLZL
	 XYOPoRr6zf3xGxxf55GQo1bh707ZA8Vb2LbMwSzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0385/1518] firmware: arm_scmi: Protect device request lookup with RCU
Date: Sat, 12 Sep 2026 08:42:34 +0200
Message-ID: <20260912065632.170797176@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c6483b8285ae4..a84765b7405bf 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -32,6 +32,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/processor.h>
+#include <linux/rcupdate.h>
 #include <linux/refcount.h>
 #include <linux/slab.h>
 #include <linux/xarray.h>
@@ -2869,7 +2870,9 @@ static int scmi_device_request_notifier(struct notifier_block *nb,
 	struct scmi_device_id *id_table = data;
 	struct scmi_info *info = req_nb_to_scmi_info(nb);
 
+	rcu_read_lock();
 	np = idr_find(&info->active_protocols, id_table->protocol_id);
+	rcu_read_unlock();
 	if (!np)
 		return NOTIFY_DONE;
 
-- 
2.53.0



