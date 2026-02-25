Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8078D242D9B;
	Wed, 25 Feb 2026 01:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983382; cv=none; b=ElC2f2aREwG1ZzwY+QeqHNxpYQQqLWn/3mNCMcIDCfneko6hEWOynrgnp5ERSGXul543TmiZU93j3NFCSZrGoIGBvp6E7wzi+emqecMFJYWLNrTCpnEZuB6O6xL4huni5n16PHpfRcZmR5az1ZavIB8K/5pgOG0OzWlSP6k9dEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983382; c=relaxed/simple;
	bh=+lsfY8RB39SnThnamPClp2eKJ/HOTT9N+mYJNPm7TAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzBDLfU1Hy13dlfvPpdzVqRwX5MM2AF9lsC4YORh3Iku9IeVhqRaJmx+KQyK1BLbKNCTouYulzGlgAsM557R/rTlypqBSNX10emMOLkpAbIa7xC6ipefrY2U85OwL10HofLvsJ+AvsQFLbsfRfXE0Ks+XqcxhvS3Yb+zFg7mFhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSjq5cT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSjq5cT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4468BC116D0;
	Wed, 25 Feb 2026 01:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983382;
	bh=+lsfY8RB39SnThnamPClp2eKJ/HOTT9N+mYJNPm7TAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSjq5cT8qfTqj7Ssy+CaC5wkbiZh3sayU/vJutG0HR+UgcSOrecjgP+hNILA4kXri
	 T1Y5KadQ9AlJtrHWGQ2JUumfe/NtGa8SvyVT/k9tSdMn8+uQWy4e3Ay3D+R2d6IjyT
	 /KoxWgsR2N65MjQry7Ev+JL14kKxeENjhPQAp7Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 506/781] remoteproc: imx_dsp_rproc: Fix multiple start/stop operations
Date: Tue, 24 Feb 2026 17:20:15 -0800
Message-ID: <20260225012412.213993441@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Baluta <daniel.baluta@nxp.com>

[ Upstream commit a84a1e21c0678032f1185173f816cbb500a87877 ]

After commit 67a7bc7f0358 ("remoteproc: Use of reserved_mem_region_*
functions for "memory-region"") following commands with
imx-dsp-rproc started to fail:

$ echo zephyr.elf > /sys/class/remoteproc/remoteproc0/firmware
$ echo start > /sys/class/remoteproc/remoteproc0/state
$ echo stop > /sys/class/remoteproc/remoteproc0/state
$ echo start > /sys/class/remoteproc/remoteproc0/state #! This fails
-sh: echo: write error: Device or resource busy

This happens because aforementioned commit replaced devm_ioremap_wc with
devm_ioremap_resource_wc which will "reserve" the memory region with the
first start and then will fail at the second start if the memory
region is already reserved.

Even partially reverting the faulty commit won't fix the
underlying issue because we map the address in prepare() but we never
unmap it at unprepare(), so we will keep leaking memory regions.

So, lets use alloc() and release() callbacks for memory carveout
handling. This will nicely map() the memory region at prepare() time
and unmap() it at unprepare().

Fixes: 67a7bc7f0358 ("remoteproc: Use of_reserved_mem_region_* functions for "memory-region"")
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20251210154906.99210-1-daniel.baluta@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_dsp_rproc.c | 50 ++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/remoteproc/imx_dsp_rproc.c b/drivers/remoteproc/imx_dsp_rproc.c
index 5130a35214c92..83468558e634e 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -644,6 +644,32 @@ static void imx_dsp_rproc_free_mbox(struct imx_dsp_rproc *priv)
 	mbox_free_channel(priv->rxdb_ch);
 }
 
+static int imx_dsp_rproc_mem_alloc(struct rproc *rproc,
+				   struct rproc_mem_entry *mem)
+{
+	struct device *dev = rproc->dev.parent;
+	void *va;
+
+	va = ioremap_wc(mem->dma, mem->len);
+	if (!va) {
+		dev_err(dev, "Unable to map memory region: %pa+%zx\n",
+			&mem->dma, mem->len);
+		return -ENOMEM;
+	}
+
+	mem->va = va;
+
+	return 0;
+}
+
+static int imx_dsp_rproc_mem_release(struct rproc *rproc,
+				     struct rproc_mem_entry *mem)
+{
+	iounmap(mem->va);
+
+	return 0;
+}
+
 /**
  * imx_dsp_rproc_add_carveout() - request mailbox channels
  * @priv: private data pointer
@@ -659,7 +685,6 @@ static int imx_dsp_rproc_add_carveout(struct imx_dsp_rproc *priv)
 	struct device *dev = rproc->dev.parent;
 	struct device_node *np = dev->of_node;
 	struct rproc_mem_entry *mem;
-	void __iomem *cpu_addr;
 	int a, i = 0;
 	u64 da;
 
@@ -673,15 +698,10 @@ static int imx_dsp_rproc_add_carveout(struct imx_dsp_rproc *priv)
 		if (imx_dsp_rproc_sys_to_da(priv, att->sa, att->size, &da))
 			return -EINVAL;
 
-		cpu_addr = devm_ioremap_wc(dev, att->sa, att->size);
-		if (!cpu_addr) {
-			dev_err(dev, "failed to map memory %p\n", &att->sa);
-			return -ENOMEM;
-		}
-
 		/* Register memory region */
-		mem = rproc_mem_entry_init(dev, (void __force *)cpu_addr, (dma_addr_t)att->sa,
-					   att->size, da, NULL, NULL, "dsp_mem");
+		mem = rproc_mem_entry_init(dev, NULL, (dma_addr_t)att->sa,
+					   att->size, da, imx_dsp_rproc_mem_alloc,
+					   imx_dsp_rproc_mem_release, "dsp_mem");
 
 		if (mem)
 			rproc_coredump_add_segment(rproc, da, att->size);
@@ -709,15 +729,11 @@ static int imx_dsp_rproc_add_carveout(struct imx_dsp_rproc *priv)
 		if (imx_dsp_rproc_sys_to_da(priv, res.start, resource_size(&res), &da))
 			return -EINVAL;
 
-		cpu_addr = devm_ioremap_resource_wc(dev, &res);
-		if (IS_ERR(cpu_addr)) {
-			dev_err(dev, "failed to map memory %pR\n", &res);
-			return PTR_ERR(cpu_addr);
-		}
-
 		/* Register memory region */
-		mem = rproc_mem_entry_init(dev, (void __force *)cpu_addr, (dma_addr_t)res.start,
-					   resource_size(&res), da, NULL, NULL,
+		mem = rproc_mem_entry_init(dev, NULL, (dma_addr_t)res.start,
+					   resource_size(&res), da,
+					    imx_dsp_rproc_mem_alloc,
+					    imx_dsp_rproc_mem_release,
 					   "%.*s", strchrnul(res.name, '@') - res.name, res.name);
 		if (!mem)
 			return -ENOMEM;
-- 
2.51.0



