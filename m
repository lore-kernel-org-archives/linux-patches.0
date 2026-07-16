Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD8A42DFF4;
	Thu, 16 Jul 2026 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212179; cv=none; b=Ec0fa1g/DaxUBYlrBQ9Wqf4YXy7PbcXMFQQMhQFDi5vQCeQBKuIXzBfBIkXgEUPDk0BoMSuVU6T45aTQjrrQPuELPpZahPHMIIQillVWnjHtpAICEQU6GCq2Qeg74Ty9ObD8ZPJRFdFz1Dp+R2V47JAyqwI/tptdtmUc+GPjkiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212179; c=relaxed/simple;
	bh=Mus+BXaLMvjqt6pNms7Qrm+T15m7qHSQ3Taa985lm80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDIrBIJEvgff0TJ0hlRXzPUGXcLOi3Bpnu5F9fFx+qt+FHmNkAKMUWJwGYSYOetspMfJje4fyvaTI57tve5dob3j9tmayMAwCwu/TqV4o7dviGPqStB86rqo/gd13E90jOxhNqViAWRi+iWZyHtnjeSh0Oe8Zv7v1MsVpbdvvvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNZikYbh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNZikYbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0705E1F000E9;
	Thu, 16 Jul 2026 14:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212178;
	bh=lXcB60hz5NeNe50yKrCgRV1A5B2XNm8RHbXjBao3Fj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNZikYbhR5XEnSNJJPuyQMxLV5hw/3wF5cbkyPv5WQHskuYgaj/HJe6PQ10Bbjk+3
	 3y+wc1Cac2TQGAkavmhAgGar4gkVC4XaEtAjz+Zssg6aj9zWxt2rhZ2ix1EHIGu8xc
	 F7dEsGFkIRGOS9oiIbl9P1IAqNTSQa6nRuOlDxo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianxiang Chen <nanmu@xiaomi.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 192/349] cpufreq: Fix hotplug-suspend race during reboot
Date: Thu, 16 Jul 2026 15:32:06 +0200
Message-ID: <20260716133037.672947086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1958,6 +1958,7 @@ void cpufreq_suspend(void)
 	if (!cpufreq_driver)
 		return;
 
+	cpus_read_lock();
 	if (!has_target() && !cpufreq_driver->suspend)
 		goto suspend;
 
@@ -1977,6 +1978,7 @@ void cpufreq_suspend(void)
 
 suspend:
 	cpufreq_suspended = true;
+	cpus_read_unlock();
 }
 
 /**


