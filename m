Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9D44D5A1;
	Sat, 12 Sep 2026 07:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198543; cv=none; b=mPQkCikbzFYshHlzr0B+J8uS2/zEloOKzGMUANWcseRFZKxJNLKbklBZtEwSj+5RCgoBXVEDZtnEIhZYr52DGKZdryOkCX04WnokbEIHufK1XehIMfkcD45+W0luXX91gHDy/eunp1vDTd9QHPFoAHc6DupV5bk9Z/9puiimO74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198543; c=relaxed/simple;
	bh=AU8h3zCq0LrCsEbUH3J/RB3Rh89yE2qJIoQ9mZtHe34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcLpYoJHMpaqJurwQvCITy7NHBks9h4i+fKn461iU+jV1RlCgR1ZyK8VpTMN8ysdQrxY/myq8SfBbhoPZ/4xca4ELp2D9k/CuLdSXiKKzSnLWFyrUOHJSzG9iqAiAnpjD4Faub4CzPIHbsokc0MfSIeEL2wrYqhkb0RBN5KmzrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCUrnWwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCUrnWwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B351F000FF;
	Sat, 12 Sep 2026 07:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198542;
	bh=Tn4yb7PeO5dxFI7tSICdl5NwiIxG0c8q3a0fTLYO6OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCUrnWwAKFytLOFffug+r4+9WDQMPDjbueFcsfu0ZhlhPLzJmJIF3xfGj1PqZqEIP
	 gTAUbVu63auYp5d/OOHhVENsaA0o2rEhwiG5iJQFfViGBeqcxUM2NX+RUsrEjWgwBk
	 8Pn6HCyfirWYilynLUTSj9Dmyn0bhzRdZI1fNEK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0401/1815] firmware: arm_scmi: Protect device request lookup with RCU
Date: Sat, 12 Sep 2026 08:35:51 +0200
Message-ID: <20260912065658.309415568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index f607557c04ad2..a2871dca24dce 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -33,6 +33,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/processor.h>
+#include <linux/rcupdate.h>
 #include <linux/refcount.h>
 #include <linux/slab.h>
 #include <linux/xarray.h>
@@ -2958,7 +2959,9 @@ static int scmi_device_request_notifier(struct notifier_block *nb,
 	struct scmi_device_id *id_table = data;
 	struct scmi_info *info = req_nb_to_scmi_info(nb);
 
+	rcu_read_lock();
 	np = idr_find(&info->active_protocols, id_table->protocol_id);
+	rcu_read_unlock();
 	if (!np)
 		return NOTIFY_DONE;
 
-- 
2.53.0



