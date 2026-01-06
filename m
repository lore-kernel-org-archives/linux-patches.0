Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC462FB630;
	Tue,  6 Jan 2026 17:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721945; cv=none; b=gLR4yGKVSUwPIrpYqWX1yEh2qGhR9AnWBUfKrNa8+ANwLzaHV/xZZ6M/NyteVkn8E6Nk1STOieBEzAfPQIvbMel34Wrd23ToofRFSxFBJAiRvkMVRVusI1qgh7D+VrcwQgnRUWhxxw02XLcchDK3Mcly3ZSyTuULYyZWTEsrPN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721945; c=relaxed/simple;
	bh=LuTewjhgpMj3o8wiAd4UqIQX+CbLjGEDfkGnNX1ku8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYw4CM8cp1aM0ifgdQJnF/ZyC1aQ3yePQ2rUinEeJCz0EvNPN/AGutJjCIoVq6pQGhuikTgGCY2D7PWgr6hlnc0UoLharfG7p/L+AE2+2foKN8h+34Buhsks/ljIHKNm+cTtneCdGzCVh7re2rCh/hX73WOvu/Nu7vyix1fWdJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUPfX34e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUPfX34e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4180C116C6;
	Tue,  6 Jan 2026 17:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721945;
	bh=LuTewjhgpMj3o8wiAd4UqIQX+CbLjGEDfkGnNX1ku8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vUPfX34e3arn/27EZWnERyzXKq7m24EVutZ7lrMnry0cJf6JJPGaxXKdr1v/ee2wz
	 EG2cv32pSMjwpip3g1DYZ4CVmBS8r4QH+v7osjGzK2v7dZtLpxkvaOmCZZIbAnJz7W
	 KoQEOUbUjz/ckGe88ZdWI2zy7Ydam+Obxej/mvH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 091/312] ASoC: codecs: wcd939x: fix regmap leak on probe failure
Date: Tue,  6 Jan 2026 18:02:45 +0100
Message-ID: <20260106170551.125670690@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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
@@ -1400,12 +1400,18 @@ static int wcd9390_probe(struct sdw_slav
 
 	ret = component_add(dev, &wcd_sdw_component_ops);
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


