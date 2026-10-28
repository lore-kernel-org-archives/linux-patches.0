Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208289;
	b=qwRMOZKrdsiVhovegpbRUyG4Ku6JT7bZCbteOS4xFVAwEf8Lgi6+fu5wMVNx3n3vf7iY
	 LWMdj2gn9OSqZGRObDGTJih8kpVxwZ8wW9xoJ5Iuzp+oSb/dBZe9/lpaWlk7Bc2+GAqdd
	 V3xH9eHfPvJrzQPzbiYlgmRy8CY9OSyvJiVBt6smbMDSf0wPdvto5OFmAV2Rn8iyKyM+I
	 6Ej7/t4IOcLjIM7UmhlD1i7JUhDoHs24aXcfj7LbNJx4eYKYF6pAMdz6PTWvMIN6+QwSI
	 EZ5QhwqZob2NYRikE94CFun3w5NdulaF0msYFL3TJaLNkZ1SiZqT1n/ESAPRWeprrsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u0YuMJSYipoUVwIJkW3U4IuUFcSBjfTSNe5AH8FKijI=;
	b=qVU5dkNHaalfPkNOpbrGIthRPFjGa5vBV9hBe6qNnt49A/rncqb1thaFIWKnJOxpmUeu
	 NRNPhS3pa1mSonCNMEFGCDS0vtMEFmvKKA/4C6bm4veMfpGaxS58Y6NQYdoPIYISqExE7
	 YOm0u4Hj20ZHqOtNUhPct50EsOkQKN4MJVJCttx7nWABi1xu6IuiUsqi6OgSHy8/tsHIV
	 R99qvnQ152GLkSmq+vSObEL8cQhwiSmLr3Lvu8vMlRIMhW0vPPadZGo6L5tqy6LYYP/yj
	 bTZM04HIpdk/hyi5Kel6OCz8y2ChVedlx9k1Sk+nowPkCNnqls3XtIBF18v8QcV6zCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ThKGvHP0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4170606A32E;
	Wed, 28 Oct 2026 17:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ThKGvHP0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516C21F031E2;
	Wed, 28 Oct 2026 17:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208288;
	bh=u0YuMJSYipoUVwIJkW3U4IuUFcSBjfTSNe5AH8FKijI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThKGvHP0Van01t9JzKXFJcKDLvG9igJ6ao0mTpg7f9FxXEvRyhUihAvE8I5TAt4MI
	 Jn5DRvIiJTbmJ9iL+0wbt58pQ+0kH4VHIIRt8VJPYg2gCRJGfdiNaOXGu+qkKgijLU
	 YZzrBYLBMawgDi6CRr1ekvbIui+wqDZ4SeWQa2ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/516] workqueue: Add resource managed version of delayed work init
Date: Wed, 28 Oct 2026 17:53:40 +0100
Message-ID: <20261028170005.136233413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit 0341ce5443949588e93581b49b934cdde2befbf8 ]

A few drivers which need a delayed work-queue must cancel work at driver
detach. Some of those implement remove() solely for this purpose. Help
drivers to avoid unnecessary remove and error-branch implementation by
adding managed verision of delayed work initialization. This will also
help drivers to avoid mixing manual and devm based unwinding when other
resources are handled by devm.

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/51769ea4668198deb798fe47fcfb5f5288d61586.1616506559.git.matti.vaittinen@fi.rohmeurope.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 9d34c9d660c3 ("power: supply: bq24257: fix use-after-free on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/devm-helpers.h | 53 ++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 include/linux/devm-helpers.h

diff --git a/include/linux/devm-helpers.h b/include/linux/devm-helpers.h
new file mode 100644
index 0000000000000..f64e0c9f3763c
--- /dev/null
+++ b/include/linux/devm-helpers.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __LINUX_DEVM_HELPERS_H
+#define __LINUX_DEVM_HELPERS_H
+
+/*
+ * Functions which do automatically cancel operations or release resources upon
+ * driver detach.
+ *
+ * These should be helpful to avoid mixing the manual and devm-based resource
+ * management which can be source of annoying, rarely occurring,
+ * hard-to-reproduce bugs.
+ *
+ * Please take into account that devm based cancellation may be performed some
+ * time after the remove() is ran.
+ *
+ * Thus mixing devm and manual resource management can easily cause problems
+ * when unwinding operations with dependencies. IRQ scheduling a work in a queue
+ * is typical example where IRQs are often devm-managed and WQs are manually
+ * cleaned at remove(). If IRQs are not manually freed at remove() (and this is
+ * often the case when we use devm for IRQs) we have a period of time after
+ * remove() - and before devm managed IRQs are freed - where new IRQ may fire
+ * and schedule a work item which won't be cancelled because remove() was
+ * already ran.
+ */
+
+#include <linux/device.h>
+#include <linux/workqueue.h>
+
+static inline void devm_delayed_work_drop(void *res)
+{
+	cancel_delayed_work_sync(res);
+}
+
+/**
+ * devm_delayed_work_autocancel - Resource-managed work allocation
+ * @dev: Device which lifetime work is bound to
+ * @pdata: work to be cancelled when driver is detached
+ *
+ * Initialize work which is automatically cancelled when driver is detached.
+ * A few drivers need delayed work which must be cancelled before driver
+ * is detached to avoid accessing removed resources.
+ * devm_delayed_work_autocancel() can be used to omit the explicit
+ * cancelleation when driver is detached.
+ */
+static inline int devm_delayed_work_autocancel(struct device *dev,
+					       struct delayed_work *w,
+					       work_func_t worker)
+{
+	INIT_DELAYED_WORK(w, worker);
+	return devm_add_action(dev, devm_delayed_work_drop, w);
+}
+
+#endif
-- 
2.53.0



