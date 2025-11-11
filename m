Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C86133B955;
	Tue, 11 Nov 2025 01:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825322; cv=none; b=RTo1qq9lXIng2JBXtn/z/WPBLXcK+iWdL9QlHxQzayay6i4QPfJu1hofViAQc0vKrFFr39mO8KRCpgjQKnSv4r7AAz2ssyVqA2bIR20R4okILPLekIKaV8UiUaU32fiFXDJ/nl8ny2e1ZNhSI1hIAzhQE3hDzPMuTNkTxl9+1WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825322; c=relaxed/simple;
	bh=Ho2qf58uEKgX4udxdzx6MQw1Rf7e8SZfWYoCzxyZlzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApZK4SKVdNvEvHTmAF/0rwRfpFCnmeZjR33XizOkdjtkWsxCBmpk5tO2MaC/COdIVlA1h02AhO7d3tAP4YSMT4PoAMxy0zssjMPwsMeoUVy4N9igLBhfGFBJFx4J7vaWf/jezSF5OhlzG4k+JVEIIyyEMlRj9ddZuIQZYDjHM00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMIuVoqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMIuVoqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81ABBC19425;
	Tue, 11 Nov 2025 01:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825321;
	bh=Ho2qf58uEKgX4udxdzx6MQw1Rf7e8SZfWYoCzxyZlzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMIuVoqFmBsPyMiCm16ru+9ylKLkq2DylyL0n9lBDBnnUUFYVbz+mIk7k24mht5Hi
	 5CxKASZ7VrLHngSr7qy0MeHbudqt4nLJkwpidGUrfEEkhvodp3anJvV5ZZBqzH8qYE
	 8v933Uyi+38kHYjBRNf5T5DAZHjXIO+XJgVA20cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lee <chullee@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 751/849] scsi: ufs: core: Fix a race condition related to the "hid" attribute group
Date: Tue, 11 Nov 2025 09:45:21 +0900
Message-ID: <20251111004554.590969951@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c74dc8ab47c1ec3927f63ca83b542c363249b3d8 ]

ufs_sysfs_add_nodes() is called concurrently with ufs_get_device_desc().
This may cause the following code to be called before
ufs_sysfs_add_nodes():

	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);

If this happens, ufs_sysfs_add_nodes() triggers a kernel warning and
fails. Fix this by calling ufs_sysfs_add_nodes() before SCSI LUNs are
scanned since the sysfs_update_group() call happens from the context of
thread that executes ufshcd_async_scan(). This patch fixes the following
kernel warning:

sysfs: cannot create duplicate filename '/devices/platform/3c2d0000.ufs/hid'
Workqueue: async async_run_entry_fn
Call trace:
 dump_backtrace+0xfc/0x17c
 show_stack+0x18/0x28
 dump_stack_lvl+0x40/0x104
 dump_stack+0x18/0x3c
 sysfs_warn_dup+0x6c/0xc8
 internal_create_group+0x1c8/0x504
 sysfs_create_groups+0x38/0x9c
 ufs_sysfs_add_nodes+0x20/0x58
 ufshcd_init+0x1114/0x134c
 ufshcd_pltfrm_init+0x728/0x7d8
 ufs_google_probe+0x30/0x84
 platform_probe+0xa0/0xe0
 really_probe+0x114/0x454
 __driver_probe_device+0xa4/0x160
 driver_probe_device+0x44/0x23c
 __device_attach_driver+0x15c/0x1f4
 bus_for_each_drv+0x10c/0x168
 __device_attach_async_helper+0x80/0xf8
 async_run_entry_fn+0x4c/0x17c
 process_one_work+0x26c/0x65c
 worker_thread+0x33c/0x498
 kthread+0x110/0x134
 ret_from_fork+0x10/0x20
ufshcd 3c2d0000.ufs: ufs_sysfs_add_nodes: sysfs groups creation failed (err = -17)

Cc: Daniel Lee <chullee@google.com>
Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251014200118.3390839-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b6d5d135527c0..8208a26c3ed63 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10869,8 +10869,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	if (err)
 		goto out_disable;
 
-	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
+	async_schedule(ufshcd_async_scan, hba);
 
 	device_enable_async_suspend(dev);
 	ufshcd_pm_qos_init(hba);
-- 
2.51.0



