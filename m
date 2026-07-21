Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5BA3E7141;
	Tue, 21 Jul 2026 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655118; cv=none; b=EjkKhtVJBHPzXYVxVjX+42YL5d6pzXW7CHOs7A66l77eHC0OYwJ6gW3v2wSbzWG7gpVlJ2kw7jziQM6a3gZ7/tJofhLHT9tzIc/yieAflciS+2KXDgj3lrXy+uBpnLO/dFoJPSLiibYkFCeoK5auKGEKfDrr1r5BBjXYg/trLWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655118; c=relaxed/simple;
	bh=zALWvvKpXv/t//BhoBQmmfvK/RzEsVjwnPa0Mj9HE0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PR4M7rQdJWmrK6EUJoq0Vy8MTHKh+bhhQYIF8LBcNAK07nPThLNIrEToEjA6qAkUiMVFjz9CFkl4RbDpWCbhQpENE4dFcLhcgT7iqHpAaOdlraW9WdowQL49wJuimzLu4oMyRG2aEiacpGeAsI+6s0y+g686su7baL9u7Fp+Nz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqIqKRwo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqIqKRwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF0B1F000E9;
	Tue, 21 Jul 2026 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655116;
	bh=WruLPIxLgyUuL5R9HK23CnCI2jrFcuWJ4X9vcgv51rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SqIqKRwoKxL3ZRJvr+yd8VhXdkkejT9O4cZ/6+NdkWt8r6UHr0N8EgIS8dZu3pw2i
	 H5f3LC4Ol+NJam/v27jvVlUK8yfK02IWHfLue/0i62BVkIVgi4BLv7nuNsu0j5y8a/
	 FutEfacf0lDxMFBfTCOPDafI6iOLT4kE3BNHMOXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 7.1 1962/2077] ata: pata_pxa: Fix DMA channel leak on probe error
Date: Tue, 21 Jul 2026 17:27:15 +0200
Message-ID: <20260721152638.984309608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit fcaf242e7fc406e78f444a35441e3b58f5e28781 upstream.

When dmaengine_slave_config() fails, the DMA channel acquired by
dma_request_chan() is not released before returning the error,
leaking the channel reference.

Fix by adding dma_release_channel() in the error path.

The ata_host_activate() error path already correctly releases the
DMA channel.

Cc: stable@vger.kernel.org
Fixes: 88622d80af82 ("ata: pata_pxa: dmaengine conversion")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/pata_pxa.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/pata_pxa.c
+++ b/drivers/ata/pata_pxa.c
@@ -286,6 +286,7 @@ static int pxa_ata_probe(struct platform
 	ret = dmaengine_slave_config(data->dma_chan, &config);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "dma configuration failed: %d\n", ret);
+		dma_release_channel(data->dma_chan);
 		return ret;
 	}
 


