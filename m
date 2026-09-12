Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05BF32A3DA;
	Sat, 12 Sep 2026 14:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223267; cv=none; b=mh364t0eAqgddVcWo1iz5r0PMAowNYwfS4Moc28G3ieC3aPY6JIgM5Uk9QO/GH+UWsSTmdsQ34GijuxHM1bIVp1b/TDHMB82SbCJWQq/OSg5QmdkVh6zz3vcQ1b87RxBFgXX7NzV2KCSgKdlX3WTuunKHTj1HQGgbNGiuvIxHVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223267; c=relaxed/simple;
	bh=50tl4/TJGdReFhRSVHeMeLxtIVPBWNe6XdCvxsRt/tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trrdy1/HAVbaLF7f73Xm+2hlv7mUf6I9D6JNzZS8jtw+xMqMyojwWayFsKCVM1MQpTYUlknj/La4pFptTlPR2YyDpIpAeVKvBTqpNRve+QqImnsD/BX9ZqGQp+738zvNTd7LaCQu455Vqdz9HWlAfxSGaa/STpWKUA+H3lqbsyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3GUM0yZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3GUM0yZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C553A1F000FF;
	Sat, 12 Sep 2026 14:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223266;
	bh=3MF0gnhXu2YBlFA8Junct8etJuOR6lXwRI4ZeF0HQp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3GUM0yZFtgJwi1NFx+wjMPy5BWokj0TBOQs2FHuDxD7l9YeA4Y8E3Bdj4Q/GoUCb
	 54i260yWRiF9BaU8psbFwtqCBWsFi9cgNBMWeIsxwgQPhB7jxQyHCbMGVrMpC/df1b
	 rBU6I/3zwUf27BgagNj72CTBVPeDeuEHY6aeUY9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0754/1424] firmware: arm_scmi: Protect device request lookup with RCU
Date: Sat, 12 Sep 2026 08:53:06 +0200
Message-ID: <20260912065624.182791764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1f025559ae1f2..99c9666235398 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -31,6 +31,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/processor.h>
+#include <linux/rcupdate.h>
 #include <linux/refcount.h>
 #include <linux/slab.h>
 
@@ -2613,7 +2614,9 @@ static int scmi_device_request_notifier(struct notifier_block *nb,
 	struct scmi_device_id *id_table = data;
 	struct scmi_info *info = req_nb_to_scmi_info(nb);
 
+	rcu_read_lock();
 	np = idr_find(&info->active_protocols, id_table->protocol_id);
+	rcu_read_unlock();
 	if (!np)
 		return NOTIFY_DONE;
 
-- 
2.53.0



