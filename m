Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208266;
	b=1Vf1tqUDeBRp7iwYwWVeP/8nd2QuW0MqdxdAzVggsvnAVYcUWthXsUVTxOcjQ0II5nBC
	 N9JNqEp4ZQBvPWPX0PwpXjzYWcgcg8sLaGiSXWqZpNRng9Tp4bF25JB9wtir6QeB07il6
	 pyD69XuSZdbp0zs4XXGyMbf64d6FTgSSHLiyP5AdQm+iIlXH5ofF0Wkzfcnxs8qTQBFax
	 u7+XbnEsDwRK4Y+zJvWObuF4DjkbEVi4Cb0wHxZGBOOyvjtzf+LvsGNFnfymv/NXkvEkj
	 GHbzR6pZ9tnmYKVbGO7Ci2xYSGi3VWgJTDZ5/yga//aRendCNg7rYOw2VIrYbOgafKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lgmay0/jJ7T5RsQtrZiFkjeyw96y5mr+i356gF2kZu4=;
	b=lLIMRccY39QAGLi9lIXDfHTG7hqBtYgxD8uQWSQMQ/S3dMHCClU9hhsHoBgcTcswZZ7C
	 e+gQ4SrMvXoL+eIzCyLOp+2d0ahL1Cn8ZCdxs4a+6hNrcfqKEcFCUbA6RGgGf3lyVjZyo
	 Yliz9J0egRUYPXhuoWi/xs0zHlHYaUSt4+0mtFzMU1Y9KtUeKwqUWEjGoZaMzENGWJKns
	 da7SI+IrkoCdqj81mtmYhmK5QfTVv3g9CSPfYnBuN4rBDzu8NHSlQqNE8szbTmdEX7oo8
	 IDK8bjAf3mSYBjY/Q+5FJlvlvprJ9IE1j5KBWZkizcoz7fTVxofUIhNAx9kVdJk2IJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWBn7Tjo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090DA606A31C;
	Wed, 28 Oct 2026 17:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWBn7Tjo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D7F1F01825;
	Wed, 28 Oct 2026 17:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208265;
	bh=lgmay0/jJ7T5RsQtrZiFkjeyw96y5mr+i356gF2kZu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWBn7TjoCRfA2v/ZpwizfW7dcUDRH2tQsf5kCfzwih3D0/Iq+lkhvYkjbn9N71Xvb
	 lm47/knUGHYAQpANCCoHhOhyu22xp4IpxMcQ1i8jxe9ZssdQ4GO6BtqW4cfHzZlq9g
	 rrVL3I/XxaymdaEwLFq5Cd9NygKHJTkqB0CswGg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/516] i2c: mxs: fix DMA channel leak on probe error
Date: Wed, 28 Oct 2026 17:53:32 +0100
Message-ID: <20261028170004.950178656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/i2c/busses/i2c-mxs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index abad24808e855..cfd81b748ee0f 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -840,7 +840,7 @@ static int mxs_i2c_probe(struct platform_device *pdev)
 	}
 
 	/* Setup the DMA */
-	i2c->dmach = dma_request_chan(dev, "rx-tx");
+	i2c->dmach = devm_dma_request_chan(dev, "rx-tx");
 	if (IS_ERR(i2c->dmach)) {
 		return dev_err_probe(dev, PTR_ERR(i2c->dmach),
 				     "Failed to request dma\n");
@@ -878,9 +878,6 @@ static int mxs_i2c_remove(struct platform_device *pdev)
 
 	i2c_del_adapter(&i2c->adapter);
 
-	if (i2c->dmach)
-		dma_release_channel(i2c->dmach);
-
 	writel(MXS_I2C_CTRL0_SFTRST, i2c->regs + MXS_I2C_CTRL0_SET);
 
 	return 0;
-- 
2.53.0



