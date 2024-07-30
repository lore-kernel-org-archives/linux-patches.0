Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137E81078F;
	Tue, 30 Jul 2024 16:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358259; cv=none; b=fOTQHsi44iM/GtNgvA2GjAR6sD8MV0IEaEoN9fv3D3uWPqniW7zvqZILxPTnP9hWR50p9OP4yDoRPHtM1ef5cQ/IKvvWOnK2yHcgl2V6rnGag7gp10NPeELjxUJH6hqV9o+GD4DaRaJfCkE+cKshDgyBkaa4mef/hyiNDHFkt64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358259; c=relaxed/simple;
	bh=PSpOa3ybGqdCdaXhkPWlHsw6OMqHM4bOCmz8um+SZwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yr/HS39MfqJII0Ck69mA49zNKGmgaVa3WBkSfxMew0ayVZoZ6Mww1PnKzjrQ4JIvxUHq1//r6QPRwor8/z9S7g3P0uDj4nFf1L9uykw0O3JO05F4j1xeelcztRgaqQhAQ5bZhvagQfZNdDw+6JoOrWxOslLLyG7plGCErRUK6Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmx4HuTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmx4HuTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5995BC32782;
	Tue, 30 Jul 2024 16:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358258;
	bh=PSpOa3ybGqdCdaXhkPWlHsw6OMqHM4bOCmz8um+SZwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmx4HuTUe9dNsaa67Mz7Xgs/Io2ep8BMS6mN3voC8HIR0JafuI6c/cQDkaQFUOpAF
	 KMtzhNZluj3ABwNhPJMYAfzA5Rbz4UyoZDK+l1FRK6rbbdJQS4GOrQs8TyY0eNi4z+
	 oQkyShq2nu5SjEB7xyhV/0j9gcwgc7CbMttNUX/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.1 371/440] remoteproc: imx_rproc: Fix refcount mistake in imx_rproc_addr_init
Date: Tue, 30 Jul 2024 17:50:04 +0200
Message-ID: <20240730151630.306373125@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

commit dce68a49be26abf52712e0ee452a45fa01ab4624 upstream.

In imx_rproc_addr_init() strcmp() is performed over the node after the
of_node_put() is performed over it.
Fix this error by moving of_node_put() calls.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5e4c1243071d ("remoteproc: imx_rproc: support remote cores booted before Linux Kernel")
Cc: stable@vger.kernel.org
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://lore.kernel.org/r/20240612131714.12907-1-amishin@t-argos.ru
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_rproc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -604,25 +604,29 @@ static int imx_rproc_addr_init(struct im
 			continue;
 		}
 		err = of_address_to_resource(node, 0, &res);
-		of_node_put(node);
 		if (err) {
 			dev_err(dev, "unable to resolve memory region\n");
+			of_node_put(node);
 			return err;
 		}
 
-		if (b >= IMX_RPROC_MEM_MAX)
+		if (b >= IMX_RPROC_MEM_MAX) {
+			of_node_put(node);
 			break;
+		}
 
 		/* Not use resource version, because we might share region */
 		priv->mem[b].cpu_addr = devm_ioremap_wc(&pdev->dev, res.start, resource_size(&res));
 		if (!priv->mem[b].cpu_addr) {
 			dev_err(dev, "failed to remap %pr\n", &res);
+			of_node_put(node);
 			return -ENOMEM;
 		}
 		priv->mem[b].sys_addr = res.start;
 		priv->mem[b].size = resource_size(&res);
 		if (!strcmp(node->name, "rsc-table"))
 			priv->rsc_table = priv->mem[b].cpu_addr;
+		of_node_put(node);
 		b++;
 	}
 


