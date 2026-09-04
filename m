Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F672D738A;
	Fri,  4 Sep 2026 05:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501394; cv=none; b=RgxDbUGsDeKxLFraJQGpX3RAs7q9L37EtfhHEaPG+XJVwRDOlvQuy3d94EjgYF35akJ2fC5HSQc7UYYANgtL9TL7D6VJ4QrxoUhEodSYyqHcqGnYwlnEd9hKIOIABEyBi48FGyNcpueMNS2cm1gX1OOALI4xRz3xoJPPTKMWms4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501394; c=relaxed/simple;
	bh=b6TiOw4xlI5oQbtv/O/U63bcfQEYjOWPoGgosWGHKtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0YoV0gaWTQvJuJckqcoiQjOHZAMBSqK30+sArfor/WqQDOPmer4lBD08H460FaSsmUmQ8xS/6G0Ym5sCeptgLKXEYOMX6wWZ0gQo75MaFDxakTIZD915R+zXjmiFGVGfWtDRPgviPkSQWx4WNcRyl8v/edAH3/qRgBwDxpcIbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5+JJclG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5+JJclG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BFD1F00A3D;
	Fri,  4 Sep 2026 05:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501393;
	bh=r1AUNsusNuxcc2Yd0I63TY7p1tAE7/ZdNKUIa3xqzZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5+JJclGOTn3ScOx3YojpI+lakm8G/0JQWJ6pPsSyANR0e8YEYQaQ/CLnFZGDmxGg
	 KLDQorCjFGSeHW9+m4eTfouQktGSvZ9L9GuMuRamRVFu2YWfyW57HZk1F4LQanM/vl
	 K2sYE3lxlWNGnQ+fBGe3HKI9ARCyXTkji/zIz2LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 351/552] i2c: mxs: fix DMA channel leak on probe error
Date: Fri,  4 Sep 2026 06:58:28 +0200
Message-ID: <20260904045758.203294704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

commit 777979e627115734052b323d2721cdb500e81dcf upstream.

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
 


