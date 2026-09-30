Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F2851FCB2;
	Wed, 30 Sep 2026 17:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789691; cv=none; b=BrjRpu0MZGokXHBy4vpUSEHKEBNDozGbVRU8U74z2kFgdFG17wbrZgMhn3E9hYRJVUf8D/vHo24+J9P3xQEM3spjSGkq6Q0wPZgtcbJwhOdi9HM6nsmDRgWx8GI/yBg2elbrnuSgdfWhlV5Ws5RgHNSrJY83tgDviUA3Afax0t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789691; c=relaxed/simple;
	bh=jGU/DHltIo/MPt4oh/CqfiwL9ifGCquGADJSBxKOgmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiJhTBbB9gV/tI6yUzTPsQBcd2uINnEX5A6zke1P8xFRxgp9lSel7ZX5UtnJKqLfwwwydo2ImRCsUjax9g0WJ5CQHuvB47CbMESZoll6//XxfCj+u4Nz+CktwFdEArscKWF687lOrIeS38YvBfw/bw+Ak5FG8lwsPy0iodZb+mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5W0u4it; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5W0u4it"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2658C1F000FF;
	Wed, 30 Sep 2026 17:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789689;
	bh=jkEpSVpPKKxraB07Ge+jGDpZP4JDBeecH2hjgMQv3ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5W0u4itkxIXQ5/l3cWj9ECFo1k5RhZxJ0ocTpl8NC/UAPaeMWgPu24y9aGQEnGYe
	 UbRDxbALUDHk/wCd/dJhrTCek+3ytRhW2Gn5hamDK+G0N2vlj8XA3w7Y/uv0cihyhY
	 fm5PomWlPIp2YbQSKL0XExWaQc3bXs5DOLWfsCP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 566/877] i2c: mxs: fix DMA channel leak on probe error
Date: Wed, 30 Sep 2026 17:24:37 +0200
Message-ID: <20260930152426.855878503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 777979e627115734052b323d2721cdb500e81dcf ]

mxs_i2c_probe() requests an exclusive DMA channel before resetting the
controller and registering the I2C adapter. If either later operation
fails, probe returns without releasing the channel because the remove
callback is not invoked after a failed probe.

Use devm_dma_request_chan() so the device core releases the channel on
probe failure and driver detach. Remove the manual release from the
remove callback because the channel is now device-managed.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 62885f59a261 ("MXS: Implement DMA support into mxs-i2c")
Assisted-by: unnamed:claude-opus-4.8 typestate
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Cc: <stable@vger.kernel.org> # v3.7+
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260815151720.3757460-1-ruoyuw560@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mxs.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -831,7 +831,7 @@ static int mxs_i2c_probe(struct platform
 	}
 
 	/* Setup the DMA */
-	i2c->dmach = dma_request_chan(dev, "rx-tx");
+	i2c->dmach = devm_dma_request_chan(dev, "rx-tx");
 	if (IS_ERR(i2c->dmach)) {
 		return dev_err_probe(dev, PTR_ERR(i2c->dmach),
 				     "Failed to request dma\n");
@@ -869,9 +869,6 @@ static void mxs_i2c_remove(struct platfo
 
 	i2c_del_adapter(&i2c->adapter);
 
-	if (i2c->dmach)
-		dma_release_channel(i2c->dmach);
-
 	writel(MXS_I2C_CTRL0_SFTRST, i2c->regs + MXS_I2C_CTRL0_SET);
 }
 


