Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548A046C4A2;
	Tue, 21 Jul 2026 15:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649512; cv=none; b=YO+8/QJZlRl1tQZUYg+DjI+XkealPAU//oNouRiyubSwkyuCGt6cYIZGyCZy/AV7MhJGzp/UcBzROUFjNYCgxhXeWhVHf1gTVIfqkLmvrZq/TamzZYgMHbwgSyC7+fCn3uNqEc+jZ/8b6b/1cZ/wlMkkeuAd9zcYFRHWgUFB18A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649512; c=relaxed/simple;
	bh=1FXDGVh+MZUBTeeDpFUORg69fochE1UFSRbQc9FfxEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEensAI6NFxcNabsUvEqiv+vQ2uFh/pgufy0r5AR9Oy4+N3nZow6cKq1bfsQVTu1T5uTq7tsT5ulDg2yQd3gxMcuMSbZquWZ5xQ7TV1wtOVsYbbq0WZpiv6HQwTticcTmqQ56e9iwdeDjb86fiD+puUgTLZiiAuxFDL3axMgrhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4AGYERe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4AGYERe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BDA1F00A3A;
	Tue, 21 Jul 2026 15:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649511;
	bh=zVRrQAgi0SN9o2fyCkOqXqpyZSQBqmu6y2FFZTjkgB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x4AGYEReEsRJpIB9M57zz3ocNv+ZwRxjv/w1CNTRpTHRissBIj7rp9JLvgIOk8Hs6
	 fw8UQdcnStmqBm7Ofh2TDu9KmT+Njg+FIeJJSJ5nhIp1ltvOZuIoxSAeHNseP5XbD8
	 LObd7LHl1L0aSceN9VrHQpsbNAMbFgzUxfpEhjLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0607/2077] PM: QoS: Fix misc device registration unwind
Date: Tue, 21 Jul 2026 17:04:40 +0200
Message-ID: <20260721152607.126520237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 51a7c560cffdd3653ac2b930d01410569b23b23e ]

cpu_latency_qos_init() registers cpu_dma_latency first and, when
CONFIG_PM_QOS_CPU_SYSTEM_WAKEUP is enabled, registers cpu_wakeup_latency
afterwards. The second registration overwrites the first return value.

As a result, a failure to register cpu_dma_latency can be masked if the
second registration succeeds. Conversely, if cpu_dma_latency succeeds and
cpu_wakeup_latency fails, the function returns an error while leaving the
first misc device registered.

Return immediately on the first registration failure and deregister
cpu_dma_latency if the second registration fails.

Fixes: a4e6512a79d8 ("PM: QoS: Introduce a CPU system wakeup QoS limit")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260608170748.82273-1-dbgh9129@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/qos.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 398b994b73aabf..1944dbeb0d4c95 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -519,18 +519,23 @@ static int __init cpu_latency_qos_init(void)
 	int ret;
 
 	ret = misc_register(&cpu_latency_qos_miscdev);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_err("%s: %s setup failed\n", __func__,
 		       cpu_latency_qos_miscdev.name);
+		return ret;
+	}
 
 #ifdef CONFIG_PM_QOS_CPU_SYSTEM_WAKEUP
 	ret = misc_register(&cpu_wakeup_latency_qos_miscdev);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_err("%s: %s setup failed\n", __func__,
 		       cpu_wakeup_latency_qos_miscdev.name);
+		misc_deregister(&cpu_latency_qos_miscdev);
+		return ret;
+	}
 #endif
 
-	return ret;
+	return 0;
 }
 late_initcall(cpu_latency_qos_init);
 #endif /* CONFIG_CPU_IDLE */
-- 
2.53.0



