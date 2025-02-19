Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620B61CD210;
	Wed, 19 Feb 2025 09:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956674; cv=none; b=brFWUuLO4fKEgGcdfYfn1qr38/C+Br0k0hJhFKwD9JQt7vRgc76FMWDMQpcq3e+oBPXMpnFAYARiCuPH8yZOQKr7bb8quh38LIIK/TkkjWg0OcEnFwEGk4a4RAly9qIPocS7z4R5vvdlaTpdDeCKqcxvtdWmJMTFcbYMMb+Lzn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956674; c=relaxed/simple;
	bh=9OU1VmR0TZPNxLng43QWMIVNLx1eWo8vfPzAymym3B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnAOHghJPD7n118StB4ur7c3xABKJ0yGInDkmV5OekzohWPB/elN8qB0/jQqNEKhQB8ZkTpn3qFpN/gIX7SV6dC49peZaKxe1FVfZ9Z9/j5ISryDpjeJGbyUq3JNL0bFpOsYHmzDtlpLauzj8ZqQYc0YcXP2wChuSVG1Ul4NgyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ja+y33B9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ja+y33B9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9492C4CED1;
	Wed, 19 Feb 2025 09:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956674;
	bh=9OU1VmR0TZPNxLng43QWMIVNLx1eWo8vfPzAymym3B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ja+y33B9C55W+BTE+eScKfysBPh4EKUGcOBct3hy0+K3vuwvjXiYVQYXwgDB+mYSL
	 buIDeubEiPyuHWcq9pJp3x6OatEU/Vzbqbw9npW04Iq8cONpMAk6YJiKEObHuN391E
	 d4mhTC2QXLJeCm8IAJ85VcAuxhLOoiTAizETUcNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.1 261/578] remoteproc: core: Fix ida_free call while not allocated
Date: Wed, 19 Feb 2025 09:24:25 +0100
Message-ID: <20250219082703.289873064@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2464,6 +2464,13 @@ struct rproc *rproc_alloc(struct device
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
@@ -2474,13 +2481,6 @@ struct rproc *rproc_alloc(struct device
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


