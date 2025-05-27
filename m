Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA53280322;
	Tue, 27 May 2025 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368316; cv=none; b=DHuo0AEch+upu90y8sNsa/XctRqMajOafi1NH8pEbw0jfyuswfWUnRtqUewdUVF5FQGqFDkFfi4j6/4g9V5Mmj5QI0kqYGuvQVX1FJHrch1iPlqroETfZEzKZibp3/qEUjLZ87BsXLdyqODyERdwZlUdJJV1WdX5RNeVTF6K+yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368316; c=relaxed/simple;
	bh=thRFJ8MEL4Zn9LdWWpS0Qyv/M2Y4dNxXjJWQpWKVJHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7/b00YD69hhyJ/Aw2hTS4LuPblPAKrM+JL8gHEMyu5Ktyr4X58KW5Ga4JI3viGrgwhske8DdpR8jNXh1HR/8+CchEJVAFGdvTVc6v4oR7vFkFIghm/9AKZH9GDXKK1JgJDD/KF8TkHwkokKB/VkgqH3OgVb0esfDRDfEg/9Rk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwA7r0Dx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwA7r0Dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A803BC4CEE9;
	Tue, 27 May 2025 17:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368316;
	bh=thRFJ8MEL4Zn9LdWWpS0Qyv/M2Y4dNxXjJWQpWKVJHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwA7r0DxkmgP6uKaGaAi+PsZ/iICKD9HMaS36AMaz54/GslUCnb37YbmFEp3DP7wS
	 J4tyEfKFpSY9TgBjZBcXEwDQlFwZjlI3bANdqRGHeJEBnq8k58oHemeNO7rCTdc3U6
	 9T54UlilZcifs4diplg7xwcJ21gJ7OSS2j/hP6ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 668/783] iio: adc: qcom-spmi-iadc: Fix wakeup source leaks on device unbind
Date: Tue, 27 May 2025 18:27:45 +0200
Message-ID: <20250527162540.327069817@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ad3764b45c1524872b621d5667a56f6a574501bd ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20250406-b4-device-wakeup-leak-iio-v1-2-2d7d322a4a93@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/qcom-spmi-iadc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/qcom-spmi-iadc.c b/drivers/iio/adc/qcom-spmi-iadc.c
index 7fb8b2499a1d0..b64a8a407168b 100644
--- a/drivers/iio/adc/qcom-spmi-iadc.c
+++ b/drivers/iio/adc/qcom-spmi-iadc.c
@@ -543,7 +543,9 @@ static int iadc_probe(struct platform_device *pdev)
 		else
 			return ret;
 	} else {
-		device_init_wakeup(iadc->dev, 1);
+		ret = devm_device_init_wakeup(iadc->dev);
+		if (ret)
+			return dev_err_probe(iadc->dev, ret, "Failed to init wakeup\n");
 	}
 
 	ret = iadc_update_offset(iadc);
-- 
2.39.5



