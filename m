Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA4E611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B71C433EF;
	Sun, 28 May 2023 19:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302640;
	bh=JZc95wvwJQZN4o0/e9AFt62sr0H7rDgK566d7dlf010=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCAdvt+hSQa/T1hfPK8OZH37k0WIV44TNpxZcrQakM6Ed8nolnITw94gb3T5ytL08
	 gfJmubt7cJG+9g7Spqjcubsjq/B+Dmq+hY4vgz0Lv0eflX5e3/mE+xn8c6v84zdXn4
	 TF7MQjuUy1y1333AgQadmAArin8PZOZuhvUAO8MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.1 086/119] firmware: arm_ffa: Check if ffa_driver remove is present before executing
Date: Sun, 28 May 2023 20:11:26 +0100
Message-Id: <20230528190838.402964807@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sudeep Holla <sudeep.holla@arm.com>

commit b71b55248a580e9c9befc4ae060539f1f8e477da upstream.

Currently ffa_drv->remove() is called unconditionally from
ffa_device_remove(). Since the driver registration doesn't check for it
and allows it to be registered without .remove callback, we need to check
for the presence of it before executing it from ffa_device_remove() to
above a NULL pointer dereference like the one below:

  | Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
  | Mem abort info:
  |   ESR = 0x0000000086000004
  |   EC = 0x21: IABT (current EL), IL = 32 bits
  |   SET = 0, FnV = 0
  |   EA = 0, S1PTW = 0
  |   FSC = 0x04: level 0 translation fault
  | user pgtable: 4k pages, 48-bit VAs, pgdp=0000000881cc8000
  | [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
  | Internal error: Oops: 0000000086000004 [#1] PREEMPT SMP
  | CPU: 3 PID: 130 Comm: rmmod Not tainted 6.3.0-rc7 #6
  | Hardware name: FVP Base RevC (DT)
  | pstate: 63402809 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=-c)
  | pc : 0x0
  | lr : ffa_device_remove+0x20/0x2c
  | Call trace:
  |  0x0
  |  device_release_driver_internal+0x16c/0x260
  |  driver_detach+0x90/0xd0
  |  bus_remove_driver+0xdc/0x11c
  |  driver_unregister+0x30/0x54
  |  ffa_driver_unregister+0x14/0x20
  |  cleanup_module+0x18/0xeec
  |  __arm64_sys_delete_module+0x234/0x378
  |  invoke_syscall+0x40/0x108
  |  el0_svc_common+0xb4/0xf0
  |  do_el0_svc+0x30/0xa4
  |  el0_svc+0x2c/0x7c
  |  el0t_64_sync_handler+0x84/0xf0
  |  el0t_64_sync+0x190/0x194

Fixes: 244f5d597e1e ("firmware: arm_ffa: Add missing remove callback to ffa_bus_type")
Link: https://lore.kernel.org/r/20230419-ffa_fixes_6-4-v2-1-d9108e43a176@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_ffa/bus.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/firmware/arm_ffa/bus.c
+++ b/drivers/firmware/arm_ffa/bus.c
@@ -53,7 +53,8 @@ static void ffa_device_remove(struct dev
 {
 	struct ffa_driver *ffa_drv = to_ffa_driver(dev->driver);
 
-	ffa_drv->remove(to_ffa_dev(dev));
+	if (ffa_drv->remove)
+		ffa_drv->remove(to_ffa_dev(dev));
 }
 
 static int ffa_device_uevent(struct device *dev, struct kobj_uevent_env *env)


