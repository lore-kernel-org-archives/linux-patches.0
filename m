Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7862D29D26C;
	Tue, 17 Mar 2026 17:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766969; cv=none; b=e0RI42ZFRtFKnFWjFfZ7U/VSxsp+sZvevKC2gj345c9uhSsXcW0fSWd0Xvy5f6k4avakcc+fAFblnIm269ClrnuMlaPH+OSBnvVgfbDwn7GyE8pxdsjGOylp9cNyEMq9ac3ZXKpSgLU/22Dmj7MfwwK1jPXYGckBCMkg0rR7Ou4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766969; c=relaxed/simple;
	bh=4KtGeHTq7lvl0SROgeUKhlGIIJ3fvuNms6J272VgChI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDDg1YmqRUpMELRC1F2TvGVMCYJ/WxJAIwmgDkP1IExG3d5Jyu5bXMI1u4DgMdMHYQdaAQB/hUUXmQOs4SEvpqV4QBC9pUr2/t8rcZ4K7tZEzbUKgA1D5Q3qlUXtW0mZ6IuIz7o0uqpsOR9IW/HFp+J9Z5gX5UmGUT/EYVeV/fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ef0jmWU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ef0jmWU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBF1C4CEF7;
	Tue, 17 Mar 2026 17:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766969;
	bh=4KtGeHTq7lvl0SROgeUKhlGIIJ3fvuNms6J272VgChI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ef0jmWU7rOLxTe/NGGdEZs45rbkUkTxi9PuJMHyH62ignxRmNYJLV0O3Nwu2nQjsl
	 3RBtNvIK/mcINyxTNRkIrOsU42+h61KpYhw/KbJDck+9eLSVfLLG7eGQohOMsIn3GP
	 0PF+m74ynVC4ZL8xuVHXg93QskHuOzTcRWMtjk1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasin Lee <yasin.lee.x@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 363/378] iio: proximity: hx9023s: Protect against division by zero in set_samp_freq
Date: Tue, 17 Mar 2026 17:35:20 +0100
Message-ID: <20260317163020.335084975@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yasin Lee <yasin.lee.x@gmail.com>

commit a318cfc0853706f1d6ce682dba660bc455d674ef upstream.

Avoid division by zero when sampling frequency is unspecified.

Fixes: 60df548277b7 ("iio: proximity: Add driver support for TYHX's HX9023S capacitive proximity sensor")
Signed-off-by: Yasin Lee <yasin.lee.x@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/hx9023s.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/proximity/hx9023s.c
+++ b/drivers/iio/proximity/hx9023s.c
@@ -719,6 +719,9 @@ static int hx9023s_set_samp_freq(struct
 	struct device *dev = regmap_get_device(data->regmap);
 	unsigned int i, period_ms;
 
+	if (!val && !val2)
+		return -EINVAL;
+
 	period_ms = div_u64(NANO, (val * MEGA + val2));
 
 	for (i = 0; i < ARRAY_SIZE(hx9023s_samp_freq_table); i++) {


