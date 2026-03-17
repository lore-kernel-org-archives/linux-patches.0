Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E268C377EDD;
	Tue, 17 Mar 2026 17:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766951; cv=none; b=DKJeeOV2n4Zc56EpzAWM4N9TZjKIGI680xV6eZSC8/QhQNiskgMDVqszzPw4WMcw7jKOql8rXpcV1pL8rnDy00gfMTgOnyej/ev1wAc6Fdh+tYDT6waoF2cG2ePoXDv+1SDmNcpTvOldamYVJO/wVKPIDC8nqlIavJx1P3cZx/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766951; c=relaxed/simple;
	bh=F2hcWbi9BDE4o1jLSKWKS9mzz0SMyex1PUI6829Z+YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJ5uzFIsMWjRAxkJfJWLhs4nqE1d8my0Ga0cPY2pyNZgDnb78AngeVSKChSE8rReshdHfv0owkeeobrnrsEvA0FXGB+CZ892SKeW9ocrVGYnkOWEtfZXWyg6nNUDFchPSrMldV3M8j5ztDi+MDnt/Saajl95qCpT6WhyJ4BuiPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZaqB/jT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZaqB/jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8A1C4CEF7;
	Tue, 17 Mar 2026 17:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766950;
	bh=F2hcWbi9BDE4o1jLSKWKS9mzz0SMyex1PUI6829Z+YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZaqB/jT6jAMbmV8Tb3SmpycqLqLGKpTZoxtUsRLNay1i1AxeRAgsH4ksdr0lRGu6
	 iDITwgg96ZhzIjfFfuWyJtzCo2CRdd1J0mjRrUiBdm3W1txTjGKAs6SlNw5IFQZEBA
	 jaHmNnMNBX296zHIO9OodH6BRN4BToTlGn+HEhp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Linus Walleij <linusw@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 358/378] iio: light: bh1780: fix PM runtime leak on error path
Date: Tue, 17 Mar 2026 17:35:15 +0100
Message-ID: <20260317163020.153259961@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit dd72e6c3cdea05cad24e99710939086f7a113fb5 upstream.

Move pm_runtime_put_autosuspend() before the error check to ensure
the PM runtime reference count is always decremented after
pm_runtime_get_sync(), regardless of whether the read operation
succeeds or fails.

Fixes: 1f0477f18306 ("iio: light: new driver for the ROHM BH1780")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/bh1780.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/bh1780.c
+++ b/drivers/iio/light/bh1780.c
@@ -109,9 +109,9 @@ static int bh1780_read_raw(struct iio_de
 		case IIO_LIGHT:
 			pm_runtime_get_sync(&bh1780->client->dev);
 			value = bh1780_read_word(bh1780, BH1780_REG_DLOW);
+			pm_runtime_put_autosuspend(&bh1780->client->dev);
 			if (value < 0)
 				return value;
-			pm_runtime_put_autosuspend(&bh1780->client->dev);
 			*val = value;
 
 			return IIO_VAL_INT;


