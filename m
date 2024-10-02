Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B731D0B98;
	Wed,  2 Oct 2024 13:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876293; cv=none; b=TECnjfHQEEI4d/ZPTqm+q3mCkuWiAsridrAmW/2h3YcVVO1TIwqn+r4J/0xJqa9NeuhlQXuTm1Q+V7biUdSPzhSEbu74Nv6zYPIWWJWYhZarz02K8z3woWUaXIqMSZhBsqRIVf9cs8IGylDtyGuj7kedUhzPA57brNssASL+Zbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876293; c=relaxed/simple;
	bh=Ilul0ouuPeuTSGh/TYj5u3GMEuCF5sQCW0o5Vy6kjOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuO2bvR1xZEbosgjwIfnpObx7BBuRwG1OtDQ0uPUfFDqfJTKA1KzG678RCVxRs20Yy7uR/mFnmosqbezr2DHJr7zcAcrfGA0VBpGzH5sMOkr7vZ6F4eyqXj8ZaBvTy3X7hMCysHCAvmqHtGkvglIEAp33gTaR1a1lunjsWa0W9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxMDTEWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxMDTEWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDDBC4CEC5;
	Wed,  2 Oct 2024 13:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876292;
	bh=Ilul0ouuPeuTSGh/TYj5u3GMEuCF5sQCW0o5Vy6kjOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxMDTEWeo7Jofe3Xne1LyNG+a0dsqqT+tA8Pt/WExEz2/utOek7ZH5voULM77ylJr
	 KWvOxCiJgOVDsVotXPJQADbiwQZEiEyj4LM/B52xHejNoGp9nV8XDhagHqE5HlcWGA
	 bKQE/SmsouRjJjLvCpDbYeScetPlnf2TLIeYp4Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 353/695] remoteproc: imx_rproc: Initialize workqueue earlier
Date: Wed,  2 Oct 2024 14:55:51 +0200
Message-ID: <20241002125836.538650097@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 858e57c1d3dd7b92cc0fa692ba130a0a5d57e49d ]

Initialize workqueue before requesting mailbox channel, otherwise if
mailbox interrupt comes before workqueue ready, the imx_rproc_rx_callback
will trigger issue.

Fixes: 2df7062002d0 ("remoteproc: imx_proc: enable virtio/mailbox")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20240719-imx_rproc-v2-3-10d0268c7eb1@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 3c8b64db8823c..448b9a5438e0b 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -1076,6 +1076,8 @@ static int imx_rproc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	INIT_WORK(&priv->rproc_work, imx_rproc_vq_work);
+
 	ret = imx_rproc_xtr_mbox_init(rproc);
 	if (ret)
 		goto err_put_wkq;
@@ -1094,8 +1096,6 @@ static int imx_rproc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_put_scu;
 
-	INIT_WORK(&priv->rproc_work, imx_rproc_vq_work);
-
 	if (rproc->state != RPROC_DETACHED)
 		rproc->auto_boot = of_property_read_bool(np, "fsl,auto-boot");
 
-- 
2.43.0



