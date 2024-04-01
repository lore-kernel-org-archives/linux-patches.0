Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DBB1E86C;
	Mon,  1 Apr 2024 16:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989638; cv=none; b=DD73w5vTKeKYXQ7OQe5L/ZysVIrxITV8XXqkDT/HssJ1CWLjcIovoj/e7+1f6mAj4ajJvPXE4910Dr/yeaQenb2nla46uas2a+WMlKI0BFrpX+QlhoKEftgHmmsWf0NUrtosrsaWK6XuDJTMRhGdzYSTAAwDzo3da3O9v7nKRtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989638; c=relaxed/simple;
	bh=wE2It1fNzluvcueLbW7tr+ibmQeoDiOOFq+E6i6gzPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOso3ZVdol7JTn7RrcxFAqfzGY2pGiw39cvx6ETkME8Z87oTAnQW0mjhF1zPNuH/cgv1+JKUIBNhSIRMlEQcsZ4Yuvp0tcSPncI5FKh4EpvNEuIt6TO50OlqsjjjwibJnkc3CRcGyU6Wl5WwyLrNmiHENKtZvwdvfh4+ZXWbNXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGC6JHon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGC6JHon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27EDC433F1;
	Mon,  1 Apr 2024 16:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989638;
	bh=wE2It1fNzluvcueLbW7tr+ibmQeoDiOOFq+E6i6gzPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGC6JHon6Hhix1QVtCZ3Rkxuj1gTNfZm5smw2RrP53g0kFn18NFrTnUluRbrlumdg
	 8ZCWEJqf6Nn3obAmMiy9Dq/8yc62WmCDefjMRzybgU2Q55/OGxmE94CboVgN25sucV
	 9M/czm54AkSTsjWu8faOZKrjRX1BQ1mbiO82tEcY=
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
Subject: [PATCH 6.6 108/396] nvmem: meson-efuse: fix function pointer type mismatch
Date: Mon,  1 Apr 2024 17:42:37 +0200
Message-ID: <20240401152551.139304649@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



