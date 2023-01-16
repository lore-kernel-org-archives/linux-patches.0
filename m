Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D226FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F94AC433EF;
	Mon, 16 Jan 2023 17:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888890;
	bh=TMSpC676pJqqGdXjBqcpao97F+p1PQzZfiLVaBlGaT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOE4flSCznFtSc36jdfb87kR5cr5+edmfoQ2nVaRtkhepqWWj49VB/K0KIt1t48y5
	 xMLou4c42aMzbVGCrPgZCJmjm5NhechzPkn+u0mqAT3fYaN4g1hY74p5QPwsDWbntR
	 qqzbBip+tX2dbRSl81Fhr2JwP1hpcRQfL5T1hlBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 148/338] scsi: ipr: Fix WARNING in ipr_init()
Date: Mon, 16 Jan 2023 16:50:21 +0100
Message-Id: <20230116154827.307309356@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit e6f108bffc3708ddcff72324f7d40dfcd0204894 ]

ipr_init() will not call unregister_reboot_notifier() when
pci_register_driver() fails, which causes a WARNING. Call
unregister_reboot_notifier() when pci_register_driver() fails.

notifier callback ipr_halt [ipr] already registered
WARNING: CPU: 3 PID: 299 at kernel/notifier.c:29
notifier_chain_register+0x16d/0x230
Modules linked in: ipr(+) xhci_pci_renesas xhci_hcd ehci_hcd usbcore
led_class gpu_sched drm_buddy video wmi drm_ttm_helper ttm
drm_display_helper drm_kms_helper drm drm_panel_orientation_quirks
agpgart cfbft
CPU: 3 PID: 299 Comm: modprobe Tainted: G        W
6.1.0-rc1-00190-g39508d23b672-dirty #332
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
RIP: 0010:notifier_chain_register+0x16d/0x230
Call Trace:
 <TASK>
 __blocking_notifier_chain_register+0x73/0xb0
 ipr_init+0x30/0x1000 [ipr]
 do_one_initcall+0xdb/0x480
 do_init_module+0x1cf/0x680
 load_module+0x6a50/0x70a0
 __do_sys_finit_module+0x12f/0x1c0
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: f72919ec2bbb ("[SCSI] ipr: implement shutdown changes and remove obsolete write cache parameter")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Link: https://lore.kernel.org/r/20221113064513.14028-1-shangxiaojing@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ipr.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 99b37e19feca..86e2d3033a2d 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -10858,11 +10858,19 @@ static struct notifier_block ipr_notifier = {
  **/
 static int __init ipr_init(void)
 {
+	int rc;
+
 	ipr_info("IBM Power RAID SCSI Device Driver version: %s %s\n",
 		 IPR_DRIVER_VERSION, IPR_DRIVER_DATE);
 
 	register_reboot_notifier(&ipr_notifier);
-	return pci_register_driver(&ipr_driver);
+	rc = pci_register_driver(&ipr_driver);
+	if (rc) {
+		unregister_reboot_notifier(&ipr_notifier);
+		return rc;
+	}
+
+	return 0;
 }
 
 /**
-- 
2.35.1



