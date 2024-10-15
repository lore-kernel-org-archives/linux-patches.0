Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26FA1E766C;
	Tue, 15 Oct 2024 11:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992816; cv=none; b=VU0fnbTSJ5VyOLdyUzFOBeHATbAISH5wc9WAQGkDcOtlzQmGka614hl5pzaxnG5K2eC7CIoVQCBU0dpKPgMSxVkPEIpjgFzJuIe9jbdh81Z/McK7pW/jJAJBtN7sicKJjQmim6L7QwRwj5ykn1l2NZAIMh6sZ0jMeHw8w0cnS3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992816; c=relaxed/simple;
	bh=TXMoD85FzcWXeKDq3OcCzVk4USeiQ2klIX2ikTCa6ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scdxG2dMskmFqFC0kWG6b5zpLIIUh/U2lxg3b7DVLdKmKPzUZ7byFM5UqCdRBEJR+9W2wjrfmbSO+4LTK9Xz1/uWrk/yQVr15rniI5oL++Y/ZVUvmP76qe/8S0Tcckk8aOgv45IDuFDEQt9ikspnoffz5N94COQgk2t7Ixjtgds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/jNMLSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/jNMLSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A55C4CEC6;
	Tue, 15 Oct 2024 11:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992816;
	bh=TXMoD85FzcWXeKDq3OcCzVk4USeiQ2klIX2ikTCa6ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/jNMLSdar9gXB0paVtWz88mRpHsNIgHglBQ4Kl+fD8lMiaZJUY7ninhKWc3hDi/v
	 2HXlVvT0vty46sfBS3IBxyzL0yT2myRweW2ymMGjNIetZP0UfSz0v+wWD+LF86Sr8/
	 yTN4C4Rm6rOk9iqnj43H6Up9mksRaS92E+R6O2Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/691] remoteproc: imx_rproc: Initialize workqueue earlier
Date: Tue, 15 Oct 2024 13:22:55 +0200
Message-ID: <20241015112449.368080695@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index fec093b3f5e10..c45c87a94d62a 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -792,6 +792,8 @@ static int imx_rproc_probe(struct platform_device *pdev)
 		goto err_put_rproc;
 	}
 
+	INIT_WORK(&priv->rproc_work, imx_rproc_vq_work);
+
 	ret = imx_rproc_xtr_mbox_init(rproc);
 	if (ret)
 		goto err_put_wkq;
@@ -810,8 +812,6 @@ static int imx_rproc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_put_mbox;
 
-	INIT_WORK(&priv->rproc_work, imx_rproc_vq_work);
-
 	if (rproc->state != RPROC_DETACHED)
 		rproc->auto_boot = of_property_read_bool(np, "fsl,auto-boot");
 
-- 
2.43.0



