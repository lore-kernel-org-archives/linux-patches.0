Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B391F8914;
	Wed,  6 Nov 2024 13:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898215; cv=none; b=SxkTt/Cya4zPk+D47U4joe/fTl1vaL77eG74WDGeuh3WiBqzhi7abG3XKbdiiKTLp4AE4gaQ4qr6e754y4RJLkSPafrDSIxClQj2fHZgWqsmH5TsCfmzQn2mtIg2xLLNonf2KlNfHWUoMGf8PY8xivdCBiineehpL0LnStECPuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898215; c=relaxed/simple;
	bh=MzSuHGfO4N0tt7mXtn90qtiutgmOKE74/R6Jo7Yyd10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJq69ImEGK7tVtD96e/rralCR1WwcBJcS4v5bXy6oQ4TMFqE14pKCis2YQljDyOLrl7t/wo8xq8GA365n3WQQxpRZCKdQrCL6zwvicYtTCOgcIpu0upAJ9t5S+VWJkazimFHHFt8pr3HtGsIUCIUNq5mHAowNtzOOdYw4rWKLNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcyJIekL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcyJIekL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEC8C4CEEE;
	Wed,  6 Nov 2024 13:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898215;
	bh=MzSuHGfO4N0tt7mXtn90qtiutgmOKE74/R6Jo7Yyd10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcyJIekLBK7wRqaIgiaoKDBS7gzawz8Npl0fnVuskMFcNcYMk8Dgw/9AVE/hh6TrL
	 j4LenMqaMMx5Qhl14fCC05IBWHW8UB3zd7IICWW7NSp6xVrva+FnmrqwDIGieSU3qD
	 pwJvwM3qXsgUJ+ih+IJd4tYDIU6e+lQBdPPws2NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/462] soc: versatile: realview: fix soc_dev leak during device remove
Date: Wed,  6 Nov 2024 13:00:57 +0100
Message-ID: <20241106120335.572279044@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit c774f2564c0086c23f5269fd4691f233756bf075 ]

If device is unbound, the soc_dev should be unregistered to prevent
memory leak.

Fixes: a2974c9c1f83 ("soc: add driver for the ARM RealView")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/20240825-soc-dev-fixes-v1-3-ff4b35abed83@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/versatile/soc-realview.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/soc/versatile/soc-realview.c b/drivers/soc/versatile/soc-realview.c
index 60947a5161e4c..9cddbde399860 100644
--- a/drivers/soc/versatile/soc-realview.c
+++ b/drivers/soc/versatile/soc-realview.c
@@ -4,6 +4,7 @@
  *
  * Author: Linus Walleij <linus.walleij@linaro.org>
  */
+#include <linux/device.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/slab.h>
@@ -79,6 +80,13 @@ static ssize_t realview_get_build(struct device *dev,
 static struct device_attribute realview_build_attr =
 	__ATTR(build,  S_IRUGO, realview_get_build,  NULL);
 
+static void realview_soc_socdev_release(void *data)
+{
+	struct soc_device *soc_dev = data;
+
+	soc_device_unregister(soc_dev);
+}
+
 static int realview_soc_probe(struct platform_device *pdev)
 {
 	struct regmap *syscon_regmap;
@@ -106,6 +114,11 @@ static int realview_soc_probe(struct platform_device *pdev)
 	if (IS_ERR(soc_dev))
 		return -ENODEV;
 
+	ret = devm_add_action_or_reset(&pdev->dev, realview_soc_socdev_release,
+				       soc_dev);
+	if (ret)
+		return ret;
+
 	ret = regmap_read(syscon_regmap, REALVIEW_SYS_ID_OFFSET,
 			  &realview_coreid);
 	if (ret)
-- 
2.43.0



