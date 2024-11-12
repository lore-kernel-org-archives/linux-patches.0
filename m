Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A06E2123F3;
	Tue, 12 Nov 2024 10:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407986; cv=none; b=G+Od3UpZEsd27Rq0V0h6PF7jITzL+kJa0dZpDksXTjdwilMrqhOS8PiNKGnDFfJCDnNqjtL2arm0vRnWS/L+kWfh9HHnmTQLOVf1Qx4lUNgaj8WAx1V/VZvMdEcZMqHELATf1wn4/InVALqmRLfj6cOdgDmi2fZH04cMdQQ/ikM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407986; c=relaxed/simple;
	bh=5fcUZDxUUsOJAOxYwsveN7Y1n6wn1/i68YMi/HyZzeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtCZS8vId6ETEGoNaMztA8o56qqxFSXjr2uLidXnMsB2DF1EiC5a7oQDaL1Xq5F9UZL/Lha88jtKsSZiXmWnvp6sukW5np/nNNZ639D8e0Xy1+Mm6BVMVqN2diLz796hwyUr6Ue5aVBgYvCKvu+yBUvDQC/mC/FjvIqtuNIzMn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWt70MpJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWt70MpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE14C4CECD;
	Tue, 12 Nov 2024 10:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407986;
	bh=5fcUZDxUUsOJAOxYwsveN7Y1n6wn1/i68YMi/HyZzeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWt70MpJlYdokyjJdyRpTTu3CL4B0QYVmA3qM6KsioNMHdDSlsEBsIIfTopW7sFDG
	 nBnsdsdKcU6utQ9ZGeYto0mws3MtHTmFijYVZlS+4wqRA9v98BKBm6XRvKqI7kfoHa
	 XigaN7tA3iUKimHwGqhoKJs6e2MRJQf0bVTXn4EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinqi Zhang <quic_xinqzhan@quicinc.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 024/184] firmware: arm_scmi: Fix slab-use-after-free in scmi_bus_notifier()
Date: Tue, 12 Nov 2024 11:19:42 +0100
Message-ID: <20241112101901.794833502@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xinqi Zhang <quic_xinqzhan@quicinc.com>

[ Upstream commit 295416091e44806760ccf753aeafdafc0ae268f3 ]

The scmi_dev->name is released prematurely in __scmi_device_destroy(),
which causes slab-use-after-free when accessing scmi_dev->name in
scmi_bus_notifier(). So move the release of scmi_dev->name to
scmi_device_release() to avoid slab-use-after-free.

  |  BUG: KASAN: slab-use-after-free in strncmp+0xe4/0xec
  |  Read of size 1 at addr ffffff80a482bcc0 by task swapper/0/1
  |
  |  CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.6.38-debug #1
  |  Hardware name: Qualcomm Technologies, Inc. SA8775P Ride (DT)
  |  Call trace:
  |   dump_backtrace+0x94/0x114
  |   show_stack+0x18/0x24
  |   dump_stack_lvl+0x48/0x60
  |   print_report+0xf4/0x5b0
  |   kasan_report+0xa4/0xec
  |   __asan_report_load1_noabort+0x20/0x2c
  |   strncmp+0xe4/0xec
  |   scmi_bus_notifier+0x5c/0x54c
  |   notifier_call_chain+0xb4/0x31c
  |   blocking_notifier_call_chain+0x68/0x9c
  |   bus_notify+0x54/0x78
  |   device_del+0x1bc/0x840
  |   device_unregister+0x20/0xb4
  |   __scmi_device_destroy+0xac/0x280
  |   scmi_device_destroy+0x94/0xd0
  |   scmi_chan_setup+0x524/0x750
  |   scmi_probe+0x7fc/0x1508
  |   platform_probe+0xc4/0x19c
  |   really_probe+0x32c/0x99c
  |   __driver_probe_device+0x15c/0x3c4
  |   driver_probe_device+0x5c/0x170
  |   __driver_attach+0x1c8/0x440
  |   bus_for_each_dev+0xf4/0x178
  |   driver_attach+0x3c/0x58
  |   bus_add_driver+0x234/0x4d4
  |   driver_register+0xf4/0x3c0
  |   __platform_driver_register+0x60/0x88
  |   scmi_driver_init+0xb0/0x104
  |   do_one_initcall+0xb4/0x664
  |   kernel_init_freeable+0x3c8/0x894
  |   kernel_init+0x24/0x1e8
  |   ret_from_fork+0x10/0x20
  |
  |  Allocated by task 1:
  |   kasan_save_stack+0x2c/0x54
  |   kasan_set_track+0x2c/0x40
  |   kasan_save_alloc_info+0x24/0x34
  |   __kasan_kmalloc+0xa0/0xb8
  |   __kmalloc_node_track_caller+0x6c/0x104
  |   kstrdup+0x48/0x84
  |   kstrdup_const+0x34/0x40
  |   __scmi_device_create.part.0+0x8c/0x408
  |   scmi_device_create+0x104/0x370
  |   scmi_chan_setup+0x2a0/0x750
  |   scmi_probe+0x7fc/0x1508
  |   platform_probe+0xc4/0x19c
  |   really_probe+0x32c/0x99c
  |   __driver_probe_device+0x15c/0x3c4
  |   driver_probe_device+0x5c/0x170
  |   __driver_attach+0x1c8/0x440
  |   bus_for_each_dev+0xf4/0x178
  |   driver_attach+0x3c/0x58
  |   bus_add_driver+0x234/0x4d4
  |   driver_register+0xf4/0x3c0
  |   __platform_driver_register+0x60/0x88
  |   scmi_driver_init+0xb0/0x104
  |   do_one_initcall+0xb4/0x664
  |   kernel_init_freeable+0x3c8/0x894
  |   kernel_init+0x24/0x1e8
  |   ret_from_fork+0x10/0x20
  |
  |  Freed by task 1:
  |   kasan_save_stack+0x2c/0x54
  |   kasan_set_track+0x2c/0x40
  |   kasan_save_free_info+0x38/0x5c
  |   __kasan_slab_free+0xe8/0x164
  |   __kmem_cache_free+0x11c/0x230
  |   kfree+0x70/0x130
  |   kfree_const+0x20/0x40
  |   __scmi_device_destroy+0x70/0x280
  |   scmi_device_destroy+0x94/0xd0
  |   scmi_chan_setup+0x524/0x750
  |   scmi_probe+0x7fc/0x1508
  |   platform_probe+0xc4/0x19c
  |   really_probe+0x32c/0x99c
  |   __driver_probe_device+0x15c/0x3c4
  |   driver_probe_device+0x5c/0x170
  |   __driver_attach+0x1c8/0x440
  |   bus_for_each_dev+0xf4/0x178
  |   driver_attach+0x3c/0x58
  |   bus_add_driver+0x234/0x4d4
  |   driver_register+0xf4/0x3c0
  |   __platform_driver_register+0x60/0x88
  |   scmi_driver_init+0xb0/0x104
  |   do_one_initcall+0xb4/0x664
  |   kernel_init_freeable+0x3c8/0x894
  |   kernel_init+0x24/0x1e8
  |   ret_from_fork+0x10/0x20

Fixes: ee7a9c9f67c5 ("firmware: arm_scmi: Add support for multiple device per protocol")
Signed-off-by: Xinqi Zhang <quic_xinqzhan@quicinc.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Message-Id: <20241016-fix-arm-scmi-slab-use-after-free-v2-1-1783685ef90d@quicinc.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 96b2e5f9a8ef0..157172a5f2b57 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -325,7 +325,10 @@ EXPORT_SYMBOL_GPL(scmi_driver_unregister);
 
 static void scmi_device_release(struct device *dev)
 {
-	kfree(to_scmi_dev(dev));
+	struct scmi_device *scmi_dev = to_scmi_dev(dev);
+
+	kfree_const(scmi_dev->name);
+	kfree(scmi_dev);
 }
 
 static void __scmi_device_destroy(struct scmi_device *scmi_dev)
@@ -338,7 +341,6 @@ static void __scmi_device_destroy(struct scmi_device *scmi_dev)
 	if (scmi_dev->protocol_id == SCMI_PROTOCOL_SYSTEM)
 		atomic_set(&scmi_syspower_registered, 0);
 
-	kfree_const(scmi_dev->name);
 	ida_free(&scmi_bus_id, scmi_dev->id);
 	device_unregister(&scmi_dev->dev);
 }
@@ -410,7 +412,6 @@ __scmi_device_create(struct device_node *np, struct device *parent,
 
 	return scmi_dev;
 put_dev:
-	kfree_const(scmi_dev->name);
 	put_device(&scmi_dev->dev);
 	ida_free(&scmi_bus_id, id);
 	return NULL;
-- 
2.43.0



