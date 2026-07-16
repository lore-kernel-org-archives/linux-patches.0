Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A54A426D0B;
	Thu, 16 Jul 2026 13:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209625; cv=none; b=rxLPRVfoPupww4GJooav7YWdWBX5BHO7SaGl+qiRwum/dRT6THSueFqqSwiW819urjcuhQIbUGXkrACFeUJ3buwhh+NoFAtRK/e7P16HvEQDwfeydf02UBtbthNe5v35dlKAvH6VTrgwhkO2RuMthHvt34Rvada0nynHU1fuEsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209625; c=relaxed/simple;
	bh=Q301GwRPQ8ithOKPd+2eHZeWuOb9RaoaM2WS/se5bBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dt7MtWA7ASHn85+s0x1D79k43S4nLSW9pRwNPsTMOOw6E4s1Whnpn3gwGlPFQsLw1HHIHsn9mCNQAd3WZE1m+GoktpE1h62mESOFhhrxBVWTFomIT4gKCWV30vwvV+Olrkf12KHAhzTuhl+KW0hTFy9hlXo6hDuyyOjeHHeYg80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzBeGu8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzBeGu8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E49D1F000E9;
	Thu, 16 Jul 2026 13:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209620;
	bh=BzeGJcRlWqmVIB2eEQlOVyhEspRRe+k62fuX/LY5IdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzBeGu8/T2X6u+QyE8heE3Vqm/TKPpnFYVkiO1PtK4nnyXz2JfNfCOh0mP+x7qzWW
	 rgtjVFiZHXeDqN/stIycpiDdRb0o4bZzhM76jst6zfhIh1QY1cilSBl+wFQABQrzxq
	 VHLO06PcasovPwXIlC/8wiky5616FwH/oDHHdrSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianxiang Chen <nanmu@xiaomi.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.1 253/518] cpufreq: Fix hotplug-suspend race during reboot
Date: Thu, 16 Jul 2026 15:28:41 +0200
Message-ID: <20260716133053.352692954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -1972,6 +1972,7 @@ void cpufreq_suspend(void)
 	if (!cpufreq_driver)
 		return;
 
+	cpus_read_lock();
 	if (!has_target() && !cpufreq_driver->suspend)
 		goto suspend;
 
@@ -1991,6 +1992,7 @@ void cpufreq_suspend(void)
 
 suspend:
 	cpufreq_suspended = true;
+	cpus_read_unlock();
 }
 
 /**


