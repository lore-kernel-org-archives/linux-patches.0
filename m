Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC0C43CECB;
	Tue, 21 Jul 2026 21:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671116; cv=none; b=XUWmkW666IV1FBg1evF25xw4yb3+7hLhSBZKZyUCBHF6gQBmgg3S6gWCXOmgF9whvKNP6cmWrZmo0SRS40AdXf//FYn/UyOWsqiPK1XpzHraDaTvf3bV6I2mCFwCRauklOg6TSlWyDj0F5LyHELuC+76b7nYCYlY4Hy7rTi3Hrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671116; c=relaxed/simple;
	bh=m5TMG1vX10nbBiJJJbgVsrT6yycpd2XFi7bUdJkGefM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVygr95fqmeS2pdMWsrrIaQTsovdZOf/f2h4rx4nLEZ5WH1GJN7FHBfeYb4MII9eEZ5M3cTXztNWE6FtNH/2xSiO2VPcORQHULo/vqz06AD1Enc6jK8U9jsv/QeJoBBbSKLSuecpAjdVp/k2/yGaN9END4ygIb84CbfBNm7Rtxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGbpy1US; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGbpy1US"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120961F00A3D;
	Tue, 21 Jul 2026 21:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671103;
	bh=Ey7WzOQUwkEjvK2lypkspMR1XDEssI/+AEWXqTVzomY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGbpy1USthiS/oXGBvhSwc4i1qHIfvnMmJUcDaKN1D4U0WHVwt2ys5WupayYk/nFe
	 tLsq3dRJsGj/ROZmrRL6PhDY+arUT8wrR+61NAcN5ykyk7pwFGixQ+1nzwr5eJGRKU
	 gpklr/VHqh/j1Hj780prH6TXw5L+ZUjJeE/dUYoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianxiang Chen <nanmu@xiaomi.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 118/843] cpufreq: Fix hotplug-suspend race during reboot
Date: Tue, 21 Jul 2026 17:15:53 +0200
Message-ID: <20260721152408.659342794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1891,6 +1891,7 @@ void cpufreq_suspend(void)
 	if (!cpufreq_driver)
 		return;
 
+	cpus_read_lock();
 	if (!has_target() && !cpufreq_driver->suspend)
 		goto suspend;
 
@@ -1910,6 +1911,7 @@ void cpufreq_suspend(void)
 
 suspend:
 	cpufreq_suspended = true;
+	cpus_read_unlock();
 }
 
 /**


