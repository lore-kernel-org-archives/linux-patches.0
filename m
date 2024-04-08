Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7512E62C;
	Mon,  8 Apr 2024 13:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581694; cv=none; b=uAcRns48mIE4bWTSo1gfDbILzhAuJ8eZEbqi+d03+3PmVIy4AWvxMjPd7i0/JD7iEeekAePg28m6N9QmNVMQQaWeF+aNpuGaEwMcyNFm6UemjrNxfQOyu8GfA/Xp1lNkvtOmPCRcKjSk5ked7KPR3qRgNhLQh9g1Y9hQcTD5GG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581694; c=relaxed/simple;
	bh=FvnAiMW/Y4UaG3i2Gt6Fv6WhaJQeJ+oemJkdDNg6by0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBgX3YZGOnNIA0A297CfHdvxUzOUOHBLuc7A9wFKeparMCgo2GlA4afbeUgLBxq7BYdFc4m6qjmCji7FqHMvn7JRyaPykm/3CUNVdu40Ij+EL6mvRYJOkiDC5J0/E9S1KbUKHyyFqQ9sHG6DV4Zw8U+664pinFX0qYyKa2qHAH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O51S5O54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O51S5O54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B326C433C7;
	Mon,  8 Apr 2024 13:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581694;
	bh=FvnAiMW/Y4UaG3i2Gt6Fv6WhaJQeJ+oemJkdDNg6by0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O51S5O542LNz7pTQYzLxQ9XHtYZmhSIHdvxoAZNXEJ9NjCP+tsA7H/AOnj30OVjHp
	 tzXOCh4pVJZiKmEGvjslNvm2Anb1LnVcMT8PZJZzFZDZN40Wmix7PQZ3fQ7hihDGaI
	 ZAuYrAeOTbXzwXo2o+ERQxdtzpwVGEf9BILz0KXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Justin Stitt <justinstitt@google.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/690] nvmem: meson-efuse: fix function pointer type mismatch
Date: Mon,  8 Apr 2024 14:49:01 +0200
Message-ID: <20240408125402.233225410@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit cbd38332c140829ab752ba4e727f98be5c257f18 ]

clang-16 warns about casting functions to incompatible types, as is done
here to call clk_disable_unprepare:

drivers/nvmem/meson-efuse.c:78:12: error: cast from 'void (*)(struct clk *)' to 'void (*)(void *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
   78 |                                        (void(*)(void *))clk_disable_unprepare,

The pattern of getting, enabling and setting a disable callback for a
clock can be replaced with devm_clk_get_enabled(), which also fixes
this warning.

Fixes: 611fbca1c861 ("nvmem: meson-efuse: add peripheral clock")
Cc: Stable@vger.kernel.org
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240224114023.85535-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/meson-efuse.c | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/nvmem/meson-efuse.c b/drivers/nvmem/meson-efuse.c
index d6b533497ce1a..ba2714bef8d0e 100644
--- a/drivers/nvmem/meson-efuse.c
+++ b/drivers/nvmem/meson-efuse.c
@@ -47,7 +47,6 @@ static int meson_efuse_probe(struct platform_device *pdev)
 	struct nvmem_config *econfig;
 	struct clk *clk;
 	unsigned int size;
-	int ret;
 
 	sm_np = of_parse_phandle(pdev->dev.of_node, "secure-monitor", 0);
 	if (!sm_np) {
@@ -60,27 +59,9 @@ static int meson_efuse_probe(struct platform_device *pdev)
 	if (!fw)
 		return -EPROBE_DEFER;
 
-	clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(clk)) {
-		ret = PTR_ERR(clk);
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "failed to get efuse gate");
-		return ret;
-	}
-
-	ret = clk_prepare_enable(clk);
-	if (ret) {
-		dev_err(dev, "failed to enable gate");
-		return ret;
-	}
-
-	ret = devm_add_action_or_reset(dev,
-				       (void(*)(void *))clk_disable_unprepare,
-				       clk);
-	if (ret) {
-		dev_err(dev, "failed to add disable callback");
-		return ret;
-	}
+	clk = devm_clk_get_enabled(dev, NULL);
+	if (IS_ERR(clk))
+		return dev_err_probe(dev, PTR_ERR(clk), "failed to get efuse gate");
 
 	if (meson_sm_call(fw, SM_EFUSE_USER_MAX, &size, 0, 0, 0, 0, 0) < 0) {
 		dev_err(dev, "failed to get max user");
-- 
2.43.0



