Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEDD1DC198;
	Sat, 12 Sep 2026 08:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202144; cv=none; b=W8YNSYyMscd0cUtt9ONM4VNMDp2pOTr9LzhqiXyxoQqjIP1D27754JEPKiWl4Qoo9xtkumKWvDgGklBahGmi8CenLNbv9PGerDJSqX/vXopz7bx+CmKhe/AvSC3k+agB/07UgA2IoxS5tegvVHBYNI0kyVObYZ4Xm0zK2AYqK3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202144; c=relaxed/simple;
	bh=8gEtrBqS+oFCg0adBD9NXumtfDFhdqIK6hdBN+T0erQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBmlTwH3jCxNNsCDndM0D0Cn8UPevutxNgQV43wLxX6fsrkNSgzHa1Xtcfa4EcbfdMsL99MgHlWH/qx6aio84CqJ8s5LE6fHbhiIk4ffj3WBlyALWqZsKuI3QeiInJ2F9biGbxu+dUS6hNjVb3yVojGTv+9dZXyIqcA04GVbSVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyVZzfCO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyVZzfCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A840D1F000FF;
	Sat, 12 Sep 2026 08:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202142;
	bh=Y7K7WkfB+ujszT2PuGzhJ19jmLPfKJzlzrYqPH5ndic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyVZzfCOibSV4EK7pf+5jXZk4sCXFQw5tqlqOl/uS8iEIskcHE0Z2UcNZUkK3YzAW
	 +EbO288NHXjDgqmWk9anl8WvxKIuWaukWQPL99SczI5VY/af9A225/+pCwzuj9KNgm
	 zDOMGFMM6VH+IhNzXV7Cg22ocQwrwSE6285/X0aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Silver <mendaxca@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1099/1815] intel_idle: Avoid using deep idle states during initialization
Date: Sat, 12 Sep 2026 08:47:29 +0200
Message-ID: <20260912065714.818671308@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 9eadbed788df453289b5927327bd22edb542f472 ]

Commit c0f691388992 ("intel_idle: Use subsys_initcall_sync() for
initialization") effectively made intel_idle initialize earlier which
turns out to interfere with USB EHCI probing on some platforms [1].
Investigation led to the conclusion that this was related to allowing
package idle states to be used earlier than before.

Work around that issue by making intel_idle set a CPU latency QoS
request to prevent package idle states from being used on all platforms
supported by it for the duration of the device_initcall() initialization
phase.

Fixes: c0f691388992 ("intel_idle: Use subsys_initcall_sync() for initialization")
Reported-by: Julian Silver <mendaxca@gmail.com>
Tested-by: Julian Silver <mendaxca@gmail.com>
Closes: https://lore.kernel.org/linux-acpi/3353bdf3-4f33-44b1-809b-b0378bee5816@gmail.com/
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/5120454.31r3eYUQgx@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/idle/intel_idle.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index d74b478db2804..49c4ac9c7bb6e 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -53,6 +53,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/moduleparam.h>
+#include <linux/pm_qos.h>
 #include <linux/sysfs.h>
 #include <asm/cpuid/api.h>
 #include <asm/cpu_device_id.h>
@@ -2697,6 +2698,9 @@ static void __init cmdline_table_adjust(struct cpuidle_driver *drv)
 	pr_info("Failed to adjust C-states with data from 'intel_idle.table'\n");
 }
 
+#define INTEL_IDLE_INIT_QOS	20
+static struct pm_qos_request qos_req __initdata;
+
 static int __init intel_idle_init(void)
 {
 	const struct x86_cpu_id *id;
@@ -2766,6 +2770,13 @@ static int __init intel_idle_init(void)
 	if (retval)
 		pr_warn("failed to initialized sysfs");
 
+	/*
+	 * Some platforms, in particular the Intel S1200BTL motherboard, have a
+	 * problem with using package idle states too early, so prevent that
+	 * from taking place until the device_initcall() phase is over.
+	 */
+	cpu_latency_qos_add_request(&qos_req, INTEL_IDLE_INIT_QOS);
+
 	retval = cpuidle_register_driver(&intel_idle_driver);
 	if (retval) {
 		struct cpuidle_driver *drv = cpuidle_get_driver();
@@ -2790,6 +2801,9 @@ static int __init intel_idle_init(void)
 	intel_idle_cpuidle_devices_uninit();
 	cpuidle_unregister_driver(&intel_idle_driver);
 init_driver_fail:
+	if (cpu_latency_qos_request_active((&qos_req)))
+		cpu_latency_qos_remove_request(&qos_req);
+
 	intel_idle_sysfs_uninit();
 	free_percpu(intel_idle_cpuidle_devices);
 	return retval;
@@ -2797,6 +2811,15 @@ static int __init intel_idle_init(void)
 }
 subsys_initcall_sync(intel_idle_init);
 
+static int __init intel_idle_init_complete(void)
+{
+	if (cpu_latency_qos_request_active((&qos_req)))
+		cpu_latency_qos_remove_request(&qos_req);
+
+	return 0;
+}
+device_initcall_sync(intel_idle_init_complete);
+
 /*
  * We are not really modular, but we used to support that.  Meaning we also
  * support "intel_idle.max_cstate=..." at boot and also a read-only export of
-- 
2.53.0



