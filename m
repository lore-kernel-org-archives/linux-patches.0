Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB9C3BED63;
	Tue, 21 Jul 2026 21:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668484; cv=none; b=iBEqd6loMTCXMDwvQCd89SrCs3aRRXz7wNLh7sfL2QW0aEDFVo+hzjdqC2/fZsge7/7yDYsDw7ZnCSFLb2ZwcC2VkqdnBoR/Q/R1LvT7MRpt8h3kkh3lqaaGcbNmqTzx3mSJ35M7F6FiwrlS2HflMjwQva6fH92kPWIsf/hHP4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668484; c=relaxed/simple;
	bh=MqtX/2po5LfJOp04Bfmq7sw9oTHLbBf4f89qrzqrLYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BURjCWnW+a5eqp4E63zE76vKz7sjeumAcs2TdMUxjkgp0vU+We/qDcWzOzZQ1LlzYaYHfmRAiiZEznfuI6QbrsLuW5WRNnH+CjTrpNAEbiYHb6PLZgQx8UfNFWqnjL8HaVgv+8W7LUcFgOJop82Gj/UTvv1YrjSquM3MMq1Sli4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AecdUf0X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AecdUf0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323AD1F000E9;
	Tue, 21 Jul 2026 21:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668483;
	bh=K8kH+Y22ew4nePLtqYys9m7nlU1f68GNCudf4AQwX8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AecdUf0XDUNRssP53HKIYl/uiFehj1+91Fc3uSNepNtTC1zym5AhDC7wMhmAZxMJz
	 D2yfa51jCxcvihyfOF4ieoh8xV5i3o0EgnejMiQPtaFYIONTH5E7F7y9dpAlfhdgDo
	 Olh3YSYnHu38g3SmPyruLe/MQptBOgIDtoEC6DjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianxiang Chen <nanmu@xiaomi.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 0150/1067] cpufreq: Fix hotplug-suspend race during reboot
Date: Tue, 21 Jul 2026 17:12:31 +0200
Message-ID: <20260721152427.950468400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianxiang Chen <nanmu@xiaomi.com>

commit a9029dd55696c651ee46912afa2a166fa456bb3e upstream.

During system reboot, cpufreq_suspend() is called via the
kernel_restart() -> device_shutdown() path. Unlike the normal system
suspend path, the reboot path does not call freeze_processes(), so
userspace processes and kernel threads remain active.

This allows CPU hotplug operations to run concurrently with
cpufreq_suspend(). The original code has no synchronization with CPU
hotplug, leading to a race condition where governor_data can be freed
by the hotplug path while cpufreq_suspend() is still accessing it,
resulting in a null pointer dereference:

  Unable to handle kernel NULL pointer dereference
  Call Trace:
   do_kernel_fault+0x28/0x3c
   cpufreq_suspend+0xdc/0x160
   device_shutdown+0x18/0x200
   kernel_restart+0x40/0x80
   arm64_sys_reboot+0x1b0/0x200

Fix this by adding cpus_read_lock()/cpus_read_unlock() to
cpufreq_suspend() to block CPU hotplug operations while suspend is in
progress.

Fixes: 65650b35133f ("cpufreq: Avoid cpufreq_suspend() deadlock on system shutdown")
Signed-off-by: Tianxiang Chen <nanmu@xiaomi.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Cc: All applicable <stable@vger.kernel.org>
[ rjw: Changelog edits ]
Link: https://patch.msgid.link/20260408141914.35281-1-nanmu@xiaomi.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1918,6 +1918,7 @@ void cpufreq_suspend(void)
 	if (!cpufreq_driver)
 		return;
 
+	cpus_read_lock();
 	if (!has_target() && !cpufreq_driver->suspend)
 		goto suspend;
 
@@ -1937,6 +1938,7 @@ void cpufreq_suspend(void)
 
 suspend:
 	cpufreq_suspended = true;
+	cpus_read_unlock();
 }
 
 /**


