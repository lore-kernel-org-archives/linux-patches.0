Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23961D416E;
	Wed,  6 Nov 2024 12:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895160; cv=none; b=gJ9gehDKoNopaW2Hjz4GTFfKNwN6THRAKiwOoCUVdbW79ef2YRChSe2BnRYxsc/fnDjpsoYPl0jWmP+1+We4tGEDGIIzM9UFltp7/sNYISlKhGwzmI01vtTMGK9cGJCA4hey6KsMXrXPafa69GpbWyJamIYlB0sRNbalxDTfzLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895160; c=relaxed/simple;
	bh=zSkZGcXwfVRXp+bRyIN19pG1gMjOcivmjnU28TQiBYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rV9dblQLOteUJ3X/ejQDa5R6DKnllJT9LROorac1q/2wKOtXn1EYhsM0Z2sfSAJKtkxoHE2fjKhDCbsN6iomIGhGno4XC4mjCdPgzM5iSGvBP/Q+wdbmJwmLzpLi7NyvFg53EDC7vUapZsT2PC2lHQAaGb2WaDp8UHxk+BikhU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Vc/9Xin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Vc/9Xin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582A1C4CECD;
	Wed,  6 Nov 2024 12:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895160;
	bh=zSkZGcXwfVRXp+bRyIN19pG1gMjOcivmjnU28TQiBYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Vc/9XinCrMJZA4ERL9YGUnqVJdheLovAC3E1ZAOEdpz+4m/uODpKsoqnJ4RtSEDp
	 jEJyNS+WbKl9wKhPcv/IlybB38m59DNUgeXZjF+tN+N97HaZeue9Qg5AaGCjMYZzQW
	 Cke6+Rw5LBDB22F8oHZK514zFG7m4ITPnpllBD1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 124/350] soc: versatile: realview: fix soc_dev leak during device remove
Date: Wed,  6 Nov 2024 13:00:52 +0100
Message-ID: <20241106120323.972228298@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 98b6c60de7f64..a9220701c190b 100644
--- a/drivers/soc/versatile/soc-realview.c
+++ b/drivers/soc/versatile/soc-realview.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  *
  */
+#include <linux/device.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/slab.h>
@@ -83,6 +84,13 @@ static ssize_t realview_get_build(struct device *dev,
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
@@ -110,6 +118,11 @@ static int realview_soc_probe(struct platform_device *pdev)
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



