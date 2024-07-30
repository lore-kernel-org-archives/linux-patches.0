Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4CD1A76B9;
	Tue, 30 Jul 2024 17:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359492; cv=none; b=nujRvwbrj2Vfh3t8Uh2qeKhMZAqEujpTk2ezoQ0AlS/Akvu5Nh671/6rAcAyvuZS5mzpe4lYTK11+muuWpHM99vN74FFEhCov6g8Xc7Tsv63Ezkc2+qPGLigSyqGekD8p6M0p2Gtc6uG9i58tJ1c1ZiHqYlp4u7fJ1C5aLV4LTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359492; c=relaxed/simple;
	bh=DBgul93pPPSRlhkqWCxkiMC/gO3kcJPEERaCtI4UdJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMyD6Xg4kCh+7WTT/qVxmigz4d5ho7cyX4PysZRh6rDtqFQl4snJtJGjUrXRy2193uTvY4StfwxzDgUas8CYnbv6gz/3aMbpDv+91KSQDVn0sysPrmldC6FmyeXJFTwqZOxFbqCZMvN2e6XactVg1B46sPKyNSwaSkq7myZxYZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cq4Vav0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cq4Vav0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B451DC32782;
	Tue, 30 Jul 2024 17:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359492;
	bh=DBgul93pPPSRlhkqWCxkiMC/gO3kcJPEERaCtI4UdJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cq4Vav0GD5rAuhJvFeu0X6pTocsHOu/618YMIOAzr3lyi4y7DcmPZEDNAWCjC+XQC
	 OcwqPZXvbo7lYmMs2vcdjFCzwhaJShhMD4mJ29gEYGNLfE0lvbVNnnFbllttaoVOmf
	 0L9E/74/7JpvuJ6xVRP9Gfsw0DR/Ihw5uDtpFReU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.6 492/568] remoteproc: imx_rproc: Fix refcount mistake in imx_rproc_addr_init
Date: Tue, 30 Jul 2024 17:49:59 +0200
Message-ID: <20240730151659.259355549@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -737,25 +737,29 @@ static int imx_rproc_addr_init(struct im
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
 


