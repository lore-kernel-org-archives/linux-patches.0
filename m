Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0110E1A76CB;
	Tue, 30 Jul 2024 17:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360515; cv=none; b=MwHjyBsmYKHYi5sHSaiCQe4/pyuc4sUEPkVt2T/KAqcM+aFcLeBIAl14rGaNdOBrVZr9TDa81hvTnl8PAi0QgGDEkHg+031rJ8Ib57T4k043D41re2wop7pEmeTEvSGWHx5Dep2cnq0KX15+s8pEWrSjDTLCgLul26/8iebAhoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360515; c=relaxed/simple;
	bh=XF8VD0jc/7Ksyc5q0G3i4WHyroq2VudrrsMbL5bs7h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmV2X5sKQg+WJEtXihwkpkcOJsaWUFEaXDfMfJndVcIFsCNJ9NSpoezuhDl02OMrs9t6tETPw1E+7g4dXIPZ+pBe2knl0KUv9s24hMvFk1wrIhbmmxKftFLIz6Mreu8NZtNV1Z/zvICRXLLZSfqf0zp6ltKGgybQ73FqDh4an80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UK9KJhbh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UK9KJhbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3541FC32782;
	Tue, 30 Jul 2024 17:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360514;
	bh=XF8VD0jc/7Ksyc5q0G3i4WHyroq2VudrrsMbL5bs7h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UK9KJhbhVQDRxRIMkVbvrWAPiqPAxa2MyYx8B832L3PbcMB5KdhY0ri6NNYhwUgMP
	 rQiKrcOJN0DInd3wvuA0PtJS0Hef6TO6aVTofYYkOvmxborBUbKzPFdxZ90F06vDn+
	 CXYP7+3Hea6VvElQxeO4z5MPiniCwTfpmc9dnnRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.10 721/809] remoteproc: imx_rproc: Fix refcount mistake in imx_rproc_addr_init
Date: Tue, 30 Jul 2024 17:49:57 +0200
Message-ID: <20240730151753.416450383@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -734,25 +734,29 @@ static int imx_rproc_addr_init(struct im
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
 


