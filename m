Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BE4356A0D;
	Sat, 12 Sep 2026 11:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212386; cv=none; b=uSDUljDV+Cvwxa0mlWicwIBapDHxuFobnFuWUFL456N7OQtrO81sx9hjn+A75S29I7mQXKM3Ow43d/IVgsS4m4WiNJYbqMFjbdJkrevP4fDRL4mnc23Kw5ALR4SCkDPia4y4K3mKLVo8EyqrRRPjHePNpvxlYJOXGS9DTAKTDOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212386; c=relaxed/simple;
	bh=HrgF9YpUXQbLSYn+IHoN4VEXueXBiFJ8kHAxyfA3ukc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0b0iS+P6hcyezTHZhe4/AasfxAJN3tCubMnIxDFY821ppeJIDs28wj8Q0GT4fBV4cWfcd6pNalyVk66fFD9GwHWQZbQx7hr3irnWlRxYsGzogQv153SZGyH2sUKWmXBRXHRlWnva1+k5ZHTLbpGwe8OTh5uDUJKGpTWm8ObWek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sghg7yU9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sghg7yU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8AB1F000FF;
	Sat, 12 Sep 2026 11:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212382;
	bh=f1ZGC0OVHkka4S0E+kv7kbeQWiRMEgsKYglDWeXtmFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sghg7yU9tn4Fp3TeWS7a9iDF+iUrTKljsI70k+MG5BeZ5J0O9igEZS8TxnlZcME2j
	 6uCjep/ivXsSBlvDka4CKrci90QVxbLSQFQd28i5+3orbbFbUpssSeGiEQT8vgas9c
	 3tDdDhDY7r92P7ByfsiB7jgwoKRi9u4GMLuZElkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Easwar Hariharan <easwar.hariharan@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1382/1518] Drivers: hv: vmbus: Skip VMBus module cleanup for non-nested root partition
Date: Sat, 12 Sep 2026 08:59:11 +0200
Message-ID: <20260912065654.810812607@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhkelley58@gmail.com>

[ Upstream commit cee0d90bceae1dee3bcc70f8d6b2ceb5b87deb42 ]

The VMBus module initialization function, hv_acpi_init(), currently
does nothing when running in the root partition and root is not nested
in another VM. But the initialization function reports success, so the
VMBus module is indeed loaded. VMBus functionality is not actually
needed, but the VMBus module must be loaded so that hv_vmbus_exists()
can answer correctly. Furthermore, the mshv_root dependency on the
VMBus module is needed as described in the commit message for
840b740a35bf ("mshv: Add conditional VMBus dependency").

Loading the VMBus module without actually initializing it causes
failures if the module should later be unloaded. The module unload code
tries to clean up things that were never initialized, resulting in
memory faults and a panic.

Fix this by having VMBus module exit function perform the same
check for non-nested root partition, and do nothing in such a
case, just like hv_acpi_init().

In the long run, the code that manages the Hyper-V provided SynIC
should be refactored to better coordinate the requirements of
root partition scenarios and normal VM scenarios, and to hopefully
remove the hv_vmbus_exists() dependnecy between mshv_root and
VMBus modules. Preventing the current unload failure scenario is
an expediency until such a refactoring is done.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-hyperv/20260721154943.A09BD1F00A3D@smtp.kernel.org/
Fixes: 7e279d78664aa ("Drivers: hv: vmbus: skip VMBus initialization if Linux is root")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Easwar Hariharan <easwar.hariharan@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 2ac492955d035..b1552a26b8d3e 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2951,6 +2951,13 @@ static int __init hv_acpi_init(void)
 		return -ENODEV;
 
 	if (hv_root_partition() && !hv_nested)
+		/*
+		 * A non-nested root partition does not need VMBus client
+		 * functionality. However, the mshv_root module may have
+		 * a dependency on the VMBus module as described in
+		 * commit 840b740a35bf. Return success so the module
+		 * loads even though no VMBus initialization is done.
+		 */
 		return 0;
 
 	/*
@@ -2999,6 +3006,14 @@ static void __exit vmbus_exit(void)
 {
 	int cpu;
 
+	if (hv_root_partition() && !hv_nested)
+		/*
+		 * If a non-nested root partition loaded the VMBus module,
+		 * hv_acpi_init() did not do any VMBus initialization.
+		 * There's nothing to clean up, so just return.
+		 */
+		return;
+
 	unregister_syscore(&hv_synic_syscore);
 
 	hv_remove_kexec_handler();
-- 
2.53.0



