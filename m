Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590797;
	b=rKsA1d91nzKA5bivYjKpu/m0Nz1ql/NDfqlUWvYUzG2jQvH9A4tIrGYejPOsTGw11WSd
	 zTB0N9MYGs/A5AN4RcElr8k34AeuXhW3J5tTU5lwOOy/+h6R7zigSnrgJncyfSUgHiiX7
	 xcaUfUVImqQ9IdbzKGSgAJiifsCCFxQLYks7ztvsf+LiAYES82c6qhtqb25UFzISmUq0q
	 Lsn97nT++QiSG5xRO/CNGGx3EDm+yReky4Q6UpcbVLR/jjie0c60Exvixe90uQunWyYdE
	 yyA86P3I924N4IMvZesmSBPQqkV7/IT5H4UDSEygKpfb8Jf6o6EIRfoANam3Nc11zcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fKwAP50wuJXaV+fTLIWrJfWXl0DF+jpcR0f7GbXLiDI=;
	b=VjRAdt9s3DxpY969oU8VehiXIAaX0l0uirK2ULigK4f42i56NIHkjHW49w+rGeMb9QHx
	 hkcwx0ijsNgqNK6/CX5IG486Lv+OOW5bDX9JkP8nGy1yKsn9PZ2b93J+AGgB0fwNrCLu0
	 Z1fV9j7lql+SgScejcTCvXEik7CERieOwisUfzEydctHfLjLr5MO/IQkwhGf1WkwKmUL8
	 aSsbPSB/0KU5JLY2V9THPNorukTBhsUoA6w283TYx4LK0OT7kr/LGT9hREPlhKHpS35mW
	 AgMY+Ij3E5Kr6lJWmitFVUOiAnbGDcAr+rF/ftyusv6YaCWeHhUAgGj8dyLpKQJxz4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DPd3uchO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C68B607D2E1;
	Fri, 13 Nov 2026 17:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DPd3uchO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289721F000C5;
	Fri, 13 Nov 2026 17:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590797;
	bh=fKwAP50wuJXaV+fTLIWrJfWXl0DF+jpcR0f7GbXLiDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPd3uchO5rc+pWDBm9GBNio7tN0/yVqvjgaEoKJyO8/kXtgFkkQHTBKR/qaDSdAGY
	 jQju4B9AYmaaUx6pgBCy8NKk7ECb2eaHmhTEVfm4dBDR00qIeuHDZ9/3E0SsyzHUvU
	 QyCZ9yPywNFnprIwR6XSRu91X0J6kdSIGOefEidA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Yingjie Wang <1075151112@qq.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 650/686] nvmet-tcp: validate the TLS handshake timeout
Date: Fri, 13 Nov 2026 10:53:03 -0500
Message-ID: <20261113153843.793878514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yingjie Wang <1075151112@qq.com>

[ Upstream commit e3e7a85730a4b17efa1e2ff4088443c4753be683 ]

tls_handshake_timeout is writable but stored as a signed int. Multiplying
the value by MSEC_PER_SEC and HZ therefore uses signed arithmetic.

With HZ=1000, setting it to 2147484 overflows both multiplications. If
the handshake request is accepted and remains pending, the timer wheel
treats the jiffies delay as already expired and queues the timeout work
on its next advance, while the handshake agent was given about 24.9
days. Negative values such as -1 cause the same immediate kernel-side
timeout.

Store the parameter as an unsigned int and reject values that cannot be
represented both by tls_handshake_args::ta_timeout_ms and by a safe
jiffies delay. Take one snapshot so a concurrent parameter update cannot
give the handshake agent and delayed work different timeouts. Document
the accepted range for built-in use.

Negative and oversized values now fail with -EINVAL. Keep zero valid,
preserving the existing immediate-timeout behavior.

Fixes: 675b453e0241 ("nvmet-tcp: enable TLS handshake upcall")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>

Backport notes: Route timeout validation through the existing parameter
setter, preserving the validation of the other parameters and avoiding a
new function. Omit the unrelated dynamic-quirks documentation and retain
its blank separator so the host timeout fix merges cleanly.

Stable-dep-of: 799203afd298 ("nvme-tcp: validate the TLS handshake timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  6 +++++
 drivers/nvme/target/tcp.c                     | 26 ++++++++++++++++---
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 5bf1df91607eb..1b53bc0671249 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4651,6 +4651,12 @@ Kernel parameters
 			This can be set from sysctl after boot.
 			See Documentation/admin-guide/sysctl/vm.rst for details.
 
+
+	nvmet_tcp.tls_handshake_timeout=
+			[NVME] NVMe/TCP target TLS handshake timeout in seconds.
+			Valid values range from 0 to the smaller of
+			UINT_MAX / 1000 and MAX_JIFFY_OFFSET / HZ. Default: 10
+
 	ohci1394_dma=early	[HW,EARLY] enable debugging via the ohci1394 driver.
 			See Documentation/core-api/debugging-via-ohci1394.rst for more
 			info.
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index b9a904f184892..f478f226e29fd 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -6,6 +6,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/jiffies.h>
 #include <linux/slab.h>
 #include <linux/crc32c.h>
 #include <linux/err.h>
@@ -41,8 +42,18 @@ static int param_store_val(const char *str, int *val, int min, int max)
 	return 0;
 }
 
+#ifdef CONFIG_NVME_TARGET_TCP_TLS
+static unsigned int tls_handshake_timeout = 10;
+#endif
+
 static int set_params(const char *str, const struct kernel_param *kp)
 {
+#ifdef CONFIG_NVME_TARGET_TCP_TLS
+	if (kp->arg == &tls_handshake_timeout)
+		return param_set_uint_minmax(str, kp, 0,
+			min_t(unsigned long, UINT_MAX / MSEC_PER_SEC,
+			      MAX_JIFFY_OFFSET / HZ));
+#endif
 	return param_store_val(str, kp->arg, 0, INT_MAX);
 }
 
@@ -76,8 +87,14 @@ MODULE_PARM_DESC(idle_poll_period_usecs,
 /*
  * TLS handshake timeout
  */
-static int tls_handshake_timeout = 10;
-module_param(tls_handshake_timeout, int, 0644);
+static const struct kernel_param_ops tls_handshake_timeout_ops = {
+	.set = set_params,
+	.get = param_get_uint,
+};
+
+module_param_cb(tls_handshake_timeout, &tls_handshake_timeout_ops,
+		&tls_handshake_timeout, 0644);
+__MODULE_PARM_TYPE(tls_handshake_timeout, "uint");
 MODULE_PARM_DESC(tls_handshake_timeout,
 		 "nvme TLS handshake timeout in seconds (default 10)");
 #endif
@@ -1926,6 +1943,7 @@ static int nvmet_tcp_tls_handshake(struct nvmet_tcp_queue *queue)
 {
 	int ret = -EOPNOTSUPP;
 	struct tls_handshake_args args;
+	unsigned int timeout = READ_ONCE(tls_handshake_timeout);
 
 	if (queue->state != NVMET_TCP_Q_TLS_HANDSHAKE) {
 		pr_warn("cannot start TLS in state %d\n", queue->state);
@@ -1939,7 +1957,7 @@ static int nvmet_tcp_tls_handshake(struct nvmet_tcp_queue *queue)
 	args.ta_done = nvmet_tcp_tls_handshake_done;
 	args.ta_data = queue;
 	args.ta_keyring = key_serial(queue->port->nport->keyring);
-	args.ta_timeout_ms = tls_handshake_timeout * 1000;
+	args.ta_timeout_ms = timeout * MSEC_PER_SEC;
 
 	ret = tls_server_hello_psk(&args, GFP_KERNEL);
 	if (ret) {
@@ -1947,7 +1965,7 @@ static int nvmet_tcp_tls_handshake(struct nvmet_tcp_queue *queue)
 		pr_err("failed to start TLS, err=%d\n", ret);
 	} else {
 		queue_delayed_work(nvmet_wq, &queue->tls_handshake_tmo_work,
-				   tls_handshake_timeout * HZ);
+				   (unsigned long)timeout * HZ);
 	}
 	return ret;
 }
-- 
2.53.0



