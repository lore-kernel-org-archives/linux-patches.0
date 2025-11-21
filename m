Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250CB349B0F;
	Fri, 21 Nov 2025 13:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732256; cv=none; b=El+y3uahCJ38iSzqQcf9szSK9QpRIRIzFGmDOC7Qknxwy8AZSEXSmhS5wAoNbPBFizFqgCpDz8Vd5+LjPdH8vAQ3CGb/OUokVu//CK7ZVqrZ4JaS/OgdIRFf1LwSt0OaWLZgY9cdzm1JDmOxS352K5Sv+F3reUstKHL3ZoqDZHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732256; c=relaxed/simple;
	bh=ip/bCX+fu3qaETWA2FIEVO6cKw0GgpDBUA/CZ89HZXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESRB6jnkGciU1G4fuNMQ0Nd8SBzWR0VgQdBaGsix9c/ricl32kL0jKjVrVG9ceNWQq3efbN9v6D274drRz8gvUMu878j5qXepGYYsXlMY/woPZgnWtzpNcOE9a/vNE+Zmc1vP2pF2prElhHb/dGv2t5MgLdfPS1qrpZJ0Xxe4ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcEOnyQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcEOnyQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E14C4CEF1;
	Fri, 21 Nov 2025 13:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732255;
	bh=ip/bCX+fu3qaETWA2FIEVO6cKw0GgpDBUA/CZ89HZXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcEOnyQ/JA7ID3tyWCDEqRPMLvULGhTAZKdawYrQhXNHazXnPmwcEfSkwpVcOLDd/
	 1FGOKcY4zsG46rbjqatIfvW1jaHRMfKSI8P2XzLV9ZRxIFWpXnRGDjLzx5OCMd2AC0
	 8+wmkn/8xyYbAUz8kBGHR0DR+APqXZK9FOK6XINk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/529] s390/pci: Avoid deadlock between PCI error recovery and mlx5 crdump
Date: Fri, 21 Nov 2025 14:05:55 +0100
Message-ID: <20251121130233.010954458@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerd Bayer <gbayer@linux.ibm.com>

[ Upstream commit 0fd20f65df6aa430454a0deed8f43efa91c54835 ]

Do not block PCI config accesses through pci_cfg_access_lock() when
executing the s390 variant of PCI error recovery: Acquire just
device_lock() instead of pci_dev_lock() as powerpc's EEH and
generig PCI AER processing do.

During error recovery testing a pair of tasks was reported to be hung:

mlx5_core 0000:00:00.1: mlx5_health_try_recover:338:(pid 5553): health recovery flow aborted, PCI reads still not working
INFO: task kmcheck:72 blocked for more than 122 seconds.
      Not tainted 5.14.0-570.12.1.bringup7.el9.s390x #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kmcheck         state:D stack:0     pid:72    tgid:72    ppid:2      flags:0x00000000
Call Trace:
 [<000000065256f030>] __schedule+0x2a0/0x590
 [<000000065256f356>] schedule+0x36/0xe0
 [<000000065256f572>] schedule_preempt_disabled+0x22/0x30
 [<0000000652570a94>] __mutex_lock.constprop.0+0x484/0x8a8
 [<000003ff800673a4>] mlx5_unload_one+0x34/0x58 [mlx5_core]
 [<000003ff8006745c>] mlx5_pci_err_detected+0x94/0x140 [mlx5_core]
 [<0000000652556c5a>] zpci_event_attempt_error_recovery+0xf2/0x398
 [<0000000651b9184a>] __zpci_event_error+0x23a/0x2c0
INFO: task kworker/u1664:6:1514 blocked for more than 122 seconds.
      Not tainted 5.14.0-570.12.1.bringup7.el9.s390x #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u1664:6 state:D stack:0     pid:1514  tgid:1514  ppid:2      flags:0x00000000
Workqueue: mlx5_health0000:00:00.0 mlx5_fw_fatal_reporter_err_work [mlx5_core]
Call Trace:
 [<000000065256f030>] __schedule+0x2a0/0x590
 [<000000065256f356>] schedule+0x36/0xe0
 [<0000000652172e28>] pci_wait_cfg+0x80/0xe8
 [<0000000652172f94>] pci_cfg_access_lock+0x74/0x88
 [<000003ff800916b6>] mlx5_vsc_gw_lock+0x36/0x178 [mlx5_core]
 [<000003ff80098824>] mlx5_crdump_collect+0x34/0x1c8 [mlx5_core]
 [<000003ff80074b62>] mlx5_fw_fatal_reporter_dump+0x6a/0xe8 [mlx5_core]
 [<0000000652512242>] devlink_health_do_dump.part.0+0x82/0x168
 [<0000000652513212>] devlink_health_report+0x19a/0x230
 [<000003ff80075a12>] mlx5_fw_fatal_reporter_err_work+0xba/0x1b0 [mlx5_core]

No kernel log of the exact same error with an upstream kernel is
available - but the very same deadlock situation can be constructed there,
too:

- task: kmcheck
  mlx5_unload_one() tries to acquire devlink lock while the PCI error
  recovery code has set pdev->block_cfg_access by way of
  pci_cfg_access_lock()
- task: kworker
  mlx5_crdump_collect() tries to set block_cfg_access through
  pci_cfg_access_lock() while devlink_health_report() had acquired
  the devlink lock.

A similar deadlock situation can be reproduced by requesting a
crdump with
  > devlink health dump show pci/<BDF> reporter fw_fatal

while PCI error recovery is executed on the same <BDF> physical function
by mlx5_core's pci_error_handlers. On s390 this can be injected with
  > zpcictl --reset-fw <BDF>

Tests with this patch failed to reproduce that second deadlock situation,
the devlink command is rejected with "kernel answers: Permission denied" -
and we get a kernel log message of:

mlx5_core 1ed0:00:00.1: mlx5_crdump_collect:50:(pid 254382): crdump: failed to lock vsc gw err -5

because the config read of VSC_SEMAPHORE is rejected by the underlying
hardware.

Two prior attempts to address this issue have been discussed and
ultimately rejected [see link], with the primary argument that s390's
implementation of PCI error recovery is imposing restrictions that
neither powerpc's EEH nor PCI AER handling need. Tests show that PCI
error recovery on s390 is running to completion even without blocking
access to PCI config space.

Link: https://lore.kernel.org/all/20251007144826.2825134-1-gbayer@linux.ibm.com/
Cc: stable@vger.kernel.org
Fixes: 4cdf2f4e24ff ("s390/pci: implement minimal PCI error recovery")
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_event.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -173,7 +173,7 @@ static pci_ers_result_t zpci_event_attem
 	 * is unbound or probed and that userspace can't access its
 	 * configuration space while we perform recovery.
 	 */
-	pci_dev_lock(pdev);
+	device_lock(&pdev->dev);
 	if (pdev->error_state == pci_channel_io_perm_failure) {
 		ers_res = PCI_ERS_RESULT_DISCONNECT;
 		goto out_unlock;
@@ -221,7 +221,7 @@ static pci_ers_result_t zpci_event_attem
 	if (driver->err_handler->resume)
 		driver->err_handler->resume(pdev);
 out_unlock:
-	pci_dev_unlock(pdev);
+	device_unlock(&pdev->dev);
 
 	return ers_res;
 }


