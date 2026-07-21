Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E23D44AB91;
	Tue, 21 Jul 2026 22:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673356; cv=none; b=lV0Q9npq6feIqHzUGgfpv7eUdTavVXNPXltAPUUpRtoAdNsqNIv2GECEz/9cOUo+4+UsmmpCUlg/P8zanOWPF8hOD57qbIBsetpjqRq9tvGrJMLels6ZGkCC6sKUey/CmMlkKTBXX/UyKjSDJ0ZBx8ogBdxukZ9BMLXFyIFoacc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673356; c=relaxed/simple;
	bh=4qLZB/6z+kZ92OIKEqAShQMtUj6Krel83PORYKbk5UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6TycwGFRPbZivNzn5dotsR0KQatraw0B9GfXXzgPcZC/I7BgS0xrY5wx0XslKY8LUhqywFmDjyyqjCV9xJ4tKpDvq1AbmTXrtjSbQTpCDTch0SoxGmOTupr3hP3B93Mf3zgdsm5U1yW+aVoDzbsyS+hiGrHwEOugbFSRoe0dNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgyeuM05; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgyeuM05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083B31F000E9;
	Tue, 21 Jul 2026 22:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673354;
	bh=/o/87AK/JVN29BJRxB8pZsxLoig8wwB8a58eHbpyt4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OgyeuM05vnpeOpXOn6nUmoLOQ2TqqIL58ocHNpE2Vk+eSsjVLNi3Uf1/z+rk+aFMz
	 zuu40eqCHRq/SD3TAD2S+sZeAkxgKQiRTTImZLXlzuhoiKXPWHfdaknV+KHVMP9a/4
	 iliSxMCis96dEJPR+67E1p1qbJbH1YEIMAf0Y16I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianxiang Chen <nanmu@xiaomi.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 088/699] cpufreq: Fix hotplug-suspend race during reboot
Date: Tue, 21 Jul 2026 17:17:27 +0200
Message-ID: <20260721152357.688314411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1872,6 +1872,7 @@ void cpufreq_suspend(void)
 	if (!cpufreq_driver)
 		return;
 
+	cpus_read_lock();
 	if (!has_target() && !cpufreq_driver->suspend)
 		goto suspend;
 
@@ -1891,6 +1892,7 @@ void cpufreq_suspend(void)
 
 suspend:
 	cpufreq_suspended = true;
+	cpus_read_unlock();
 }
 
 /**


