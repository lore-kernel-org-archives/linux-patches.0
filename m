Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F8835946;
	Wed,  5 Feb 2025 15:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768202; cv=none; b=kA4C+/vkaiQm4y3GTHlTKdBq4nTQTahbyXOAGsBV+a1Gdw0O9q3CtQaW+lFx2EMk1aIT0Al6GRVKJ24VCvor06WKC9qWUhCCss5E0sMf46ckdHptbK3R5vtqS8zLQvwxmuVVxynqoKM3CdR+oT/u3v+U4Te9JXz/DnCzz+Wjpt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768202; c=relaxed/simple;
	bh=EHiDViOAvp4vHd9hZeKgvFCmFzexJjx21U8nrTKLIKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnFH7j3kFx+I1ZvdJzAMI3TEc863hX9K06sEXwwyHoqrmzdXpUY/mdquohiURQA5Y21rqzUdNyirR3kSGnHVGlRwZKGzTNZCoSk88mXC4FXA7JaAIqXpPKnS36PTl8JxvwcDTdcsFX8R+OYMAFNlpv4ZyrT6QooH7plEKzyCyfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkozs4W9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkozs4W9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6880C4CED1;
	Wed,  5 Feb 2025 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768202;
	bh=EHiDViOAvp4vHd9hZeKgvFCmFzexJjx21U8nrTKLIKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkozs4W9lNSFMpVzd5sL0kgmV4+3m1KuVm0grrwwzOwQE9WBxFB/XAh2V3BJPxdmx
	 x+ZfR7uTWSZbVePZFjholB5xwGT1XGKekx/H7dkFRp+WYRmABH6JDaMmmdxg99kN/P
	 m4gA6yOv4qPI5BCXhr8vEUdZDBgTlVPlJvrib08A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.12 567/590] remoteproc: core: Fix ida_free call while not allocated
Date: Wed,  5 Feb 2025 14:45:22 +0100
Message-ID: <20250205134516.959659773@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>

commit 7378aeb664e5ebc396950b36a1f2dedf5aabec20 upstream.

In the rproc_alloc() function, on error, put_device(&rproc->dev) is
called, leading to the call of the rproc_type_release() function.
An error can occurs before ida_alloc is called.

In such case in rproc_type_release(), the condition (rproc->index >= 0) is
true as rproc->index has been  initialized to 0.
ida_free() is called reporting a warning:
[    4.181906] WARNING: CPU: 1 PID: 24 at lib/idr.c:525 ida_free+0x100/0x164
[    4.186378] stm32-display-dsi 5a000000.dsi: Fixed dependency cycle(s) with /soc/dsi@5a000000/panel@0
[    4.188854] ida_free called for id=0 which is not allocated.
[    4.198256] mipi-dsi 5a000000.dsi.0: Fixed dependency cycle(s) with /soc/dsi@5a000000
[    4.203556] Modules linked in: panel_orisetech_otm8009a dw_mipi_dsi_stm(+) gpu_sched dw_mipi_dsi stm32_rproc stm32_crc32 stm32_ipcc(+) optee(+)
[    4.224307] CPU: 1 UID: 0 PID: 24 Comm: kworker/u10:0 Not tainted 6.12.0 #442
[    4.231481] Hardware name: STM32 (Device Tree Support)
[    4.236627] Workqueue: events_unbound deferred_probe_work_func
[    4.242504] Call trace:
[    4.242522]  unwind_backtrace from show_stack+0x10/0x14
[    4.250218]  show_stack from dump_stack_lvl+0x50/0x64
[    4.255274]  dump_stack_lvl from __warn+0x80/0x12c
[    4.260134]  __warn from warn_slowpath_fmt+0x114/0x188
[    4.265199]  warn_slowpath_fmt from ida_free+0x100/0x164
[    4.270565]  ida_free from rproc_type_release+0x38/0x60
[    4.275832]  rproc_type_release from device_release+0x30/0xa0
[    4.281601]  device_release from kobject_put+0xc4/0x294
[    4.286762]  kobject_put from rproc_alloc.part.0+0x208/0x28c
[    4.292430]  rproc_alloc.part.0 from devm_rproc_alloc+0x80/0xc4
[    4.298393]  devm_rproc_alloc from stm32_rproc_probe+0xd0/0x844 [stm32_rproc]
[    4.305575]  stm32_rproc_probe [stm32_rproc] from platform_probe+0x5c/0xbc

Calling ida_alloc earlier in rproc_alloc ensures that the rproc->index is
properly set.

Fixes: 08333b911f01 ("remoteproc: Directly use ida_alloc()/free()")
Signed-off-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241122175127.2188037-1-arnaud.pouliquen@foss.st.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/remoteproc_core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2486,6 +2486,13 @@ struct rproc *rproc_alloc(struct device
 	rproc->dev.driver_data = rproc;
 	idr_init(&rproc->notifyids);
 
+	/* Assign a unique device index and name */
+	rproc->index = ida_alloc(&rproc_dev_index, GFP_KERNEL);
+	if (rproc->index < 0) {
+		dev_err(dev, "ida_alloc failed: %d\n", rproc->index);
+		goto put_device;
+	}
+
 	rproc->name = kstrdup_const(name, GFP_KERNEL);
 	if (!rproc->name)
 		goto put_device;
@@ -2496,13 +2503,6 @@ struct rproc *rproc_alloc(struct device
 	if (rproc_alloc_ops(rproc, ops))
 		goto put_device;
 
-	/* Assign a unique device index and name */
-	rproc->index = ida_alloc(&rproc_dev_index, GFP_KERNEL);
-	if (rproc->index < 0) {
-		dev_err(dev, "ida_alloc failed: %d\n", rproc->index);
-		goto put_device;
-	}
-
 	dev_set_name(&rproc->dev, "remoteproc%d", rproc->index);
 
 	atomic_set(&rproc->power, 0);


