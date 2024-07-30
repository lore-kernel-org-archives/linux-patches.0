Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614E11A76A7;
	Tue, 30 Jul 2024 17:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359866; cv=none; b=NNe4byH4EdylgXXDm2+wL05Luc9mnBMpnG5yXH/22A2N8EKwKXmE5NMBmeMbZl9ZJ9l3ORY1eAUixgiW5BKsHftOqfMWlu0TICfwmPfkxk6pHcZ/WvaJtYDomi6xuCz3jeGcZj/z9aTYV49KA/29pw+VtysjtCu3x4q9tWg5rQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359866; c=relaxed/simple;
	bh=xXJF6qXqUnSNPhhVXd/FvdtOtHV4WNGPEAxWRewBUH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZp8pwOjV5hZyBKezmrkfksHJiCmuP+b9ReWFsSjwSg5ZnxyY3YGOO1ZU4ZjylNxt4UhK5NFfj1hmVlxj+P+0bKur/4/bNpoEayi7BnYJVW9W5jVEmy4ktO4cuCfe0h7K+w/A5KbUGC+c3DX2+rIVf5l+1ZRNnNnD/xI9SV81H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kA6SFYoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kA6SFYoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C015FC4AF0A;
	Tue, 30 Jul 2024 17:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359866;
	bh=xXJF6qXqUnSNPhhVXd/FvdtOtHV4WNGPEAxWRewBUH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kA6SFYoXWP/bxRAjk0Mt/SO+yjzpD6MdJ/pTAuypHSayH9k8oSg/3ljyOENzzBO5U
	 1Zxl/YMuAmnN7AcS1rB+VLvXCy3nM55uOojq7YygbMVO2mXFWzlqLw0W5fGilkSB60
	 igA3fXKAYLsv4xsgAV925Vt+VS4zdEmtCxDsB1hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 548/568] auxdisplay: ht16k33: Drop reference after LED registration
Date: Tue, 30 Jul 2024 17:50:55 +0200
Message-ID: <20240730151701.581837082@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 2ccfe94bc3ac980d2d1df9f7a0b2c6d2137abe55 ]

The reference count is bumped by device_get_named_child_node()
and never dropped. Since LED APIs do not require it to be
bumped by the user, drop the reference after LED registration.

[andy: rewritten the commit message and amended the change]

Fixes: c223d9c636ed ("auxdisplay: ht16k33: Add LED support")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/ht16k33.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/auxdisplay/ht16k33.c b/drivers/auxdisplay/ht16k33.c
index 3a2d883872249..b360ddefc4238 100644
--- a/drivers/auxdisplay/ht16k33.c
+++ b/drivers/auxdisplay/ht16k33.c
@@ -507,6 +507,7 @@ static int ht16k33_led_probe(struct device *dev, struct led_classdev *led,
 	led->max_brightness = MAX_BRIGHTNESS;
 
 	err = devm_led_classdev_register_ext(dev, led, &init_data);
+	fwnode_handle_put(init_data.fwnode);
 	if (err)
 		dev_err(dev, "Failed to register LED\n");
 
-- 
2.43.0



