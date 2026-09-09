Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B7D53D0B8;
	Wed,  9 Sep 2026 14:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963418; cv=none; b=pMdUKjwxaA+39GusDiY1KFn7lygx0RtgzVEdHmUYGng6IgD+ATnpsv362Ci4XXbKO8Ur40v5WCsvkIJ8ENTAB7lBOUTEqa+0VghS+CxBlJHFxU0/F+FISYB9hGmCkXQ4htHFl+KE2wQaSRuW7gOM4B4Osux9lQbhdopEJz5a/ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963418; c=relaxed/simple;
	bh=LNlLmdQK+F52FcMABpJWrPqZjZUD1cBQ8Dtg7QNMLR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUxo8GyVZpgy+pBMojS7JS8Yl2gkpZhERqG9l//JvXoqQPaBT+vbzZxQVNejnMHL+xhrNP+hHWHtJDtMC51ACI1sQGZcwj9NUvworqFUTqrszlE/6wkO5A4WRWPTyrxGyaPJFPaQNroSJHHMzKXepUDlEXvw41YM+YJxBaBdhAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ui69Z9ai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ui69Z9ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEEE1F00A3A;
	Wed,  9 Sep 2026 14:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963417;
	bh=B49fr4kNdzYIC9d9q7F9nLtfzNRnIv/Ld9VbVbjTv/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ui69Z9aiqTvk2B95AQfCArYByUCrALS/ooLb142BPs9DxNlFnEAWPYD8512ydii+N
	 jnvDZ+UmQB5SF1U58jOP0p29ng6gvXxswPJZuNJ9SXhgmKlMrgb87pIRLG0ZE5rm3f
	 rpulsLpWUFscJKkJ4PVT/HSht0aXytkXn/198RUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 071/583] dmaengine: dw-edma: Fix HDMA channel status register access
Date: Wed,  9 Sep 2026 15:35:56 +0200
Message-ID: <20260909134240.544112593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

commit ef1b080e03acc83d5bde841da67036985acd50dc upstream.

GET_CH_32() takes the direction before the channel ID, but
dw_hdma_v0_core_ch_status() passed them in the opposite order. This can
make the status callback read another HDMA channel status register.

Use the same argument order as the other HDMA register accesses.

Fixes: e74c39573d35 ("dmaengine: dw-edma: Add support for native HDMA")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260717180639.2643243-2-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-hdma-v0-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/dw-edma/dw-hdma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-hdma-v0-core.c
@@ -79,7 +79,7 @@ static enum dma_status dw_hdma_v0_core_c
 	u32 tmp;
 
 	tmp = FIELD_GET(HDMA_V0_CH_STATUS_MASK,
-			GET_CH_32(dw, chan->id, chan->dir, ch_stat));
+			GET_CH_32(dw, chan->dir, chan->id, ch_stat));
 
 	if (tmp == 1)
 		return DMA_IN_PROGRESS;


