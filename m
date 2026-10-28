Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217372;
	b=svi07F4d/VQGIzrHSqG/EEGnzOZ9i1R1mN3RljljkKef/zNhdG4SeYCV+nVJOK1C5GlT
	 wXd0K0umvv00dthu0K8wyD2UXlAtOmF+QIw2wlv9on0JGg+4D/zjbaBVgs/pPHtaZD2qz
	 HlR91q7f563Z1LCoB5RFrx2qAJVn2DzV9g/ekkpaklj+cYsiKULMjs4mCpyPDDpIyalFZ
	 fKh7ioLCE5xt2EoJNWJiJNGzaz9gczjv8qCYSDzBnGXx4t/Gs4l0hpITO5d9E5wsZAv6J
	 yiEYGxhKWtEH8yUKI/VRbNO8PGmX5fVsC2IWvdDsF33RK17v2fqe3/kETnpG1+ODqiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9m020ce0ytV7sLNpy0MfbYC1nfjRxaQoz5jgAy6UlZ8=;
	b=rC8+zmabgDeuqTdbTMwhNVZVOf9pzuY5U2uP3VkTBlbt3bn9EXjua2BXJqbOjPRO8CdU
	 LblTqyU0bY8fCkUimaKMb/kM8XZo6B8HJXhOwkIyZAAyuy0G01dR99YcGCBsCoXej8woi
	 Iefn4BaB1SQpnWKtXuE3l28Zbu50IN7jW0NI6PY82/cNBIDsMPwxtwFHWZXsQH/IxQzel
	 cYUnmNeYLfV5oKNyEJcE1h5e/D6tGgoNLgYojmYbEdHUzbNcvw9XQfgXiIq8FIV/I+OSQ
	 3AdlQQNnVQaSaCoHX7rYhLhK6CGsdvz4NKfwAFfsMLBJViRxbNFUAupcDydlfe2IS6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=quGSSoGK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401BB606A31C;
	Wed, 28 Oct 2026 19:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=quGSSoGK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8641F01825;
	Wed, 28 Oct 2026 19:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217372;
	bh=9m020ce0ytV7sLNpy0MfbYC1nfjRxaQoz5jgAy6UlZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=quGSSoGK0fbVNJIwmbnBtxpDA9kDjP8OVKpvq141Db70/DoiZfbjBazRsUOoIDu+t
	 pG0xepomiAIZKld21jH+9N37JrSNNBpObbqs2lrN/XOxL1OBe6Fy5zZm72DW+XcFGp
	 vzLAbDT2D7IVqvY+VkDP1OEmB5WGRH9WYjS3JS4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1837/1887] firmware: arm_scmi: Protect device request lookup with RCU
Date: Wed, 28 Oct 2026 18:05:33 +0100
Message-ID: <20261028170541.251478830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2a814d3c4ca28..75dc215f1ec9d 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -28,6 +28,7 @@
 #include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/processor.h>
+#include <linux/rcupdate.h>
 #include <linux/refcount.h>
 #include <linux/slab.h>
 
@@ -2282,7 +2283,9 @@ static int scmi_device_request_notifier(struct notifier_block *nb,
 	struct scmi_device_id *id_table = data;
 	struct scmi_info *info = req_nb_to_scmi_info(nb);
 
+	rcu_read_lock();
 	np = idr_find(&info->active_protocols, id_table->protocol_id);
+	rcu_read_unlock();
 	if (!np)
 		return NOTIFY_DONE;
 
-- 
2.53.0



