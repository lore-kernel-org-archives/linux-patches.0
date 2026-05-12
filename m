Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AB1368D56;
	Tue, 12 May 2026 18:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609569; cv=none; b=SliIGT2MmH9e1H8N0uEuSjWmQrFi/mHInJibYhxSFa6ZkPDuI22G6AlJEOrM5KDnkovzwnpBk6xBrLYqjDrAU+CCujOBbzRCPJrjdUAtETr+zcLkS9WNSJ8wHFv3zfQLXJIR3poNomeA9X2F5GMs4MOqS+11cFXQsP/WLBEcUMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609569; c=relaxed/simple;
	bh=fmiYJlwM0ihFw1o0AbrOopFWPvXHzqW347Ovmwobuj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9r/Oan9drvYYhSh6oimhRMlHjoAgW6wPOXSqZAtwSV9s6h2nyukA9m62L/i7D5UPWY76bSdhu0HZT8s7TI/aftQ0V42kUnZMa6K0ySghEZoewoyUbsE2I+DGBHMUu0fKzCKh4dPmlhV5pZCultUzHlod0smbQBDSo6LDDWhyQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+HQi4qm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+HQi4qm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE53C2BCB0;
	Tue, 12 May 2026 18:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609568;
	bh=fmiYJlwM0ihFw1o0AbrOopFWPvXHzqW347Ovmwobuj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+HQi4qmi0lM4gkkJlTGg19UugsUNPHY03otykH43NnABeIgkLQgZZ/0X82pE85Xp
	 HVir/7t4yow3Z421Dau2g/qGrSrsZ0vLS90qL3DT1G4Dwauy15zQYH4mTFL2sdQJKd
	 Mf43ktncfzCMq/NaCAvIi/nvY00gFIv9v2MErGt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 7.0 244/307] remoteproc: imx_rproc: Fix NULL vs IS_ERR() bug in imx_rproc_addr_init()
Date: Tue, 12 May 2026 19:40:39 +0200
Message-ID: <20260512173945.272694756@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

commit 665eebebb029690a5b2f92e481020877cc6c8d36 upstream.

The devm_ioremap_resource_wc() function never returns NULL, it returns
error pointers.  Update the error checking to match.

Fixes: 67a7bc7f0358 ("remoteproc: Use of_reserved_mem_region_* functions for "memory-region"")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260227091546.4044246-1-nichen@iscas.ac.cn
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_rproc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -812,7 +812,7 @@ static int imx_rproc_addr_init(struct im
 
 		/* Not use resource version, because we might share region */
 		priv->mem[b].cpu_addr = devm_ioremap_resource_wc(&pdev->dev, &res);
-		if (!priv->mem[b].cpu_addr) {
+		if (IS_ERR(priv->mem[b].cpu_addr)) {
 			dev_err(dev, "failed to remap %pr\n", &res);
 			return -ENOMEM;
 		}


