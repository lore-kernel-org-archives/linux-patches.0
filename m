Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12094315A;
	Mon, 23 Jun 2025 21:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715012; cv=none; b=AAEPowuS6MRk2wgLDdcgTQEbaWP/cpG5vQ0MXXNZHCYRrT2ZLxI4m9y11fxNm8Xt+EZZIf0uQuCz3nbeLOzY+6unOQduluhYRr7E9tEPGRxT5U+YEu+M4f5eaI+LYlzjXmu+A22Fkkdx6wFH8eRDoSBLmg9c1a/y/awSUMDlFBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715012; c=relaxed/simple;
	bh=avdJkp5+b66eWCNkrlVBIqE8rk6FeMuNiuQ0lem0f8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qly9jxQILWP0WS3+Zn5PQ961DEBtWkens38Vgu2ixrd6npYh8ErguJ/6+f8n9pCf9rgD03a+sg1V3SC293ev+vm240R1AvZG931wUm8MUEo4xwmwcMcSl2M1sL/BIwetlISSVirDTTbRmboG/1gJxleeoEMJG6WJgsH+SK/xPDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxLsGzer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxLsGzer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3C7C4CEEA;
	Mon, 23 Jun 2025 21:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715011;
	bh=avdJkp5+b66eWCNkrlVBIqE8rk6FeMuNiuQ0lem0f8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxLsGzer6K30ARg4rxknhIfzKX+MNctosGfqXjMR9g7ZDb5DY/bXqqLeQgBnRRswC
	 Z4778msoosdjGMrWP9XbGYXBaPSQ45ZYGz7/pG3o6P2UlK0mlOmsxnz5Stc7AE09TL
	 umVYrhAR6BsdcjX7zJ1QQcl1rXYZ3tQwvapn3vzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 6.12 140/414] remoteproc: core: Cleanup acquired resources when rproc_handle_resources() fails in rproc_attach()
Date: Mon, 23 Jun 2025 15:04:37 +0200
Message-ID: <20250623130645.555762866@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit 7692c9fbedd9087dc9050903f58095915458d9b1 upstream.

When rproc->state = RPROC_DETACHED and rproc_attach() is used
to attach to the remote processor, if rproc_handle_resources()
returns a failure, the resources allocated by imx_rproc_prepare()
should be released, otherwise the following memory leak will occur.

Since almost the same thing is done in imx_rproc_prepare() and
rproc_resource_cleanup(), Function rproc_resource_cleanup() is able
to deal with empty lists so it is better to fix the "goto" statements
in rproc_attach(). replace the "unprepare_device" goto statement with
"clean_up_resources" and get rid of the "unprepare_device" label.

unreferenced object 0xffff0000861c5d00 (size 128):
comm "kworker/u12:3", pid 59, jiffies 4294893509 (age 149.220s)
hex dump (first 32 bytes):
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
00 00 02 88 00 00 00 00 00 00 10 00 00 00 00 00 ............
backtrace:
 [<00000000f949fe18>] slab_post_alloc_hook+0x98/0x37c
 [<00000000adbfb3e7>] __kmem_cache_alloc_node+0x138/0x2e0
 [<00000000521c0345>] kmalloc_trace+0x40/0x158
 [<000000004e330a49>] rproc_mem_entry_init+0x60/0xf8
 [<000000002815755e>] imx_rproc_prepare+0xe0/0x180
 [<0000000003f61b4e>] rproc_boot+0x2ec/0x528
 [<00000000e7e994ac>] rproc_add+0x124/0x17c
 [<0000000048594076>] imx_rproc_probe+0x4ec/0x5d4
 [<00000000efc298a1>] platform_probe+0x68/0xd8
 [<00000000110be6fe>] really_probe+0x110/0x27c
 [<00000000e245c0ae>] __driver_probe_device+0x78/0x12c
 [<00000000f61f6f5e>] driver_probe_device+0x3c/0x118
 [<00000000a7874938>] __device_attach_driver+0xb8/0xf8
 [<0000000065319e69>] bus_for_each_drv+0x84/0xe4
 [<00000000db3eb243>] __device_attach+0xfc/0x18c
 [<0000000072e4e1a4>] device_initial_probe+0x14/0x20

Fixes: 10a3d4079eae ("remoteproc: imx_rproc: move memory parsing to rproc_ops")
Suggested-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250430092043.1819308-2-xiaolei.wang@windriver.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/remoteproc_core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1617,7 +1617,7 @@ static int rproc_attach(struct rproc *rp
 	ret = rproc_set_rsc_table(rproc);
 	if (ret) {
 		dev_err(dev, "can't load resource table: %d\n", ret);
-		goto unprepare_device;
+		goto clean_up_resources;
 	}
 
 	/* reset max_notifyid */
@@ -1634,7 +1634,7 @@ static int rproc_attach(struct rproc *rp
 	ret = rproc_handle_resources(rproc, rproc_loading_handlers);
 	if (ret) {
 		dev_err(dev, "Failed to process resources: %d\n", ret);
-		goto unprepare_device;
+		goto clean_up_resources;
 	}
 
 	/* Allocate carveout resources associated to rproc */
@@ -1653,7 +1653,6 @@ static int rproc_attach(struct rproc *rp
 
 clean_up_resources:
 	rproc_resource_cleanup(rproc);
-unprepare_device:
 	/* release HW resources if needed */
 	rproc_unprepare_device(rproc);
 disable_iommu:


