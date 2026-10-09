Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF234E56CA;
	Fri,  9 Oct 2026 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557227; cv=none; b=lpFxb7TVFzmkPfJDxtPxXr7yZifYrydW036EI0XiEdbVRttNqtZF8pIH/an8C7TVxLBjDP+uBkPzNPSE974uB0bc31zBctu/B7EWKdEALhrwCisYzIJ8TqymTuKjVxHqq+1JX0LOHVyyNtxi4hCNK8wzsdOi0m20nm6/E/W6g7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557227; c=relaxed/simple;
	bh=b90RLuqbVWzEvmiMsxfwxs6g2GOx+t1g7vHOa/8cOQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1gAQD7iAah7asJJ9+07wQQ3H3V7CnTuTVB7BwY3ZOBjg8TH3wcuKGPonjemRmkHU+SNLprQYqYa1lqbtNm5We6H2lBNJ/yIWJh6FoWrrvX/Qns+BvmC6/BezzVVNGWn0Sd0kLw4pg3umQ49BKhAuAmOAeVFjcjy2ZIDgdq8mew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhQ7ir6J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhQ7ir6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEA81F000FF;
	Fri,  9 Oct 2026 14:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557223;
	bh=hOZs6U+pbtUIWba4geg9PFF6MwTCSgmBEocLRC9tpv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhQ7ir6JARbhaj2oSZ0RhsxBJaars+njodb5XNKshQK8iloN7BZnbmiz3sDXofwMw
	 od7pBnfmUFk9PBFRcMkbHxCvHZzOu0tbnrNDOgGK2us53DHAriurOlOZ4vRv0sNwSZ
	 wIEAAxitJzeoojfzA8zUcKGf0G8RdWIkTPMcxKMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 367/403] iio: adc: aspeed: propagate reset deassert errors
Date: Fri,  9 Oct 2026 16:12:08 +0200
Message-ID: <20261009141000.879599659@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 95e4eb426b4bd666fa2f37886c0ddf74a0cc6167 ]

aspeed_adc_probe() continues to register ADC resources after deasserting
the shared reset, even if the reset controller reports a failure.

A failed deassertion leaves the hardware unavailable, so stop probing
before installing the cleanup action and enabling the ADC.

Fixes: edf7550a1f93 ("iio: adc: aspeed: Deassert reset in probe")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/aspeed_adc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -540,7 +540,9 @@ static int aspeed_adc_probe(struct platf
 		return dev_err_probe(&pdev->dev, PTR_ERR(data->rst),
 				     "invalid or missing reset controller device tree entry");
 
-	reset_control_deassert(data->rst);
+	ret = reset_control_deassert(data->rst);
+	if (ret)
+		return ret;
 
 	ret = devm_add_action_or_reset(data->dev, aspeed_adc_reset_assert,
 				       data->rst);


