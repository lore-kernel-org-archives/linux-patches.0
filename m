Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2B33590D7;
	Wed,  3 Dec 2025 16:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778875; cv=none; b=j4PH2HEEEuSfB82RFmBQtxhtxtdXLfSfZ0cII3C08JSlpCFLaR67p0UrAefJvfQd0yAQ6TNKc+Jw7+92BqfZPC+gr1A3qAldsp4RGRXc673VY2UpHnPIsYZgcB0xNsv1RRPjPDQLeoEjJgY0AtcYtSDkw3mMGBCSIZvXLXudTKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778875; c=relaxed/simple;
	bh=0WbKk8Nj/qivQX+Xg2FlhMLAnj88fSt1u416b9fu1wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQo4r7C9evuvg0aHrSL5WzzuC7i7jfqxYU46Id259Du5ccSA/v9dnOzRWd8DO1Grs3hb7qo4t061vlXwT2pRRCUJNxcVZRJw0iQKd1rNMpNqhIcfz7iTk+F6otlYBxJFl0L0dWp6+T5ZkrRJ9pIuutjkh4q1NFqC82r2Hrkt1YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1QQE/JJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1QQE/JJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1070C4CEF5;
	Wed,  3 Dec 2025 16:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778875;
	bh=0WbKk8Nj/qivQX+Xg2FlhMLAnj88fSt1u416b9fu1wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1QQE/JJ4OQvN0pr9JdjSRrRGAhWs9YGtEcLBrvrdFgMgZoh1FPWM7WqUstZ52prn
	 jOH9FePT4EfKgYzASCTnf6CXNii3VQ+ngib9ZuVqqSv+wR6oyQUkYqvx19Wb6LlDT6
	 FDSEWSv7iAONowDKWdmN1XvS/I9H7vmq458Ny9iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/568] s390/pci: Avoid deadlock between PCI error recovery and mlx5 crdump
Date: Wed,  3 Dec 2025 16:21:28 +0100
Message-ID: <20251203152443.887294768@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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


