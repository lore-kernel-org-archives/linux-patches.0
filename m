Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CFA1E521E;
	Mon, 23 Jun 2025 21:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714004; cv=none; b=dPG8RqZshCYTJe6lVs/2mkPuGxHKUNcuR2EZn564jn6ZIBTL8F1rgD9uJKKyJiJroE0H4ZLmUZo3Ggj3xPXX0AAyePJs8FEmVC2QeTYb88Yu2JgLL5VxNJGks3OVQs470oFwUtwg0730rmNMFaidlaDcb2aniAMb12oIUXYqjwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714004; c=relaxed/simple;
	bh=sK8Y1giYHmQo+7XV9dNZX4UDMw+v7DuaZK9IbFPis2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnHgCHUWmchqZ4P/DgMVGpEph03PqHm9ET5j6altn6T0eM5t0DPnls7jx0PoCAWbe22blQ+Budm9Rvfo7fuvyVxJQuCngfZxMfw7tiV0dl/lElk8+R+BaAfMWS7rFQF5A1N7fpWhhfEtY1YVmcG5Tjw0FiNXhj03H11pm08e7jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aj6nIkrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aj6nIkrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F257C4CEEA;
	Mon, 23 Jun 2025 21:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714003;
	bh=sK8Y1giYHmQo+7XV9dNZX4UDMw+v7DuaZK9IbFPis2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aj6nIkrLkH6HApaq/BT06ATyP/3wMYnSj/tWfnpb0Zdw0YJc4mfbyn6FEz2Pdi5iW
	 Og8E/wy8Cr9A1DcPijTUfiZxD9e9BUGYnC858nYYxxj/Kg2gQ7VE/Lt18SCIBmUBL7
	 lJLTm9i/xNWXs+jUWwWrJUuS7NSvLeBXKqYlEDXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 075/414] ASoC: codecs: wcd9375: Fix double free of regulator supplies
Date: Mon, 23 Jun 2025 15:03:32 +0200
Message-ID: <20250623130643.952448654@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 63fe298652d4eda07d738bfcbbc59d1343a675ef upstream.

Driver gets regulator supplies in probe path with
devm_regulator_bulk_get(), so should not call regulator_bulk_free() in
error and remove paths to avoid double free.

Fixes: 216d04139a6d ("ASoC: codecs: wcd937x: Remove separate handling for vdd-buck supply")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20250526-b4-b4-asoc-wcd9395-vdd-px-fixes-v1-3-0b8a2993b7d3@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd937x.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/sound/soc/codecs/wcd937x.c
+++ b/sound/soc/codecs/wcd937x.c
@@ -2897,10 +2897,8 @@ static int wcd937x_probe(struct platform
 		return dev_err_probe(dev, ret, "Failed to get supplies\n");
 
 	ret = regulator_bulk_enable(WCD937X_MAX_BULK_SUPPLY, wcd937x->supplies);
-	if (ret) {
-		regulator_bulk_free(WCD937X_MAX_BULK_SUPPLY, wcd937x->supplies);
+	if (ret)
 		return dev_err_probe(dev, ret, "Failed to enable supplies\n");
-	}
 
 	wcd937x_dt_parse_micbias_info(dev, wcd937x);
 
@@ -2936,7 +2934,6 @@ static int wcd937x_probe(struct platform
 
 err_disable_regulators:
 	regulator_bulk_disable(WCD937X_MAX_BULK_SUPPLY, wcd937x->supplies);
-	regulator_bulk_free(WCD937X_MAX_BULK_SUPPLY, wcd937x->supplies);
 
 	return ret;
 }
@@ -2953,7 +2950,6 @@ static void wcd937x_remove(struct platfo
 	pm_runtime_dont_use_autosuspend(dev);
 
 	regulator_bulk_disable(WCD937X_MAX_BULK_SUPPLY, wcd937x->supplies);
-	regulator_bulk_free(WCD937X_MAX_BULK_SUPPLY, wcd937x->supplies);
 }
 
 #if defined(CONFIG_OF)


