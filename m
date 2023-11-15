Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5E128383
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqeyo/RJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514B5C433C7;
	Wed, 15 Nov 2023 19:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077450;
	bh=azu6Twf0n/JG5jLJWNjAVUtRTVskZF2WRCaxbsKzKZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqeyo/RJsNqyvATcw6jR5vQ0d9bv/hjq5xUOzwhGMPhm7jeUXnGm3hrLThGN9qI1Z
	 dgeskH96b1RwA86vpnmbFzon8BTfdZ2vbkZMTSlGV0168XNEwxTo9pG/KvyuQbYshY
	 e5jmOsk4cjL0cPDxhltc9WpQthvXYlzi1055iVzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 310/603] firmware: arm_ffa: Assign the missing IDR allocation ID to the FFA device
Date: Wed, 15 Nov 2023 14:14:15 -0500
Message-ID: <20231115191634.882141523@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 7d0bc6360f17ea323ab25939a34857123d7d87e5 ]

Commit 19b8766459c4 ("firmware: arm_ffa: Fix FFA device names for logical
partitions") added an ID to the FFA device using ida_alloc() and append
the same to "arm-ffa" to make up a unique device name. However it missed
to stash the id value in ffa_dev to help freeing the ID later when the
device is destroyed.

Due to the missing/unassigned ID in FFA device, we get the following
warning when the FF-A device is unregistered.

  |   ida_free called for id=0 which is not allocated.
  |   WARNING: CPU: 7 PID: 1 at lib/idr.c:525 ida_free+0x114/0x164
  |   CPU: 7 PID: 1 Comm: swapper/0 Not tainted 6.6.0-rc4 #209
  |   pstate: 61400009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
  |   pc : ida_free+0x114/0x164
  |   lr : ida_free+0x114/0x164
  |   Call trace:
  |    ida_free+0x114/0x164
  |    ffa_release_device+0x24/0x3c
  |    device_release+0x34/0x8c
  |    kobject_put+0x94/0xf8
  |    put_device+0x18/0x24
  |    klist_devices_put+0x14/0x20
  |    klist_next+0xc8/0x114
  |    bus_for_each_dev+0xd8/0x144
  |    arm_ffa_bus_exit+0x30/0x54
  |    ffa_init+0x68/0x330
  |    do_one_initcall+0xdc/0x250
  |    do_initcall_level+0x8c/0xac
  |    do_initcalls+0x54/0x94
  |    do_basic_setup+0x1c/0x28
  |    kernel_init_freeable+0x104/0x170
  |    kernel_init+0x20/0x1a0
  |    ret_from_fork+0x10/0x20

Fix the same by actually assigning the ID in the FFA device this time
for real.

Fixes: 19b8766459c4 ("firmware: arm_ffa: Fix FFA device names for logical partitions")
Link: https://lore.kernel.org/r/20231003085932.3553985-1-sudeep.holla@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_ffa/bus.c b/drivers/firmware/arm_ffa/bus.c
index 2b8bfcd010f5f..7865438b36960 100644
--- a/drivers/firmware/arm_ffa/bus.c
+++ b/drivers/firmware/arm_ffa/bus.c
@@ -193,6 +193,7 @@ struct ffa_device *ffa_device_register(const uuid_t *uuid, int vm_id,
 	dev->release = ffa_release_device;
 	dev_set_name(&ffa_dev->dev, "arm-ffa-%d", id);
 
+	ffa_dev->id = id;
 	ffa_dev->vm_id = vm_id;
 	ffa_dev->ops = ops;
 	uuid_copy(&ffa_dev->uuid, uuid);
-- 
2.42.0



