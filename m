Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84BB3B9DBC;
	Mon, 23 Mar 2026 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278733; cv=none; b=bR38ZG8Z6bPIEj33p1H3jwnYA+H7eufyqxOfrkfp9wliwHy15vO5ekFnVCKzbPl/ssd0+9wF/+bDdXql+lT2hE+zTL+hMvV32V3O1POLgUZl5Jr4zpANgqtcccsys5e1gfCMhQxjR9xsTFiP2h7vatp/tcbItfGWddK/zCAwFtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278733; c=relaxed/simple;
	bh=la5VaXFgR7v1DAQ6IEHW/8xk0usWZhK43hfXjAFd3gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvpQq8SE6RE1c3Ye/QaeLgOig7H0hsLroBAbcc0O1jiNUMCQ08qobTMqZpMg5HVD7zlqntMiipwFQge5v+QUCRCFELbyQ/9fDpKy/9nDeTKak9ZcgweY7A6HSR6J4XVSjeugZ4yE7BAwsKMQWPQNPW6a0Z0257Wu3YF83KishW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YszDjqdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YszDjqdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C860C4CEF7;
	Mon, 23 Mar 2026 15:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278733;
	bh=la5VaXFgR7v1DAQ6IEHW/8xk0usWZhK43hfXjAFd3gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YszDjqdTZMPlktVLYE/6UPGCHR+HYcQoRwYVREHhG0OKJvjajcgXv2Go/HP8ZE3ae
	 5uIYBW1I0N7ClEPFyMxkBHWBWzLA8Sb6ItSfyzcuJCVQljW8IlRh4qG8PQyCQKoc7m
	 0khw2mRb3ZyvLRjKzOlT+6nHsBK4EeCPnzu1Czro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongliang Wang <wanghongliang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 401/567] net: stmmac: dwmac-loongson: Set clk_csr_i to 100-150MHz
Date: Mon, 23 Mar 2026 14:45:21 +0100
Message-ID: <20260323134543.787540314@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit e1aa5ef892fb4fa9014a25e87b64b97347919d37 upstream.

Current clk_csr_i setting of Loongson STMMAC (including LS7A1000/2000
and LS2K1000/2000/3000) are copy & paste from other drivers. In fact,
Loongson STMMAC use 125MHz clocks and need 62 freq division to within
2.5MHz, meeting most PHY MDC requirement. So fix by setting clk_csr_i
to 100-150MHz, otherwise some PHYs may link fail.

Cc: stable@vger.kernel.org
Fixes: 30bba69d7db40e7 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Hongliang Wang <wanghongliang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -14,7 +14,7 @@
 static int loongson_default_data(struct plat_stmmacenet_data *plat)
 
 {
-	plat->clk_csr = 2;	/* clk_csr_i = 20-35MHz & MDC = clk_csr_i/16 */
+	plat->clk_csr = 1;	/* clk_csr_i = 100-150MHz & MDC = clk_csr_i/62 */
 	plat->has_gmac = 1;
 	plat->force_sf_dma_mode = 1;
 


