Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB343C2F;
	Wed, 21 Feb 2024 13:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523274; cv=none; b=SFJ/SqPqayHMtuZCzKm7eJL0s9csFbZNL97u3quzmINaAcnT4nWPwW4MhVO3jwrFGsnl9H9leIvaziOP1nRG5y/AQbz1Ui75a8LPdhB4oV3UOcR8oi4nbxmJ+mK9Is+MmmClTdNy5bgLUOWt2GvoNixx5R/VVMgXBNmLBREYyoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523274; c=relaxed/simple;
	bh=HpByqWA6dDTzn+vNhpTSyYdh3ezzrebKkCGqr3OQSbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCDIH29gP0k78OPA9E6gangzv25McDhIkXQDm96kiApisFC4OeATzqm3iXiIXik1ssHEsDZXZfbODcZ9LmvLZAhYVzEs0dizSXBfS9ZgL8lEZ5WFbM48ZvDUyVs7p4OlLZv5ZglzgschJdQKimKT+F8mxjWAIJhgOdqXCTkP0QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MamXD2fX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MamXD2fX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF92C433F1;
	Wed, 21 Feb 2024 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523274;
	bh=HpByqWA6dDTzn+vNhpTSyYdh3ezzrebKkCGqr3OQSbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MamXD2fXVLJMPzqyWdqreTqTVar7e/Wvv5UBCE8J2pTIg/jUgWWF0zH20q6KRHLwG
	 9GUw9GstfSJEJ9Wcp+Rvi7aktOO86g0LkqkU0jO7QDzQIjoYbVD8DLRPSYW5jgH5RN
	 8rUOga2BxHD5TcETxg+aDothry9bl+T0JU+KNeR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 385/476] ASoC: codecs: wcd938x: handle deferred probe
Date: Wed, 21 Feb 2024 14:07:16 +0100
Message-ID: <20240221130022.276979251@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 086df711d9b886194481b4fbe525eb43e9ae7403 upstream.

WCD938x sound codec driver ignores return status of getting regulators
and returns EINVAL instead of EPROBE_DEFER.  If regulator provider
probes after the codec, system is left without probed audio:

  wcd938x_codec audio-codec: wcd938x_probe: Fail to obtain platform data
  wcd938x_codec: probe of audio-codec failed with error -22

Fixes: 16572522aece ("ASoC: codecs: wcd938x-sdw: add SoundWire driver")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://msgid.link/r/20240117151208.1219755-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd938x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -4573,7 +4573,7 @@ static int wcd938x_probe(struct platform
 	ret = wcd938x_populate_dt_data(wcd938x, dev);
 	if (ret) {
 		dev_err(dev, "%s: Fail to obtain platform data\n", __func__);
-		return -EINVAL;
+		return ret;
 	}
 
 	ret = wcd938x_add_slave_components(wcd938x, dev, &match);


