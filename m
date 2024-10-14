Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5375219F43B;
	Mon, 14 Oct 2024 15:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918103; cv=none; b=MXNbU9gDbX8a7G41Wi52smlSBlUYTkb9Dx0454/Xkcg6SQSCdvRuRpEYF6MfUNXxbmNYLoFML5BUOrHcpj3Jmz6fAWC2Hq1xgzRVoxOxntCRGChqdbmHMwfLXSv8Nx65VGfmuMDFSv7IVD3DQhd4+IHpV0iXh38fnwU4tK8rwwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918103; c=relaxed/simple;
	bh=7z8OPJWYjRQy4+0YsKCcQ977/i5ero73JmhfehAByFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dewEbzMwDOuR88xapDv/LeSZ/6jFyFzS1/HH88Hu9TNpsyTozd6BTo6x5TMzEgTZZZbIRYcYMuhiCn2mAlKAbFaevi5VeMNb3km5RgWb9TZa89HRpRqhrdpfefyooBKHAUa3kjBKGEGESZBLmADzDJl0G0abcai0QGhMi3lZN8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGlBbXDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGlBbXDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62D3C4CEC3;
	Mon, 14 Oct 2024 15:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918103;
	bh=7z8OPJWYjRQy4+0YsKCcQ977/i5ero73JmhfehAByFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGlBbXDBm4Yumtttu9vrHmr4AXxhM0HmfVO7M19V9LPdt0Ev8AA37MBLKpeOXLx9x
	 6EC+ARLbeXrtCJsA6rvuSq2MAx6eMih1rbCJy8zVQpt1JAA3gFPW1HLskU3mGXHpeT
	 ttQpWDGeDhSVCZhYHTkpbeh0y0rh0XrN53B9qaAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/798] remoteproc: imx_rproc: Initialize workqueue earlier
Date: Mon, 14 Oct 2024 16:12:26 +0200
Message-ID: <20241014141225.473001968@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 7dad5cbec7ede..00a0c8f4a2200 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -796,6 +796,8 @@ static int imx_rproc_probe(struct platform_device *pdev)
 		goto err_put_rproc;
 	}
 
+	INIT_WORK(&priv->rproc_work, imx_rproc_vq_work);
+
 	ret = imx_rproc_xtr_mbox_init(rproc);
 	if (ret)
 		goto err_put_wkq;
@@ -814,8 +816,6 @@ static int imx_rproc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_put_mbox;
 
-	INIT_WORK(&priv->rproc_work, imx_rproc_vq_work);
-
 	if (rproc->state != RPROC_DETACHED)
 		rproc->auto_boot = of_property_read_bool(np, "fsl,auto-boot");
 
-- 
2.43.0



