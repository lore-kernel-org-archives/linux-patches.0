Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3B82D8DC4;
	Tue,  6 Jan 2026 17:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720805; cv=none; b=WHtGiWDUkBLacNFhIqwNvMb9obqWNJwNb8lpcz4v9dG6tTYaO5YGZb5ecjQBy/u7ie0OtdtO+oFiWkFsxeucJJ13fOz71no2TlyZsgx14gPXfyJtMiWZCODVaZO1V1Eittmu5AGThZ56owQV+XKUEO51afWl27SWMno++S0U75I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720805; c=relaxed/simple;
	bh=rG5GzRa4l1VWAaG2j8XwPpZ0PK7v+Y7x18cpSAerqls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWYlDrQ3hqALseI2SWizUYOSm/SSOorubPnsZuT5nk+//AIqV83G/OxnkXARJdTQzcdTKEMh3DNVf7iCpcm1wNejUAwwgzvBHe3wjlrdGdsBVISoNv8u0bchAyrpUKO+T5/IUW6ZVrSsrnVq1npBI0mGu/Vvttp6r6jc3olDUW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNqDy85g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNqDy85g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695DEC116C6;
	Tue,  6 Jan 2026 17:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720804;
	bh=rG5GzRa4l1VWAaG2j8XwPpZ0PK7v+Y7x18cpSAerqls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNqDy85gQh2XzB80096aM9Iwc4HucsFjIwqL31/1izzOd27qRogeBFktCiL4KJu+K
	 XCdjYuWsd0XkgA4B+WsyAP5ZUvQJzBdnVRb5Rx81zKEg4SU3+Y/FPTxWV8XI9x7Qd3
	 1IMBvURH0njJU4jpFUbtzzq9St6mYtB/X0uQzeXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 345/567] ASoC: codecs: wcd939x: fix regmap leak on probe failure
Date: Tue,  6 Jan 2026 18:02:07 +0100
Message-ID: <20260106170504.088466465@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 86dc090f737953f16f8dc60c546ae7854690d4f6 upstream.

The soundwire regmap that may be allocated during probe is not freed on
late probe failures.

Add the missing error handling.

Fixes: be2af391cea0 ("ASoC: codecs: Add WCD939x Soundwire devices driver")
Cc: stable@vger.kernel.org	# 6.9
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251127135057.2216-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd939x-sdw.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/wcd939x-sdw.c
+++ b/sound/soc/codecs/wcd939x-sdw.c
@@ -1480,12 +1480,18 @@ static int wcd9390_probe(struct sdw_slav
 
 	ret = component_add(dev, &wcd939x_sdw_component_ops);
 	if (ret)
-		return ret;
+		goto err_free_regmap;
 
 	/* Set suspended until aggregate device is bind */
 	pm_runtime_set_suspended(dev);
 
 	return 0;
+
+err_free_regmap:
+	if (wcd->regmap)
+		regmap_exit(wcd->regmap);
+
+	return ret;
 }
 
 static int wcd9390_remove(struct sdw_slave *pdev)


