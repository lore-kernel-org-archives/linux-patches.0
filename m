Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EF41C3C1C;
	Mon, 10 Mar 2025 18:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630667; cv=none; b=mlazqXsaZKJzYmxqT8C1Embvvtm36Mc2DDb7ovoC4nPYPp/UyceenFBbgTzInTgOPoGSP+ZeKuz1BQTt4A5Yc4YWmWuBOubX5GfiuktUG0OnV/dkV8XgqObuy1OJaTII3kyzgFbmV7Tk9o6kiUkJy9q12Xv9S95lVMvu016Zogw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630667; c=relaxed/simple;
	bh=RDPsvh9SCtdQXWI/M3uxVAy1Y1MbWkC+zFUDl62U2Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afQJZcpi5LXMu37Uyha7I/pYOWmFNM5WxC2+eLWP3wsa1lHlLcugSvETeDo9BzlrNY2uODuUCMRSAGiH5cpL+3UW1g/KIH/Exk+625AF/H1fm3OWJA9g9gOugctO9+2bIqWs+A8n+eA9LF7K11SYeEIcC5+kVZhSaGXaj2uutv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpskMkav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpskMkav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6414C4CEEE;
	Mon, 10 Mar 2025 18:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630667;
	bh=RDPsvh9SCtdQXWI/M3uxVAy1Y1MbWkC+zFUDl62U2Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpskMkavQZ8SrnfCPHnD8Q1MReHA4DjJqiEaUgquHusgWFstjbgHKL5KmX4RCkHgz
	 1E6LvPLHt0fFqP9ZFQ/a56U/uO0dPWG/K609/BOBSzLAVaEhdrveMO1Gd8uBX84G/o
	 M1e/FmwZZdWhzWqtkgXppJhF02G6kOFvksrXeXbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 452/620] soc: mediatek: mtk-devapc: Fix leaking IO map on driver remove
Date: Mon, 10 Mar 2025 18:04:58 +0100
Message-ID: <20250310170603.431895752@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index da075918424d3..56534d9a77513 100644
--- a/drivers/soc/mediatek/mtk-devapc.c
+++ b/drivers/soc/mediatek/mtk-devapc.c
@@ -290,6 +290,7 @@ static void mtk_devapc_remove(struct platform_device *pdev)
 	struct mtk_devapc_context *ctx = platform_get_drvdata(pdev);
 
 	stop_devapc(ctx);
+	iounmap(ctx->infra_base);
 }
 
 static struct platform_driver mtk_devapc_driver = {
-- 
2.39.5



