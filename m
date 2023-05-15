Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF88FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E68FC433D2;
	Mon, 15 May 2023 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170466;
	bh=mblPHaVTzJFd9zvtR/j6mmAdK23F7mYATGqoMeeeZ2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSeTQFnsvvYFWf6RDfdyO0xw51/T+SQ0c2fjjSPzwuhRgwZ+vYQGNn/tuSwWGLttj
	 IH3lt52c/rTZHMRx8mXjFGb6IWYErCUHC9PdbNhYezpWBPbhE5Xrp72Ol+sBnynHhe
	 JntzLNSMUMIuI5m4ferL0PGEMZOxRQQYYD3tpLhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Shengjiu Wang <shengjiu.wang@gmail.com>
Subject: [PATCH 6.1 139/239] remoteproc: imx_dsp_rproc: Call of_node_put() on iteration error
Date: Mon, 15 May 2023 18:26:42 +0200
Message-Id: <20230515161725.861771525@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathieu Poirier <mathieu.poirier@linaro.org>

commit e0e01de8ee146986872e54e8365f4b4654819412 upstream.

Function of_phandle_iterator_next() calls of_node_put() on the last
device_node it iterated over, but when the loop exits prematurely it has
to be called explicitly.

Fixes: ec0e5549f358 ("remoteproc: imx_dsp_rproc: Add remoteproc driver for DSP on i.MX")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20230320221826.2728078-6-mathieu.poirier@linaro.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_dsp_rproc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -627,15 +627,19 @@ static int imx_dsp_rproc_add_carveout(st
 
 		rmem = of_reserved_mem_lookup(it.node);
 		if (!rmem) {
+			of_node_put(it.node);
 			dev_err(dev, "unable to acquire memory-region\n");
 			return -EINVAL;
 		}
 
-		if (imx_dsp_rproc_sys_to_da(priv, rmem->base, rmem->size, &da))
+		if (imx_dsp_rproc_sys_to_da(priv, rmem->base, rmem->size, &da)) {
+			of_node_put(it.node);
 			return -EINVAL;
+		}
 
 		cpu_addr = devm_ioremap_wc(dev, rmem->base, rmem->size);
 		if (!cpu_addr) {
+			of_node_put(it.node);
 			dev_err(dev, "failed to map memory %p\n", &rmem->base);
 			return -ENOMEM;
 		}
@@ -644,10 +648,12 @@ static int imx_dsp_rproc_add_carveout(st
 		mem = rproc_mem_entry_init(dev, (void __force *)cpu_addr, (dma_addr_t)rmem->base,
 					   rmem->size, da, NULL, NULL, it.node->name);
 
-		if (mem)
+		if (mem) {
 			rproc_coredump_add_segment(rproc, da, rmem->size);
-		else
+		} else {
+			of_node_put(it.node);
 			return -ENOMEM;
+		}
 
 		rproc_add_carveout(rproc, mem);
 	}


