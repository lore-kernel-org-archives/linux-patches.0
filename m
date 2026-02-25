Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03E831960B;
	Wed, 25 Feb 2026 06:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002763; cv=none; b=MGlSERq14fk+ZGdZlygIe4m9hTQY92JKubzRWM3aDQK4n+iHLSIcpJ7aD/1nz+NxCqvinPKq5Ugl46XJJd/Cot9l1lJrwaC7//kzb0S1thKGvAgTqlz99mc0i7R6soj58Hr0jtot1xfLIiE1b+buIHr+mYIyFoFyVyR/aoJDFyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002763; c=relaxed/simple;
	bh=z8NBonEidLDhc0rrpprHc1WnHmF2c6QwcLHB0kqgFNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AIMOnbpRJh59za7Q+lz9l2xaywNLY4Tua8J2TSrgUa7x2mgpguKV3Y/mqG9R/fUIqF6poPqZzgMsd47yKV3gF3Nb+zfkFhJTA/VKwnXPxEJc2oBaDv1lb2ShZVnzl2eSrX6SBq1YN++9tdPjYkwXmhX0xAD+vdQWUYoYDZMXyV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXQyU65M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXQyU65M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E00C116D0;
	Wed, 25 Feb 2026 06:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002763;
	bh=z8NBonEidLDhc0rrpprHc1WnHmF2c6QwcLHB0kqgFNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXQyU65MdZFOhNfkfHoShlcBHODc11qFNicXXvSxRl9G91CzT7uU/HSNbr2rzCvDI
	 UD/ysDOP5JWm0oMY+yDHQieuyzKiKAxqYK4sygYcmtJe4jHwYzBh/v+jjhzQKhCxYq
	 wckfeGL8J2W4BwXBABbQzC6sWRAZ4xhyvEDHc5Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	"=?UTF-8?q?J . =20Neusch=C3=A4fer?=" <j.ne@posteo.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 593/641] spi: wpcm-fiu: Fix potential NULL pointer dereference in wpcm_fiu_probe()
Date: Tue, 24 Feb 2026 17:25:19 -0800
Message-ID: <20260225012402.882941778@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 888a0a802c467bbe34a42167bdf9d7331333440a ]

platform_get_resource_byname() can return NULL, which would cause a crash
when passed the pointer to resource_size().

Move the fiu->memory_size assignment after the error check for
devm_ioremap_resource() to prevent the potential NULL pointer dereference.

Fixes: 9838c182471e ("spi: wpcm-fiu: Add direct map support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: J. Neuschäfer <j.ne@posteo.net>
Link: https://patch.msgid.link/20260212-wpcm-v1-1-5b7c4f526aac@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-wpcm-fiu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-wpcm-fiu.c b/drivers/spi/spi-wpcm-fiu.c
index a9aee2a6c7dcb..c47b56f0933f1 100644
--- a/drivers/spi/spi-wpcm-fiu.c
+++ b/drivers/spi/spi-wpcm-fiu.c
@@ -459,11 +459,11 @@ static int wpcm_fiu_probe(struct platform_device *pdev)
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "memory");
 	fiu->memory = devm_ioremap_resource(dev, res);
-	fiu->memory_size = min_t(size_t, resource_size(res), MAX_MEMORY_SIZE_TOTAL);
 	if (IS_ERR(fiu->memory))
 		return dev_err_probe(dev, PTR_ERR(fiu->memory),
 			       "Failed to map flash memory window\n");
 
+	fiu->memory_size = min_t(size_t, resource_size(res), MAX_MEMORY_SIZE_TOTAL);
 	fiu->shm_regmap = syscon_regmap_lookup_by_phandle_optional(dev->of_node, "nuvoton,shm");
 
 	wpcm_fiu_hw_init(fiu);
-- 
2.51.0



