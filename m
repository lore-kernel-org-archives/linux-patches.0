Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8E31714A1;
	Thu, 15 Aug 2024 13:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730165; cv=none; b=b5hNVKLhH/h21IlDmDIhYE3edUVU/mQcgWNYVZd3RvoH/hhhp4PBCGTNI7+W5l948Z0QCZ5qHwrIaxInsQIC/YqeNgCfSsYuEW/1Ybk3AMdKvOp0rQ0b6K8sXZQAaZrVm93iV6hcc6wPhz9S/dOaqsmywZrot9vOyos1c1FjFD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730165; c=relaxed/simple;
	bh=ROx8+wGuyQclItzIlv0GSuOAocojXKOrNqix/5OW8yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBBM0v6Z/afo89Je0rzEh6FpmE01td4N3g3ND0ZE0AcfO1U9bjOM1qIE2+mysEkjwEq0ZhBNeY03pM89ExpVDrD2JlzQx943E7rm+PPVdBldL3bmtb3tE3gu7s7V/6M7NotupRsSxftcrJGSYUGbqE+wtzmmTPkP0WqR6ZWPOTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2caVNrpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2caVNrpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B12C32786;
	Thu, 15 Aug 2024 13:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730165;
	bh=ROx8+wGuyQclItzIlv0GSuOAocojXKOrNqix/5OW8yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2caVNrpO2QYE3Cfy/yxC3rNMvKCn9faeYdYEa4d6S5Na38ZwPnulVAuzqyIS5l5bD
	 tBajC9oe7nmZaVpNSp/ki9Kbbunu1KegWvyuR7oQG9HE6zXi3e4Ii85jGD1YM6Z9gf
	 FxFUu6XX4f1DIfxLzL0Vfw4f3EhLxW4RGSwYmLZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 323/484] remoteproc: imx_rproc: Fix refcount mistake in imx_rproc_addr_init
Date: Thu, 15 Aug 2024 15:23:01 +0200
Message-ID: <20240815131953.885934043@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit dce68a49be26abf52712e0ee452a45fa01ab4624 ]

In imx_rproc_addr_init() strcmp() is performed over the node after the
of_node_put() is performed over it.
Fix this error by moving of_node_put() calls.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5e4c1243071d ("remoteproc: imx_rproc: support remote cores booted before Linux Kernel")
Cc: stable@vger.kernel.org
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://lore.kernel.org/r/20240612131714.12907-1-amishin@t-argos.ru
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index cfdb96cafc7b9..d5ce97e75f027 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -596,25 +596,29 @@ static int imx_rproc_addr_init(struct imx_rproc *priv,
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
 		priv->mem[b].cpu_addr = devm_ioremap(&pdev->dev, res.start, resource_size(&res));
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
 
-- 
2.43.0



