Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189E218E34A;
	Mon, 24 Feb 2025 14:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407945; cv=none; b=NNJV/Us/ehFYR+hcqg1QLxmbbadCYO9higFVCduTTr3AaoG4Dqu27W1avf1zY4sfNnk0V5aZ4NvfwwMGPRWO6YN+rQV4BWEHt3HPVu9Chvs4Da99iuBA/kL/SrcuOg8f7FlqCQH+yiXac6ipa9+KDTA/ij3i1Wso5Dn1YGR+fNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407945; c=relaxed/simple;
	bh=3DTBAnkUIONVeoC8jGi9a2ICJyK/XV6vtijecwNLEj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gixx3DQJQqp4mRq9RAxUAxU8+OTBV8wxbklwg7nEOXSoiwLdLEPb4a0isrd9WZyptUI8phUo/rvwyJPr3iEVJEgY4WWCDciNsLYi7gNujJcpxuKi5VXor3P860pjfkafBQ/tDvdxn/oIpZxOA7c/zZWeEo6h38v6t2kRqLylyTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7y8XRGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7y8XRGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B36AC4CEE9;
	Mon, 24 Feb 2025 14:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407944;
	bh=3DTBAnkUIONVeoC8jGi9a2ICJyK/XV6vtijecwNLEj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7y8XRGxecCDl8FcHNd4jFmt45hSYDtODp97dGH2QLqavNu07q0CR12KPDCDrxWbv
	 wui+KVNQrHHRTuTFvXOKnEJeonXRh1VjYkKGX/m4JYO1v4NlMevTI0ssjtu0TRruql
	 nShfEGoXHZ1YO/sZKKJwgOyvp28Rzo8ILvjR30A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/140] soc: mediatek: mtk-devapc: Fix leaking IO map on driver remove
Date: Mon, 24 Feb 2025 15:34:13 +0100
Message-ID: <20250224142605.138136980@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit c9c0036c1990da8d2dd33563e327e05a775fcf10 ]

Driver removal should fully clean up - unmap the memory.

Fixes: 0890beb22618 ("soc: mediatek: add mt6779 devapc driver")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250104142012.115974-2-krzysztof.kozlowski@linaro.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-devapc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/mediatek/mtk-devapc.c b/drivers/soc/mediatek/mtk-devapc.c
index eb8f92f585882..d83a46334adbb 100644
--- a/drivers/soc/mediatek/mtk-devapc.c
+++ b/drivers/soc/mediatek/mtk-devapc.c
@@ -305,6 +305,7 @@ static void mtk_devapc_remove(struct platform_device *pdev)
 	struct mtk_devapc_context *ctx = platform_get_drvdata(pdev);
 
 	stop_devapc(ctx);
+	iounmap(ctx->infra_base);
 }
 
 static struct platform_driver mtk_devapc_driver = {
-- 
2.39.5



